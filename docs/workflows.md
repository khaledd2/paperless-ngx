---
title: Workflows
---

# Workflows

A **workflow** is a rule that watches the document pipeline and does something
when it sees what it is looking for: it can set the title, tags, correspondent,
document type, storage path, owner and permissions; it can take information away
again; and it can send the document by e-mail, post it to a web address, try to
unlock it, or move it to the trash.

Each workflow has three parts:

| Part | What it decides |
| --- | --- |
| **Trigger** | *When* the workflow runs, and which documents it applies to |
| **Actions** | What the workflow does, in order, when it runs |
| **Settings** | Its name, its position among the other workflows, and whether it is switched on |

Workflows live under **Workflows** in the sidebar. The page header describes
them as *Use workflows to customize the behavior of Paperless-ngx when events
'trigger' a workflow.*

!!! note

    Workflows are shared: everyone who can open the page sees the same list.
    Workflows can also set owners and permissions, so treat them as an
    administrative feature — see
    [Who can change workflows](#who-can-change-workflows) below.

## The Workflows page

The list has one row per workflow:

| Column | Meaning |
| --- | --- |
| **Name** | Click the name to edit the workflow. |
| **Sort order** | The number that decides the order workflows run in — lower first. |
| **Status** | A switch reading **Enabled** or **Disabled**. Flick it to turn the workflow on or off without deleting it. |
| **Triggers** | A short summary of the trigger types, such as "Consumption Started" or "Document Added, Scheduled". |
| **Actions** | **Edit**, **Delete**, and **Copy**. |

**Add Workflow** opens an empty workflow; **Copy** makes a duplicate called
"*name* (copy)" and opens it for editing, which is the quickest way to build a
similar rule. If the list is empty it says **No workflows defined.**

Deleting asks for confirmation first: **Confirm delete workflow**, followed by
**This operation will permanently delete this workflow.** and **This operation
cannot be undone.**, and the confirm button is **Proceed**.

## Triggers

A trigger answers two questions: which event are we reacting to, and which
documents does it apply to. Open the **Triggers** section in the workflow dialog
and click **Add Trigger** (**Trigger Workflow On:**). Every trigger starts with
a **Trigger type**:

| Trigger type | Runs… |
| --- | --- |
| **Consumption Started** | *before* a document is stored, while it is still being read. File name, source, path and mail rule are known; the extracted text and the automatic tags are not yet available. |
| **Document Added** | *after* a new document has been stored, with its text extracted and its tags, correspondent and document type worked out. |
| **Document Updated** | whenever somebody changes an existing document. |
| **Scheduled** | on a fixed day relative to a date on the document — useful for reminders and deadlines. |

A workflow can hold several triggers; it runs when **any** of them matches.

### What you can filter on

Under the trigger type you can narrow down which documents qualify:

- **Filter filename** — applies to documents whose file name matches, with
  wildcards allowed, for example `*.pdf` or `*invoice*`. It is not
  case-sensitive.
- With **Consumption Started** you also get:
  - **Filter sources** — **Consume Folder**, **API Upload**, **Mail Fetch**, or
    **Web UI**.
  - **Filter path** — the folder the file arrived from, with `*` wildcards
    allowed.
  - **Filter mail rule** — only documents that came in through a particular
    mail rule.
- With **Document Added**, **Document Updated**, and **Scheduled** you also get
  **Content matching algorithm** and, when the choice needs one, **Content
  matching pattern** and **Case insensitive** — the same idea as tag matching,
  but applied to the text of the document. The choices are **Any word**,
  **All words**, **Exact match**, **Regular expression**, **Fuzzy word**, and
  **None**.

The line above the filters, **Trigger for documents that match *all* filters
specified below.**, is the rule: a document must satisfy every filter on the
trigger.

### Advanced Filters

Below the basic filters, **Add filter** builds extra conditions on the document's
own attributes. Each filter is a pair: pick what to test on the left, then the
value on the right. The available tests are:

| Test | Matches |
| --- | --- |
| **Has any of these tags** | Documents carrying at least one of the tags you pick |
| **Has all of these tags** | Documents carrying every one of the tags you pick |
| **Does not have these tags** | Documents carrying none of the tags you pick |
| **Has correspondent** | Documents from one particular correspondent |
| **Has any of these correspondents** | Documents from any of several correspondents |
| **Does not have correspondents** | Documents from none of the correspondents you pick |
| **Has document type** | Documents of one particular type |
| **Has any of these document types** | Documents of any of several types |
| **Does not have document types** | Documents of none of the types you pick |
| **Has storage path** | Documents filed under one particular storage path |
| **Has any of these storage paths** | Documents filed under any of several storage paths |
| **Does not have storage paths** | Documents filed under none of the paths you pick |
| **Matches custom field query** | Documents whose custom fields satisfy a query you build |

A filter you no longer want is removed with its **Delete** button. Advanced
filters are only offered for **Document Added**, **Document Updated** and
**Scheduled** triggers; with none defined the section says **No advanced
workflow filters defined.**

### Scheduled settings

A **Scheduled** trigger asks a different question: not "which document arrived"
but "which documents have reached a date". For those triggers you set:

| Field | What it means |
| --- | --- |
| **Offset days** | How far from the date to run. Positive values trigger after the date, negative values before. |
| **Relative to** | Which date to count from: **Added**, **Created**, **Modified**, or **Custom Field**. |
| **Custom field** | Which date field to use, when **Relative to** is **Custom Field**. |
| **Recurring** | Whether the trigger repeats instead of firing once. |
| **Recurring interval days** | How often it repeats, when **Recurring** is ticked. |

## Actions

Open the **Actions** section and click **Add Action** (**Apply Actions:**).
Every action begins with an **Action type**:

| Action type | What it does |
| --- | --- |
| **Assignment** | Fills in or replaces information on the document. |
| **Removal** | Takes information off the document. |
| **Email** | Sends the document by e-mail. |
| **Webhook** | Posts a message to a web address you give. |
| **Password removal** | Tries passwords against a protected PDF so it can be read. |
| **Move to trash** | Moves the document to the trash. |

A workflow can hold as many actions as you like, and they run from top to
bottom; there is a handle on the left of each action so you can drag them into
the order you want.

### Assignment

| Field | What it sets |
| --- | --- |
| **Assign title** | A new title, which may contain placeholders so the name is built from the document's own details. |
| **Assign tags**, **Assign document type**, **Assign correspondent**, **Assign storage path** | The matching attribute on the document. |
| **Assign custom fields** | Which custom fields the document should carry. |
| **Assign owner** | The user the document belongs to. |
| **Assign view permissions**, **Assign edit permissions** | The **Users:** and **Groups:** who may open, or change, the document. As elsewhere, **Edit permissions also grant viewing permissions**. |

**Assign title**, **Email subject** and **Email body** may contain placeholders
that are filled in from the document itself. A few that work with every trigger:

| Placeholder | Fills in |
| --- | --- |
| `{{correspondent}}` | The correspondent assigned to the document |
| `{{document_type}}` | The document type assigned to the document |
| `{{owner_username}}` | The owner of the document |
| `{{added_year}}`, `{{added_month}}`, `{{added_day}}`, `{{added_time}}` | Parts of the date the document was added |
| `{{original_filename}}` | The original file name, without its extension |
| `{{filename}}` | The document's current file name, without its extension |

With **Document Added** and **Document Updated** triggers the date the document
was created is available too, as `{{created_year}}` and the like, together with
`{{doc_url}}` and `{{doc_id}}`.

### Removal

Removal takes things off a document. Each block has a **Remove all** switch
beside it, so you can either clear everything of that kind or name exactly what
to take away:

- **Remove tags**, **Remove correspondents**, **Remove document types**,
  **Remove storage paths**, **Remove custom fields**.
- **Remove owners** — clears the owner.
- **Remove permissions** — with separate **View permissions** and
  **Edit permissions** blocks, each with **Users:** and **Groups:**.

### Email, Webhook, Password removal and Move to trash

| Action | Fields |
| --- | --- |
| **Email** | **Email subject**, **Email body**, **Email recipients** (several addresses separated by commas), and **Attach document**. Subject and body may use placeholders. |
| **Webhook** | **Webhook url**, the body as **Webhook params** (key-and-value pairs) or as plain **Webhook body**, the **Webhook headers**, whether to **Send webhook payload as JSON**, and **Include document**. |
| **Password removal** | **Passwords**, one per line. The workflow tries them in order until one succeeds. Passwords are stored in plain text, so use with caution. |
| **Move to trash** | Nothing to fill in — the document is moved to the trash at the end of the run, where it can still be restored until the trash is emptied. |

!!! warning

    **Move to trash** always runs last, wherever it sits in the list, and no
    further workflow runs on that document afterwards. The same applies to
    e-mail and webhook actions: an action that reaches outside Paperless-ngx
    cannot be undone.

## How workflows combine

- The **Sort order** numbers decide the sequence, lowest first. Workflows run
  one after another.
- For **Assignment**, a later workflow overrides an earlier one — except for
  values that can hold several entries, such as tags, custom fields and
  permissions, which are merged instead of replaced.
- A later workflow always sees the changes the earlier ones made, so one
  workflow can set a tag and the next can react to it.

## Who can change workflows

Workflows are powerful, so they have their own permissions: a user needs the
right to add, change, or delete workflows before the matching buttons appear.
Everyone who can open the **Workflows** page sees the whole list, because
workflows belong to the installation rather than to a person.

!!! note

    Because workflows can set owners and permissions, a workflow is an easy way
    to give a whole class of documents the same access rules. If documents from
    the consume folder arrive without an owner, a workflow is the usual place to
    fix that. See
    [Authentication, Users, Groups & Permissions](authentication.md).

## A quick example

Priya runs the office of a small charity. Every invoice that arrives by e-mail
should be tagged, filed, and given a sensible title without anyone touching it.

She opens **Workflows** and clicks **Add Workflow**. She names it
**Incoming invoices**, leaves **Enabled** on and sets **Sort order** to 1.

Under **Triggers** she adds a **Consumption Started** trigger and sets
**Filter sources** to **Mail Fetch** and **Filter filename** to `*.pdf`.

Under **Actions** she adds an **Assignment** action with **Assign title** set to
`Invoice {{added_year}} {{original_filename}}`, **Assign tags** set to *Invoice*
and *To review*, **Assign document type** set to *Invoice*, and **Assign owner**
set to herself.

She saves the workflow. The next invoice that arrives by e-mail, a file named
*Northern Power March*, is stored with the title "Invoice 2026 Northern Power
March", tagged *Invoice* and *To review*, typed as *Invoice*, and owned by Priya
— with no manual work at all.

