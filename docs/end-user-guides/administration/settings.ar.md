---
title: الإعدادات
---

# الإعدادات (Settings)

**Settings** هي المكان الذي يُهيّئ فيه كل شخص الواجهة على ذوقه. تجدها في الشريط
الجانبي تحت **Administration**، وتصف الصفحة نفسها بأنها
*Options to customize appearance, notifications and more. Settings apply to the
**current user only**.*

هذه الجملة الأخيرة هي المهمّة: لا شيء في هذه الصفحة يغيّر الأرشيف عند الآخرين.
يمكن لشخصين تسجيل الدخول إلى التثبيت نفسه ورؤية ألوان ولغات وأحجام صفحات مختلفة
تمامًا، من دون أن يُزعج أحدهما الآخر.

وتُحفظ الإعدادات مع حسابك، فترافقك إلى أي حاسوب أو متصفّح تسجّل الدخول منه.

## نظرة سريعة على الصفحة

يحمل رأس الصفحة حتى ثلاثة أزرار:

| الزر | ما يفعله |
| --- | --- |
| **Start tour** | جولة قصيرة موجّهة تُشير إلى الأجزاء الرئيسية في الواجهة. |
| **System Status** | يفتح تقرير صحة التثبيت — راجع [حالة النظام (System Status)](system-status.md). وجود علامة صحّ خضراء على الزر يعني أن كل شيء سليم، والعلامة الحمراء تعني أن شيئًا يحتاج انتباهك. |
| **Open Django Admin** | يراه المدراء فقط. يفتح واجهة الإدارة التقنية للتثبيت في تبويب جديد، ولا يُحتاج إليه إلا في الأعمال المتقدّمة. |

وتحت الرأس تُوزَّع الإعدادات على أربع تبويبات: **General** و**Documents**
و**Permissions** و**Notifications**.

وفي أسفل كل تبويب يقع **Cancel** و**Save**. ويبقى الاثنان باهتَين حتى تغيّر شيئًا
فعلًا، وهذا أيضًا دليلٌ على أن عملك محفوظ من قبل:

- يخزّن **Save** التبويب الذي أنت فيه ويعرض رسالة
  *Settings were saved successfully.*
- وإذا كان التغيير لا يسري إلا بعد إعادة تحميل الصفحة، تصير الرسالة
  *Settings were saved successfully. Reload is required to apply some changes.*
  مع زرّ **Reload now**.
- ويُعيد **Cancel** كل شيء إلى ما كان عليه.
- وإذا فشل التخزين جاءت الرسالة **An error occurred while saving settings.**

!!! note

    تُعرض تغييرات المظهر — الوضع الليلي ولون السمة — فورًا أثناء تغييرها، لترى ما
    تختاره بعينك. لكنها لا تُحفظ إلا إذا ضغطت **Save**؛ ومغادرة الصفحة بلا حفظ
    تُعيد المظهر القديم.

## عام (General)

### المظهر (Appearance)

| الإعداد | ما يغيّره |
| --- | --- |
| **Display language** | لغة الواجهة كلها. اتركه على **Use system language** ليتابع متصفّحك، أو اختر لغة من القائمة — ويظهر الاسم بالإنجليزية بجانب كل ترجمة. |
| **Date display** | اصطلاحات أي بلد تُستعمل في التواريخ. يتابع **Use date format of display language** لغة الواجهة، ويعرض كل خيار آخر تاريخًا نموذجيًا لتقارن بينها. |
| **Date format** | طريقة كتابة التاريخ، مع مثال حيّ لتاريخ اليوم أمام كل خيار: **Short** أو **Medium** أو **Long**. |
| **Sidebar** | الخيار الوحيد **Use 'slim' sidebar (icons only)** يقلّص الشريط الجانبي إلى شريط أيقونات رفيع، فيترك مساحة أكبر لقائمة المستندات أو للعارض. |
| **Dark mode** | يتابع **Use system settings** اختيار حاسوبك بين الفاتح والداكن. أزل العلامة لتختار بنفسك بـ **Enable dark mode**. ويقلب **Invert thumbnails in dark mode** معاينات المستندات الفاتحة حتى لا تُبهِر العين على خلفية داكنة. |
| **Theme Color** | اللون المميّز للواجهة. ويُعيده **Reset** إلى لون التثبيت الأصلي. |

