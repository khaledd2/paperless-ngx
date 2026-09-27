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

### 5. Administration & monitoring — **done**

Delivered as nested pages under `docs/admin/`, English and Arabic, and listed in
`docs/guides.md`, `docs/index.md`, and the **Administration & Monitoring** group
of the `nav` in `zensical.toml`.

- [x] `settings` — Application settings: the page header (**Start tour**,
  **System Status**, **Open Django Admin**) and the four tabs **General**,
  **Documents**, **Permissions**, **Notifications**, with **Save** / **Cancel**.
  EN + AR.
- [x] `system-status` — System status and monitoring: the four cards
  **Environment**, **Database**, **Tasks Queue**, **Health**, the **Run Task**
  buttons, and **Copy**. EN + AR.
- [x] `logs` — Logs: the **paperless.log** / **mail.log** / **celery.log** tabs,
  **Show … lines**, **Auto refresh**, **Jump to bottom**, and how lines are
  marked **DEBUG** / **WARNING** / **ERROR** / **CRITICAL**. EN + AR.
- [x] `tasks` — Task monitoring: the sections **All**, **Needs attention**,
  **In progress**, **Recently completed**, the type and source filters, the
  **Name** / **Created** / **Results** / **Info** / **Actions** columns, the
  detail panels, and **Dismiss visible** / **Dismiss selected**. EN + AR.
- [x] `backup` — Export and import: what a complete backup must contain, the
  three ways to back up, the built-in exporter and importer, what is not a
  backup, and how a restore goes. It stays applicable to the target audience by
  describing the export and import tools in plain language as work done outside
  the web interface, with no commands. EN + AR.

### 6. Optional / advanced — **done**

Delivered as pages at the root of `docs/`, English and Arabic, and listed in
`docs/guides.md`, `docs/index.md`, and the **Optional & Advanced** group of the
`nav` in `zensical.toml`.

- [x] `ai` — AI features: the chat in the top bar (its button, the two prompts
  **Ask a question about a document...** and **Ask a question about this
  document...**, **Send**, the streamed answer and its document links), and the
  **Suggest** / **Show suggestions** flow in the document details, including
  **Tags** / **Document Types** / **Correspondents** / **No novel suggestions**.
  The AI index, the **AI Settings** cards on the **Configuration** page, and the
  privacy and cost warnings. EN + AR.
- [x] `barcodes-asn` — Barcodes and ASN: the archive serial number (where it
  appears, the **+1** button, the **ASN** column, filter target and sorting), the
  uniqueness rule and the blocked import it causes, reading a number from a
  barcode (prefix, retained page), separator barcodes and **Retain Split Pages**,
  tag barcodes and **Split on Tag Barcodes**, and the **Barcode Settings** cards.
  EN + AR.
- [x] `consume-folder` — Document consumption: the watched folder, the ways files
  reach it, the formats it accepts, the housekeeping files it ignores, subfolders
  and subfolders-as-tags, the four steps a file goes through, the duplicate rule,
  what a failed import looks like, healthy habits, and the administrator-side
  choices described in plain language. EN + AR.

## Suggested order (phases)

1. **Foundation** — done; rename existing files.
2. **Core document lifecycle** — done (section 2 above).
3. **Organizing attributes** — done (section 3 above).
4. **Automation** — done (section 4 above).
5. **Administration & monitoring** — done (section 5 above).
6. **Optional / advanced** — done (section 6 above).

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
- **Section 5 — Administration & monitoring (5 topics, 10 files):** EN and AR
  pages mirror each other heading for heading; each page ends with a quick
  example (or, for **backup**, **A quick example** after the worked restore
  discussion); and the same no-leak rule holds — no environment variables,
  class names, or source paths, no commands, and no code blocks. Every quoted
  label was checked against the Angular templates: the **Settings** page
  (**Start tour**, **System Status**, **Open Django Admin**, the **General** /
  **Documents** / **Permissions** / **Notifications** tabs with **Display
  language**, **Date display**, **Date format** — **Short** / **Medium** /
  **Long** — **Use 'slim' sidebar (icons only)**, **Use system settings**,
  **Enable dark mode**, **Invert thumbnails in dark mode**, **Theme Color** with
  **Reset**, **Global search** with **Do not include advanced search results**
  and **Full search links to** (**Title and content search** / **Advanced
  search**), **Update checking**, **Saved Views**, **Items per page**,
  **Document editing** with **Use PDF viewer provided by the browser**,
  **Default zoom** (**Fit width** / **Fit page**), **Automatically remove inbox
  tag(s) on save**, **Show document thumbnail during loading**, **Built-in
  fields to show**, **Bulk editing**, **PDF Editor** (**Create new document(s)**
  / **Add document version**), **Notes**, **Default Owner**, **Default View
  Permissions**, **Default Edit Permissions**, and the four **Document
  processing** notification switches); the **System Status** dialog
  (**Environment**, **Database**, **Tasks Queue**, **Health**, **Paperless-ngx
  Version**, **Install Type**, **Server OS**, **Media Storage**, **Migration
  Status** with **Up to date** / **Pending**, **Redis Status**, **Celery
  Status**, **Recent Task Activity** with **Total** / **Successful** / **Failed**
  / **Pending** and **No recent tasks**, **Search Index** with **Last Updated**,
  **Classifier** with **Last Trained**, **Sanity Checker** with **Last Run**,
  **WebSocket Connection**, **AI Index**, **Run Task**, and **Copy**); the
  **Logs** page (**Show** / **lines**, **Auto refresh**, **Jump to bottom**,
  **Loading...**, and the **paperless.log** / **mail.log** / **celery.log** tab
  names, which are the labels the app itself renders); and the **Tasks** page
  (**All**, **Needs attention**, **In progress**, **Recently completed**,
  **Filter by** with **All types** / **All sources** and the type and source
  lists, the **Name** / **Result** search target, **Reset filters**, **Auto
  refresh**, **Clear selection**, **Dismiss visible** / **Dismiss selected**,
  **Confirm Dismiss** with *Dismiss N tasks?*, **No tasks match the current
  filters.**, the **Name** / **Created** / **Results** / **Info** / **Actions**
  columns, **Open Document**, and the **Result message** / **Duplicate** /
  **Input data** / **Result data** detail panels). The **backup** page names its
  three storage areas and the export and import tools in plain language only —
  the tool names come from `docs/administration.md` (the *document exporter* and
  the *document importer*) and no command, path, or environment variable is
  reproduced, and the same-version rule, the missing API tokens, the
  incremental behaviour, the data-only variant, and the empty-installation
  requirement all come from that page. Both **Logs** and **Tasks** permission
  notes match the app: **Logs** is shown to administrators only, and **Tasks**
  is shown to anyone with view permission on tasks.
