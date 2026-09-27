---
title: Logs
---

# Logs

**Logs** lets you read what the installation has been writing down while it
works. It is the first place to look when something did not happen the way you
expected and you want to know why. It sits in the sidebar under
**Administration** and describes itself as *Review the log files for the
application and for email checking.*

!!! note

    **Logs** is shown to administrators only. If the sidebar has no **Logs** entry,
    your account does not have the right to read them.

## The three logs

Each log is a separate tab across the top of the page, named after the log it
shows. Only the logs that exist on your installation get a tab.

| Tab | What is written there |
| --- | --- |
| **paperless.log** | The main record of the application: documents being consumed and filed, workflows and rules being applied, and any errors along the way. |
| **mail.log** | What happened each time a mail account was checked: which messages were looked at, which were imported, and which were refused or failed. |
| **celery.log** | The background workers that carry out the work — consuming files, sending mail, running scheduled jobs and the periodic checks. |

## The controls

| Control | What it does |
| --- | --- |
| **Show** _number_ **lines** | How much of the log to read, counted from the newest line backwards. The starting value is 5000, and you can step it up or down in hundreds. |
| **Auto refresh** | On by default. The page re-reads the log every few seconds, so new lines appear on their own while you watch. |
| **Jump to bottom** | A floating button that appears as soon as you scroll away from the newest line. Pressing it returns you to the end and starts following along again. |

While a log is being fetched the page says **Loading...**.

!!! tip

    The newest entries are at the bottom of the page. If you are chasing a
    problem that happened at a known moment, turn **Auto refresh** off first so
    the page stops moving under your cursor, and lower the **Show … lines** value
    so there is less to read.

## Reading the lines

The log is shown in a dark, evenly spaced panel, and each line is shaded
according to how serious it is:

| Marked as | Meaning |
| --- | --- |
| **DEBUG** | Detail intended for troubleshooting; usually safe to ignore. |
| plain lines | Ordinary information: something was done, or is about to be. |
| **WARNING** | Something unexpected happened, but the work continued. |
| **ERROR** | Something failed. This is where to start reading. |
| **CRITICAL** | The failure was serious enough that part of the installation stopped. |

A line normally records the time, the part of the system that wrote it, and the
message. A failure is usually followed by the reason, and sometimes by a
longer technical explanation on the lines beneath it.

!!! warning

    Log lines are written for administrators. They can contain file names,
    document titles, e-mail subjects and addresses, and other details about your
    archive's contents, so treat a copied log the same way you would treat the
    documents themselves.

## A quick example

Karim's team reported that supplier invoices stopped arriving from the mailbox
during the night.

He opens **Logs** and picks the **mail.log** tab. He switches **Auto refresh**
off, sets **Show** to a few hundred **lines**, and reads the last entries: every
check of the account for several hours ends with an **ERROR** line, and the line
below it names the reason — the mailbox has stopped accepting the saved password.

He confirms the same thing from the [Tasks](tasks.md) page, where the mail
fetching tasks are listed as needing attention, and tells his colleague to
create a new password for the mailbox in [Mail](../mail.md). The next morning the
**mail.log** tab shows successful checks again, and the invoices are back in the
archive.

If the reason had not been obvious in the log, Karim would have copied the last
few **ERROR** lines into a message to whoever maintains the server.
