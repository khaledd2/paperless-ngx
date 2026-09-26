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

Follow the `paperless-docs` skill at `skills/paperless-docs/SKILL.md`:

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

- [x] **Authentication, users, groups & permissions** — EN + AR. Currently
  saved as `docs/permissions.md` and `docs/permissions.ar.md`; rename to
  `authentication.*` to match the wider scope.

### 1. Getting started

- [ ] `overview` — What is Paperless-ngx: concepts (documents, tags,
  correspondents, document types, storage paths, custom fields, saved views).
- [ ] `dashboard` — The dashboard and navigating the interface.

### 2. Documents (core lifecycle)

- [ ] `documents/adding` — Uploading and adding documents.
- [ ] `documents/browsing` — Browsing, filtering, and searching; saved views.
- [ ] `documents/viewing` — Viewing a document: preview, download, versions,
  metadata.
- [ ] `documents/editing` — Editing document metadata (tags, correspondent,
  document type, storage path, ASN, custom fields).
- [ ] `documents/notes-history` — Notes and document history.
- [ ] `documents/trash` — Deleting and restoring documents.
- [ ] `documents/bulk` — Bulk editing many documents at once.
- [ ] `documents/sharing` — Share links and share link bundles.

### 3. Organizing (attributes)

- [ ] `tags` — Tags (colors, hierarchy, matching).
- [ ] `correspondents` — Correspondents.
- [ ] `document-types` — Document types.
- [ ] `storage-paths` — Storage paths.
- [ ] `custom-fields` — Custom fields.

### 4. Automation

- [ ] `saved-views` — Saved views (filters).
- [ ] `workflows` — Workflows (triggers and actions).
- [ ] `mail` — Mail: accounts and rules.

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
2. **Core document lifecycle** — highest user value.
3. **Organizing attributes**.
4. **Automation**.
5. **Administration & monitoring**.
6. **Optional / advanced**.

## Definition of done (per topic)

- [ ] English and Arabic files exist and mirror each other in structure.
- [ ] No technical details leaked (no code, paths, class names, env vars).
- [ ] Actual UI labels used throughout.
- [ ] A worked example is included where useful.
- [ ] Topic is linked from the documentation index.

## Index / navigation

- Create a documentation index that lists every topic and links its English and
  Arabic pages (e.g. a dedicated section or `docs/index.md` update).
