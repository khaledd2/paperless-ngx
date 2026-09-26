---
title: Document Types
---

# Document Types

A **document type** says what kind of paperwork a document is: an invoice, a
contract, a receipt, an insurance policy, a payslip. It answers a different
question from a tag — a tag is about the topic, a document type is about the
form — and each document can have only one.

Not every document needs a type. Some things are hard to classify, and a type
used once is rarely worth creating. Types earn their place when they help you
find a group of documents again.

You manage them under **Attributes → Document types** in the sidebar, and you
can also create one while editing a document.

## The Document types list

The page shows one row per type, with this toolbar above it:

| Part | What it does |
| --- | --- |
| **Filter by:** | Type part of a name to narrow the list. |
| **Show:** | How many rows to list — **25**, **50**, or **100** — with the paging buttons beside it. |
| **Select:** | **None**, **Page**, or **All**, for working on several types at once. |
| **Permissions** | Set the owner and the view/edit permissions of every selected type. |
| **Delete** | Delete every selected type after a **Confirm delete**. |
| **Create** | Opens the **Create new document type** dialog. |

The columns are **Name**, **Matching**, **Document count**, and **Actions**:

- **Name** — clicking a name opens the type for editing.
- **Matching** — the automatic matching rule in short form, such as
  **Automatic**, **None**, or **All words: invoice payment**.
- **Document count** — how many documents currently have this type.
- **Actions** — **Edit**, **Delete**, and, when the count is not zero,
  **Documents** with the count, which opens the type as a filter in the document
  list. On a narrow screen these hide behind a three-dot menu.

Below the table, **N total document types** tells you how big the list is, and
**(N selected)** appears while you have a selection.

In the **Confirm delete** dialog, **Associated documents will not be deleted.**
applies here too: removing a type never removes documents, it only clears the
field on them.

## Creating and editing a document type

**Create** opens the **Create new document type** dialog; **Edit** opens **Edit
document type**. The fields are:

| Field | What it means |
| --- | --- |
| **Name** | The name of the type, as it should appear on documents — for example **Invoice**. |
| **Matching algorithm** | How Paperless-ngx should decide on its own to set this type on new documents. |
| **Matching pattern** | The word or words to look for. It appears only when the chosen algorithm needs one. |
| **Case insensitive** | Whether the pattern ignores capital letters. |

The **Matching algorithm** choices — **Automatic**, **Any word**, **All words**,
**Exact match**, **Regular expression**, **Fuzzy word**, and **None** — work
exactly as they do for tags, and are described under
[Matching algorithms](tags.md#matching-algorithms).

The dialog closes with **Cancel** or saves with **Save**. Owners and permissions
are described in
[Authentication, Users, Groups & Permissions](../authentication.md).

## Using a document type on documents

- While editing a document, use the **Document type** field. Type to search, or
  write a new name and create it on the spot; leave it empty when no type fits.
- Let matching do the work with a **Matching algorithm** and **Matching
  pattern**.
- Tick several documents in the list and set the type with bulk editing — see
  [Working with Many Documents at Once](../documents/bulk.md).
- In the document list, open the **Document type** filter button, type in
  **Filter document types**, and tick the ones you want — see
  [Browsing, Filtering and Searching](../documents/browsing.md).

You can also search by type from the top bar with a query such as
`type:invoice contract`, which finds documents whose type is **invoice** and
whose text contains "contract".

## A quick example

Layla decides to separate her household paperwork by form. She creates the types
**Invoice**, **Contract**, **Receipt**, and **Policy**. For **Invoice** she sets
**Matching algorithm** to **Any word** and **Matching pattern** to
`invoice amount due`, so incoming bills are classified as they arrive.

She then filters the document list by the **Invoice** type and saves the result
as the saved view **"All invoices"**. Next time she needs one, she does not have
to remember the correspondent or the month — the type is enough.