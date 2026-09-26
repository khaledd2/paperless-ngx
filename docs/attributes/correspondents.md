---
title: Correspondents
---

# Correspondents

A **correspondent** is the person, company, or institution a document came from
or was sent to: a bank, an electricity supplier, an employer, a landlord, a
clinic. Grouping documents by correspondent is one of the fastest ways to answer
"where is the last letter from the tax office?".

You manage correspondents under **Attributes → Correspondents** in the sidebar,
and you can also create one while editing a document.

!!! tip

    A correspondent is not the same thing as a tag. A correspondent answers
    *who*, and each document has at most one; a tag answers *what it is about*,
    and a document can have many.

## The Correspondents list

The page shows one row per correspondent, with this toolbar above it:

| Part | What it does |
| --- | --- |
| **Filter by:** | Type part of a name to narrow the list. |
| **Show:** | How many rows to list — **25**, **50**, or **100** — with the paging buttons beside it. |
| **Select:** | **None**, **Page**, or **All**, for working on several correspondents at once. |
| **Permissions** | Set the owner and the view/edit permissions of every selected correspondent. |
| **Delete** | Delete every selected correspondent after a **Confirm delete**. |
| **Create** | Opens the **Create new correspondent** dialog. |

The columns are **Name**, **Matching**, **Document count**, **Last used**, and
**Actions**:

- **Name** — clicking a name opens the correspondent for editing.
- **Matching** — the automatic matching rule in short form, such as
  **Automatic**, **None**, or **Any word: city power**.
- **Document count** — how many documents are currently filed under this
  correspondent.
- **Last used** — the date of the most recent document from this correspondent.
- **Actions** — **Edit**, **Delete**, and, when the count is not zero,
  **Documents** with the count, which opens the correspondent as a filter in the
  document list. On a narrow screen these hide behind a three-dot menu.

Below the table, **N total correspondents** tells you how big the list is, and
**(N selected)** appears while you have a selection.

In the **Confirm delete** dialog, **Associated documents will not be deleted.**
applies here too: removing a correspondent never removes documents, it only
clears the field on them.

## Creating and editing a correspondent

**Create** opens the **Create new correspondent** dialog; **Edit** opens **Edit
correspondent**. A correspondent has fewer fields than a tag:

| Field | What it means |
| --- | --- |
| **Name** | The name of the person, company, or institution, as it should appear on documents. |
| **Matching algorithm** | How Paperless-ngx should decide on its own to set this correspondent on new documents. |
| **Matching pattern** | The word or words to look for. It appears only when the chosen algorithm needs one. |
| **Case insensitive** | Whether the pattern ignores capital letters. |

The **Matching algorithm** choices — **Automatic**, **Any word**, **All words**,
**Exact match**, **Regular expression**, **Fuzzy word**, and **None** — work
exactly as they do for tags, and are described under
[Matching algorithms](tags.md#matching-algorithms).

The dialog closes with **Cancel** or saves with **Save**. Owners and permissions
are described in
[Authentication, Users, Groups & Permissions](../authentication.md).

## Using a correspondent on documents

- While editing a document, use the **Correspondent** field. Type to search, or
  write a new name and create it on the spot; leave it empty when no
  correspondent applies.
- Let matching do the work with a **Matching algorithm** and **Matching
  pattern**.
- Tick several documents in the list and set the correspondent with bulk editing
  — see [Working with Many Documents at Once](../documents/bulk.md).
- In the document list, open the **Correspondent** filter button, type in
  **Filter correspondents**, and tick the ones you want — see
  [Browsing, Filtering and Searching](../documents/browsing.md).

Suggestions help here as well: when a document has just been imported, the
**Suggest** button often proposes a correspondent for it — see
[Editing Document Details](../documents/editing.md).

## A quick example

Omar opens **Attributes → Correspondents** and creates **City Power** with
**Matching algorithm** set to **Any word** and **Matching pattern** set to
`city power electricity`. From then on, each monthly bill is filed under the
right correspondent the moment it is added.

A month later he opens the list and reads the **Last used** column: it shows the
current month for **City Power**, while his old insurer has not appeared for
two years. He clicks **Documents** on the **City Power** row, and the document
list shows every bill from that supplier.