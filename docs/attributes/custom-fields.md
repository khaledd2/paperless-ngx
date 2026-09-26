---
title: Custom Fields
---

# Custom Fields

Everything up to here — tags, correspondents, document types, storage paths —
is a fixed kind of information. A **custom field** is the opposite: it is a
field you invent for the things Paperless-ngx does not know about. An account
number, a warranty end date, a policy holder, a link to the related contract,
the amount that is still outstanding — if you need to record it, you can add a
field for it.

Once a custom field exists, it behaves like any other document detail: you fill
it in on a document, you see it in the list, and you can filter and search by it.

You manage fields under **Attributes → Custom fields** in the sidebar.

## The Custom fields list

The page is a simple table with the columns **Name**, **Data Type**, and
**Actions**, and the button **Add Field** at the top right:

- **Name** — clicking a field's name opens it for editing.
- **Data Type** — what kind of value the field holds, such as **Text**,
  **Date**, or **Monetary**.
- **Actions** — **Edit**, **Delete**, and, when the field is in use,
  **Documents** with the count, which opens every document that has a value in
  the field. On a narrow screen these hide behind a three-dot menu.

When nothing has been defined yet, the page says **No fields defined.**

Deleting a field is permanent. **Delete** opens the **Confirm delete field**
dialog, which warns **This operation will permanently delete this field.** and
**This operation cannot be undone.** before you press **Proceed**.

## Data types

The **Data type** is chosen when a field is created and then fixed for good —
the dialog says **Data type cannot be changed after a field is created**. If you
pick the wrong one, create a new field and delete the old one.

| Data type | Holds | Entered as |
| --- | --- | --- |
| **Text** | A short piece of text. | A normal text box. |
| **Long Text** | A longer passage, such as a note or a clause. | A multi-line box. |
| **Date** | A single date. | A date picker. |
| **Boolean** | A yes/no fact. | A tick box. |
| **Integer** | A whole number. | A number box. |
| **Number** | A number that may have decimals. | A number box. |
| **Monetary** | An amount of money. | An amount box, with the field's currency. |
| **Url** | A web address. | A text box; the value becomes a clickable link. |
| **Document Link** | One or more other documents in Paperless-ngx. | A document search box; the values show as links. |
| **Select** | One value from a list you define. | A dropdown. |

Choosing **Monetary** adds one more field to the dialog:

| Field | What it means |
| --- | --- |
| **Default Currency** | The three-character currency code to show with amounts, such as `USD` or `EUR`. Leave it empty to use your language's own currency. |

Choosing **Select** adds the option list. Press **Add option** for each value
you want in the dropdown, type its label, and use **Delete** to remove one. Long
option lists are worked through a page at a time.

## Creating and editing a custom field

**Add Field** opens the **Create new custom field** dialog; **Edit** opens **Edit
custom field**. Both hold:

| Field | What it means |
| --- | --- |
| **Name** | The field's name as it will appear on documents, such as **Account number**. |
| **Data type** | What kind of value the field holds, from the table above. |
| **Default Currency** | (Monetary only) the currency code to use by default. |
| **Add option** | (Select only) adds a value to the list of choices. |

The dialog closes with **Cancel** or saves with **Save**.

!!! note

    Custom fields have no owner or per-field permissions of their own.
    Whether you may create, change, or delete field definitions comes from your
    account's permissions — see
    [Authentication, Users, Groups & Permissions](../authentication.md) — while
    who may see a particular value is decided by the permissions on the document
    that carries it.

## Putting custom fields on documents

Open a document, and use the **Custom Fields** button above the **Details** form
to add a field to it:

1. Click **Custom Fields**, or type in **Search fields** to narrow the list; each
   entry shows the field's name and its data type.
2. Click a field to add it. To make a brand new one without leaving the page,
   click **Create new field**, type a name, and press the keyboard shortcut shown
   in the menu.
3. Fill the new field in on the form. The kind of input matches the data type —
   a date picker for **Date**, a tick box for **Boolean**, and so on.
4. Remove a field from the document with the trash button beside it. This clears
   the value on this document only; the field itself is untouched.

Custom fields are part of the document's details, so you save them the same way
as any other change, with **Save** or `Ctrl` + `S` — see
[Editing Document Details](../documents/editing.md). To set the same field on
many documents at once, use the **Custom fields** filter in the bulk editing bar
described in [Working with Many Documents at Once](../documents/bulk.md).

## Filtering and searching by custom fields

Custom field values are part of what the search engine reads, so simply typing a
value in the top bar usually finds the document. When you want to be precise:

- In the document list, open the **Custom fields** filter button. Choose a field,
  an operator, and a value, then add more conditions and join them with **All**,
  **Any**, or **Not**.
- The operators on offer depend on the data type, and include **Exists**,
  **Is null**, **Equal to**, **Contains (case-insensitive)**, **Greater than**,
  **Greater than or equal to**, **Less than**, **Less than or equal to**,
  **Contains**, **In**, and **Range**.
- In the top bar you can name the field directly, as in
  `custom_fields.name:"Account number" custom_fields.value:12345`.

A filter made of custom fields is called a **Custom fields query** when it is
saved as a view.

## A quick example

Nour keeps track of home maintenance. She opens **Attributes → Custom fields**,
clicks **Add Field**, and creates:

- **Contract Number**, of type **Text**;
- **Coverage Ends**, of type **Date**;
- **Premium**, of type **Monetary**, with **Default Currency** set to `EUR`;
- **Policy Holder**, of type **Select**, with the options **Nour**, **Sami**,
  and **Both**.

On each insurance document she clicks **Custom Fields** and adds **Contract
Number**, **Coverage Ends**, and **Premium**, then fills them in. Months later she
opens the **Custom fields** filter, picks **Coverage Ends**, chooses
**Less than or equal to**, and answers with a date a month away: the list shows
exactly the policies that are about to run out.