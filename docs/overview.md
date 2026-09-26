---
title: Understanding Paperless-ngx
---

# What is Paperless-ngx?

Paperless-ngx is a document management system. It takes the paper that comes
into your life — letters, invoices, contracts, receipts, statements — and turns
it into a searchable, organized digital archive that lives on your own server.

Instead of filing paper in folders and binders, you keep everything in one
place and let Paperless-ngx do the heavy lifting: it reads the text of your
documents, stores them safely, and helps you find any of them again in seconds.

This page explains the main ideas you need before you start using the system.
It is written for everyday users and for the person who administers the
installation.

## What you can do with Paperless-ngx

- **Add documents** by uploading them, by dragging and dropping them, or by
  letting the system pick them up automatically from a watched folder.
- **Organize documents** with tags, correspondents, document types, storage
  paths, and custom fields.
- **Find anything** with full-text search, filters, and saved views.
- **Edit documents** one at a time or many at once with bulk editing.
- **Share documents** with public share links.
- **Automate** how documents are processed with workflows and mail rules.

## The main areas of the app

The web interface is organized into a few main areas. You move between them
using the sidebar on the left.

| Area | What it is for |
| --- | --- |
| **Dashboard** | Your starting page. Shows helpful widgets, statistics, and any saved views you choose to display. |
| **Documents** | The list of all documents, with filtering, searching, sorting, and bulk actions. |
| **Document detail** | A single document: its preview, its metadata, its notes, and its history. |
| **Attributes** | The lists of tags, correspondents, document types, storage paths, and custom fields. |
| **Saved Views** | Manage the views you have created. |
| **Workflows** | Rules that react to events and act on documents automatically. |
| **Mail** | E-mail accounts and rules for importing documents automatically. |
| **Trash** | Documents you have deleted, where they can be restored. |
| **Administration** | Settings, system configuration, users and groups, tasks, and logs. |

!!! tip

    New to the app? The **Dashboard** offers a short guided tour. You can start
    it from the welcome message on the dashboard, or from **Settings**.

## Core concepts

### Documents

A **document** is one item in your archive: a scanned page, an uploaded PDF, a
photo of a receipt, and so on. Each document has a preview and a set of
details you can search and filter by.

The most important details of a document are:

| Detail | Meaning |
| --- | --- |
| **Title** | The name of the document. You can change it at any time. |
| **Content** | The text that was read from the document. This is what the search engine looks through. |
| **Correspondent** | The person, company, or institution the document came from or was sent to. |
| **Document type** | What kind of document it is, such as an invoice, contract, or letter. |
| **Tags** | Labels you attach to group documents together. |
| **Storage path** | Where the document's file is stored inside the archive. |
| **Date created** | The date the document was originally issued, signed, or written. |
| **Date added** | The date the document was added to Paperless-ngx. The system sets this; you should not need to change it. |
| **Archive serial number (ASN)** | The number that links a digital document to its place in your physical binders. |
| **Custom fields** | Extra details you define yourself, such as an account number or a warranty end date. |
| **Owner and permissions** | Who the document belongs to and who else is allowed to view or change it. |

