---
title: Barcodes and Archive Serial Numbers
---

# Barcodes and Archive Serial Numbers

A printed barcode is a note to Paperless-ngx that travels with the paper. When a
page carrying one is scanned, the installation reads it and acts on it: it can
break a stack of scans into separate documents, give a document its archive
serial number, and attach tags — all without anyone typing a thing.

Barcodes are read while a document is being imported, so they work wherever the
file came from: a scan in the consume folder, an upload in the browser, or a
scan sent from the scanner. They are off until an administrator turns them on, and
they are read from PDF files — and from TIFF images as well, when that is switched
on with them.

The *kind* of barcode does not matter — a QR square, the striped code on a
product, a patch-code sheet. Only what the barcode *says* is used.

## The archive serial number (ASN)

The archive serial number is the number you would write on the paper original if
you were keeping a paper archive. You write it once, store that sheet in a binder
in number order, and from then on the number is the fastest way back from the
digital copy to the sheet of paper in your hand.

In the app the number lives in a few places:

| Where | What it looks like |
| --- | --- |
| The **Details** tab of a document | The **Archive serial number** box. The **+1** button beside it fills in the next free number for you. |
| The documents list | An **ASN** column, once you tick it in **Show**. |
| **Sort** | Sorting by **ASN** puts your documents in binder order. |
| The filter bar | Choose **ASN** as the search target and pick **equals**, **is empty**, **is not empty**, **greater than**, or **less than**. |

An ASN is always a whole number of 1 or more, and it belongs to exactly one
document. Two documents cannot share one.

!!! warning "A number that is already taken"

    If a scan arrives carrying a number that another document already uses, the
    document is *not* imported and an error is recorded — check the
    [Tasks](../administration/tasks.md) page to see it. A number that is still held by a
    document in the [trash](../documents/trash.md) counts as taken as well. Numbers
    outside the allowed range are refused for the same reason.

    Nothing is lost: the file is still there, and it can be imported again after
    the number is corrected or the other document is emptied from the trash.

If you do not keep the paper, you never have to fill this in. Nothing in the app
requires it.

## Reading a number from a barcode

When ASN barcodes are switched on, an administrator also sets a short prefix. A
barcode is treated as a number when it starts with that prefix; the prefix is
then removed and anything that is not a digit after it is ignored. With the usual
prefix `ASN`, a barcode reading `ASN00123` gives the document the number **123**.

- Put the barcode on the first page, next to or above the content, the way a
  library stamp would sit.
- The page carrying the barcode stays part of the document. This is deliberate:
  you can stick an ASN label on a page of the document itself and that page is
  kept.
- If a file carries several ASN barcodes, each one starts a new document, and the
  page with the barcode becomes the first page of the document that follows it.
- A file with no ASN barcode at all is imported as usual, with no number.

!!! note "Which barcodes can be read"

    The reader understands the common printed kinds: **Code 39**, **Code 93**,
    **Code 128**, **Codabar**, **Interleaved 2 of 5**, **EAN-8**, **UPC-A** and
    **UPC-E**, **QR codes**, and **SQ codes**. Any of them can carry an ASN, a
    separator, or a tag; you are free to use whichever your label printer or
    label sheet already offers.

## Splitting a stack with separator barcodes

A separator barcode is a barcode printed on a page of its own, used to tell the
app "the next pages belong to a new document". The usual way to do this is a
sheet of pre-printed separator pages, such as the PATCH-T pages, whose default
code word the installation already knows.

Scan a stack with a separator sheet in front of each document and one file comes
out of the scanner containing several documents. Paperless-ngx splits it:

- the pages *after* a separator sheet become a document of their own;
- the separator sheet itself is thrown away, so it does not litter your archive
  with a page of stripes;
- a stack with no separator in it is imported as a single document, exactly as
  before.

There is one alternative arrangement. If an administrator turns on **Retain Split
Pages**, the separator page is kept instead of discarded, and it becomes the
**first** page of the document it introduces. That suits a scan where the marker
page carries something you want to read — a cover sheet with a title, for
instance.

## Tagging with barcodes

Tag barcodes attach tags while the document is being imported, which saves you
from filing a stack by hand afterwards. A tag barcode has to match a pattern the
administrator has set up. The pattern that ships with the app is the word `TAG:`
followed by the tag name, so a barcode reading `TAG:invoice` puts the tag
**invoice** on the document.

- Several barcodes on one line, separated by commas, are all read.
- Matching ignores upper and lower case.
- A tag that does not exist yet is created, so a new barcode is enough to start
  using a new tag.
- Only the barcodes on a document's own pages are applied to it, which is what
  makes splitting and tagging work together.

### Splitting on tag barcodes

Normally tag barcodes only tag: they do not separate documents. An administrator
can change that with **Split on Tag Barcodes**, which makes a tag barcode behave
like an ASN barcode as well:

