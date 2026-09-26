---
title: Adding Documents
---

# Adding Documents

Everything in Paperless-ngx starts with a file. This guide shows the different
ways to get files into your archive, what happens to them afterwards, and how to
deal with the things that can go wrong.

## Ways to add a document

| Way | Best for | Where to find it |
| --- | --- | --- |
| **Upload documents** | Adding one or a few files by hand | The widget on the **Dashboard** |
| **Drag and drop** | Quickly adding files you already have open on your computer | Any page of the app |
| Watched folder | Scanners and software that save files into a shared folder | Set up by your administrator |
| **Mail** | Bills and statements that arrive by e-mail | The **Mail** section of the sidebar |

### Upload from the dashboard

On the **Dashboard**, find the **Upload documents** widget and click it. A file
picker opens; select one or more files and confirm. The widget says
**or drop files anywhere**, which is a reminder that you are not limited to the
button.

### Drag and drop anywhere

Drag files from your computer onto any page of Paperless-ngx. The whole screen
turns into a drop zone and shows **Drop files to begin upload**; let go of the
files to start. This works from the document list, a single document, or the
dashboard.

### The watched folder

If your installation uses a watched folder (sometimes called the *consume
folder*), any file that lands in it is imported automatically. This is the usual
way to bring in documents from a scanner. You do not need to sign in for this;
your administrator decides where the folder is and who can write to it.

### By e-mail

Administrators can connect mail accounts and write **Mail rules** that import
attachments automatically. See the **Mail** section of the sidebar for the
accounts and rules that are set up on your system.

## What happens after you add a file

Paperless-ngx does far more than store the file:

1. **It reads the file.** Text is extracted, and for scans or photographs the
   text is recognised with OCR so the page becomes searchable and selectable.
2. **It creates a long-term copy.** Alongside your untouched original, an
   archived version is prepared for safe, long-term storage.
3. **It tries to help.** If machine learning or AI features are switched on, the
   app may propose a title, tags, a correspondent, or a document type for you.

While this happens, a status card appears in the corner of the screen showing
progress. When the document is ready the card offers **Open document**. Use
**Dismiss completed** to clear the finished messages from the dashboard.

If you close the browser, nothing is lost: the work continues in the background.
The bell-shaped **Notifications** button in the top bar and the **Tasks** page
(both described in [The Dashboard and Navigating the Interface](../dashboard.md))
show what finished and what failed.

## Supported file types

- PDF documents — the ideal format, and the one that can be edited in the app.
- Images — for example JPG, PNG, and TIFF files from a camera or phone.
- Plain text files.
- Office documents — Word, Excel, PowerPoint, and their LibreOffice
  equivalents.

!!! note

    What you can *see* in a preview and what you can *edit* are two different
    things. Many formats preview nicely but cannot be annotated or rotated
    inside Paperless-ngx.

### Files that ask for a password

Some PDFs are protected. When you open one, a small prompt asks you to
**Enter Password** before the pages are shown. If you own the document and you
have the password, the **Remove Password** action in the **Actions** menu saves
an unprotected copy so you do not have to type it again.

## Adding the same file twice

Paperless-ngx checks the content of every new file. If an identical file has
already been imported, the new document is flagged and the **Duplicates** tab
appears on its detail page with the heading **Duplicate documents detected:**.
Each entry links to the other copy, and shows an **In trash** badge if that copy
has been deleted. Open the tab, compare the two, and keep the one you want.

## Adding another version of an existing document

When a contract is renewed or a scan needs replacing, do not create a second
document — add a version instead. Open the document, click **Versions** above the
preview, type an optional **Label**, and choose **Add new version**. See
[Viewing a Document](viewing.md) for the full details.

## If something goes wrong

- A failed import is reported in the document progress card, in
  **Notifications**, and on the **Tasks** page.
- Ask an administrator to look at **Logs** if the message is unclear.
- If a scan arrived but the text is unreadable, open the document and use
  **Actions → Reprocess** to extract the text again — for example after the OCR
  language was corrected.

## A quick example

Omar receives a five-page insurance policy as a PDF attachment. He saves it to
his computer and drags the file onto the **Documents** page. The drop overlay
appears, he releases the file, and a progress card reports that text is being
extracted.

While he waits, he scans a paper receipt with his phone and drags the photo in
as well. Both documents finish processing within a minute. Omar clicks
**Open document** on the policy, adds a tag, and saves. Later, the same policy
arrives again by post and he scans it: when he opens the new document,
**Duplicate documents detected:** lists both copies, so he deletes the poorer
scan and keeps the cleaner one.
