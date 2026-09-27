---
title: The Consume Folder
---

# The Consume Folder

Paperless-ngx has a doorway that does not need a browser: a folder on the server
that it watches. Any file that appears in that folder is picked up and imported
on its own. In the documentation it is also called the *consumption directory*,
and you will hear people call it the *watched folder*.

It is the standard way to bring in paper. A scanner or a multifunction printer is
set to save to that folder — over a network share, over FTP, or with a
"scan to folder" button — and that is the whole routine: the sheets go through
the scanner, and the documents appear in the archive a little later.

Nobody signs in to use it. Where the folder is, and who is allowed to write to
it, is decided by the administrator who set the installation up.

!!! note "The folder is a doorway, not a shelf"

    Files sit in the consume folder only long enough to be imported. Once a
    document has been consumed, its file is removed from the folder and lives
    inside the archive, where the app manages it. The folder is expected to be
    empty between scans, and it is not a backup of anything.

## Getting a file into the folder

Everything that can save a file can feed the folder:

| Way | Typical use |
| --- | --- |
| A network share | A scanner or a computer saves straight into the folder over the local network. |
| An FTP or SFTP server | Older scanners and appliances that upload rather than write to a share. |
| Copying by hand | Dragging a file with a file manager, or copying it to a mapped drive. |
| File syncing or a scanner's own cloud app | The synced copy lands in the folder and is imported. |

You can drop several files at once, and you can keep adding more while earlier
ones are still being processed; they queue up and are worked through one after
another.

### What it accepts

The folder is read for the document formats the archive understands — PDF files,
images such as TIFF, JPEG and PNG, plain text files, and Office documents (Word,
Excel, PowerPoint, and their LibreOffice equivalents).

Files with any other extension are left alone, as are the small housekeeping files
that computers scatter everywhere: `.DS_Store` and `._` files from macOS,
`Thumbs.db` and `desktop.ini` from Windows, and folders that sync tools and NAS
devices use for their own bookkeeping. None of those ever becomes a document.

### Subfolders

By default only the files directly in the folder are picked up. An administrator
can switch on watching of subfolders as well, and can go one step further: with
*subfolders as tags*, the name of each folder a file was saved in becomes a tag on
the document. Files in `Bills/2026/` then arrive tagged **Bills** and **2026**,
with any missing tag created on the spot.

That is a neat trick for a scanner or a phone app that gives you no way to tag
before scanning: sort the files into folders when you copy them, and the tags come
along by themselves. Such folders are never removed.

## What happens after a file lands

1. **The file is left alone for a moment.** The installation waits until the file
   has stopped changing before it starts, so that a scan that is still being
   written is never read half-finished.
2. **The file is read.** Its text is extracted, and scans are put through OCR so
   the pages become searchable. A long-term archive copy is prepared alongside the
   original.
3. **It is filed.** The document is stored with the filename and folder layout
   built from the storage paths and settings of the installation, and matching
   may attach tags, a correspondent, or a document type — including any barcodes
   it carries (see [Barcodes and Archive Serial Numbers](barcodes-asn.md)).
4. **The file leaves the folder.** Once the import has succeeded, the file is
   removed from the consume folder. The archive keeps its own copies, so nothing
   is lost by this.

Progress and results appear in the app like any other import: the notification
bell in the top bar, and the [Tasks](../administration/tasks.md) page for the details.

### A file that has been imported before

If a file with exactly the same content was already imported, the new document is
kept but flagged as a duplicate, with the copies linked to each other — open the
**Duplicates** tab to compare them (see
[Adding Documents](../documents/adding.md)). An administrator can instead have such a
file deleted from the folder without being imported at all, which keeps a repeated
scan out of the archive entirely.

## When something goes wrong

A file that cannot be imported is not deleted. It stays where it is, and the
failure is recorded: the notification bell shows it, the [Tasks](../administration/tasks.md)
page lists what went wrong, and an administrator can read the reason in
[Logs](../administration/logs.md). Correct the file — or have the administrator correct the
setting — and save it into the folder again to make another attempt.

The causes are usually one of these:

| What you see | What it usually means |
| --- | --- |
| The file never moves | The format is not one the archive understands, or the file is a housekeeping file the folder ignores. |
| The file stays after an error | The document could not be read at all, for example a PDF that needs a password, or a truncated scan. Password-protected files are best added through the app, where **Enter Password** can be answered. |
| An error naming an archive serial number | The scan carries a barcode for a number that is already used. See [Barcodes and Archive Serial Numbers](barcodes-asn.md). |
| The document arrives but not where you expected | The storage path that decides the filename and folder did not match, so the document was filed in the default place. |

!!! tip

    A password-protected PDF, and a file you want to check before importing, are
    both easier to handle in the browser: drag the file onto any page of the app
    instead, as described in [Adding Documents](../documents/adding.md).

## Habits that keep the folder healthy

- **Let the scanner finish.** The short wait before a file is read covers most
  cases, but a very slow or interrupted transfer can still produce an unreadable
  file. If that happens often, ask an administrator to lengthen the waiting time
  or to have the installation poll the folder on a schedule.
- **One document per file, or separator sheets.** A stacked scan becomes one
  document unless it carries separator barcodes — see
  [Barcodes and Archive Serial Numbers](barcodes-asn.md).
- **Do not edit a file in the folder.** Changing it while it is being read is the
  surest way to a failed import.
- **Copy rather than move when in doubt.** A copy leaves you the original until
  you have seen the document appear in the archive.
- **Use subfolders for tags** if the folder watching is set up that way.
- **Do not use the folder as storage.** It holds nothing for long, and anything
  you leave in it will be imported.

## How the folder is set up, for administrators

All of this lives outside the web interface, in the installation's configuration,
and is described here in plain language:

- where the folder is, and whether the folder watching is switched on at all — an
  installation that only uses browser uploads and e-mail can switch it off to save
  work;
- whether subfolders are watched, and whether their names become tags;
- how the folder is noticed: immediately, when the operating system reports a
  change, or by looking at it every few seconds when the folder lives on a network
  drive that reports changes poorly;
- how long a file must stay unchanged before it is read;
- which extra files to ignore, in addition to the housekeeping files already
  skipped;
- whether a file that has already been imported once is deleted from the folder
  instead of being imported again;
- which scripts, if any, run before and after each file is consumed.

The folder itself needs to be readable and writable by the installation and by
whatever saves files into it, and only those. If scanner and server disagree about
permissions, the usual symptom is a file that appears in the folder and stays
there.

## A quick example

The office multifunction printer has a "scan to network folder" button that the
administrator has pointed at the consume folder. Nadia scans a signed lease: four
pages, saved as one PDF.

Two minutes later the notification bell tells her that a document finished
processing. She opens it, corrects the title, tags it **Lease**, and saves. The
file is gone from the folder, and a copy of the original and a long-term archive
version are both inside the archive.

That afternoon she copies the year's utility bills into a subfolder of the
consume folder named `Bills`. When the documents appear, each of them already
carries the tag **Bills** — the folder name did the filing for her.