!!! note

    تغيير **Display language** يُظهر التذكير **You need to reload the page after
    applying a new language.** — اضغط **Save** ثم أعد التحميل.

### البحث الشامل (Global search)

| الإعداد | ما يغيّره |
| --- | --- |
| **Do not include advanced search results** | يقصر الاقتراحات تحت صندوق البحث على البحث البسيط في العنوان والمحتوى. |
| **Full search links to** | إلى أين يوصل رابط **Full search**: **Title and content search**، أو **Advanced search** بقواعد تصفيته. |

### التحقّق من التحديثات (Update checking)

يتيح **Enable update checking** لـ Paperless-ngx أن يقارن نفسه بأحدث إصدار
منشور. وتشرح علامة الاستفهام بجانبه التفاصيل: يسأل التثبيت فهرس الإصدارات العام
الخاص بالمشروع هل يوجد إصدار أحدث — ويبقى تثبيت ذلك الإصدار مهمة يدوية يقوم بها
من يدير الخادم — و*No tracking data is collected by the app in any way.*

وتشغيل هذا الخيار من التغييرات التي تحتاج إلى إعادة تحميل.

### العروض المحفوظة (Saved Views)

| الإعداد | ما يغيّره |
| --- | --- |
| **Show warning when closing saved views with unsaved changes** | يسألك قبل مغادرة عرض تغيّر، فلا يضيع تغيير المرشّح من غير قصد. |
| **Show document counts in sidebar saved views** | يضع عدد المستندات المطابقة بجانب كل عرض في الشريط الجانبي. |

## المستندات (Documents)

### المستندات (Documents)

يحدّد **Items per page** عدد المستندات التي تعرضها القائمة في المرة الواحدة —
10 أو 25 أو 50 أو 100. ويمكن للعروض المحفوظة أن تتجاوز ذلك لنفسها؛ راجع
[العروض المحفوظة (Saved Views)](../automation/saved-views.md).

### تحرير المستند (Document editing)

| الإعداد | ما يغيّره |
| --- | --- |
| **Use PDF viewer provided by the browser** | يعرض ملفات PDF بالعارض المدمج في متصفّحك بدلًا من العارض الذي يوفّره Paperless-ngx. أسرع عادةً مع المستندات الكبيرة، لكن ليست كل المتصفّحات تجيده. |
| **Default zoom** | كيف يُفتح المستند: **Fit width** أو **Fit page**. وهو يسري على عارض PDF الخاص بـ Paperless-ngx وحده. |
| **Automatically remove inbox tag(s) on save** | عند تحرير مستند وحفظه يُمسح وسم البريد الوارد عنك — وهي الطريقة المعتادة للقول «فرغت من هذا المستند». |
| **Show document thumbnail during loading** | يعرض معاينة للصفحة أثناء وصول المستند كاملًا، بدلًا من مساحة فارغة. |
| **Built-in fields to show** | ضع علامة أو أزلها عن **Archive serial number** و**Correspondent** و**Document type** و**Storage path** و**Tags**. وكما تقول الصفحة: *Uncheck fields to hide them on the document details page.* |

### التعديل الجماعي (Bulk editing)

| الإعداد | ما يغيّره |
| --- | --- |
| **Show confirmation dialogs** | يسألك التأكيد قبل تطبيق التغيير الجماعي. |
| **Apply on close** | يطبّق التعديل الجماعي فور إغلاق النافذة بدل انتظار زرّ. |

### محرّر PDF (PDF Editor)

يختار **Default editing mode** ما يفعله محرّر PDF عند فتحه: **Create new
document(s)**، أو **Add document version** إلى المستند الذي تنظر إليه الآن.

### الملاحظات (Notes)

يشغّل **Enable notes** ميزة الملاحظات في حسابك أو يوقفها، فتُخفيها إن كنت لا
تكتب ملاحظات على المستندات أبدًا.

