---
name: paperless-docs
description: Create user-oriented, bilingual (English + Arabic) Markdown documentation for Paperless-ngx features and subsystems. Use when the user asks to document, explain, or write a guide about how a part of the system works (authentication, permissions, workflows, mail, etc.) for end users and administrators — not for developers.
---

# Paperless User Documentation

## Purpose

Produce clean, plain-language, end-user documentation for Paperless-ngx
features and subsystems, in **two separate files**: English and Arabic.

## When to use

Use this skill when asked to document, explain, or write guides about how the
system works for everyday users or the person managing the system — for example
authentication, users, groups, permissions, workflows, mail rules, saved views,
custom fields, etc.

## Output conventions

- Create **two separate files** with identical structure:

  | File | Language |
  | --- | --- |
  | `docs/<topic>.md` | English |
  | `docs/<topic>.ar.md` | Arabic |

- Keep the same section headings and order in both languages so they are easy
  to maintain side by side.
- Use the project's mkdocs-material conventions already present in `docs/`:
  - YAML front-matter with a `title`:
    ```markdown
    ---
    title: Understanding Authentication, Users, Groups & Permissions
    ---
    ```
  - Admonitions: `!!! note`, `!!! warning`, `!!! danger`.
  - Tables and nested lists.
- Use an H1 (`#`) for the title and `##` / `###` for sections.

## Style rules — user-oriented, not technical

Write for a **non-developer**. Translate implementation details into behavior
and plain language.

**Never include** (these leak implementation details):

- Source file paths (`src/documents/permissions.py`)
- Class, function, or model names (`UserViewSet`, `PaperlessObjectPermissions`)
- Code blocks, SQL, or HTTP verbs
- Environment-variable names (`PAPERLESS_ACCOUNT_ALLOW_SIGNUPS`)
- Framework/library names (`django-guardian`, `django-allauth`)

**Always use** the app's own interface labels. Find the real labels by reading
the Angular edit-dialog templates, e.g.
`src-ui/src/app/components/common/edit-dialog/**/*.component.html`. Known labels
include: `Active`, `Admin`, `Superuser`, `Groups`, `Permissions`,
`Two-factor authentication`, `Username`, `Email`, `Password`, `First name`,
`Last name`.

## Standard document structure

For a "whole subsystem" guide, use two parts:

1. **How people use / interact with it** (e.g. signing in): the available
   options, common flows, and any administrator-only choices.
2. **How access/behavior is decided** (e.g. permissions): the types, the
   per-item settings, the rules in plain language, and where to manage them.

End with a **short worked example** (a realistic scenario with a few named
people showing the outcome).

## Research process

Before writing:

1. Find the relevant backend models, views, and serialisers to understand what
   the feature does.
2. Read the frontend edit-dialog templates to learn the **exact labels** users
   see.
3. Read the relevant section of `docs/configuration.md` or `docs/api.md` to
   capture any admin-facing options (then rephrase them in plain language).
4. Write the English file first, then translate it into Arabic.

## Arabic language conventions

- Use Modern Standard Arabic (فصحى) suitable for technical documentation.
- Keep technical identifiers and UI labels in **English**, with the Arabic
  gloss in parentheses, e.g. `مدير (Admin)`, `عرض (View)`, `مالك (owner)`.
- Keep the meaning and structure identical to the English version.
- Use Arabic punctuation naturally; do not mirror-translate English idioms
  word-for-word.

## Quality checklist

- [ ] Two files exist: `docs/<topic>.md` and `docs/<topic>.ar.md`.
- [ ] Both have the same section order.
- [ ] No file paths, class names, code, SQL, or env-var names appear.
- [ ] All UI terms match the actual labels in the edit-dialog templates.
- [ ] Admonitions and tables render correctly (blank lines around them).
- [ ] A worked example is included.
- [ ] No leftover placeholder markers (e.g. `<!-- CONTINUE -->`).
