---
title: Notes and History
---

# Notes and History

Paperless-ngx can carry two kinds of annotation beside a document: **notes**,
which you write to remind yourself or your colleagues of something, and
**history**, which the system writes for you every time a document changes.

## Notes

Open a document and choose the **Notes** tab. Each note shows its text and who
wrote it and when.

### Writing a note

1. Click in the box that says **Enter note**.
2. Type your note. Plain text is enough — a payment reference, a reminder that
   the original was filed in a different folder, a question for a colleague.
3. Confirm to add it. The note appears at the top of the list straight away and
   the **Notes** tab gains a small badge with the total number of notes.

A note can be deleted with **Delete note**, which asks you to confirm first.

Notes are attached to the document, not to a file version, so they stay in place
when a new version is uploaded.

!!! note

    Notes must be switched on by your administrator under
    **Settings → Documents → Notes → Enable notes**. If the **Notes** tab is
    missing, the feature is off. Writing notes also requires permission to change
    the document; without it you can read notes but not add them.

### Finding notes later

Although notes are not part of the document's text, they are useful in the list:
tick **Notes** under **Show** to see how many each document has, and pick
**Notes** in the **Sort** menu to bring annotated documents to the top.

## History

Open a document and choose the **History** tab to see every recorded change,
newest first. Each entry has three parts:

| Part | Meaning |
| --- | --- |
| A relative time such as “3 days ago” | When it happened; hover over it to see the exact date and time |
| A name, or **System** | Who made the change. **System** means Paperless-ngx did it automatically — while importing a file, running a workflow, or fetching mail |
| A badge — **Create**, **Update**, or **Delete** | The kind of change |

Below that, the details of what changed are listed field by field: **Title**,
**Created**, **Correspondent**, **Document type**, **Storage path** and your
custom fields show their new value, tag and document-type changes are listed as
what was added or removed, and edits to the extracted text are shown as a short
excerpt.

If nothing has been recorded yet the tab simply says **No entries found.**

!!! note

    History is written by the optional auditing feature, which your
    administrator turns on for the whole system. It is a record of what happened,
    so it cannot be edited or deleted from the interface — and if the **History**
    tab is missing, auditing is switched off.

## A quick example

Yusuf scans the signed copy of a contract. On the **Details** tab he corrects the
title. Before saving, he opens the **Notes** tab and adds a note: “Signed copy
received 14 March, original posted to the lawyer.” He saves with `Ctrl` + `S`.

A week later a colleague wonders who changed the title and when. She opens the
same document, chooses **History**, and finds an **Update** entry with Yusuf's
name, the title's new value, and the time it was saved — then reads his note to
find out why.