## الصلاحيات (Permissions)

لا تغيّر هذه التبويبة من يرى ماذا. إنها تحدّد الصلاحيات المملوءة مسبقًا لك عندما
تُنشئ *أنت* شيئًا في واجهة الويب — وتقول الصفحة ذلك بنفسها: *Settings apply to
this user account for objects (Tags, Mail Rules, etc. but not documents) created
via the web UI.*

| الحقل | معناه |
| --- | --- |
| **Default Owner** | مَن يملك الكائنات الجديدة. وإذا تُرك فارغًا سرت الملاحظة تحت الحقل: *Objects without an owner can be viewed and edited by all users*. |
| **Default View Permissions** | المستخدمون **Users:** والمجموعات **Groups:** المسموح لهم برؤية الكائنات الجديدة. |
| **Default Edit Permissions** | المستخدمون **Users:** والمجموعات **Groups:** المسموح لهم بتغييرها. وملاحظة تحت الحقول تستحق التذكّر: *Edit permissions also grant viewing permissions*. |

والمستندات مستثناة من هذا قصدًا: فتُحدَّد صلاحيات المستند على المستند نفسه —
راجع [المشاركة والصلاحيات (Sharing and permissions)](../documents/sharing.md).

!!! tip

    إن كنت تحرص على ترتيب الأرشيف، فتعيين **Default Owner** على نفسك هو الخيار
    المعتاد، لأن الكائنات التي تُنشئها تصير ملكك بدل أن تصير بلا مالك.

## الإشعارات (Notifications)

تحدّد مفاتيح **Document processing** أي الرسائل تصل إلى قائمة الجرس — أي قائمة
**Notifications** في الشريط العلوي، حيث يُفرغها **Clear All** وتقول القائمة
الفارغة **No notifications**:

| الإعداد | عمّ يخبرك |
| --- | --- |
| **Show notifications when new documents are detected** | لوحظ ملف جديد وهو في انتظار المعالجة. |
| **Show notifications when document processing completes successfully** | انتهى مستند وصار جاهزًا. |
| **Show notifications when document processing fails** | تعذّرت معالجة مستند. |
| **Suppress notifications on dashboard** | *This will suppress all messages about document processing status on the dashboard.* |

!!! warning

    إيقاف إشعارات الفشل مغري في تثبيت مزدحم، لكنها الرسائل التي تخبرك بأن مستندًا
    لم يصل إلى الأرشيف قط. وإن أسكتّها فراجع [المهام (Tasks)](tasks.md) من وقت إلى
    آخر بدلًا منها — فالمهام التي تحتاج انتباهك تُعَدّ هناك.

## مثال سريع

تعمل سلمى بالعربية طوال يومها، لكن عليها أن تقرأ كثيرًا من الفواتير الإنجليزية،
ويُتعب نظرها في المساء حجم معاينات المستندات الكبيرة.

تفتح **Settings**. في **General** تترك **Display language** على **Use system
language**، وتضبط **Date display** على منطقتها، وتختار **Long** في **Date
format** حتى تكون التواريخ في لوحة التفاصيل واضحة لا تلتبس. وفي **Dark mode**
تترك **Use system settings** معلَّمًا وتُشغّل **Invert thumbnails in dark mode**.
وتختار **Theme Color** أخضر.

وفي **Documents** تضبط **Items per page** على **25** فيقلّ التمرير، وتعلّم
**Automatically remove inbox tag(s) on save** فيُفرغ صندوق واردها نفسه أثناء
عملها، وتزيل العلامة عن **Tags** تحت **Built-in fields to show** لأنها تفضّل
رؤية الوسوم فقط عند فتح المستند.

وفي تبويبة **Notifications** تُزيل العلامة عن **Show notifications when new
documents are detected** لتهدأ قائمة الجرس، ثم تضغط **Save** فيظهر
*Settings were saved successfully.* وتبقى هذه الإعدادات كلها موجودة في المرّة
القادمة التي تسجّل فيها الدخول من حاسوبها المحمول.
