---
title: Browsing, Filtering and Searching Documents
---

# Browsing, Filtering and Searching Documents

The **Documents** page is where you will spend most of your time. This guide
covers the toolbar above the list, the filters that narrow it down, the ways to
sort and arrange what you see, and how to keep a useful set of filters as a saved
view.

## Getting to the list

Choose **Documents** in the sidebar. The page always shows a filtered list —
Paperless-ngx remembers *how* you were looking at your documents, not just where
you were, so you usually land straight back on the view you last used.

Above the list is a bar with three groups of controls: **Select:**, the display
and sort buttons, and **Views**. Under it sits the filter bar.

## Selecting documents

| Control | What it does |
| --- | --- |
| **Select: None** | Clears the selection |
| **Select: Page** | Selects every document on the current page |
| **Select: All** | Selects every document matching the current filters, not only the visible page |

Once something is selected, the filter bar is replaced by the bulk editing bar
(described in [Working with Many Documents at Once](bulk.md)) and the count above
the list reads **Selected N of M documents**, with a **Clear selection** link
beside it.

## Choosing what each row shows

Click **Show** to tick the fields you want to see: **Title**, **Created**,
**Added**, **Tags**, **Correspondent**, **Document type**, **Storage path**,
**Notes**, **Owner**, **Shared**, **ASN**, and **Pages**. Your choice is
remembered for next time.

The three small buttons next to **Show** switch between the ways the results are
drawn:

- a **list** (a table whose columns you can sort by),
- **small cards** (compact tiles, good for scanning many documents), and
- **large cards** (a preview thumbnail with more detail — useful for image
  documents).

## Sorting

Click **Sort** and choose a field. The two buttons at the top of the menu decide
the direction (A → Z or Z → A). You can sort by **ASN**, **Correspondent**,
**Title**, **Document type**, **Created**, **Added**, **Modified**, **Notes**,
**Owner**, and **Pages**. In the list view you can also click a column heading to
sort by that column. When you have searched with **Advanced search**, an extra
option appears: **Search score**, which puts the best matches first.

## Searching

The quickest search is the **Search** box in the top bar. Anything you type there
can be turned into a document filter, and the **Full search links to** setting
decides whether pressing enter gives you a title-and-content search or an
advanced query.

On the **Documents** page itself, the filter bar starts with a text box whose
left-hand button chooses what you are matching against:

| Target | Matches |
| --- | --- |
| **Title** | The title only |
| **Title & content** | The title and the extracted text |
| **ASN** | The archive serial number |
| **File type** | The kind of file, for example a PDF or an image |
| **Advanced search** | A full search query that you type yourself |

For **ASN** you also get a word before the box — **equals**, **is empty**,
**is not empty**, **greater than**, or **less than** — so you can find "every
document numbered above 5000" without writing a query.

### Filtering

To the right of the text box are the filter buttons. Inside each one is a
**Filter …** box for finding the value you want:

- **Tags**, **Correspondent**, **Document type**, and **Storage path**.
- **Custom fields** — pick a field and a condition; combine several conditions
  with **All** or **Any**.
- **Dates** — filter by **Created** or **Added** date, either with **From** and
  **To** dates or by picking a quick range from **Relative dates**: **Within
  1 week**, **Within 1 month**, **Within 3 months**, **Within 1 year**,
  **This year**, **This month**, **Today**, **Yesterday**, **Previous week**,
  **Previous month**, **Previous quarter**, or **Previous year**.
- **Permissions** — **All**, **My documents**, **Shared with me**,
  **Shared by me**, **Unowned**, **Hide unowned**, or a particular person chosen
  in the **Users** box.

The line above the list tells you how many documents you are looking at, together
with **(filtered)** when filters are active. **Reset filters** clears everything
at once and is also offered as a small link next to the count.

!!! tip

    Once the filter bar is on screen you can open the common filters with a
    single key: **T** for Tags, **Y** for Correspondent, **U** for Document
    type, and **I** for Storage path.

### A note about how filters combine

Filters from different buttons are combined with "and": a document has to match
every one of them. Inside a single button the values you tick can be combined
either with "all" or with "any", depending on the setting offered in that menu.

## Filtering from what you can see

Most values in the list are clickable:

- Click a **tag**, **correspondent**, **document type**, or **storage path** to
  add it as a filter instantly.
- Use the eye button on a row or card to peek at the document without leaving the
  page.
- Choose **Edit document** on a card to open it for editing.
- Choose **More like this** on a card to find similar documents.
- Double-click a row, or click a card, to open the document.

## Keyboard shortcuts

| Keys | What happens |
| --- | --- |
| `/` | Jump to the top-bar search |
| `A` | **Select all** |
| `P` | **Select page** |
| `O` | Open the first document (or the first selected one) |
| `Esc` | Clear the selection, or **Reset filters** |
| `Ctrl` + `←` / `Ctrl` + `→` | Previous / next page |
| `Shift` + `?` | Show the list of shortcuts |

## Keeping a set of filters: saved views

A **saved view** is a set of filters with a name. Use the **Views** button:

- Pick a view from the menu to jump to it. The page title becomes the view's
  name, and a small dot on the **Views** button reminds you when you have changed
  the filters since.
- **Save "name"** updates the current view with your new filters.
- **Save as...** opens **Save current view**, where you give the view a **Name**
  and decide whether to **Show in sidebar** and **Show on dashboard**. You can
  also set who else may see and use it.
- **All saved views** opens the management page, where views can be renamed,
  reordered, and deleted.

If a view cannot be saved because a filter rule is not valid, an alert explains
that a **Filter rules error occurred while saving this view** and reports what
**The error returned was**.

!!! note

    Views can hold sensitive combinations of filters, so they have their own
    permissions. If **Save as...** is missing, you do not have permission to
    create views — ask an owner or an administrator.

## A quick example

Layla needs every invoice from her electricity provider for the current year. She
opens **Documents**, types the provider's name in the top-bar **Search**, and
clicks **Filter documents** on the correspondent result, so the list is now
filtered by correspondent. She presses **U** to open the document type filter and
ticks "Invoice", opens **Dates**, chooses **This year** under **Created**, and
checks the count: it reads “38 documents (filtered)”.

She presses **Save as...**, names the view **"Electricity 2026"**, ticks
**Show in sidebar**, and saves. From now on the view sits in the sidebar and
always shows the current year's invoices without her rebuilding the filters.
