---
title: Mail
---

# Mail

Paperless-ngx can read a mailbox for you and turn what it finds there into
documents. You give it an account to watch, tell it which messages count with a
rule, and it does the filing — tagging, naming, and deciding where each document
belongs — without anybody dragging files around.

Mail lives under **Mail** in the sidebar. The page is titled **Mail Settings**
and described as *Manage e-mail accounts and rules for automatically importing
documents.* Everything comes in two layers:

| Layer | What it is |
| --- | --- |
| **Mail accounts** | The mailboxes Paperless-ngx is allowed to sign in to. |
| **Mail rules** | What to do with the messages found in an account. |

An account on its own does nothing; the rules decide which messages become
documents and what happens to them afterwards.

!!! note

    Mail is fetched in the background on a schedule — every 10 minutes by
    default — so there is nothing to press to keep it working. You can also ask
    for one account to be checked straight away with **Process Mail**, see
    below.

## Mail accounts

The **Mail accounts** section lists one row per account:

| Column | Meaning |
| --- | --- |
| **Name** | The name you gave the account. Click it to edit. |
| **Server** | The mail server the account connects to. |
| **Username** | The username used to sign in. |
| **Actions** | **Edit**, **Permissions**, **Delete**, and **Process Mail**. |

- **Add Account** opens the **Create new mail account** dialog.
- **Connect Gmail Account** and **Connect Outlook Account** appear when the
  installation has been set up for them, and they sign in to Google or Microsoft
  for you instead of you typing a server and port.
- **Process Mail** checks that account right away instead of waiting for the
  next automatic run. A message confirms it with *Processing mail account
  "…"*.
- If there are no accounts yet the list says **No mail accounts defined.**

Deleting asks for confirmation first, and — as with everything in
Paperless-ngx — a deleted account is gone for good.

### The mail account dialog

**Add Account** opens **Create new mail account**; **Edit** opens **Edit mail
account**. Both hold the same fields:

| Field | What it means |
| --- | --- |
| **Name** | A label for the account, so you can recognise it in the rules. |
| **IMAP Server** | The address of the mail server. |
| **IMAP Port** | The port to connect on. |
| **IMAP Security** | **SSL**, **STARTTLS**, or **No encryption**. |
| **Username** | The sign-in name for the mailbox. |
| **Password** | The sign-in password. |
| **Password is token** | Tick this when the password is a token used for authentication, as some providers require. |
| **Character Set** | The text encoding, **UTF-8** by default. |

Before saving you can press **Test**. The dialog reports back either
**Successfully connected to the mail server** or **Unable to connect to the
mail server**, which saves you from a rule that can never run because the
account cannot sign in. The dialog closes with **Cancel** or saves with **Save**.

!!! warning

    A mail account usually needs access to your whole mailbox, so give it a
    password or token made for the purpose if your provider allows it. Everyone
    who is allowed to change mail accounts can use the account, so keep that
    permission to people you trust.

## Mail rules

A **mail rule** decides which messages in an account become documents, and what
happens to those messages afterwards. The **Mail rules** section lists one row
per rule:

| Column | Meaning |
| --- | --- |
| **Name** | The rule's name. Click it to edit. |
| **Sort Order** | The number that decides the order rules are tried in — lower first. |
| **Account** | The mail account the rule reads. |
| **Status** | A switch reading **Enabled** or **Disabled**. |
| **Processed Mail** | A button, **View Processed Mail**, opening the record of messages this rule has handled. |
| **Actions** | **Edit**, **Permissions**, **Delete**, and **Copy**. |

**Add Rule** opens **Create new mail rule**; **Copy** duplicates a rule (named
"*name* (copy)") so you can adapt it. With no rules at all the list says
**No mail rules defined.**

### Choosing which mail the rule reads

| Field | What it means |
| --- | --- |
| **Name** | A label for the rule. |
| **Account** | Which mail account this rule belongs to. |
| **Enabled** | Whether the rule runs. |
| **Order** | The order rules are tried in. |
| **Stop further processing** | When the rule queues a document, stop and do not try the rules below it on the same message. Useful when one message should match exactly one rule. |
| **Folder** | The mailbox folder to read, **INBOX** by default. Subfolders are separated by a delimiter, often a dot or a slash, which varies by mail server. |
| **Maximum age (days)** | Ignore messages older than this many days. Leave it empty to read everything in the folder. |
| **Filter from** | Only messages whose sender matches this text. |
| **Filter to** | Only messages whose recipient matches this text. |
| **Filter subject** | Only messages whose subject contains this text. |
| **Filter body** | Only messages whose body contains this text. |

The line above the filters reminds you how they combine: **Paperless will only
process mails that match *all* of the criteria specified below.** An empty filter
simply does not apply.

### What gets turned into a document

