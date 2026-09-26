---
title: Users, Groups & Permissions
---

# Users, Groups & Permissions

This page explains how authentication, authorization, users, groups and
permissions work in Paperless-ngx. It covers the rules the system uses to
decide whether a user may view or change a given object.

## Overview of the auth stack

The access-control system is built from three layers that are combined in
Django:

1. **Django's built-in auth** (`django.contrib.auth`) provides users, groups and
   model-level permissions.
2. **django-guardian** (`guardian`) adds *object-level* permissions, i.e. who may
   view or change a *specific* document, tag, correspondent, etc.
3. **django-allauth** adds SSO / social login and TOTP two-factor
   authentication (MFA).

The authentication backends are configured in
`src/paperless/settings/__init__.py`:

```python
AUTHENTICATION_BACKENDS = [
    "guardian.backends.ObjectPermissionBackend",
    "django.contrib.auth.backends.ModelBackend",
    "allauth.account.auth_backends.AuthenticationBackend",
]
```

There is **no custom `User` model**; the project uses Django's stock
`django.contrib.auth.models.User`.

## Users

Users are managed by `UserViewSet` (`src/paperless/views.py`) and serialized by
`UserSerializer` (`src/paperless/serialisers.py`).

A user has the following relevant fields:

| Field | Description |
| --- | --- |
| `username` | Login name. |
| `email`, `password` | Account credentials. |
| `first_name`, `last_name` | Display name. |
| `date_joined` | When the account was created. |
| `is_active` | Whether the account is allowed to log in. |
| `is_staff` | Grants access to the Django admin panel. |
| `is_superuser` | Bypasses **all** permission checks. |
| `groups` | Groups the user belongs to. |
| `user_permissions` | Model-level permissions granted directly to the user. |
| `inherited_permissions` | Computed as `user.get_group_permissions()`, i.e. permissions inherited through groups. |
| `is_mfa_enabled` | Whether TOTP two-factor authentication is enabled. |

### Special / system users

Two usernames are treated as internal and are excluded from the user list
(see `UserViewSet.queryset` and `src/paperless/adapter.py`):

- **`consumer`** — an internal system user used during document processing.
- **`AnonymousUser`** — Django's placeholder for unauthenticated requests.

### User-management rules

`UserViewSet` applies additional guards on top of the normal permission checks:

- Only a **superuser** can grant or revoke `is_superuser` or `is_staff`.
- Only a **superuser** can modify or delete another superuser.
- A user may deactivate their own TOTP, or a superuser may deactivate it for
  anyone.

## Groups

Groups are managed by `GroupViewSet` and `GroupSerializer`
(`src/paperless/serialisers.py`). A group consists of:

- `name`
- `permissions` — a list of permission codenames (excluding Django
  admin-content-type permissions).

Groups are the primary mechanism for granting **model-level** permissions to
many users at once. Users automatically inherit the permissions of their groups
(which is exposed as `inherited_permissions` on the user serializer).

Default group assignment on sign-up is configurable via environment variables:

- `PAPERLESS_ACCOUNT_DEFAULT_GROUPS`
- `PAPERLESS_SOCIAL_ACCOUNT_DEFAULT_GROUPS`
- `PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS` (sync groups from an SSO claim)

## Permissions

Permissions exist on two distinct levels.

### Model-level (global) permissions

These are standard Django `Permission` objects with codenames of the form
`action_model`. The relevant types are enumerated on the frontend in
`PermissionsService` (`src-ui/src/app/services/permissions.service.ts`):

- `add_…`, `view_…`, `change_…`, `delete_…` for models such as `document`,
  `tag`, `correspondent`, `documenttype`, `storagepath`, `savedview`,
  `paperlesstask`, `note`, `mailaccount`, `mailrule`, `user`, `group`,
  `sharelink`, `customfield`, `workflow`, and others.

Two special app-level permissions are declared on `ApplicationConfiguration`
(`src/paperless/models.py`):

| Permission | Description |
| --- | --- |
| `view_global_statistics` | "Can view global object counts" |
| `view_system_monitoring` | "Can view system status information" |

These are assigned through a user's `user_permissions` or through a group's
`permissions`.

### Object-level permissions

Object-level permissions are implemented with `django-guardian`. Most content
objects (documents, tags, correspondents, document types, storage paths, saved
views, workflows, custom fields, etc.) can have an **owner** plus explicit
per-object permissions.