A document can also have **versions**. Think of versions as file history: a new
version can be added when the file itself is replaced or updated, while the
document's details (tags, correspondent, and so on) stay the same. By default,
search and preview use the latest version. See
[Versions](#versions) below.

### Tags

A **tag** is a label you assign to documents. Tags work like more flexible
folders: one document can carry several tags, and one tag can group any number
of documents.

- Tags can have a **parent** tag, so you can build a hierarchy (for example
  "Finance" with a child "Taxes"). A hierarchy can be up to five levels deep.
- When you add a tag to a document, its parent tags are added automatically.
  When you remove a tag, its child tags are removed as well.
- A tag can have a **color** so it stands out in the document list.
- A tag can be set to be assigned **automatically** to new documents that match
  certain words. See [Automation](#automation) below.

### Correspondents

A **correspondent** is the person, institution, or company that a document
originates from or is sent to. Assigning the right correspondent makes it easy
to pull up "everything from my bank" or "everything from this client". A
correspondent can also be assigned automatically to new documents, like a tag.

### Document types

A **document type** describes what a document *is*, for example an invoice, a
bank statement, a contract, or a letter. Document types help you separate
documents that look similar but mean different things. Like tags and
correspondents, a document type can be assigned automatically.

### Storage paths

A **storage path** is the location where the document's file is saved inside
your archive. Storage paths let you keep related files together on disk — for
example, all invoices in one folder and all contracts in another — without
having to move files yourself. The system applies the storage path when it
stores the document.

!!! note

    Storage paths affect where files are kept. In most installations the exact
    folder layout has already been chosen for you, so you can often leave this
    field empty and let the default apply.

### Custom fields

A **custom field** is an extra piece of information that you decide you want to
track for your documents, such as an insurance policy number, a project code,
or a renewal date. An administrator creates the custom field once, and then
everyone can fill it in on each document.

Each custom field has a **data type**, which decides what kind of value it can
hold:

| Data type | What it holds |
| --- | --- |
| **Text** | A short line of text. |
| **Long Text** | A longer, multi-line amount of text. |
| **Number** | A decimal number. |
| **Integer** | A whole number. |
| **Monetary** | An amount of money, with a currency. |
| **Date** | A calendar date. |
| **Boolean** | A simple yes/no (true/false) choice. |
| **Url** | A web address. |
| **Select** | One choice from a list of options you define. |
| **Document Link** | A link to another document in Paperless-ngx. |

!!! note

    A custom field's data type is set when it is created and cannot be changed
    afterwards.

### Saved views

A **saved view** is a stored set of filters. Once you have narrowed the document
list down to exactly what you want — for example "Invoices from 2026, newest
first" — you can save that combination as a view. A saved view can then be
shown on the **Dashboard**, in the **sidebar**, or both, so your most useful
views are always one click away.

### Ownership and permissions

Every document and every attribute (a tag, a correspondent, and so on) can have
an **owner** and a set of **permissions**. The owner is the user the item
belongs to, and permissions decide which other users or groups can **view** or
**change** the item. An item with no owner is visible to everyone.

This is covered in detail in
[Authentication, Users, Groups & Permissions](authentication.md).

## Versions

A document can have more than one **version** of its file. This is useful when
a file is corrected or replaced but you want to keep the record of the change,
similar to file history.

- Each version has its own file and its own extracted text.
- The document's details — tags, correspondent, document type, storage path,
  and custom fields — stay with the document and are shared by all versions.
- By default, search and document preview show the **latest** version.
- In the document detail page you can select a version to preview, download,
  and read its text, or to check its file information.
- Deleting a non-latest version keeps the document and simply falls back to the
  latest remaining version.

## How documents get into Paperless-ngx

There are several ways to add documents:

- **Upload** them from the dashboard or the documents list.
- **Drag and drop** files anywhere in the app.
- Let the system **consume** files placed in a watched folder (the *consume
  folder*).
- Let the system **import** documents from a connected e-mail account.

Whichever route you use, Paperless-ngx reads the text of the document, creates
a long-term archive copy, and tries to match tags, a correspondent, a document
type, and a storage path automatically based on what you have done before.

## Automation

Paperless-ngx can do a lot of the organizing for you:

- **Matching** lets a tag, correspondent, document type, or storage path be
  assigned automatically to new documents when certain words appear.
- **Workflows** run actions automatically when documents are added, updated, or
  when other events happen.
- **Mail rules** import documents from e-mail and can sort them as they arrive.

These are covered in their own guides.

## A quick example

Suppose you receive a monthly electricity bill as a PDF.

1. You drag the PDF onto the **Dashboard**. Paperless-ngx reads its text and
   stores it.
2. Because you have set up a matching rule, the document is automatically given
   the tag **"Utilities"** and the correspondent **"City Power"**.
3. You open the document and set its **Document type** to **"Invoice"** and its
   **Date created** to the billing date.
4. You add a custom field called **"Account number"** and fill it in.
5. In the documents list you filter by the tag **"Utilities"**, set the sort to
   newest first, and save the result as a view called **"Utility bills"**.
6. You tick **Show on dashboard** for that view, so next month's bill is easy to
   find the moment you sign in.


