---
title: Editing Document Details
---

# Editing Document Details

Very little in Paperless-ngx is fixed for good. The text that was read from a
file, the title a scan arrived with, and the tags or correspondent that were
guessed can all be corrected later — and the corrections are what make a
document easy to find next time.

!!! note

    You can only change a document you are allowed to edit. If the fields will
    not respond, see [Sharing and Permissions](sharing.md).

## The Details tab

Open a document and stay on the **Details** tab. Everything on it describes the
document as a whole, so a correction applies to all of its versions:

| Field | What it holds |
| --- | --- |
| **Title** | The name you will search by. Start here when a scan arrives with a long filename. |
| **Archive serial number** | The number you would write on the paper original — see [Barcodes and ASN](../usage.md). |
| **Created** | The date printed on the document itself. |
| **Added** | The date the file entered Paperless-ngx. It is set for you. |
| **Tags** | What the document is, so it can be filtered later. |
| **Correspondent** | Who sent it. |
| **Document type** | What kind of paperwork it is. |
| **Storage path** | The folder the file belongs in, for later exporting. |
| **Custom fields** | Your own fields, described in [Custom Fields and Metadata](../usage.md). |

For **Tags**, **Correspondent**, **Document type**, and **Storage path** you can
either pick something that already exists or type a new name and create it on
the spot, so nothing stops you from setting up an attribute while you work.

## The Content tab

The **Content** tab holds the text that was read out of the file. It is meant for
correction, and it is editable in a large plain text box:

- Fix a word the reader got wrong, so searching for it finds the document.
- Add a line that was missed, such as an amount or a reference number.
- Clear the whole box when a document should not be searchable by its text.

The text you see there is what the search engine matches against, so a change
here affects searching, not the look of the file. To change the file itself, use
the **PDF Editor** described in [Viewing a Document](viewing.md).

## Help while you fill the form in

Four buttons above the form save typing:

- **Suggest** asks the machine learning or AI features of your installation for a
  title, tags, a correspondent, or a document type. The number on the button is
  how many were found.
- The arrow beside it (when your installation uses AI assistance) opens the menu
  described as **Show suggestions**, with its results grouped under **Tags**,
  **Document Types**, and **Correspondents**. Clicking a suggestion adds it to
  the document; anything already assigned is left out, and when there is nothing
  new the menu says **No novel suggestions**.
- The **custom fields** button adds another field to the document.
- The **preview** eye button lets you glance at the file while you fill the form
  in.

!!! tip

    Suggestions are fetched for you automatically when the document still carries
    an inbox tag, so a fresh import usually arrives with its suggestions already
    counted.

## Saving, discarding and moving on

| Button | What it does |
| --- | --- |
| **Save** | Stores your changes and stays on the document |
| **Save & next** | Stores your changes and opens the next document in the list |
| **Save & close** | Stores your changes and returns to the list |
| **Discard** | Drops your unsaved changes |

The buttons stay greyed out until something actually changes, and they work from
the keyboard too:

| Keys | What happens |
| --- | --- |
| `Ctrl` + `S` | **Save document** |
| `Ctrl` + `Shift` + `S` | **Save and close / next** |
| `Esc` | **Close document** |
| `Ctrl` + `←` / `Ctrl` + `→` | **Previous document** / **Next document** |

## A quick example

Sam opens a scanned invoice and sees that the title is the scanner's filename.
He clicks **Suggest**, the button shows a count of three, and the menu proposes
the correspondent “Northwind Energy” and the tag “Invoice”; one click each adds
them. He types a proper title, answers **Created** with the date printed on the
invoice, then opens the **Content** tab and repairs two words the reader mangled —
“tota1” and “arnount” — so that searching for the correct spelling will work
later. He presses `Ctrl` + `Shift` + `S` to save and jump straight to the next
document.
