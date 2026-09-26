---
title: Sharing and Permissions
---

# Sharing and Permissions

There are three ways to give somebody else access to a document, and they are
good for different things:

| Way | Good for | Needs a Paperless-ngx account? |
| --- | --- | --- |
| Permissions on the document | Colleagues who use the same installation | Yes |
| **Share Links** | A public link anybody can open | No |
| **Email** | Sending a copy to somebody outside | No |

Whichever you use, remember that a **share link** and an e-mailed copy are just
files: once they are out, you cannot take them back. For an everyday overview of
sharing, see [Sharing documents from Paperless-ngx](../usage.md).

## Sharing with people who have an account

Open a document and choose the **Permissions** tab. The form has three parts:

- **Owner:** — the one person who owns the document. The owner's settings decide
  who may edit and delete it. A note under the field says that
  **Objects without an owner can be viewed and edited by all users**.
- **View** — the **Users:** and **Groups:** who may open the document.
- **Edit** — the **Users:** and **Groups:** who may change it, with a reminder
  that **Edit permissions also grant viewing permissions**.

Permissions are part of the document's own form, so you save them the same way as
any other change, with **Save** or `Ctrl` + `S`.

!!! note

    An important default: **Objects without an owner can be viewed and edited by
    all users.** If you never set an owner, everybody on the installation can see
    and change the document. Set an owner whenever a document is not meant for
    everyone.

### Finding your shared documents

The **Permissions** filter in the document list is the fastest way to see what is
going on:

- **All** — everything you may see.
- **My documents** — documents you own.
- **Shared with me** — documents owned by somebody else that you can open.
- **Shared by me** — documents you own that you have shared with others.
- **Unowned** — documents with no owner at all, which everybody can see.
- **Users** — pick one or more people to see what they have.
- **Hide unowned** — a switch that leaves ownerless documents out of the results.

You can also tick **Owner** and **Shared** under **Show** to see both facts beside
each document in the list.

## Public share links for one document

Open the document and choose **Actions → Share Links**. The **Share Links** dialog
lists every link that exists for this document; when there are none it says
**No existing links**.

Each link is shown as a ready-made address of the form
`{paperless-url}/share/{slug}`, with:

- A **Copy** button that puts the address on your clipboard and shows **Copied!**;
- A **Share** button, on devices that offer sharing to other apps;
- A **Delete** button for links you no longer want;
- A badge with the time left, such as “7 days”, when the link expires.

At the bottom you choose how the new link should behave:

| Setting | Options |
| --- | --- |
| **Share archive version** | On: the visitor downloads the archived copy. Off: the original file as you uploaded it |
| **Expires** | **1 day**, **7 days**, **30 days**, or **Never** |

Press **Create** to make the link; it appears in the list immediately.

Anyone who has the address can open the file without signing in, so treat a share
link like a password. Once a link expires or is deleted, visitors are sent to the
normal sign-in page instead.

!!! tip

    If your installation sits behind a reverse proxy with its own authentication,
    a share link may still ask for a password. Your administrator can create an
    exception for the `/share/` path — see
    [Sharing documents from Paperless-ngx](../usage.md).

## Share link bundles for a selection

To share several documents at once, select them in the document list and choose
**Send → Create a share link bundle**. Paperless-ngx builds a ZIP file in the
background and gives you one link for the whole archive.

The **Create share link bundle** dialog shows **Selected documents:** (with
**+ N more…** when the selection is long), plus **Expires** and **File version**
— **Share archive version (if available)**, or the original files. Press
**Create link**, and the dialog reports the **Slug**, the **Status**, and
eventually the **Size**.

To monitor or tidy up bundles, choose **Send → Manage share link bundles**. The
**Share link bundles** dialog lists them all with **Documents**, **Status**,
**Size**, **Created**, **Expires**, **File version**, and **Actions** — where you
can **Copy share link**, **Retry** a failed bundle, or
**Delete share link bundle**. It notes that **Status updates every few seconds
while bundles are being prepared**, and says
**No share link bundles currently exist.** when the list is empty.

Statuses run through **Pending**, **Processing**, **Ready**, and **Failed**. A
bundle is only worth sharing once it is **Ready**; if it ends up **Failed**,
**Retry** builds it again.

## E-mailing a document

If your administrator has configured sending, choose **Actions → Email** on a
document (or **Send → Email** for a selection) to open the **Email** dialog:

- **Email address(es)** — one or more recipients;
- **Subject** and **Message** — a subject line and any covering text;
- **Use archive version** — send the archived copy instead of the original file;
- **Send email** — sends the message, and a notification confirms **Email sent**.

The dialog warns that **Some email servers may reject messages with large
attachments.** If the send fails, the notification reports
**Error emailing document** so you can try again with fewer attachments or the
original file.

## A quick example

Nadia needs to send a supplier the delivery note, an invoice, and a signed
contract. She first opens each document, uses the **Permissions** tab to give her
colleague Rami **View** rights, and saves.

For the supplier she needs no account at all, so she selects the three documents
in the list, chooses **Send → Create a share link bundle**, sets **Expires** to
**30 days**, and clicks **Create link**. The dialog shows **Pending**, then
**Processing**, and finally **Ready**; she clicks **Copy share link** and pastes
it into her e-mail.

A month later she opens **Send → Manage share link bundles**, sees that the
bundle has expired, and clicks **Delete share link bundle** so that nothing is
left lying around.
