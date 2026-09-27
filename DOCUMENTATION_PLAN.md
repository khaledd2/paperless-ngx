# Paperless-ngx End-User Documentation Plan

A roadmap for documenting the whole system for **end users and administrators**
(non-developers), in plain language, in **English and Arabic** as separate files.

## Purpose

Build a complete, consistent set of end-user guides covering every major area
of Paperless-ngx: signing in, working with documents, organizing content,
automation, sharing, and administration.

## Audience

- Everyday users who upload, find, and read documents.
- System administrators who configure and maintain the instance.
- **Not** developers (no code, file paths, class names, or environment variables).

## Conventions

Follow the `paperless-docs` skill at `.cline/skills/doc.md`:

- **Two files per topic**, same structure:
  - `docs/<topic>.md` (English)
  - `docs/<topic>.ar.md` (Arabic)
- Plain language; use the app's **actual UI labels**.
- mkdocs-material formatting: front-matter `title`, `!!! note` / `!!! warning` / `!!! danger`, tables.
- Each guide ends with a short **worked example** where useful.

## Status legend

- `[ ]` not started · `[~]` in progress · `[x]` done

## Roadmap

### 0. Foundation

- [x] **Authentication, users, groups & permissions** — EN + AR. Files are
  `docs/authentication.md` and `docs/authentication.ar.md` (renamed from
  `permissions.*` to match the wider scope).

### 1. Getting started

- [x] `overview` — What is Paperless-ngx: concepts (documents, tags,
  correspondents, document types, storage paths, custom fields, saved views).
  EN + AR.
- [x] `dashboard` — The dashboard and navigating the interface. EN + AR.

### 2. Documents (core lifecycle) — **done**

Delivered as nested pages under `docs/documents/`, English and Arabic, and listed
in `docs/guides.md`, `docs/index.md`, and the **Documents** group of the `nav` in
`zensical.toml`.

- [x] `documents/adding` — Uploading and consuming documents, supported file
  types, re-adding the same file, extra versions. EN + AR.
- [x] `documents/browsing` — Browsing, filtering, and searching; columns,
  sorting, keyboard shortcuts, saved views. EN + AR.
- [x] `documents/viewing` — Viewing a document: opening it, the tabs, the viewer,
  downloading, the **Actions** menu, versions, and the PDF editor. EN + AR.
- [x] `documents/editing` — Editing document details: the **Details** fields, the
  **Content** tab, suggestions, saving and discarding, keyboard shortcuts. EN + AR.
- [x] `documents/notes-history` — Notes and document history. EN + AR.
- [x] `documents/trash` — Deleting, restoring, emptying for good, and the
  automatic empty. EN + AR.
- [x] `documents/bulk` — Working with many documents at once: selection, bulk
  editing, permissions, reprocess/rotate/merge, sending, downloading, deleting.
  EN + AR.
- [x] `documents/sharing` — Sharing and permissions: owners, view and edit
  permissions, the permissions filter, share links, share link bundles, e-mail.
  EN + AR.

!!! note "Two deliveries read slightly differently from the original outline"

    - `documents/editing` was split out of `documents/viewing`, so the viewing
      page stays about looking at a document; the two pages link to each other.
    - `documents/sharing` also covers document **permissions**, because owners and
      view/edit permissions live in the same **Permissions** tab as share links.

### 3. Organizing (attributes) — **done**

Delivered as nested pages under `docs/attributes/`, English and Arabic, and
listed in `docs/guides.md`, `docs/index.md`, and the **Attributes** group of the
`nav` in `zensical.toml`.

- [x] `attributes/tags` — Tags (colors, hierarchy, matching, inbox tag). EN + AR.
- [x] `attributes/correspondents` — Correspondents. EN + AR.
- [x] `attributes/document-types` — Document types. EN + AR.
- [x] `attributes/storage-paths` — Storage paths (the **Path** pattern, its
  placeholders, and the **Preview** test). EN + AR.
- [x] `attributes/custom-fields` — Custom fields (data types, select options,
  default currency, filtering and search). EN + AR.

### 4. Automation — **done**

Delivered as pages at the root of `docs/`, English and Arabic, and listed in
`docs/guides.md`, `docs/index.md`, and the **Automation** group of the `nav` in
`zensical.toml`.

- [x] `saved-views` — Saved views (filters): the **Saved Views** page, the
  **Views** menu, **Save "…"**, **Save as...** / **Save current view**, layout
  and page-size settings, and how views are shared. EN + AR.
- [x] `workflows` — Workflows: the list, **Triggers** (types, filters, advanced
  filters, scheduled settings) and **Actions** (Assignment, Removal, Email,
  Webhook, Password removal, Move to trash). EN + AR.
- [x] `mail` — Mail: **Mail accounts** (including the connection test and the
  Gmail/Outlook sign-ins), **Mail rules** (criteria, consumption, action and
  metadata), **Processed Mail**. EN + AR.

### 5. Administration & monitoring

- [ ] `settings` — Application settings.
- [ ] `system-status` — System status, statistics, and monitoring.
- [ ] `logs` — Logs.
- [ ] `tasks` — Task monitoring.
- [ ] `backup` — Export and import (if applicable to the target audience).

### 6. Optional / advanced

- [ ] `ai` — AI features (chat and document suggestions).
- [ ] `barcodes-asn` — Barcodes and ASN (archive serial number).
- [ ] `consume-folder` — Document consumption (consume folder).

## Suggested order (phases)

1. **Foundation** — done; rename existing files.
2. **Core document lifecycle** — done (section 2 above).
3. **Organizing attributes** — done (section 3 above).
4. **Automation** — done (section 4 above).
5. **Administration & monitoring**.
6. **Optional / advanced**.

