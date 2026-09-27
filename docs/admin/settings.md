---
title: Settings
---

# Settings

**Settings** is where each person tailors the interface to themselves. You find
it in the sidebar under **Administration**, and the page describes itself as
*Options to customize appearance, notifications and more. Settings apply to the
**current user only**.*

That last sentence is the important one: nothing on this page changes the archive
for anybody else. Two people can sign in to the same installation and see
completely different colours, languages and page sizes, and neither of them
disturbs the other.

The settings are kept with your account, so they follow you to any computer or
browser you sign in from.

## The page at a glance

The header carries up to three buttons:

| Button | What it does |
| --- | --- |
| **Start tour** | A short guided walkthrough that points at the main parts of the interface. |
| **System Status** | Opens the health report of the installation — see [System Status](system-status.md). A green tick on the button means all is well; a red mark means something needs attention. |
| **Open Django Admin** | Only administrators see this. It opens the technical administration interface of the installation in a new tab, and is only needed for advanced work. |

Below the header the settings are grouped into four tabs: **General**,
**Documents**, **Permissions**, and **Notifications**.

At the bottom of every tab sit **Cancel** and **Save**. Both stay greyed out
until you have actually changed something, which is also how you can tell whether
your work is already stored:

- **Save** stores the tab you are on and shows the message *Settings were saved
  successfully.*
- If a change only takes effect after the page is reloaded, the message becomes
  *Settings were saved successfully. Reload is required to apply some changes.*
  and offers a **Reload now** action.
- **Cancel** puts everything back the way it was.
- If storing fails, the message is **An error occurred while saving settings.**

!!! note

    Appearance changes — dark mode and the theme colour — are shown straight
    away as you change them, so you can see what you are choosing. They are only
    kept if you press **Save**; leaving the page without saving restores the old
    look.

## General

### Appearance

| Setting | What it changes |
| --- | --- |
| **Display language** | The language of the whole interface. Leave it at **Use system language** to follow your browser, or pick a language from the list — the English name is shown next to each translation. |
| **Date display** | Which country's conventions are used for dates. **Use date format of display language** follows the interface language; every other choice shows a sample date so you can compare. |
| **Date format** | How a date is written, with a live example of today's date for each choice: **Short**, **Medium**, or **Long**. |
| **Sidebar** | The single option **Use 'slim' sidebar (icons only)** shrinks the sidebar to a strip of icons, which leaves more room for the document list or viewer. |
| **Dark mode** | **Use system settings** follows your computer's light/dark choice. Untick it to choose yourself with **Enable dark mode**. **Invert thumbnails in dark mode** flips pale document previews so they are not glaring on a dark background. |
| **Theme Color** | The accent colour of the interface. **Reset** returns it to the installation's own colour. |

!!! note

    Changing **Display language** shows the reminder **You need to reload the
    page after applying a new language.** — press **Save**, then reload.

### Global search

| Setting | What it changes |
| --- | --- |
| **Do not include advanced search results** | Keeps the suggestions under the search box to the plain title-and-content search. |
| **Full search links to** | Where the **Full search** link takes you: **Title and content search**, or **Advanced search** with its filter rules. |

### Update checking

**Enable update checking** lets Paperless-ngx compare itself with the latest
published release. The question mark beside it explains the details: the
installation asks the public release catalogue of the project whether a newer
version exists — installing that version is still a manual job for whoever
maintains the server — and *No tracking data is collected by the app in any way.*

Turning this on is one of the changes that needs a reload.

### Saved Views

| Setting | What it changes |
| --- | --- |
| **Show warning when closing saved views with unsaved changes** | Asks before you leave a changed view, so a filter change is not lost by accident. |
| **Show document counts in sidebar saved views** | Puts the number of matching documents next to each view in the sidebar. |

## Documents

### Documents

**Items per page** sets how many documents a list shows at a time — 10, 25, 50,
or 100. Saved views can override this for themselves; see
[Saved Views](../saved-views.md).

### Document editing

