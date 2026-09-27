---
title: System Status
---

# System Status

**System Status** is the health report of the installation, in one window. It
answers the question "is everything working, and what has the system been doing
lately?" without digging through anywhere else.

You open it from the header of the [Settings](settings.md) page, with the
**System Status** button. The button carries a small badge:

| Badge | Meaning |
| --- | --- |
| A green tick | Everything the report covers is working. |
| A red mark | At least one item is failing — the database, the background services, the search index, the classifier, the sanity checker, or the live connection to the browser. |

The button appears for administrators, and for anyone who has been granted
permission to view system status. If you cannot see it, that is the reason.

The report is in four cards — **Environment**, **Database**, **Tasks Queue**, and
**Health** — and ends with a **Copy** button.

## Environment

| Item | What it tells you |
| --- | --- |
| **Paperless-ngx Version** | The version of the installation. If the interface and the server are not the same version, a small warning triangle appears; click it to see the **Frontend version** and the **Backend version** side by side. |
| **Install Type** | How the installation is run. |
| **Server OS** | The operating system of the computer the archive runs on. |
| **Media Storage** | A bar and two figures: how much room the documents have left, and how much there is in total. |

## Database

| Item | What it tells you |
| --- | --- |
| **Type** | Which kind of database is in use. |
| **Status** | **OK** with a green tick, or a red mark. Click it to see the address it is talking to, or the address together with the error. |
| **Migration Status** | **Up to date** with a green tick, or a number with **Pending** and an amber warning. Click it to see the **Latest Migration** applied and the list of **Pending Migrations**. |

!!! note

    **Pending Migrations** normally means the installation has been updated but
    the update has not been finished. It is a job for whoever maintains the
    server, not something to fix from the web interface.

## Tasks Queue

The two background services that carry out the work — for example processing
incoming documents or running scheduled workflows — are listed here:

| Item | What it tells you |
| --- | --- |
| **Redis Status** | **OK** or a red mark. Click it to see the address, or the address with the error. |
| **Celery Status** | **OK** or a red mark. Click it to see the address, or the error. |
| **Recent Task Activity (_n_ days)** | A small summary: **Total**, **Successful**, **Failed**, and **Pending**, or **No recent tasks** when nothing has run. |

For the tasks themselves — which document, when, and what went wrong — use
[Tasks](tasks.md).

## Health

| Item | What it tells you |
| --- | --- |
| **Search Index** | **OK** or an error. Click it to see the **Last Updated** time. If the search index is not working, documents still exist, but searching will not find them. |
| **Classifier** | The part of the system that learns how you file documents. **OK**, a warning, or an error, with the **Last Trained** time in the popover. |
| **Sanity Checker** | A periodic check that looks for damaged documents and other inconsistencies. **OK**, a warning, or an error, with the **Last Run** time in the popover. |
| **WebSocket Connection** | **OK** while the live link between the browser and the server is up, or **Error** when it has dropped. This is the link that lets progress updates appear by themselves. |
| **AI Index** | Only shown when the optional AI features are switched on. **OK**, a warning, or an error, with the **Last Run** time. See [AI Features](../advanced/ai.md). |

!!! note "About the amber warning"

    An amber warning triangle means the item is working, but its last result is
    more than a day old. For the **Classifier** and the **AI Index** that is
    worth looking into; for the **Sanity Checker**, which normally runs about
    once a week, it is the ordinary state between runs.

## Re-running a check

Some entries carry a **Run Task** button with a play symbol: the **Classifier**,
the **Sanity Checker**, and the **AI Index**. Pressing it asks the installation
to do that work again right away, and a small spinner appears while it runs. The
buttons are only shown to superusers, because they set off work on the server.

Everything else in the report is read-only.

## Reading the report

Every entry is a small button. Press it (or hover) and a popover explains the
value: the address being used, the time of the last run, or the error that was
reported.

| Status | Looks like |
| --- | --- |
| **OK** | A green tick. |
| **WARNING** | An amber triangle — working, but something is worth a look. |
| **ERROR** | A red triangle — this part is failing. |
| **DISABLED** | A grey dash — this part is deliberately not in use. |

If something is failing, the two places to look next are [Logs](logs.md) for the
details, and [Tasks](tasks.md) for the work that did not finish.

**Copy** puts the whole report on your clipboard as plain text, which is the
quickest way to hand the numbers to whoever maintains your server or to attach
them to a support request.

## A quick example

The archive at Huda's office has felt slow for two days.

She opens **Settings** and notices that the **System Status** button carries a
red mark instead of its usual green tick. She presses it. **Environment** and
**Database** are fine — **Media Storage** shows plenty of room left, and the
migration column says **Up to date**. In **Tasks Queue** the **Redis Status** is
**OK** but **Celery Status** shows a red mark; pressing it reveals an error
instead of an address. Under **Health**, the **Search Index** is fine, so once
the queue is running again the search will be current.

The background workers have stopped, which is why nothing is being processed and
why the report looks unwell. She presses **Copy**, sends the report to her
server administrator, and opens [Tasks](tasks.md), where the pending
document-processing entries explain why the new scans never appeared.

## Statistics

Numbers about the contents of the archive — how many documents arrived, how they
are distributed across tags and correspondents — are not part of this window.
They live on the **Dashboard**; see
[Dashboard & navigation](../getting-started/dashboard.md).