## Definition of done (per topic)

- [ ] English and Arabic files exist and mirror each other in structure.
- [ ] No technical details leaked (no code, paths, class names, env vars).
- [ ] Actual UI labels used throughout.
- [ ] A worked example is included where useful.
- [ ] Topic is linked from the documentation index.

### Verification log

Checked against the pages themselves and against the Angular templates in this
repository, so that every quoted label is a real label.

- **Section 2 — Documents (8 topics, 16 files):** EN and AR pages mirror each
  other heading for heading; no environment variables, file paths, or class
  names appear in any page; every button, tab, and dialog name was compared with
  the UI source; each page ends with **A quick example**; all links between
  pages resolve and the pages build with `zensical build --clean` without new
  warnings.
- **Section 3 — Attributes (5 topics, 10 files):** EN and AR pages mirror each
  other heading for heading. Every quoted label was verified against the Angular
  templates in this repository — the **Attributes** tabs, the shared management
  list (`Filter by:`, `Show:`, `Select:`, `Permissions`, `Delete`, `Create`,
  and the **Name** / **Matching** / **Document count** / **Actions** columns),
  the five edit dialogs (**Name**, **Color**, **Parent**, **Inbox tag**,
  **Matching algorithm**, **Matching pattern**, **Case insensitive**, **Path**
  with its **Preview** test, **Data type**, **Default Currency**,
  **Add option**), the custom fields list (**Add Field**, **No fields
  defined.**), and the document-side **Tags**, **Correspondent**,
  **Document type**, **Storage path**, and **Custom Fields** controls. The
  matching-algorithm names come from the application's own list (**Automatic**,
  **Any word**, **All words**, **Exact match**, **Regular expression**,
  **Fuzzy word**, **None**) and the custom-field data types from its data-type
  list. No environment variables, class names, or source paths appear; the
  storage-path **Path** placeholders are user-entered values, not server
  configuration. Each page ends with **A quick example**.
- **Section 4 — Automation (3 topics, 6 files):** EN and AR pages mirror each
  other heading for heading; each ends with **A quick example**; and the same
  no-leak rule holds — no environment variables, class names, or source paths,
  though **Views**, **Save as...**, and the trigger and action names are the
  application's own labels. Every quoted label was checked against the Angular
  templates: the **Saved Views** page (**Name**, **Show on dashboard**,
  **Show in sidebar**, **Documents page size**, **Display as** with **Table** /
  **Small Cards** / **Large Cards**, **Show** with its `Default` empty state,
  **Note: ordering is not preserved**, **Permissions**, **Delete**, **Cancel**,
  **Save**, **No saved views defined.**) and the documents-list **Views** menu
  (**Save "…"**, **Save as...**, **All saved views**, and the **Save current
  view** dialog with its **Filter rules error occurred while saving this view** /
  **The error returned was** alert); the **Workflows** page (**Name**,
  **Sort order**, **Status** with **Enabled** / **Disabled**, **Triggers**,
  **Actions**, **Add Workflow**, **Edit**, **Delete**, **Copy**, **No workflows
  defined.**, and the **Confirm delete workflow** dialog ending in **Proceed**)
  and its dialog (**Trigger type** — **Consumption Started**, **Document
  Added**, **Document Updated**, **Scheduled**; **Filter filename**, **Filter
  sources**, **Filter path**, **Filter mail rule**, **Content matching
  algorithm**, **Advanced Filters** with its thirteen tests, **Offset days**,
  **Relative to**, **Recurring**; **Action type** — **Assignment**, **Removal**,
  **Email**, **Webhook**, **Password removal**, **Move to trash** — with
  **Assign title**, **Assign tags**, **Remove all**, **Email subject**,
  **Webhook url**, **Passwords**); and **Mail Settings** (**Mail accounts** and
  **Mail rules** with their **Name** / **Server** / **Username**, **Sort
  Order** / **Account** / **Status** / **Processed Mail** columns, **Add
  Account**, **Connect Gmail Account**, **Connect Outlook Account**, **Add
  Rule**, **Process Mail**, **Test** with its two result messages, the account
  and rule dialogs including **Consumption scope**, **Attachment type**, **PDF
  layout**, **Action**, **Assign title from**, **Assign correspondent from**,
  **Stop further processing**, and the **Processed Mail** dialog with **Subject**
  / **Received** / **Processed** / **Status** / **Error**, **Clear**, **Delete
  selected**). The `{{…}}` values used in the workflow examples are placeholders
  the application itself offers for titles and messages, and the page says which
  of them work with every trigger type.

## Index / navigation

- [x] Created `docs/guides.md` as the documentation index: it lists every topic
  and links its English and Arabic pages. It is linked from `docs/index.md` and
  added to the `nav` in `zensical.toml` under **User Guides**.
- [x] Section 2 added a nested **Documents** group to the `nav`, holding
  `adding`, `browsing`, `viewing`, `editing`, `notes-history`, `bulk`, `trash`,
  and `sharing` in reading order, and matching rows to the English and Arabic
  tables of `docs/guides.md` plus the bullet list in `docs/index.md`.
- [x] Section 3 added a nested **Attributes** group to the `nav`, holding
  `tags`, `correspondents`, `document-types`, `storage-paths`, and
  `custom-fields` in reading order — the same order used by the **Attributes**
  tabs in the app — with matching rows in both tables of `docs/guides.md` and
  matching bullets in `docs/index.md`.
- [x] Section 4 added a nested **Automation** group to the `nav`, holding
  `saved-views`, `workflows`, and `mail` in reading order — the order of the
  **Manage** section of the sidebar, where the three pages live — with matching
  rows in both tables of `docs/guides.md` and matching bullets in
  `docs/index.md`.

