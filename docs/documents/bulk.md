---
title: Working with Many Documents at Once
---

# Working with Many Documents at Once

Filing a batch of scanned receipts, tagging a year of invoices, or clearing out
duplicates is much faster when you do it to a whole selection at once.
Paperless-ngx calls this **bulk editing**.

## Making a selection

In the **Documents** list, tick the box beside each document you want, or use the
**Select:** menu above the list, which offers **Page** and **All** — and **None**
to let go again. The count above the list shows what you have chosen, for example
**Selected 12 of 340 documents**, and a **Clear selection** button starts you
over.

While something is selected, the filter bar at the top is replaced by the bulk
editing bar.

!!! tip

    **Select: All** means "everything the current filters match", not just what
    fits on screen. Filter first, then select all, and the operation applies to
    every match — including documents on other pages.

## The bulk editing bar

From left to right the bar offers:

1. **Edit:** followed by dropdowns for **Tags**, **Correspondent**,
   **Document type**, **Storage path**, and **Custom fields**.
2. **Permissions** — change who may see and change the selection.
3. **Actions** — **Reprocess**, **Rotate**, and **Merge**.
4. **Send** — **Create a share link bundle**, **Manage share link bundles**, and
   **Email**.
5. **Download** — save the selection as a ZIP file.
6. **Delete** — move the selection to the trash.

## Editing tags and other fields

Open a dropdown such as **Tags**. Because you are editing rather than filtering,
each value has three states, and you cycle through them by clicking:

| Clicks | Result |
| --- | --- |
| Once | The value will be **added** to every selected document |
| Twice | The value will be **removed** from every selected document |
| Three times | Back to no change |

Use the box inside the dropdown — **Filter tags**, **Filter correspondents**, and
so on — to find a value in a long list, or type a new name and click **Create** to
make it there and then. When you are done, click **Apply** at the bottom of the
dropdown list.

For **Custom fields** there is an extra **Set values** button in the same
dropdown, which lets you fill in the value of a custom field for the whole
selection.

If there is any value marked for adding or removing, the blue **Apply** button
glows; nothing is written to your documents until you click it.

!!! note

    Different values are not interchangeable: adding a tag never removes the
    others. To replace a correspondent, for example, mark the old one for removal
    and the new one for addition in the same pass.

## Changing permissions

Click **Permissions** to change who can see and edit the whole selection. The
dialog is titled **Edit permissions for …** and lets you set the **Owner:** of the
documents, and the **View** and **Edit** rights for individual people under
**Users:** and for groups under **Groups:**. A note reminds you that **Edit
permissions also grant viewing permissions**.

The **Merge with existing permissions** switch decides what happens to the
permissions that are already there. With the switch on, the hint reads
**Existing owner, user and group permissions will be merged with these settings.**
With it off, the hint warns that
**Any and all existing owner, user and group permissions will be replaced.**

Confirm with **Confirm**, or leave with **Cancel**. The button is only available
when you own every document in the selection and may edit them all.

## Actions on a selection

| Action | What it does |
| --- | --- |
| **Reprocess** | Reads the selected files again; the archive files are rebuilt with the current settings |
| **Rotate** | Adds rotated versions of the selected documents, which is mainly useful for sideways scans |
| **Merge** | Combines two or more documents into one new document, which is then queued for processing |

**Merge** needs at least two documents, and the merged result is a new document —
the originals are not modified unless you ask for that in the dialog, so you can
delete them afterwards. Merging starts with PDFs only; turn on the archive
fallback switch if other file types should join in. **Rotate** only affects PDF
files; images are left alone.

## Sending and sharing a selection

The **Send** menu collects the actions that hand documents to somebody else:

- **Create a share link bundle** — takes the whole selection and prepares a ZIP
  file in the background, exposed as one public link. See
  [Sharing and Permissions](sharing.md).
- **Manage share link bundles** — a dialog for monitoring progress, copying
  links, retrying failed bundles, and deleting bundles you no longer need.
- **Email** — sends the selection as attachments, if your administrator has
  configured e-mail sending.

Preparing a bundle of 340 documents at once is rarely what you want, so the
**Send** menu is only available for a hand-picked selection — not when you have
chosen **Select: All**.

## Downloading a selection

**Download** packages everything you ticked into a single ZIP file. The small
arrow beside the button opens **Include:** where you choose **Archived files**,
**Original files**, or both, and where you can tick **Use formatted filename**.
Large selections take a moment to prepare; the button shows a spinner while it
works.

## What the confirmations say

If **Show confirmation dialogs** is switched on in
**Settings → Documents → Bulk editing**, each risky operation asks first and
explains the consequences:

- Tag changes get **Confirm tags assignment**, stating, for example,
  *This operation will add the tag "Invoices" to 12 selected document(s).*
  Confirm it with **Confirm**.
- **Rotate confirm** shows the first selected document as a preview, with buttons
  to turn it clockwise or anticlockwise in 90° steps and the note
  *Note that only PDFs will be rotated.* The bold line reads
  *This operation will add rotated versions of the 12 document(s).*
- **Merge confirm** lists the documents in the order they will be merged — drag
  the grip to change the order — and adds **Use metadata from:**
  (**Regenerate all metadata** or one of the documents),
  **Try to include archive version in merge for non-PDF files**, and
  **Delete original documents after successful merge** (available only if you own
  them all). The bold line is
  *This operation will merge 12 selected documents into a new document.*
- **Reprocess confirm** states
  *The archive files will be re-generated with the current settings.* and
  *This operation will permanently recreate the archive files for 12 selected
  document(s).*

Confirm rotation, merging, and reprocessing with **Proceed**. Afterwards, a
notification reports the result — *Merged document will be queued for
consumption.* after a merge, for instance.

The other setting in the same place, **Apply on close**, decides whether a
dropdown applies its changes as soon as you close it or only when you click
**Apply**.

## Deleting a selection

**Delete** moves everything you have selected to the trash. A dialog asks
**Move 12 selected document(s) to the trash?** and reminds you that *Documents
can be restored prior to permanent deletion.* The confirm button is labelled
**Move to trash**. Nothing is lost until the trash is emptied — see
[Deleting and Restoring Documents](trash.md).

## A quick example

Tariq has just scanned a shoebox of receipts: 96 documents, all with useless
titles. He filters the list by the document type “Receipt”, clicks
**Select: All**, and opens the **Tags** dropdown. He clicks “2026” once to add
it, then clicks “Unsorted” twice to remove it, and clicks **Apply**.

Next he sets the correspondent for the whole batch — click once on “Utilities”,
**Apply** — and confirms the dialog that tells him what is about to happen. Then
he ticks a dozen contracts that are not receipts and uses **Download** to keep a
ZIP copy for his accountant before moving the rest to the trash.
