---
title: Backup and Restore
---

# Backup and Restore

Paperless-ngx is your archive, and an archive is only as good as its backup. This
page explains what a complete backup of Paperless-ngx has to contain, how the
built-in export and import fit into that, and what is *not* a backup.

!!! note

    There is no **Backup** button in the web interface. Backups are made by the
    person who installed and maintains your server — either with the export
    tool that comes with Paperless-ngx, or by copying the storage areas, or
    both. If you are an everyday user rather than the administrator, this page
    is worth reading so that you know what to ask for; then hand the work on.

## What a backup has to contain

Three things together make a complete backup of a Paperless-ngx installation:

| Part | What it holds |
| --- | --- |
| The documents themselves | Every stored file, including the originals and, where applicable, the archived versions and thumbnails. |
| The archive's records | Everything you have built up around the files: titles, dates, tags, correspondents, document types, storage paths, custom fields, notes, saved views, workflows, mail accounts and rules, share links, and the users, groups and permissions. |
| The auxiliary data | The smaller working files the installation keeps beside the documents. The search index can be rebuilt from the documents if it cannot be saved, but the rest cannot. |

Copying only the document files is therefore not enough: you would get the paper
back, but none of the ordering, naming or access rules that make it an archive.

## The three ways to back up

Which route is available depends on how your installation is run.

| How Paperless-ngx runs | How to back it up |
| --- | --- |
| In containers | Copy the storage areas the containers are given. There are usually three or four of them: the documents, the auxiliary data, and — if a database server is run the same way — the database itself. This is the simplest route, because it is a plain copy of everything. |
| Directly on a computer | Copy the whole Paperless-ngx folder, and, if the installation uses a separate database server, a copy of that database as well. Put it back the way it was and the installation works again. |
| Any installation | Use the built-in exporter, described next. It needs no knowledge of where things are stored and produces something you can read, keep and move. |

If the server is run the first or second way, the copy has to include the working
data as well as the documents. Whichever route you use, keep the finished backup
somewhere other than the machine the archive runs on — a second disk, a network
location, or wherever your organisation keeps its other backups.

## The built-in exporter and importer

Paperless-ngx ships with two utilities that are run by the administrator from
outside the web interface:

- the **document exporter**, which writes the whole installation out to a folder
  you choose, or to a single packaged file;
- the **document importer**, which reads that output back into a fresh
  installation.

What is worth knowing about them:

- An export contains the documents, their files, their metadata and the
  configuration around them — so it is both a backup and a way to move an archive
  to another computer or into another document system.
- An export is an exact picture of **one version** of Paperless-ngx. Export and
  import must be done with the same version; an export taken before an upgrade
  cannot be read back after it.
- The export deliberately leaves out the **API tokens** that programs use to talk
  to the archive. Those have to be created again after an import, in
  [Authentication, users, groups & permissions](../authentication.md).
- Running the exporter again over an export you already have updates it rather
  than starting from the beginning, so a backup can be refreshed cheaply and kept
  in step with the archive.
- There is a variant that exports the records only, without the document files.
  It exists for the case where you are moving between database programs and for
  other special situations.
- An import has to go into a **completely empty** installation — no documents
  and no records at all.

!!! danger

    An import is not a merge. Pointing the importer at a running installation
    that already has documents in it is not a way to add the contents of a backup
    to what is already there. Restore into an empty installation instead, or ask
    the administrator to do it for you.

## Before and after

1. Make sure nothing is being added at the time: ask everyone to stop uploading
   for a few minutes while the backup runs, so that a document is not caught
   half-finished.
2. Take the backup.
3. Satisfy yourself that it worked: the backup should be roughly as large as the
   documents it contains, and the newest files in it should be from today.
4. Move the backup off the machine the archive runs on.
5. If you used the exporter, keep the version of Paperless-ngx it was taken from
   written down with it. That note is what makes it possible to restore it.

## What is not a backup

It is easy to mistake a convenient feature for a backup. None of these replaces
one:

| Not a backup | Why |
| --- | --- |
| Downloading documents from the web interface, one by one or in bulk | You get the files, but not the titles, dates, tags, owners, notes or share links. See [Working with many documents at once](../documents/bulk.md). |
| A public share link | It points at a document inside the archive and stops working when the link expires. It is a way of showing a document, not of keeping a copy. See [Sharing and permissions](../documents/sharing.md). |
| A saved view | Only a filter. It stores no documents at all. See [Saved Views](../saved-views.md). |
| A copy kept on the same computer as the archive | Survives a mistake, but not a failed disk, a fire, or a theft. |

And one thing to keep clear in the other direction: whatever is sitting in the
trash is on its way out, because the installation empties the trash by itself
after a set delay. If you want something kept, restore it — see
[Deleting and restoring documents](../documents/trash.md) — before you rely on the
archive as your backup.

## Restoring

A restore is done by whoever maintains the server, and which of the three routes
you used decides how it goes:

- **From a copy of the storage areas or the whole folder**, put the copy back
  where it came from and start the installation again. If a database server was
  part of the copy, restore that too.
- **From an export**, import it into a completely empty installation of the same
  version, and then create the API tokens again.

!!! note

    Try a restore before you need one. A backup that has never been read back is
    only a hope; reading an export into a test installation once is the surest
    way to know that your routine works, and it tells you how long a real restore
    would take.

## A quick example

Nadia administers the archive at a clinic. The clinic runs Paperless-ngx on one
small server, and the scans, the invoices and fifteen years of patient
correspondence live in it.

Once a week, on Sunday evening when nobody is uploading, she takes an export of
the whole installation onto an external disk, and writes the version number of
Paperless-ngx on the label. The same disk copy is then mirrored to the clinic's
network backup, so two copies exist outside the server. Once a month she copies
the newest export into a test installation on her own laptop and opens a handful
of documents to be sure the backup really reads back.

One Tuesday the server's disk fails. Because the previous Sunday's export is
intact and its version number is recorded, she rebuilds the installation on a new
machine from that export, creates the API tokens again for the two programs that
feed the archive, and by the next morning the clinic is working from a complete
archive — including the tags, correspondents and permissions, which no amount of
downloading files by hand would have brought back.
