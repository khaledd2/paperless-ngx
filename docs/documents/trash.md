---
title: Deleting and Restoring Documents
---

# Deleting and Restoring Documents

Nothing in Paperless-ngx disappears the moment you delete it. A deleted document
goes to the **Trash**, where it waits for a while so that a mistake can be undone.

## Moving a document to the trash

Open the document and click **Delete** in the top bar. A confirmation dialog
appears:

- **Do you really want to move the document "…" to the trash?**
- *Documents can be restored prior to permanent deletion.*
- The confirm button is labelled **Move to trash**.

When several documents have to go, select them in the list and use the **Delete**
button in the bulk editing bar; see
[Working with Many Documents at Once](bulk.md).

Once deleted, the document disappears from **Documents**, from saved views, and
from the dashboard, and any **share link** pointing at it stops working. Anything
dependent on it — a workflow that would have matched it, an e-mail rule — simply
never sees it again.

!!! note

    Deleting is not something you can do to somebody else's document. The
    **Delete** button only appears when you have permission to delete the
    document, so if it is missing you are looking at a document shared with you
    rather than owned by you.

## Opening the Trash

Choose **Trash** in the sidebar under **Manage**. The page is described as
*Manage trashed documents that are pending deletion*, and lists:

| Column | Meaning |
| --- | --- |
| **Name** | The document's title, with an eye button to preview it |
| **Remaining** | How many days are left before the document is deleted for good, shown as “N days” |
| **Actions** | **Restore** and **Delete** for that one document |

At the bottom you will see a count such as “3 total documents in trash”, and how
many are currently selected. At the top of the page are four buttons:
**Clear selection**, **Restore selected**, **Delete selected**, and
**Empty trash**.

!!! tip

    The **Remaining** column is your safety net. If a document matters, restore
    it before the days run out — the number comes from a delay your administrator
    sets, 30 days by default.

## Restoring

- Click **Restore** beside a single document, or
- tick the documents you want and click **Restore selected**.

A message confirms that the document was restored. It reappears in your lists
immediately, with its tags, correspondent, document type, storage path, custom
fields, notes, and history all untouched — a deleted document keeps its place in
the archive until the trash is emptied.

## Deleting for good

- **Delete** beside one document permanently removes that document.
- **Delete selected** permanently removes the documents you have ticked.
- **Empty trash** permanently removes everything in the trash.

All three ask for confirmation first, and the dialogs are blunt about the
consequences: *This operation will permanently delete this document* (or *the
selected documents*, or *all documents in the trash*), and *This operation cannot
be undone*.

Afterwards the database row is gone — including the document's history and its
links to other data. If your administrator has configured a directory for
deleted files, the original and archived files are moved there rather than
erased, which gives you one last chance to recover a file from disk. Ask an
administrator if you need to know whether that is switched on in your
installation.

## The automatic empty

You do not have to empty the trash yourself. A scheduled task removes documents
whose time has run out, which is why the **Remaining** column counts down. An
administrator controls both the delay and how often the task runs, so on some
installations documents may sit in the trash slightly longer than the number
shown.

## A quick example

Mei deletes a delivery note that was scanned twice. The trash count becomes
“1 total documents in trash” and the **Remaining** column reads “30 days”.

Two days later she notices the receipt she wanted is missing, and realises the
“duplicate” she deleted had the handwritten delivery time on it. She opens
**Trash**, finds the delivery note, and clicks **Restore**. The document comes
back to the **Documents** list with its tags and notes intact, and she adds a
note explaining which copy is the good one.

At the end of the month she opens **Trash** once more, checks the two documents
sitting there, decides neither is needed, and clicks **Empty trash**. The
confirmation warns that *This operation cannot be undone*, she confirms, and the
trash is finally empty.