| Setting | What it changes |
| --- | --- |
| **Use PDF viewer provided by the browser** | Shows PDFs with the viewer built into your browser instead of the one Paperless-ngx provides. Usually faster for large documents, but not every browser handles it well. |
| **Default zoom** | How a document is opened: **Fit width** or **Fit page**. It applies only to the Paperless-ngx PDF viewer. |
| **Automatically remove inbox tag(s) on save** | When you edit a document and save it, the inbox tag is cleared for you — the usual way of saying "I have dealt with this one". |
| **Show document thumbnail during loading** | Shows a preview of the page while the full document is still arriving, instead of an empty space. |
| **Built-in fields to show** | Tick or untick **Archive serial number**, **Correspondent**, **Document type**, **Storage path** and **Tags**. As the page says, *Uncheck fields to hide them on the document details page.* |

### Bulk editing

| Setting | What it changes |
| --- | --- |
| **Show confirmation dialogs** | Asks you to confirm before a bulk change is applied. |
| **Apply on close** | Applies a bulk edit as soon as you close the window, instead of waiting for a button. |

### PDF Editor

**Default editing mode** chooses what the PDF editor does when you open it:
**Create new document(s)**, or **Add document version** to the document you are
already looking at.

### Notes

**Enable notes** turns the notes feature on or off for your account, so you can
hide it if you never annotate documents.

## Permissions

This tab does not change who may see what. It sets the permissions that are
pre-filled for you when *you* create something in the web interface — the page
says so itself: *Settings apply to this user account for objects (Tags, Mail
Rules, etc. but not documents) created via the web UI.*

| Field | What it means |
| --- | --- |
| **Default Owner** | Who owns the new objects. Left empty, the note under the field applies: *Objects without an owner can be viewed and edited by all users*. |
| **Default View Permissions** | The **Users:** and **Groups:** who may see the new objects. |
| **Default Edit Permissions** | The **Users:** and **Groups:** who may change them. The reminder under the fields is worth remembering: *Edit permissions also grant viewing permissions*. |

Documents are deliberately not covered here: a document's permissions are
decided on the document itself — see
[Sharing and permissions](../documents/sharing.md).

!!! tip

    If you keep a tidy archive, setting **Default Owner** to yourself is the
    usual choice, because objects you create then belong to you instead of
    belonging to nobody.

## Notifications

The **Document processing** switches decide which messages reach the bell menu —
the **Notifications** list in the top bar, where **Clear All** empties it and an
empty list says **No notifications**:

| Setting | What it tells you about |
| --- | --- |
| **Show notifications when new documents are detected** | A new file has been noticed and is waiting to be processed. |
| **Show notifications when document processing completes successfully** | A document finished and is ready. |
| **Show notifications when document processing fails** | A document could not be processed. |
| **Suppress notifications on dashboard** | *This will suppress all messages about document processing status on the dashboard.* |

!!! warning

    Turning off the failure notifications is tempting in a busy installation,
    but those are the messages that tell you a document never made it into the
    archive. If you silence them, check [Tasks](tasks.md) now and then instead —
    the tasks that need attention are counted there.

## A quick example

Salma works in Arabic all day but has to read a lot of English invoices, and she
finds the large document previews hard on her eyes in the evening.

She opens **Settings**. On **General** she leaves **Display language** at
**Use system language**, sets **Date display** to her own region and chooses
**Long** as the **Date format** so the dates in the details panel are
unmistakable. Under **Dark mode** she leaves **Use system settings** ticked and
turns on **Invert thumbnails in dark mode**. She picks a green **Theme Color**.

On **Documents** she sets **Items per page** to **25** so there is less
scrolling, ticks **Automatically remove inbox tag(s) on save** so her inbox
empties itself as she works, and unticks **Tags** under **Built-in fields to
show** because she prefers to see the tags only when she opens a document.

On the **Notifications** tab she unticks **Show notifications when new documents
are detected** to quieten the bell, then presses **Save** and sees *Settings were
saved successfully.* The next time she signs in from her laptop, all of it is
still there.
