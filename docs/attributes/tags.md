---
title: Tags
---

# Tags

A **tag** is a label you stick onto documents so you can gather them together
later: **Invoice**, **Taxes**, **Warranty**, **To do**. A document can carry as
many tags as you like, and the same tag can sit on thousands of documents, so
tags behave like folders you are allowed to be in several of at once.

Tags live under **Attributes → Tags** in the sidebar, and you can also create one
while you are editing a document.

## The Tags list

The page holds one row per tag, with this toolbar above it:

| Part | What it does |
| --- | --- |
| **Filter by:** | Type part of a name to narrow the list to matching tags and their children. |
| **Show:** | How many rows to list — **25**, **50**, or **100** — with the paging buttons beside it. |
| **Select:** | **None**, **Page**, or **All**, for working on several tags at once. |
| **Permissions** | Set the owner and the view/edit permissions of every selected tag. |
| **Delete** | Delete every selected tag after a **Confirm delete**. |
| **Create** | Opens the **Create new tag** dialog. |

The columns are **Name**, **Matching**, **Document count**, **Color**, and
**Actions**:

- **Name** — clicking a name opens the tag for editing.
- **Matching** — the automatic matching rule, in short form, such as
  **Automatic**, **None**, or **Any word: policy premium**.
- **Document count** — how many documents currently carry the tag.
- **Color** — a badge showing the tag's colour.
- **Actions** — **Edit**, **Delete**, and, when the count is not zero,
  **Documents** with the count, which opens the tag as a filter in the document
  list. On a narrow screen these hide behind a three-dot menu.

Below the table, the line **N total tags** tells you how big the list is, and
**(N selected)** appears while you have a selection.

!!! note

    Deleting a tag never deletes documents. It only takes the label off every
    document that carried it.

## Creating and editing a tag

**Create** opens the **Create new tag** dialog; **Edit** opens **Edit tag**. Both
hold the same fields:

| Field | What it means |
| --- | --- |
| **Name** | What the tag is called, exactly as it will appear on documents. |
| **Color** | The tag's colour, shown as a badge on every document that carries it. |
| **Parent** | The tag this one sits under when you are building a hierarchy. Leave it empty for a top-level tag. |
| **Inbox tag** | A special tag: **Inbox tags are automatically assigned to all consumed documents.** |
| **Matching algorithm** | How Paperless-ngx should decide on its own to add this tag to new documents. |
| **Matching pattern** | The word or words to look for. It appears only when the chosen algorithm needs one. |
| **Case insensitive** | Whether the pattern ignores capital letters. |

The dialog closes with **Cancel** or saves with **Save**. Every attribute also has
an owner and permissions; those are described in
[Authentication, Users, Groups & Permissions](../authentication.md).

## Matching algorithms

**Matching** is what lets Paperless-ngx tag a document for you as it arrives. The
choices in the **Matching algorithm** menu are:

| Choice | Paperless-ngx adds the tag when… |
| --- | --- |
| **Automatic** (the default) | it has learned the answer from how you have tagged similar documents before. No pattern is needed. |
| **Any word** | the document contains any one of the words you list, separated by spaces. |
| **All words** | the document contains every one of the words you list. |
| **Exact match** | the document contains your pattern exactly as written. |
| **Regular expression** | the document matches a pattern you have written in the regular-expression language. |
| **Fuzzy word** | the document contains a word similar to the one you gave, allowing small spelling differences. |
| **None** | you want no automatic matching for this tag. |

Only **Automatic** and **None** hide the **Matching pattern** field. For the
others, whatever you type there is what gets looked for; tick **Case insensitive**
to ignore capital letters.

## Nested tags

Tags can be arranged in a tree by giving one tag a **Parent**:

- A tag may sit up to five levels deep.
- Adding a child tag to a document also adds all of its parents.
- Removing a tag from a document also removes all of its children.
- Giving an existing tag a **Parent** updates every document that already has it,
  so the parent is added there too.

In the list, children appear indented under their parent. On a document, a tag
badge shows the whole chain, like **Files > Taxes > 2026**.

## Putting tags on documents

There are three easy ways:

- While editing a document, use the **Tags** field. Type to search, click a
  suggestion to add it, and use the **+** button to create a brand new tag
  without leaving the page.
- Let matching do the work: give the tag a **Matching algorithm** and a
  **Matching pattern**, and new documents are tagged as they arrive.
- Tick several documents in the list and set the tag with bulk editing — see
  [Working with Many Documents at Once](../documents/bulk.md).

In the document list you can also filter by tags: open the **Tags** filter button,
type in **Filter tags**, and tick the tags you want — see
[Browsing, Filtering and Searching](../documents/browsing.md).

## The Inbox tag

An **Inbox tag** is a tag used as a holding area. Because it is automatically
assigned to every consumed document, it is an easy way to find what has just
arrived and work through it:

1. Open **Attributes → Tags** and create a tag called, for example, **Inbox**.
2. Tick **Inbox tag** and save.
3. Filter the document list by that tag whenever you want to review new
   documents, and remove the tag once a document has been dealt with.

!!! tip

    A document that still carries an inbox tag also has its suggestions worked
    out for you, so its **Tags**, **Correspondent**, and **Document type** are
    usually one click away — see
    [Editing Document Details](../documents/editing.md).

## A quick example

Rana organizes a household archive. She creates the top-level tags **Home**,
**Work**, and **Car**, and under **Car** she adds **Insurance** and **Service**.
For **Insurance** she sets **Matching algorithm** to **Any word** and **Matching
pattern** to `policy premium`, so renewal letters are tagged as they arrive.

Later she opens a letter that was missed. As she types in its **Tags** field,
**Insurance** is offered; she picks it, and Paperless-ngx adds **Car** as well,
because it is the parent. Back on **Attributes → Tags**, the **Document count**
for **Insurance** has gone up by one.
