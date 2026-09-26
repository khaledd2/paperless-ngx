---
title: The Dashboard and Navigating the Interface
---

# The Dashboard and Navigating the Interface

When you sign in to Paperless-ngx you land on the **Dashboard**. From there you
move around the app using the **sidebar** on the left and the **top bar** across
the top. This guide explains what each part does and how to get where you want
to go.

## The top bar

The bar across the top of every page stays with you wherever you go. From left
to right it contains:

- **The logo and app name** — clicking them always takes you back to the
  **Dashboard**.
- **Search** — the global search box, described below.
- **The AI assistant button** — appears only if an administrator has turned on
  the AI features. It opens a chat you can ask questions about your documents.
- **Notifications** — a bell-shaped button that shows background events and
  messages, such as documents that have finished being processed or errors that
  need your attention.
- **Your account menu** — your name (or avatar) opens a menu with:
    - **My Profile** — change your display name, e-mail, password, and
      two-factor authentication.
    - **Settings** — open the application settings.
    - **Logout** — sign out.
    - **Documentation** — open the online documentation in a new tab.

### Search

The **Search** box finds things as you type. Results are grouped by type, in
this order: **Documents**, **Saved Views**, **Tags**, **Correspondents**,
**Document types**, **Storage paths**, **Users**, **Groups**, **Custom fields**,
**Mail accounts**, **Mail rules**, and **Workflows**. If nothing matches, it
shows **No results**.

Each result offers buttons that do the most useful thing for that item — for
example:

- **Open** a document, a saved view, a workflow, or a custom field.
- **Download** a document.
- **Filter documents** by a tag, correspondent, document type, or storage path.

If you press the search button instead of picking a result, you run a full
search. The **Full search links to** setting (under **Global search** in
**Settings**) decides what that button does: either **Title and content
search**, which opens your documents list filtered by the words you typed, or
**Advanced search**, which opens it as a full query you can extend.

## The dashboard

The **Dashboard** is your home page. A greeting at the top welcomes you by
name, when a display name has been set. The page is made up of flexible
**widgets**: the main column holds a card for each saved view you have chosen to
show here, and the column on the right holds the **Upload documents** and
**Statistics** widgets. On a narrow screen the widgets stack into a single
column.

### Upload documents

The **Upload documents** widget starts adding documents to Paperless-ngx.
Click it to choose files, or simply **drag and drop** files onto any page of the
app. You can also drop files into the watched *consume folder* if your
installation uses one.

While documents are being processed, a small status card appears in the corner
showing progress, any errors, and a link to **Open document** once a document is
ready. **Dismiss completed** clears the finished messages.

### Saved view widgets

Any **saved view** you choose to show on the dashboard appears as its own card.
A saved view is a stored set of filters — for example "Inbox", "Unpaid
invoices", or "Recent contracts".

- The card's title is the name of the saved view, and it shows how many
  documents match.
- **Show all** opens that view in the full documents list.
- You can **reorder** the cards by dragging them by their handle, and the new
  order is saved for you.
- If you have not created any saved views yet, the dashboard shows a hint
  linking to the documents list, where views are created.

!!! note

    To control whether a view appears on the dashboard or in the sidebar, open
    **Manage → Saved Views** and tick **Show on dashboard** and/or
    **Show in sidebar** for that view.

### Statistics

The **Statistics** widget summarizes your archive. Depending on your
permissions it can include:

- **Documents in inbox** — documents not yet filed under a view; clicking it
  opens them.
- **Total documents** — how many documents you have.
- **Total characters** — how much searchable text is stored.
- **Current ASN** — the highest archive serial number in use.
- A breakdown of **file types**.
- Counts for **Tags**, **Correspondents**, **Document Types**, and
  **Storage Paths**, each linking to its list.

### The first-time tour

The first time you sign in, a welcome message offers a quick guided tour of the
app, ending with a thank-you. You can start it with **Start the tour**; it walks
you through the dashboard, uploading, the documents list, filtering, saved
views, attributes, mail, workflows, tasks, and settings. A button is also
available in **Settings** if you want to take the tour later.

## The sidebar

The sidebar on the left is how you move around the app. Its sections appear in
this order:

### Dashboard and Documents

- **Dashboard** — return to your home page at any time.
- **Documents** — open the list of every document you are allowed to see.

### Saved views

Every saved view you have chosen to show **in the sidebar** is listed here under
the heading **Saved views**. Click one to open it. A small badge can show how
many documents match each view; you can turn that count on or off with
**Show document counts in sidebar saved views** in **Settings**.

While you are on the **Manage → Saved Views** page, you can **drag** the sidebar
views to change their order. The order is saved for you.

### Open documents

When you open a document for editing, it stays listed in the sidebar under
**Open documents**. This is handy for jumping between several documents without
losing your place. **Close all** closes them together.

### Manage

The **Manage** section holds the things you use to organize your archive:

- **Attributes** — the lists of **Tags**, **Correspondents**,
  **Document types**, **Storage paths**, and **Custom fields**. Each is a
  management list where you can add, edit, delete, search, and set permissions.
- **Saved Views** — create, rename, reorder, delete, and choose where each view
  appears.
- **Workflows** — automatic rules that respond to events.
- **Mail** — e-mail accounts and **Mail rules** for importing documents.
- **Trash** — documents you have deleted, where they can be restored.

### Administration

The **Administration** section is for the person who runs the installation (some
items need special permissions):

- **Settings** — personal and application-wide preferences.
- **Configuration** — the administrator view of how the system is set up.
- **Users & Groups** — manage accounts, groups, and permissions.
- **Tasks** — background work, what needs attention, and what recently
  completed.
- **Logs** — system messages, for administrators only.
- **About** and **Documentation** — version information and a link to the
  online documentation.

### A slim sidebar

If you prefer more room for your documents, you can switch the sidebar to a
**slim** version showing icons only. Turn on **Use "slim" sidebar (icons only)**
in **Settings**. You can also collapse or expand the sidebar with the small
arrow button at its top.

## A map of the app

| Where to go | What you can do there |
| --- | --- |
| **Dashboard** | Upload documents, see statistics, open your saved-view widgets. |
| **Documents** | Browse, search, filter, sort, and bulk-edit documents. |
| **A single document** | Preview it, edit its details, read and write notes, see its history, download or share it. |
| **Attributes** | Manage tags, correspondents, document types, storage paths, and custom fields. |
| **Saved Views** | Manage your saved filters and where they appear. |
| **Workflows** | Build automatic rules for your documents. |
| **Mail** | Connect e-mail accounts and write rules that import documents. |
| **Trash** | Restore or permanently remove deleted documents. |
| **Settings** | Change how the app looks and behaves for you. |
| **Users & Groups** | (Administrators) manage people and access. |

## A quick example

Ana signs in for the first time and finds the welcome message on the
**Dashboard**. She clicks **Start the tour**, follows it through the app, and
finishes knowing where everything lives.

She opens the **Search** box, types the name of her bank, and clicks
**Filter documents** on the result. The documents list shows every document
from that correspondent. She narrows it further to the current year, saves the
result as a view called **"Bank 2026"**, and ticks **Show on dashboard**.

Back on the **Dashboard**, the new **Bank 2026** card is waiting. She drags it
to the top, so it is the first thing she sees whenever she signs in.


