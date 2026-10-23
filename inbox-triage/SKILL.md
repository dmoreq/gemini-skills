---
name: inbox-triage
description: Triages Gmail threads, extracts prioritized action items into Google Tasks, and prepares context-grounded draft replies with strict approval gates. Use when the user asks to clean up their inbox, summarize unread emails, turn emails into tasks, or draft replies across Gmail and Google Workspace.
---

# Inbox Triage

Synthesizes the `spark-gmail-command-center` workflow from the Awesome Gemini Spark Skills library with the official Google Workspace CLI (`gws-gmail` `+triage`, `+reply`, and `gws-workflow` `+email-to-task`) standards. It transforms a cluttered inbox into prioritized decisions, tracked tasks, and ready-to-send drafts while keeping final send authority strictly with the user.

## When to Use

- The user asks to triage, summarize, or prioritize unread emails in Gmail.
- Extracting action items, deadlines, or follow-ups from email threads into Google Tasks (`+email-to-task`).
- Drafting context-aware replies to clients, teammates, or stakeholders using supporting documents from Google Drive.
- The user invokes `/inbox-triage` or asks "what emails do I need to reply to?"

## Core Workflow

### Step 1: Discover and Read Full Primary Threads

1. Search Gmail threads matching the requested time window, label, or query (`is:unread`, specific senders, or keywords).
2. **Never extrapolate from snippets alone**: Call the full thread/message retrieval tool on every candidate thread to inspect the complete chronological conversation, sender addresses, CC list, and attachments before summarizing or drafting.

### Step 2: Classify by Action Priority

Group threads into three actionable buckets (excluding automated marketing/newsletters unless requested):

| Bucket | Criteria | Default Action |
| :--- | :--- | :--- |
| **1. Needs Reply Today** | Direct questions, blockers, client requests, or time-sensitive approvals | Summarize context; prepare a draft only if requested or approved. |
| **2. Action / Task Extraction** | Assigned deliverables, invoices to pay, or documents to review by a specific date | Extract task title, due date, and source `threadUrl` for Google Tasks. |
| **3. FYI / Monitor** | Status updates, CC'd threads where someone else owns the next step, or resolved items | Summarize in 1 bullet per thread; no draft needed. |

### Step 3: Ground Replies in Workspace Context

Before creating a draft reply for Bucket 1 items:

- If the email asks about schedule availability, check Google Calendar first and propose exact, conflict-free time slots.
- If the email references a project document, spreadsheet, or report, locate and read the file in Google Drive to pre-fill accurate figures and links.
- Write the draft in natural, concise paragraphs matching the user's tone and language, with zero bracketed placeholders like `[Insert Date]`.

### Step 4: Execute Safe Drafts & Present Triage Table

- Create email drafts (`gmail:create_draft`) only when the user asks for drafts or approves them; otherwise present proposed reply text in chat. Never send unless the user explicitly instructed a specific send.
- Create Google Tasks only when the user asks for task creation or approves it; otherwise list proposed action items.
- Present a compact summary table containing Sender, Subject (linked via `threadUrl`), Date, Priority Bucket, and Action Taken (e.g., No write, Draft created, or Task added).

## Approval Rules (Approval-First Design)

- **Read-only by default**: Searching and reading email threads, checking Calendar availability, reading reference Drive files, and presenting proposed replies or tasks.
- **Ask or follow an explicit request before writing**: Saving draft replies in Gmail and creating action items in Google Tasks.
- **Explicit authorization for each sensitive action**: Sending emails (`send_message`, `reply`, `forward`), moving threads to Trash/Spam, or modifying email filters.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "The search snippet shows enough to summarize the email" | Snippets omit replies, attachments, and resolved questions later in the thread. Always read the full thread first. |
| "I will leave `[Insert Time]` in the draft for the user to fill in" | Leaving placeholders creates extra work when you already have tools to check Calendar and Drive context directly. |

## Verification

- [ ] Full email threads were read before summarizing or drafting.
- [ ] Every referenced email includes Sender, Subject, Date, and a clickable `threadUrl`.
- [ ] Draft replies contain concrete, context-grounded details with no bracketed placeholders.
- [ ] Sensitive actions (sending mail or trashing threads) were gated behind explicit user authorization; drafts and tasks were created only when requested or approved.