- **Section 6 — Optional / advanced (3 topics, 6 files):** EN and AR pages mirror
  each other heading for heading and each ends with **A quick example**; the
  no-leak rule holds — no environment variables, class names, source paths, or
  commands. Every quoted label was checked against the Angular templates and the
  development data file: the chat (**Send**, **Ask a question about a
  document...**, **Ask a question about this document...**, the **Error receiving
  response.** line, and the document links under an answer), the suggestions
  (**Suggest**, **Show suggestions**, **Tags**, **Document Types**,
  **Correspondents**, **No novel suggestions**, **Error retrieving
  suggestions.**), the document fields (**Archive serial number**, the **+1**
  button, the **ASN** column, **Sort by ASN**, and the **equals** / **is empty** /
  **is not empty** / **greater than** / **less than** ASN filter), the two
  administration tabs (**Barcode Settings**: **Enable Barcodes**, **Enable TIFF
  Support**, **Barcode String**, **Retain Split Pages**, **Enable ASN**, **ASN
  Prefix**, **Enable Tag Detection**, **Tag Mapping**, **Split on Tag Barcodes**,
  **Upscale**, **DPI**, **Max Pages**; **AI Settings**: **AI Enabled**, **LLM
  Backend**, **LLM Model**, **LLM API Key**, **LLM Endpoint**, **LLM Embedding
  Backend**, **LLM Embedding Model**), and the shared **Configuration** page
  frame (**Reset**, **Save**, **Cancel**, and the note about applying to every
  user). The barcode behaviour (split after the separator page, the retained page
  for ASN and tag barcodes, the `TAG:` pattern, the `ASN00123`-style prefix rule,
  and the uniqueness of an ASN, including against the **Trash**) comes from
  `docs/advanced_usage.md`, `docs/configuration.md`, and `docs/usage.md`; the
  consume-folder behaviour (the stability wait, the supported-format filter, the
  ignored housekeeping files, subfolders as tags, the removal of the file after a
  successful import, and the duplicate rule) comes from the consumer in
  `src/documents/` and those same pages. Neither page names a file path, a
  setting name as an environment variable, or a command: the consume folder's
  administrator section describes the choices in plain language only.

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
- [x] Section 5 added a nested **Administration & Monitoring** group to the
  `nav`, holding `settings`, `system-status`, `logs`, `tasks`, and `backup` in
  reading order, with matching rows in both tables of `docs/guides.md` and
  matching bullets in `docs/index.md`. The group is named **Administration &
  Monitoring** rather than **Administration** so that it does not read like the
  separate top-level **Administration** entry, which still holds
  `administration.md` and the migration guide.
- [x] Section 6 added an **Optional & Advanced** group to the `nav`, holding
  `ai`, `barcodes-asn`, and `consume-folder` in the order of the roadmap, with
  matching rows in both tables of `docs/guides.md` and matching bullets in
  `docs/index.md`. Smaller cross-links were added while doing so: the watched
  folder in `documents/adding`, the **Archive serial number** row in
  `documents/editing`, the AI assistant button in `dashboard`, and the **AI
  Index** row in `admin/system-status` now point at the new pages, in both
  languages.