The API accepts an `owner` and/or a `set_permissions` payload (see
`docs/api.md`):

```json
{
  "owner": 5,
  "set_permissions": {
    "view":   { "users": [1, 2], "groups": [3] },
    "change": { "users": [1],    "groups": []  }
  }
}
```

Internally this is stored as guardian `UserObjectPermission` /
`GroupObjectPermission` rows, written by `set_permissions_for_object()` in
`src/documents/permissions.py`.

The only two object-level actions are **`view`** and **`change`**.

!!! note

    Granting `change` automatically also grants `view` on the same object. This
    is enforced in `set_permissions_for_object()`.

## How access is decided (the rules)

The core logic lives in `src/documents/permissions.py`.

### HTTP verb → permission mapping

`PaperlessObjectPermissions` (a `DjangoObjectPermissions` subclass) maps HTTP
methods to the required permission codenames:

| HTTP method | Required permission |
| --- | --- |
| `GET`, `OPTIONS`, `HEAD` | `view_<model>` |
| `POST` | `add_<model>` |
| `PUT`, `PATCH` | `change_<model>` |
| `DELETE` | `delete_<model>` |

### The owner-aware rule

`PaperlessObjectPermissions.has_object_permission` decides access to a single
object as follows:

1. If the object has an `owner` and `request.user == owner` → **allowed**.
2. Otherwise fall back to guardian's object-permission check.
3. If the object has **no owner** (`owner is None`) → **allowed for everyone**
   (unowned objects are effectively public/shared).

The same logic is captured in the helper `has_perms_owner_aware()`:

```python
def has_perms_owner_aware(user, perms, obj):
    checker = ObjectPermissionChecker(user)
    return obj.owner is None or obj.owner == user or checker.has_perm(perms, obj)
```

In plain terms, a user can access an object if **any** of these is true:

- they are the object's **owner**, or
- the object is **unowned** (public), or
- they have an **explicit `view`/`change` object permission**, either directly
  or through a group.

### Listing objects a user can see

`get_objects_for_user_owner_aware()` returns the union of:

- objects the user **owns**,
- **unowned** objects,
- objects the user has **explicit permissions** on.

For documents specifically, `_permitted_document_ids()` builds an efficient SQL
filter:

```python
Q(owner=user) | Q(owner__isnull=True) | Q(id__in=permitted_ids)
```

Superusers always bypass the filter and see everything. Anonymous /
unauthenticated users see **only unowned objects**.

### Who can change an object's permissions

To overwrite an object's permissions (or change its owner), the requesting user
must be the **object owner or a superuser**. The serializer
(`src/documents/serialisers.py`) enforces this and raises `PermissionDenied`
otherwise.

### Frontend mirror

The Angular `PermissionsService`
(`src-ui/src/app/services/permissions.service.ts`) mirrors these rules for UI
visibility:

- `currentUserCan(action, type)` — superuser or the user holds the permission
  codename.
- `currentUserOwnsObject(obj)` — true if the object is unowned, owned by the
  current user, or the user is a superuser.
- `currentUserHasObjectPermissions(action, obj)` — owner/unowned or the user is
  listed in the object's `permissions.view` / `permissions.change` users or
  groups.

## Special permission classes

The following permission classes are defined in
`src/documents/permissions.py`:

| Class | Rule |
| --- | --- |
| `PaperlessAdminPermissions` | `request.user.is_staff` only (Django admin). |
| `ViewDocumentsPermissions` | Requires `documents.view_document`. |
| `PaperlessNotePermissions` | Requires `view_note`, `add_note` or `delete_note`. |
| `AcknowledgeTasksPermissions` | Requires `documents.change_paperlesstask`. |

## Related "rules" (automation)

The word "rules" is also used for two separate automation features, distinct
from access control:

- **Workflows** (`Workflow`, `WorkflowTrigger`, `WorkflowAction` in
  `src/documents/models.py`) — condition/action rules applied to documents. A
  workflow trigger matches documents (e.g. "has these tags / this correspondent
  / this document type") and its actions can assign a correspondent, storage
  path, **owner**, or grant `view`/`change` permissions to specific users and
  groups. Workflow actions therefore feed back into the object-permission
  system described above.
- **Mail rules** (`MailRule` in `src/paperless_mail/models.py`) — rules that
  decide how incoming emails are consumed.