| Field | What it means |
| --- | --- |
| **Consumption scope** | **Only process attachments** (the default), **Process message as .eml**, or **Process message as .eml and attachments separately**. |
| **Attachment type** | **Only process attachments**, or **Process all files, including 'inline' attachments**. Use the second when a document is embedded in the message body rather than attached. |
| **PDF layout** | How a converted message is laid out: **System default**, **Text, then HTML**, **HTML, then text**, **HTML only**, or **Text only**. |
| **Include only files matching** | An optional list of file names or wildcards to accept, for example `*.pdf` or `*invoice*`. Several patterns can be separated by commas, and matching is not case-sensitive. |
| **Exclude files matching** | An optional list of file names or wildcards to skip, in the same style. Use it to leave signatures and logos out of the archive. |

### What happens to the message afterwards

**Action** decides what happens to the message once it has been processed. The
footnote under the field is the rule: it is **Only performed if the mail is
processed.**

| Action | Effect |
| --- | --- |
| **Delete** | Removes the message from the mailbox. |
| **Move to specified folder** | Moves the message to a folder you name in **Action parameter**. |
| **Mark as read, don't process read mails** | Marks the message as read, and skips messages that are already read. |
| **Flag the mail, don't process flagged mails** | Sets the important flag, and skips messages that already carry it. |
| **Tag the mail with specified tag, don't process tagged mails** | Adds a tag you name in **Action parameter**, and skips messages that already carry it. |

With **Move to specified folder** or **Tag the mail with specified tag…** an
extra field, **Action parameter**, appears for the folder name or the tag. Not
every mail server supports tags; where a provider uses colours instead, a colour
name can be given in the form `apple:green` — see the note about Apple Mail in
[Incoming e-mail](../../usage.md#incoming-mail).

### Naming and filing the new document

| Field | What it means |
| --- | --- |
| **Assign title from** | **Use subject as title**, **Use attachment filename as title**, or **Do not assign title from this rule**. |
| **Assign owner from rule** | Tick to make the rule's owner the owner of the document. Untick when an owner should be set some other way. |
| **Assign tags** | Tags to put on every document from this rule. |
| **Assign document type** | The document type to apply. |
| **Assign correspondent from** | **Do not assign a correspondent**, **Use mail address**, **Use name (or mail address if not available)**, or **Use correspondent selected below**. |
| **Assign correspondent** | The correspondent to use, when the choice above is **Use correspondent selected below**. |

The dialog closes with **Cancel** or saves with **Save**.

!!! tip

    **Assign tags** is the trick that makes mail rules pay off. Pair it with
    **Stop further processing**, and a fallback rule that catches everything
    unrecognised, and every message is either filed where you expect it or
    waiting in a pile you can find with a saved view.

## Processed mail

For every message a rule has handled, Paperless-ngx remembers the message's
identity so that it is never imported twice — reading a message in your mail
client, or leaving the message in the folder, does not cause a duplicate.

**View Processed Mail** opens that record for a rule. The table has a checkbox
per row and these columns:

| Column | Meaning |
| --- | --- |
| **Subject** | The subject of the message. |
| **Received** | When the message arrived. |
| **Processed** | When Paperless-ngx handled it. |
| **Status** | A green tick for success, a red warning for failure, or a dash for anything else. |
| **Error** | The reason, when something went wrong. Hover over it to read the whole message. |

**Clear** drops the current selection and **Delete selected** forgets the chosen
entries. If nothing is listed the dialog says **No processed email messages
found.**

!!! warning

    **Delete selected** is how you ask Paperless-ngx to treat a message as new
    again. The next mail check will import it a second time, so only remove an
    entry when you actually want the message reprocessed.

## What happens when mail is checked

1. Paperless-ngx signs in to each **mail account**.
2. In the folder named by each enabled rule, it looks at messages that match all
   of the rule's criteria and that it has not seen before.
3. Matched attachments — or the message itself, depending on **Consumption
   scope** — are added to the archive and processed like any other document, so
   text is extracted and automatic matching applies.
4. The rule's **Assign…** settings choose the title, tags, document type and
   correspondent.
5. The rule's **Action** is then performed on the message, so it does not come
   back next time.

Because the archive only ever reads from the mailbox, a message that was not
wanted can simply be left where it is. But if the password changes, or the
server cannot be reached, nothing is imported until an administrator fixes it —
which is what the **Processed Mail** record and its **Error** column are for.

## A quick example

Mercury Supplies scans invoices to `invoices@mercury.example`, and the accountant
Farid wants them in the archive without any handling.

He opens **Mail**, clicks **Add Account**, and enters the mailbox's **Name**,
**IMAP Server**, **Username** and **Password**, then presses **Test**. The dialog
reports **Successfully connected to the mail server**, so he saves.

Under **Mail rules** he clicks **Add Rule** and names it **Supplier invoices**.
He sets **Account** to the new mailbox, **Folder** to **INVOICES**, **Filter
subject** to `invoice`, **Consumption scope** to **Only process attachments**,
**Assign title from** to **Use attachment filename as title**, **Assign tags** to
*Invoice* and *To pay*, and **Assign correspondent from** to **Use name (or mail
address if not available)**. For **Action** he chooses **Move to specified
folder** and types **Processed** in **Action parameter**.

He saves the rule. From then on, supplier invoices are imported with a sensible
title and the right tags, and their messages are tidied into the **Processed**
folder. When he wants to check what happened, he clicks **View Processed Mail**
on the rule.

