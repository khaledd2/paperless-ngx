---
title: Viewing a Document
---

# Viewing a Document

The document detail page is where a single document is shown, read, checked, and
sent on. This guide walks through the page itself, the viewer, the files you can
download, and the actions available while you are looking at a document. The
fields on the page have a guide of their own: [Editing Document Details](editing.md).

## Opening a document

- Double-click a row, or click a card, in the **Documents** list.
- From the **Dashboard**, click a document in **Recently added** or in a saved
  view widget.
- Click **Open document** in the progress card that appears after an upload, or
  in **Notifications**.

The page opens as an overlay on top of the list. Use **Close** (the ✕ button) or
press `Esc` to return to exactly where you were.

## What the page contains

On a wide screen the page has two halves: the editable fields on the left and the
preview on the right. On a phone or tablet the preview moves into its own
**Preview** tab.

The tabs along the top are:

| Tab | What is in it |
| --- | --- |
| **Details** | The fields you can edit, such as title, dates, tags, and custom fields — see [Editing Document Details](editing.md) |
| **Content** | The text that was extracted from the file, which you can edit |
| **Metadata** | Technical facts: filenames, checksums, file sizes, and the details read from the file itself |
| **Preview** | The document itself (only shown on small screens) |
| **Notes** | Notes attached to the document — see [Notes and History](notes-history.md) |
| **History** | Who changed what, and when — see [Notes and History](notes-history.md) |
| **Permissions** | Who may see and change the document — see [Sharing and Permissions](sharing.md) |
| **Duplicates** | Other documents with identical content, shown only when there are any |

## Viewing the document

The preview shows the archived copy of the file when there is one, so what you
read is what will be kept. Above it you will find:

- A **Page** box with **of N** beside it, to jump straight to a page.
- **–** and **+** buttons for zooming out and in.
- A zoom menu offering **Page Fit** and percentage levels.

Two settings change how the preview behaves, both under
**Settings → Documents → Document editing**: **Use PDF viewer provided by the
browser**, which is faster for large PDFs but may not suit every browser, and
**Default zoom**, which offers **Fit width** or **Fit page**. **Show document
thumbnail during loading** puts a low-resolution copy on screen while the file is
still being fetched.

If your screen is small, the **Preview** tab holds the same viewer.

!!! note

    Your administrator decides which fields appear on this page under
    **Settings → Documents**: the **Built-in fields to show** checkboxes control
    the archive serial number, correspondent, document type, storage path, and
    tags. **Uncheck fields to hide them on the document details page.**

## Downloading

The **Download** button saves the archived copy, ready-formatted for long-term
storage. The small arrow beside it opens a menu with:

- **Download original** — your untouched upload; only offered when the document
  has both an original and an archived copy.
- **Use formatted filename** — a checkbox that decides whether the saved file
  keeps Paperless-ngx's tidy naming scheme or the original name.

To save an image instead of a document, right-click the preview.

## The Actions menu

Everything else lives behind the **Actions** button:

| Action | What it does |
| --- | --- |
| **Reprocess** | Reads the file again to extract the text afresh — useful after correcting the OCR language or a title |
| **More like this** | Searches for other documents that resemble this one |
| **PDF Editor** | Opens the built-in page editor (see below) |
| **Remove Password** | Saves an unprotected copy of a password-protected PDF; available to the owner once the password has been entered |
| **Share Links** | Creates a public link — see [Sharing and Permissions](sharing.md) |
| **Email** | Sends the document to an e-mail address — see [Sharing and Permissions](sharing.md) |

**Delete** sits in the top bar rather than in the menu. It asks for confirmation
and moves the document to the trash; see [Deleting and Restoring Documents](trash.md).

## Versions

The **Versions** button above the preview manages the file history of a
document. It shows the current version, and lets you:

- **Add new version** — upload a replaced or corrected file, with an optional
  **Label** such as “signed copy” to explain it.
- Switch the preview to an earlier version to see what it looked like.
- **Delete version**, with a confirmation prompt.

A new version is uploaded first and then processed in the background; the menu
reports **Uploading version...** and **Processing version...** while that
happens, and **Version upload failed.** if something goes wrong.

The document's own fields — title, tags, correspondent, document type, storage
path, and custom fields — are not versioned. They always describe the whole
document, which is why you can correct them once and have them apply to every
version.

## The PDF Editor

Choose **Actions → PDF Editor** to change the file itself: delete pages, rotate
them, split a document into several, and reorder them. Splitting is done by
adding a **Split here** marker between pages, and the page tools include **Rotate
page clockwise**, **Rotate page counter-clockwise**, **Delete page**, and their
**selected pages** equivalents.

When you finish editing, choose what should happen to the result:

- **Create new document(s)**, so the edited file becomes a document of its own
  (or several, if you split it); or
- **Add document version**, so the edited file replaces the current version of
  the document you are looking at.

Two checkboxes decide the details: **Copy metadata** carries the tags,
correspondent, document type, and so on across to the new document, and **Delete
original** removes the source document once the edit is saved.

Which of the two is preselected is controlled by
**Settings → Documents → PDF Editor → Default editing mode**. Rotating a page
asks you to confirm, and reminds you that **only PDFs will be rotated** — images
are left as they are.

## A quick example

Hana double-clicks a row in the **Documents** list, and the detail page opens on
top of it. The **Details** tab confirms she has the invoice she was looking for,
so she switches to **Metadata** to read the filename the scan arrived with, and
then jumps to page 3 with the **Page** box above the preview to check a figure.

The invoice runs to twelve pages and the last two are blank scans. She chooses
**Actions → PDF Editor**, deletes those two pages, and picks **Add document
version** with **Copy metadata** ticked, so the cleaned-up file becomes the newest
version of the same document while its title and tags stay as they were.
**Versions** above the preview still lists the file she replaced, so nothing was
lost. Before leaving she clicks **Download** and ticks **Use formatted
filename**, so her own copy lands in her folder under a tidy name.
