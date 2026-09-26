---
title: Storage Paths
---

# Storage Paths

A **storage path** is a rule that decides where a document's file is placed
inside the archive on disk. It changes the *file*, not the app: a document with
a storage path looks and behaves exactly like any other document in the list,
but its file is filed in a folder structure you chose.

Storage paths are useful when one flat pile of files is not enough — for
example when you want statements sorted by year and bank, and insurance letters
in their own folder. Each document can have one storage path, and a storage path
is optional. When no storage path applies, Paperless-ngx falls back to its
normal naming rule.

You manage them under **Attributes → Storage paths** in the sidebar.

!!! note

    Changing a storage path moves the files that use it. It does not change any
    document's details, and it does not delete anything.

## The Storage paths list

The page shows one row per storage path, with this toolbar above it:

| Part | What it does |
| --- | --- |
| **Filter by:** | Type part of a name to narrow the list. |
| **Show:** | How many rows to list — **25**, **50**, or **100** — with the paging buttons beside it. |
| **Select:** | **None**, **Page**, or **All**, for working on several storage paths at once. |
| **Permissions** | Set the owner and the view/edit permissions of every selected storage path. |
| **Delete** | Delete every selected storage path after a **Confirm delete**. |
| **Create** | Opens the **Create new storage path** dialog. |

The columns are **Name**, **Matching**, **Document count**, **Path**, and
**Actions**:

- **Name** — clicking a name opens the storage path for editing.
- **Matching** — the automatic matching rule in short form, such as
  **Automatic**, **None**, or **Any word: insurance**.
- **Document count** — how many documents currently use this storage path.
- **Path** — the pattern itself, shortened when it is long.
- **Actions** — **Edit**, **Delete**, and, when the count is not zero,
  **Documents** with the count, which opens the storage path as a filter in the
  document list. On a narrow screen these hide behind a three-dot menu.

Below the table, **N total storage paths** tells you how big the list is, and
**(N selected)** appears while you have a selection.

In the **Confirm delete** dialog, **Associated documents will not be deleted.**
applies here too: removing a storage path never removes documents, it only
clears the field on them.

## Creating and editing a storage path

**Create** opens the **Create new storage path** dialog; **Edit** opens **Edit
storage path**. The fields are:

| Field | What it means |
| --- | --- |
| **Name** | The name you will recognise the storage path by, such as **By Year**. |
| **Path** | The pattern that builds the folder and file name. See below. |
| **Matching algorithm** | How Paperless-ngx should decide on its own to use this storage path for new documents. |
| **Matching pattern** | The word or words to look for. It appears only when the chosen algorithm needs one. |
| **Case insensitive** | Whether the pattern ignores capital letters. |

The **Matching algorithm** choices — **Automatic**, **Any word**, **All words**,
**Exact match**, **Regular expression**, **Fuzzy word**, and **None** — work
exactly as they do for tags, and are described under
[Matching algorithms](tags.md#matching-algorithms).

The dialog closes with **Cancel** or saves with **Save**. Owners and permissions
are described in
[Authentication, Users, Groups & Permissions](../authentication.md).

## Building a path from placeholders

The **Path** field is a pattern rather than a fixed folder name. You write it
with ordinary folder separators and as many lines as you like, and you drop in
**placeholders** — names in double curly braces — wherever a value should come
from the document. For example:

```
{{ created_year }}/{{ correspondent }}/{{ title }}
```

A 2026 invoice from **My Bank** titled **Statement January** then lands in the
**My Bank** folder inside a **2026** folder.

The placeholders you are most likely to want are:

| Placeholder | Fills in |
| --- | --- |
| `{{ title }}` | The document's title. |
| `{{ correspondent }}` | The correspondent's name, or "none". |
| `{{ document_type }}` | The document type's name, or "none". |
| `{{ tag_list }}` | A comma-separated list of the document's tags. |
| `{{ created }}` | The full creation date, such as `2026-03-14`. |
| `{{ created_year }}`, `{{ created_month }}`, `{{ created_day }}` | The year, month (01–12), and day (01–31) of the creation date. |
| `{{ created_month_name }}` | The month's name, such as `March`. |
| `{{ added }}`, `{{ added_year }}`, `{{ added_month }}`, `{{ added_day }}` | The same parts, but for the date the document was added. |
| `{{ asn }}` | The document's archive serial number, or "none". |
| `{{ original_name }}` | The original file name, without its extension. |
| `{{ owner_username }}` | The user name of the document's owner, or "none". |

A folder that ends up empty is skipped, and characters that are not allowed in
file names — such as `:`, `\`, and `/` — are replaced with dashes. If two
documents would end up with the same name, Paperless-ngx appends `_01`, `_02`,
and so on.

!!! tip

    Keep the pattern short. Very long paths made of many placeholders can run
    into the maximum path length of your operating system, in which case the
    document keeps its previous location.

## Testing a path before you save

Above the matching fields, the **Preview** section lets you try the pattern out
on a real document:

1. Open **Preview**.
2. In the **Search for a document** box, type at least two characters and pick a
   document from the results.
3. The card shows the folder and file name the pattern would produce for it.

When the box is empty the card says **No document selected**; if the pattern
cannot be used, it says **Path test failed**. Fix the pattern and pick the
document again to retry.

## Using a storage path on documents

- While editing a document, use the **Storage path** field. Its empty value is
  shown as **Default**, which means the normal naming rule applies.
- Let matching do the work with a **Matching algorithm** and **Matching
  pattern**.
- Tick several documents in the list and set the storage path with bulk editing
  — see [Working with Many Documents at Once](../documents/bulk.md).
- In the document list, open the **Storage path** filter button, type in
  **Filter storage paths**, and tick the ones you want — see
  [Browsing, Filtering and Searching](../documents/browsing.md).

## A quick example

Sami wants his bank statements in one shape and his insurance letters in
another. He creates two storage paths:

| Name | Path |
| --- | --- |
| **By Year** | `{{ created_year }}/{{ correspondent }}/{{ title }}` |
| **Insurances** | `Insurances/{{ correspondent }}/{{ created_year }}-{{ created_month }}-{{ created_day }} {{ title }}` |

For **Insurances** he sets **Matching algorithm** to **Any word** and **Matching
pattern** to `policy premium claim`. He opens **Preview**, searches for an old
policy letter, and sees the exact name it would receive; happy with it, he saves.

A statement from **My Bank** now lands in `2026/My Bank/Statement January.pdf`,
while a renewal letter is filed as
`Insurances/Healthcare 123/2026-01-01 Renewal Notice.pdf`.