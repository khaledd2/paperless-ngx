---
title: المستخدمون والمجموعات والصلاحيات
---

# المستخدمون والمجموعات والصلاحيات

توضّح هذه الصفحة كيفية عمل المصادقة والتفويض والمستخدمين والمجموعات والصلاحيات في Paperless-ngx، وتغطّي القواعد التي يعتمدها النظام لتحديد ما إذا كان بإمكان مستخدمٍ ما عرض كائن معيّن أو تعديله.

## نظرة عامة على حزمة المصادقة

يتكوّن نظام التحكم بالوصول من ثلاث طبقات مدمجة في Django:

1. المصادقة المدمجة في Django (`django.contrib.auth`) لتوفير المستخدمين والمجموعات وصلاحيات مستوى النموذج.
2. `django-guardian` (`guardian`) لإضافة صلاحيات على مستوى الكائن، أي من يحق له عرض أو تعديل مستند أو وسم أو مراسل معيّن... إلخ.
3. `django-allauth` لإضافة الدخول عبر SSO / الحسابات الاجتماعية والمصادقة الثنائية (MFA) عبر TOTP.

تُعرَّف خلفيات المصادقة في الملف `src/paperless/settings/__init__.py`:

```python
AUTHENTICATION_BACKENDS = [
    "guardian.backends.ObjectPermissionBackend",
    "django.contrib.auth.backends.ModelBackend",
    "allauth.account.auth_backends.AuthenticationBackend",
]
```

لا يوجد نموذج `User` مخصّص؛ إذ يستخدم المشروع نموذج Django الافتراضي `django.contrib.auth.models.User`.

## المستخدمون

تتم إدارة المستخدمين عبر `UserViewSet` (في `src/paperless/views.py`) وتسلسلهم عبر `UserSerializer` (في `src/paperless/serialisers.py`).

يملك المستخدم الحقول التالية ذات الصلة:

| الحقل | الوصف |
| --- | --- |
| `username` | اسم الدخول. |
| `email`, `password` | بيانات اعتماد الحساب. |
| `first_name`, `last_name` | الاسم المعروض. |
| `date_joined` | تاريخ إنشاء الحساب. |
| `is_active` | ما إذا كان الحساب مسموحًا له بتسجيل الدخول. |
| `is_staff` | يمنح الوصول إلى لوحة إدارة Django. |
| `is_superuser` | يتجاوز **جميع** فحوصات الصلاحيات. |
| `groups` | المجموعات التي ينتمي إليها المستخدم. |
| `user_permissions` | صلاحيات مستوى النموذج الممنوحة للمستخدم مباشرة. |
| `inherited_permissions` | تُحسب عبر `user.get_group_permissions()` أي الصلاحيات الموروثة من المجموعات. |
| `is_mfa_enabled` | ما إذا كانت المصادقة الثنائية (TOTP) مفعّلة. |

### المستخدمون الخاصون / مستخدمو النظام

يُعامَل اسمان كمستخدمين داخليين ويُستبعدان من قائمة المستخدمين (انظر `UserViewSet.queryset` و `src/paperless/adapter.py`):

- **`consumer`** — مستخدم نظام داخلي يُستخدم أثناء معالجة المستندات.
- **`AnonymousUser`** — عنصر Django النائب للطلبات غير المصادقة.

### قواعد إدارة المستخدمين

يضيف `UserViewSet` قيودًا إضافية فوق فحوصات الصلاحيات العادية:

- لا يمكن سوى **superuser** منح أو سحب `is_superuser` أو `is_staff`.
- لا يمكن سوى **superuser** تعديل أو حذف superuser آخر.
- يمكن للمستخدم تعطيل TOTP الخاص به، أو يمكن لـ superuser تعطيله لأي شخص.

## المجموعات

تُدار المجموعات عبر `GroupViewSet` و `GroupSerializer` (في `src/paperless/serialisers.py`). تتكوّن المجموعة من:

- `name`
- `permissions` — قائمة بأسماء رموز الصلاحيات (مع استبعاد صلاحيات نوع محتوى إدارة Django).