- the page carrying the tag barcode is kept, and becomes the first page of the
  document it introduces;
- each resulting document receives only the tags found on its own pages;
- several tag barcodes in one stack produce several splits.

That is useful for a batch scan: put a page with `TAG:invoice` in front of the
invoices and one with `TAG:receipt` in front of the receipts, and the single scan
arrives as properly separated, properly tagged documents.

## How the pieces work together

| Combination | What happens |
| --- | --- |
| ASN barcodes only | Each ASN barcode starts a new document, and the page carrying it stays with that document. |
| Separator barcodes only | Each separator sheet starts a new document with the pages after it, and is then discarded. |
| ASN and separators together | The stack is split first; the number is then read from each part separately. |
| Tag barcodes with splitting | Each part gets its own tags, and its own ASN if it carries one. |

## The settings, for administrators

All of this is configured on the **Configuration** page, under **Administration**
in the sidebar, on the **Barcode Settings** tab. Each option is a card with a
switch, a box, or a number, and an information button that opens the online
documentation for that setting; changes are kept with **Save** and dropped with
**Cancel**.

| Setting | What it does |
| --- | --- |
| **Enable Barcodes** | Turns on reading and splitting by separator barcodes. |
| **Enable TIFF Support** | Also reads TIFF image files, converting them so their barcodes can be found. |
| **Barcode String** | The code word that counts as a separator. It is already set to the value used by PATCH-T separator sheets, so it normally needs no change. |
| **Retain Split Pages** | Keeps the separator page and makes it the first page of the new document instead of discarding it. |
| **Enable ASN** | Turns on reading archive serial numbers from barcodes. |
| **ASN Prefix** | The short text that marks a barcode as containing an ASN. |
| **Enable Tag Detection** | Turns on reading tags from barcodes. |
| **Tag Mapping** | The rules that decide which barcodes count as tags and what tag name each one produces. |
| **Split on Tag Barcodes** | Makes tag barcodes split documents as well as tag them. |
| **Upscale** | Enlarges each page before looking for barcodes, for small or fine ones. Only takes effect above 1.0. |
| **DPI** | The resolution used when a PDF page is turned into an image for reading. Higher values help with small barcodes and cost more time. |
| **Max Pages** | Limits reading to the first pages of a file, to keep very long scans quick. It is off by default, so every page is checked. |

The option cards are only shown to someone who is allowed to change them, and the
page makes clear that a value set there applies to **every** user of the
installation.

## Tips that save trouble

- **Number first, scan second.** Writing or sticking the number on the sheet
  before it goes through the scanner is what makes the digital copy and the paper
  copy line up. The label sheet that prints ASN and separator barcodes is the
  simplest way to do it.
- **Keep the numbering in one series.** The value of the number is that it sorts:
  binder order, list order, and shopping for a document all follow it.
- **Leave the next number to the button.** Pressing **+1** beside **Archive
  serial number** fills in a number that is free right now, which avoids the
  collision described above.
- **Give the reader a clean page.** A barcode that is skewed, faded, creased, or
  printed very small is missed. Scanning at a higher resolution, or asking an
  administrator to raise **DPI** or **Upscale**, is the usual cure.
- **Expect the whole stack to be one file.** Splitting depends on the separator
  barcode being read; a file with no separator in it is filed as one document.
- **Barcodes are read on the way in.** Turning the feature on does not renumber
  or split documents that are already in the archive, so import the affected
  scans again if you need them numbered.
- **A blocked import is not a lost file.** When a number is already taken, the
  file stays where it is and the reason is recorded — read it on the
  [Tasks](../administration/tasks.md) page, and ask an administrator for the
  [logs](../administration/logs.md) if it is not clear.

## A quick example

Omar keeps his paper in binders and wants the archive to follow the same order.
He prints a sheet of labels with an `ASN` barcode on each, and writes the next
free number of his current binder where he sticks each one.

He scans a bundle of five pages in a single file: a sheet carrying the label
**1041** followed by the two pages of a service contract, then a sheet carrying
**1042** followed by an invoice. He drops the resulting PDF into the watched
folder.

A few minutes later the archive holds two documents instead of one: the contract
with ASN **1041** and the invoice with ASN **1042** — the numbers he wrote on the
paper. Nothing has to be filed twice, and when a client asks about invoice 1042 he
types the number into the filter bar, chooses **ASN** and **equals**, and the
document is in front of him. When he wants a stack split without numbering it, he
puts a PATCH-T separator sheet in front of it instead of a numbered label.

Weeks later a colleague scans a page whose label says **1043** by mistake. That
import fails instead of silently overwriting the document that already owns the
number he wrote; Omar sees it on the **Tasks** page, corrects the label, and scans
the sheet again.
