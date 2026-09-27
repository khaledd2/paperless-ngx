---
title: Tasks
---

# Tasks

**Tasks** is the record of everything the installation has been asked to do, and
what came of it. It lives in the sidebar under **Administration**, and the page
describes itself as *Tasks shows detailed information about document consumption
and system tasks.*

Reading it tells you why a document you were expecting is not in the archive
yet, whether an overnight mail check did anything, and what a failure was. The
sidebar entry also carries a red badge with the number of tasks that need
attention, so you can see at a glance that something went wrong even when you are
not on the page.

## The sections

The list is split into sections, chosen with the buttons at the top left of the
page. Each button carries the number of tasks in that section when it is not
empty.

| Section | Contains |
| --- | --- |
| **All** | Everything, grouped by section. |
| **Needs attention** | Tasks that failed or were stopped before they finished. The count sits in a red badge, and it is also the number on the sidebar entry. |
| **In progress** | Tasks that are waiting to start or are running right now. |
| **Recently completed** | Tasks that finished successfully. |

## Narrowing the list

| Control | What it does |
| --- | --- |
| **Filter by** — the type menu | Shows only one kind of task. It opens with **All types**; see the list of types below. |
| **Filter by** — the source menu | Shows only tasks that came from one place. It opens with **All sources**; see the list of sources below. |
| The search box | Looks for text either in the **Name** of the task or in its **Result**, which you choose on the small menu to the left of the box. A search starts once you have typed at least three characters; pressing Enter applies it immediately and Escape clears it. |
| **Reset filters** | Appears as soon as any filter is in use, and clears all of them. |
| **Auto refresh** | On by default; the list is rebuilt every few seconds while you are on the page. |
| The page numbers | The list shows 25 tasks at a time. |

With nothing left to show, the page says **No tasks match the current filters.**

## The list

| Column | Meaning |
| --- | --- |
| The tick box | Selects a task, so that you can dismiss several at once. The tick box at the top of a column selects every task in that section. |
| **Name** | The name of the file for an incoming document, or the kind of task otherwise. The small line beneath it names the type of task and where it came from. |
| **Created** | When the task was queued. |
| **Results** | What happened. Long results are shortened in the column; hover to read more, or press to open the full detail. |
| **Info** | On a narrow screen this replaces the **Results** column, and opens the detail. |
| **Actions** | **Dismiss** removes the entry from the list. **Open Document** appears when the task produced a document and opens it. |

Opening the detail of a task shows:

| Part | Meaning |
| --- | --- |
| **Result message** | The same outcome as in the column, in full. |
| **Duplicate** | When a file was recognised as one the archive already has, the document it matches, with an **Open** button. |
| **Input data** | What the task was given — for a document, its file name and the options that were used. |
| **Result data** | The technical outcome: the new document's number, a reason, or the error. |

Common result messages you will see are *Success. New document id N created*,
*Duplicate of document #N*, or the reason the document was not added at all.

## Dismissing tasks

The list is meant for looking, not for keeping. Once you have read a task you can
put it away:

1. Either tick the tasks you want to put away, or leave the list unticked to work
   on everything currently visible.
2. Press the blue button at the top right. It reads **Dismiss visible** when
   nothing is selected and **Dismiss selected** when something is.
3. If more than one task is about to be dismissed, a window asks **Confirm
   Dismiss** with the question *Dismiss N tasks?* — press **Dismiss** to go
   ahead.

While something is selected, a **Clear selection** button appears next to it to
undo the ticks.

!!! warning

    Dismissing a task only removes the entry from this list. It does not undo
    what the task did: a document that was imported stays imported, and one that
    failed is not tried again by dismissing it. To have a document processed
    again, use the document's own actions — see
    [Working with many documents at once](../documents/bulk.md).

## The kinds of task

| Type | What it does |
| --- | --- |
| **Consume File** | Adds a file to the archive: reading it, running text recognition, and applying automatic matching. |
| **Train Classifier** | Re-learns your filing habits from the documents you have already named and tagged, so that suggestions improve. |
| **Sanity Check** | The periodic check for damaged documents and other inconsistencies. |
| **Mail Fetch** | Checks a mail account and imports whatever its rules match. |
| **LLM Index** | Prepares the index used by the optional AI features. |
| **Empty Trash** | The scheduled removal of documents that have been in the trash long enough. |
| **Check Workflows** | Runs the workflows that are due. |
| **Bulk Update** | Applies a change to many documents at once. |
| **Reprocess Document** | Runs one document through processing again. |
| **Build Share Link** | Prepares a public share link and the copy of the document it serves. |
| **Bulk Delete** | Removes many documents at once. |

## Where tasks come from

| Source | Meaning |
| --- | --- |
| **Scheduled** | The installation did it by itself, on its own timetable. |
| **Web UI** | Somebody asked for it in the web interface. |
| **API Upload** | A file arrived from another program that is allowed to add documents. |
| **Folder Consume** | A file appeared in a folder the installation watches. |
| **Email Consume** | A message was imported from a mail account. |
| **System** | The installation's own housekeeping. |
| **Manual** | Somebody started it directly. |

## A quick example

Every Monday morning Mounir checks the archive for the weekend's post.

The sidebar shows a red badge next to **Tasks**, so he opens it. **Needs
attention** holds two entries. He sets **Filter by** to **Consume File** and
reads them: both are scans that the office sent on Saturday, and both carry the
result *Duplicate of document #N* with a **Duplicate** panel he can open.

Under **Recently completed** he finds the rest of the weekend's work, and the
**Mail Fetch** entries tell him the supplier mailbox was checked as usual. He
opts to show only **Mail Fetch** tasks for that, then presses **Dismiss visible**
to clear them out of the way. Finally he selects the two duplicates, presses
**Dismiss selected**, and confirms **Dismiss** — the archive stays as it is, and
the list is now empty of everything he has read.