تُعد المجموعات الآلية الأساسية لمنح صلاحيات **مستوى النموذج** لعدد كبير من المستخدمين دفعة واحدة. يرث المستخدمون صلاحيات مجموعاتهم تلقائيًا (يظهر ذلك عبر `inherited_permissions`).

يمكن ضبط تعيين المجموعات الافتراضية عند التسجيل عبر متغيرات البيئة:

- `PAPERLESS_ACCOUNT_DEFAULT_GROUPS`
- `PAPERLESS_SOCIAL_ACCOUNT_DEFAULT_GROUPS`
- `PAPERLESS_SOCIAL_ACCOUNT_SYNC_GROUPS` (لمزامنة المجموعات من مطالبة SSO)

## الصلاحيات

توجد الصلاحيات على مستويين مختلفين.

### صلاحيات مستوى النموذج (العامة)

هذه كائنات `Permission` قياسية في Django تحمل رموزًا بصيغة `action_model`. تُعدَّد الأنواع ذات الصلة في الواجهة الأمامية عبر `PermissionsService` (في `src-ui/src/app/services/permissions.service.ts`):

- `add_…` و `view_…` و `change_…` و `delete_…` لنماذج مثل `document` و `tag` و `correspondent` و `documenttype` و `storagepath` و `savedview` و `paperlesstask` و `note` و `mailaccount` و `mailrule` و `user` و `group` و `sharelink` و `customfield` و `workflow` وغيرها.

تُعرَّف صلاحيتان خاصتان على مستوى التطبيق على `ApplicationConfiguration` (في `src/paperless/models.py`):

| الصلاحية | الوصف |
| --- | --- |
| `view_global_statistics` | "يمكنه عرض أعداد الكائنات العامة" |
| `view_system_monitoring` | "يمكنه عرض معلومات حالة النظام" |

تُمنح هاتان الصلاحيتان عبر `user_permissions` الخاص بالمستخدم أو عبر `permissions` الخاصة بالمجموعة.

### صلاحيات مستوى الكائن

تُنفَّذ صلاحيات مستوى الكائن عبر `django-guardian`. يمكن لمعظم كائنات المحتوى (المستندات والوسوم والمراسلون وأنواع المستندات ومسارات التخزين والعروض المحفوظة وسير العمل والحقول المخصصة... إلخ) أن تملك **مالكًا** (owner) بالإضافة إلى صلاحيات صريحة لكل كائن.

يقبل الـ API حقل `owner` و/أو حمولة `set_permissions` (انظر `docs/api.md`):

```json
{
  "owner": 5,
  "set_permissions": {
    "view":   { "users": [1, 2], "groups": [3] },
    "change": { "users": [1],    "groups": []  }
  }
}
```

تُخزَّن هذه داخليًا كصفوف `UserObjectPermission` / `GroupObjectPermission` من guardian، وتكتبها الدالة `set_permissions_for_object()` في `src/documents/permissions.py`.

الفعلان الوحيدان على مستوى الكائن هما **`view`** و **`change`**.

!!! note

    منح صلاحية `change` يمنح تلقائيًا صلاحية `view` على الكائن نفسه، ويُطبَّق ذلك في `set_permissions_for_object()`.

## كيف يُتَّخذ قرار الوصول (القواعد)

يقع المنطق الأساسي في `src/documents/permissions.py`.

### ربط أفعال HTTP بالصلاحيات

يربط `PaperlessObjectPermissions` (وهو صنف فرعي من `DjangoObjectPermissions`) طرق HTTP برموز الصلاحيات المطلوبة:

| طريقة HTTP | الصلاحية المطلوبة |
| --- | --- |
| `GET`, `OPTIONS`, `HEAD` | `view_<model>` |
| `POST` | `add_<model>` |
| `PUT`, `PATCH` | `change_<model>` |
| `DELETE` | `delete_<model>` |

### قاعدة "الوعي بالمالك"

تقرر `PaperlessObjectPermissions.has_object_permission` الوصولَ إلى كائن واحد كما يلي:

1. إذا كان للكائن `owner` وكان `request.user == owner` → **مسموح**.
2. وإلا يُرجِع الفحص القرارَ إلى فحص guardian لصلاحيات الكائن.
3. إذا لم يكن للكائن **مالك** (`owner is None`) → **مسموح للجميع** (تُعد الكائنات بلا مالك عامة/مشتركة فعليًا).

