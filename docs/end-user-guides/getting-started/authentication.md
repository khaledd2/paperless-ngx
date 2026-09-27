---
title: Understanding Authentication, Users, Groups & Permissions
---

# Authentication, Users, Groups & Permissions

This guide explains the whole authentication system: how people sign in to
Paperless-ngx, how accounts are created, and what users are allowed to see and
do once they are signed in. It is written for everyday users and for the person
who manages the system.

# Part 1 — Signing in

## Ways to sign in

Paperless-ngx supports several ways to sign in, depending on how the system has
been set up.

### Username and password

The simplest way to sign in is with a username and password. This is available
by default, unless an administrator has turned it off in favor of single
sign-on.

### Single sign-on (SSO) and social accounts

The system can be connected to an external sign-in provider, such as Google,
GitHub, or an organization's OpenID Connect provider. Users then sign in with
that existing account instead of a local password.

### Two-factor authentication (2FA)

For extra security, a user can enable two-factor authentication. After entering
their password, they are asked for a second, time-based code (usually from an
authenticator app on their phone).

!!! note

    Only the user themself — or a superuser — can disable two-factor
    authentication.

### Other sign-in options (administrators only)

There are a few additional, less common sign-in methods that an administrator
can enable:

- **Automatic sign-in** — a specific account is signed in automatically. This is
  only suitable for trusted, private installations.
- **Remote-user sign-in** — sign-in is handled by an external system (such as a
  reverse proxy) that passes the user's identity to Paperless-ngx.

!!! warning

    These advanced methods can bypass the normal sign-in process, so they
    should only be used on private, trusted installations.

## Creating accounts

Depending on the system settings, new accounts can be created in two ways:

- **Self sign-up** — an administrator can allow people to create their own
  account. This can be enabled for regular accounts and/or for SSO/social
  accounts.
- **Created by an administrator** — an administrator creates an account
  manually for each person.

When a new account is created, it can automatically be added to one or more
**default groups**, so new users start with the right permissions immediately.

!!! note

    If email is configured, new accounts may be asked to verify their email
    address. If no email server is configured, this step is skipped.

## Staying signed in

- **Remember me** — by default a session is remembered, so users stay signed in
  even after closing the browser. The system can instead be set to end the
  session when the browser closes.
- **Session length** — an administrator can set how long a sign-in session
  lasts before the user must sign in again.
- **Logging out** — users can always sign out manually. An administrator can
  also choose a page to redirect to after signing out (for example, back to the
  SSO provider's sign-out page).

# Part 2 — Users, groups & permissions

Once someone is signed in, permissions decide what they can see and do.

## The basics

- **Users** are the accounts people use to sign in.
- **Groups** are collections of users. Instead of setting up each person
  individually, you give a whole group the same permissions once.
- **Permissions** decide what each user (or group) is allowed to see and do.

## Types of users

| Type | What it can do |
| --- | --- |
| **Regular user** | Can only do what their permissions allow. |
| **Admin** | Same as a regular user, plus access to system status, logs, and the administrative backend. |
| **Superuser** | Has **full access** to everything. A superuser is granted all permissions and can view all objects, regardless of any other settings. |

## User accounts

When you create or edit a user, you will see these options:

- **Username** — the name used to sign in.
- **Email** and **Password**.
- **First name** and **Last name** — used for display.
- **Active** — an inactive account cannot sign in.
- **Admin** — access to system status, logs, and the administrative backend.
- **Superuser** — grants all permissions and the ability to view all objects.
- **Groups** — the groups this user belongs to.
- **Two-factor authentication** — an optional extra security step at sign-in.
- **Permissions** — the individual permissions granted to this user.

!!! note

    Only a superuser can grant or remove **Admin** or **Superuser** status, and
    only a superuser can edit or delete another superuser.

## Groups

A group is simply a named set of permissions. When a user joins a group, they
automatically receive all of that group's permissions.

Groups are the easiest way to manage many people at once: create groups such as
"Accounting" or "Reviewers", assign each group the permissions it needs, and
then add people to the right groups.

A user's **effective** permissions are the combination of:

- the permissions granted to them **directly**, and
- the permissions they **inherit** from their groups.

## Permissions

Permissions work at two levels.

### General permissions — what you can do everywhere

These permissions control general abilities across the whole application, for
example:

- view, add, edit, or delete **documents**;
- view, add, edit, or delete **tags**, **correspondents**, **document types**,
  **storage paths**, and other objects;
- manage **users** and **groups**;
- manage **workflows**, **mail rules**, **saved views**, **custom fields**, and
  more.

There are also two special permissions:

- **View global statistics** — see overall object counts.
- **View system status** — see system status information.

### Object-level permissions — access to a specific item

Most things in Paperless-ngx (a document, a tag, a correspondent, and so on)
can have their own individual access settings. This lets you decide *who* can
access *that particular item*.

Each item can have:

- an **owner** — the user the item belongs to, and
- a list of **users and groups** who are allowed to **view** it and/or
  **change** it.

There are only two object-level permissions:

- **View** — the person can see the item.
- **Change** — the person can edit the item.

!!! note

    Granting **Change** automatically also grants **View** — someone who can
    edit an item can always see it.

## How access is decided

For any given item, you can access it if **any** of the following is true:

1. You are its **owner**.
2. It has **no owner** (it is shared/public), in which case everyone can access
   it.
3. You have been **explicitly granted** View or Change permission on it, either
   directly or through one of your groups.

Additional rules to remember:

- **Superusers** can always see and change everything, regardless of owners or
  permissions.
- **Items with no owner** are visible to everyone.
- Only the item's **owner or a superuser** can change who has access to it (for
  example, change its owner, or its View/Change permissions).

## Where to manage this in the app

- **Users & Groups** — open **Settings → Users & Groups** to create and edit
  users and groups, and to assign their general permissions.
- **A single item** — when you edit a document (or a tag, correspondent,
  document type, storage path, etc.), look for the **Permissions** section to
  set its owner and its View/Change permissions.
- **Many items at once** — the **bulk edit** feature can apply the same owner
  and permissions to many documents or objects in one step.

## A quick example

Suppose three people use your Paperless-ngx: Alice, Bob, and Carol.

1. You create a group called **"Team"** and give it permission to **view** and
   **add** documents.
2. You add Alice and Bob to the **"Team"** group.
3. You make Carol a **superuser** so she can manage everything.

Later, you upload a sensitive document and set its **owner** to Alice. You also
grant the **"Team"** group **View** permission on it.

Now:

- **Alice** can view and edit the document (she owns it).
- **Bob** can view the document (through the group permission).
- **Carol** can view and edit it (she is a superuser).
- Anyone else **cannot** see the document at all.


