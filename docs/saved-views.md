---
title: Saved Views
---

# Saved Views

A **saved view** is a named set of filters, sorting, columns and layout that you
keep and reuse. Instead of rebuilding "invoices from this year, newest first"
every morning, you save it once and open it with a single click from the
**Views** menu, the sidebar, or the dashboard.

You can create a view from the documents list (see
[Browsing, Filtering and Searching](documents/browsing.md)); the **Saved Views**
page under **Manage** is where you look after the ones you already have.

## The Saved Views page

Choose **Saved Views** under **Manage** in the sidebar. The page header reads
*Customize the views of your documents.* Every view you are allowed to see has
its own row in the list, with these controls:

| Field | What it means |
| --- | --- |
| **Name** | What the view is called, everywhere it appears — the menu, the sidebar, the dashboard, and as the page title when you open it. |
| **Show on dashboard** | Whether the view gets its own card on the **Dashboard**. |
| **Show in sidebar** | Whether the view is listed in the sidebar under the **Saved views** heading. |
| **Documents page size** | How many documents the list shows per page when you open this view. |
| **Display as** | How the results are drawn: **Table**, **Small Cards**, or **Large Cards**. |
| **Show** | Which fields each row displays. Leave it at **Default** to follow the installation's standard set. |
| **Actions** | **Permissions**, which sets the owner and who may view or change the view, and **Delete**. |

Two things are worth noticing on this page:

- The line under the columns, **Note: ordering is not preserved**, is about the
  **Show** list: the order in which you arrange the fields there is not kept, so
  only the choice of fields matters.
- The page compares what you have changed against what was stored. **Save**
  stays greyed out until something is different, and **Cancel** puts everything
  back the way it was.

With no views at all the page simply says **No saved views defined.**, which is
your cue to go to the documents list and create one.

!!! note

    Deleting a view never deletes documents. It only removes the shortcut.

## The Views menu in the document list

The day-to-day way to work with views is the **Views** button above the
documents list:

- The menu lists every view you can use. Picking one jumps straight to it, and
  the page title becomes the view's name.
- **Save "…"** writes your current filters back into the view you are looking
  at. It only appears when you opened the list from a view you are allowed to
  change.
- **Save as...** opens the **Save current view** dialog to make a new view.
- **All saved views** opens the management page described above.
- A small dot on the **Views** button reminds you that you have changed the
  filters, the sorting, or the columns since the view was last saved.

A view remembers the filters, the sorting, the columns and the layout — not a
list of documents. Open it tomorrow and it shows what matches the rules *then*,
which is why a view called "This year" always stays current.

## Creating a view from the document list

1. Open **Documents** and build the list you want: search, tick filters, choose
   a sort order, and pick the columns you like.
2. Open the **Views** menu and choose **Save as...**.
3. In the **Save current view** dialog:
   - Give it a **Name**.
   - Tick **Show in sidebar** and/or **Show on dashboard** if you want the
     shortcut handy.
   - Set the owner and who else may use it, if you like.
4. Click **Save**.

If one of the filters is not something a view can store, the dialog shows the
alert **Filter rules error occurred while saving this view** and reports what
**The error returned was**, so you can fix the filter and try again.

## Where views appear

| Place | What you get |
| --- | --- |
| **Views** menu in the documents list | Every view you can use, by name |
| Sidebar, under **Saved views** | The views you ticked **Show in sidebar** for |
| **Dashboard** | One card per view you ticked **Show on dashboard** for, which you can reorder by dragging |
| **Saved Views** page | Every view you are allowed to see, with all of its settings |

Once a view is open it behaves exactly like the documents list — you can select,
edit, download, and share the documents in it as usual.

## Sharing a view

Views are objects with their own owner and permissions, so they can be shared
independently of the documents inside them:

- **Permissions** opens the usual owner, **View**, and **Edit** form.
- Open the dialog and you will see the reminder
  **Note: Sharing saved views does not share the underlying documents.** Whoever
  you share a view with still only sees the documents *they* are allowed to see;
  the view just saves them the work of rebuilding the filters.
- If **Save as...** is missing from the **Views** menu, you do not have
  permission to add views — ask an owner or an administrator.

!!! warning

    Because a view is only a filter, sharing one is a convenience, not a
    security decision. Give people access to the documents themselves with
    [permissions or share links](documents/sharing.md).

## A quick example

Omar runs the accounts for a small workshop. Every morning he needs the
invoices that arrived since his last check.

He opens **Documents**, opens the filter for **Document type** and ticks
"Invoice", opens **Dates** and chooses **Last 7 days** under **Added**, then
opens **Sort** and picks **Added** newest first. He clicks **Views → Save
as...**, names it **"Invoices this week"**, ticks **Show in sidebar**, and saves.

The view now sits in the sidebar. When his colleague Salma needs the same list,
Omar opens **Manage → Saved Views**, clicks **Permissions** on
**"Invoices this week"**, and grants her **View**. Salma sees the view in her
**Views** menu, but only ever the invoices she is herself allowed to open.
