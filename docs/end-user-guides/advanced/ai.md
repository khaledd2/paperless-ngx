---
title: AI Features
---

# AI Features

Paperless-ngx can borrow a *large language model* — the kind of AI behind modern
chat assistants — to help you work with your archive. Two things use it:

- **the chat**, a button in the top bar that answers questions about your
  documents in plain language;
- **AI suggestions**, which propose a title, tags, a correspondent, and a
  document type for a document you are filing.

Both are optional, and both stay away until an administrator turns them on.
Nothing about your day-to-day work changes while they are off.

!!! warning "Your documents leave the server"

    While the AI features are on, the text of the documents involved is sent to
    the AI provider your installation is set up to use. That provider may be a
    model running on your own server, but it is often a hosted, paid service on
    the internet. Treat the AI features the way you would treat uploading the
    documents to that provider yourself, and ask your administrator which
    provider is in use.

## The chat in the top bar

When the AI features are on, a chat-shaped button appears in the top bar, just
left of the **Notifications** bell. It is there on every page of the app.

1. Click the button. A small panel opens holding the conversation so far and a
   text box.
2. Type a question and press `Enter`, or click **Send**.
3. The answer is written out as it is produced, with a blinking cursor at the
   end while the assistant is still typing, so you can read along instead of
   waiting.
4. Beneath an answer, the documents the assistant used are listed as links.
   Clicking one opens it, so you can check the answer against the original.

The box waits for one answer at a time: it is disabled until the answer being
written has finished.

### One document, or all of them

The chat follows the page you are on, and the text box tells you which it is:

| Where you are | What the box says | What the chat answers from |
| --- | --- | --- |
| The documents list, the dashboard, or anywhere else | **Ask a question about a document...** | Every document you are allowed to view |
| A single document is open | **Ask a question about this document...** | That document only |

The conversation already on screen stays as it is when you move around; the
questions you ask from a document belong to that document.

!!! note

    The chat can only read what you can read. Answers about the whole archive are
    built from documents you have permission to view, and asking about one
    document requires permission to view that document. If you cannot see a
    document in the app, the chat will not show it to you either.

If an answer cannot be produced, the panel shows **Error receiving response.**
Try the question again, and tell your administrator if it keeps happening.

## AI suggestions while you file a document

Suggestions themselves are not new. A Paperless-ngx installation has always been
able to propose a title, tags, a correspondent, a document type, and a date by
learning from the way you have filed your existing documents. The AI features add
a second engine for the same job, which reads the document's own text instead of
comparing it with your past filings. You do not have to choose between them: the
button behaves the same way either way, and what changes is only where the answer
comes from.

Open a document and look at the buttons above the form on the **Details** tab:

- **Suggest** asks for suggestions. The number on the button is how many were
  found, and a small spinner replaces the label while the answer is on its way.
- The arrow beside it opens the list, described as **Show suggestions**. The
  results are grouped under **Tags**, **Document Types**, and **Correspondents**:
  click a suggestion to apply it. Anything already on the document is left out,
  and when there is nothing new the menu says **No novel suggestions**.

Nothing is stored until you press **Save**, so a suggestion you do not like costs
nothing — ignore it, or press **Discard**.

!!! tip

    A freshly imported document that still carries an inbox tag has its
    suggestions fetched for you, so the count is often already there by the time
    you open it. See [Editing Document Details](../documents/editing.md) for the
    rest of that form.

If suggestions cannot be retrieved, the app reports **Error retrieving
suggestions.** Nothing is lost; simply try again, or fill the fields in by hand.

## The index that makes answers good

An assistant can only answer from what it has been given. Alongside the AI
features, an installation can build an index of the text and details of every
document and keep it up to date. When answering, the chat looks up the most
relevant passages first, which usually makes its answers shorter and far more
trustworthy than handing it a single document.

The index is refreshed on a schedule, normally once a day. Administrators can
watch it on the [System Status](../administration/system-status.md) page, where it appears as
**AI Index** with its **Last Run** time, and can press **Run Task** to build it
again straight away — for example after importing a large batch of documents.

## Turning the AI features on and off

Administrators manage this on the **Configuration** page, under
**Administration** in the sidebar. The page explains that its options apply to
**every** user of the installation, and that the value chosen there takes
precedence over settings made elsewhere.

The **AI Settings** tab holds these cards:

| Card | What it decides |
| --- | --- |
| **AI Enabled** | The master switch. Until it is on, the chat button does not appear for anyone and suggestions come from the ordinary classifier. |
| **LLM Backend** | Which kind of AI is used: a hosted service that follows the common OpenAI style, or a model running on your own machine. |
| **LLM Model** | Which model answers — for example a larger one for better answers, or a smaller one for speed and lower cost. |
| **LLM API Key** | The credential used to reach a hosted provider. |
| **LLM Endpoint** | The web address of the provider, or of the model running on your own machine. |
| **LLM Embedding Backend** | Which kind of model turns document text into the index described above. |
| **LLM Embedding Model** | The model used for that index. |

Each card carries an information button that opens the online documentation for
that setting, and **Reset** to put it back to its default. Changes are kept only
when you press **Save**; **Cancel** leaves everything as it was. The **AI
Enabled** card carries the reminder that enabling AI has privacy consequences,
especially with a model that runs somewhere else.

!!! warning

    A hosted AI provider is usually a paid service. What it charges your account,
    and the terms on which it handles what you send, are outside Paperless-ngx.
    Every question and every document handed to it is subject to those terms.

## A quick example

Layla is asked what her electricity provider charged over the last two years. She
does not want to open six bills one by one, so she stays on the documents list
and opens the chat.

The box says **Ask a question about a document...**, a reminder that the whole
archive is within reach. She types *"How much did we pay the electricity company
each year since 2025?"* and reads the answer as it streams in. Two document
titles appear underneath it; she clicks the older one and checks the figure
against the bill itself.

Later she opens a freshly scanned invoice and presses **Suggest**. The menu
proposes the correspondent “Northwind Energy” and the tag “Invoice”, and she
applies both with two clicks before saving. She never has to know which engine
produced them — the classifier or the AI — because from her side the button works
the same way.

If the answers had been vague, she would have told her administrator, who can
check the **AI Index** on the [System Status](../administration/system-status.md) page and
press **Run Task** to rebuild it.