يُلخَّص المنطق نفسه في الدالة المساعدة `has_perms_owner_aware()`:

```python
def has_perms_owner_aware(user, perms, obj):
    checker = ObjectPermissionChecker(user)
    return obj.owner is None or obj.owner == user or checker.has_perm(perms, obj)
```

بعبارة بسيطة، يمكن للمستخدم الوصول إلى كائن إذا تحقق **أيٌّ** مما يلي:

- أنه **مالك** الكائن، أو
- أن الكائن **بلا مالك** (عام)، أو
- أنه يملك **صلاحية `view`/`change` صريحة** على الكائن، مباشرة أو عبر مجموعة.

### سرد الكائنات التي يمكن للمستخدم رؤيتها

تعيد `get_objects_for_user_owner_aware()` اتحاد ما يلي:

- الكائنات التي **يملكها** المستخدم،
- الكائنات **بلا مالك**،
- الكائنات التي يملك عليها **صلاحيات صريحة**.

وبالنسبة للمستندات تحديدًا، تبني `_permitted_document_ids()` فلتر SQL كفؤًا:

```python
Q(owner=user) | Q(owner__isnull=True) | Q(id__in=permitted_ids)
```

يتجاوز superuser الفلتر دائمًا ويرى كل شيء. ويرى المستخدمون المجهولون/غير المصادقين **الكائنات بلا مالك فقط**.

### من يحق له تغيير صلاحيات كائن

لتجاوز صلاحيات كائن (أو تغيير مالكه)، يجب أن يكون المستخدم الطالب هو **مالك الكائن أو superuser**. يفرض المسلسل (`src/documents/serialisers.py`) ذلك ويرفع `PermissionDenied` في غير ذلك.

### الانعكاس في الواجهة الأمامية

تعكس خدمة `PermissionsService` في Angular (في `src-ui/src/app/services/permissions.service.ts`) هذه القواعد لإظهار واجهة المستخدم:

- `currentUserCan(action, type)` — superuser أو أن المستخدم يحمل رمز الصلاحية.
- `currentUserOwnsObject(obj)` — true إذا كان الكائن بلا مالك، أو مملوكًا للمستخدم الحالي، أو أن المستخدم superuser.
- `currentUserHasObjectPermissions(action, obj)` — مالك/بلا مالك أو أن المستخدم مدرج في قوائم `permissions.view` / `permissions.change` للمستخدمين أو المجموعات.

## أصناف الصلاحيات الخاصة

تُعرَّف أصناف الصلاحيات التالية في `src/documents/permissions.py`:

| الصنف | القاعدة |
| --- | --- |
| `PaperlessAdminPermissions` | `request.user.is_staff` فقط (إدارة Django). |
| `ViewDocumentsPermissions` | يتطلب `documents.view_document`. |
| `PaperlessNotePermissions` | يتطلب `view_note` أو `add_note` أو `delete_note`. |
| `AcknowledgeTasksPermissions` | يتطلب `documents.change_paperlesstask`. |

## "القواعد" ذات الصلة (الأتمتة)

تُستخدم كلمة "قواعد" (rules) أيضًا لوصف ميزتين للأتمتة منفصلتين عن التحكم بالوصول:

- **سير العمل (Workflows)** (`Workflow` و `WorkflowTrigger` و `WorkflowAction` في `src/documents/models.py`) — قواعد شرط/إجراء تُطبَّق على المستندات. يطابق مشغّل سير العمل المستندات (مثل "يملك هذه الوسوم / هذا المراسل / هذا النوع من المستندات") ويمكن لإجراءاته تعيين مراسل أو مسار تخزين أو **مالك** أو منح صلاحيات `view`/`change` لمستخدمين ومجموعات محددة. لذا تتغذّى إجراءات سير العمل مرة أخرى على نظام صلاحيات الكائن الموصوف أعلاه.
- **قواعد البريد (Mail rules)** (`MailRule` في `src/paperless_mail/models.py`) — قواعد تحدد كيفية استهلاك رسائل البريد الواردة.



