---
name: daily-brief
description: Synthesizes a structured morning executive briefing across Google Calendar, Gmail, Tasks, Keep, and Drive. Use when the user asks for a daily briefing, morning check-in, standup summary, schedule review, or meeting preparation across Google Workspace.
---

# Daily Brief

Merges the approval-first `spark-daily-brief` workflow from the Awesome Gemini Spark Skills library with the official Google Workspace CLI (`gws-workflow` `+standup-report` and `+meeting-prep`) patterns. It delivers a high-signal executive snapshot of the user's day without mutating any data unless explicitly asked.

## When to Use

- The user asks "what does my day look like?", "give me my morning brief", or invokes `/daily-brief`.
- Preparing for daily standup meetings (`+standup-report`) or reviewing upcoming meeting context (`+meeting-prep`).
- Identifying schedule conflicts, overdue tasks, and urgent unread messages at the start of a work session.

## Core Workflow

### Step 1: Parallel Multi-Source Discovery (Read-Only)

Query the user's connected Workspace sources concurrently for the current date (and the next 24 hours):

1. **Google Calendar**: Fetch all scheduled events, time windows, locations/Meet links, attendee lists, RSVP statuses, and attached documents.
2. **Gmail**: Search for unread threads from the last 24-48 hours, prioritizing direct messages from human senders, threads with action keywords (`urgent`, `approval`, `deadline`, `review`), and emails from today's meeting attendees.
3. **Google Tasks & Keep**: Retrieve open tasks due today or overdue, plus pinned action notes.
4. **Google Drive**: Check recently modified or shared documents linked to today's meetings or active tasks.

### Step 2: Triage and Cross-Reference Context

Connect signals across apps rather than dumping isolated lists:

- **Meeting Readiness**: Match today's calendar events with relevant Drive docs and recent email threads from the same participants.
- **Schedule Health**: Flag any overlapping events, back-to-back blocks without travel/buffer time, or unconfirmed RSVPs.
- **Priority Ranking**: Rank action items by deadline urgency and stakeholder impact.

### Step 3: Present the Executive Briefing

Format the output into four scannable sections with clickable links (`htmlLink`, `threadUrl`, `webViewLink`) on every referenced item:

1. **Schedule & Meeting Prep**: Compact chronological table or list of today's events with exact time windows, key attendees, attached doc links, and any conflict warnings.
2. **Priority Inbox Signals**: Top 3-5 unread emails requiring action today, showing sender, subject link, date, and a 1-sentence summary of what is needed.
3. **Critical Tasks & Deadlines**: Overdue and due-today tasks from Google Tasks/Keep.
4. **Recommended Top 3 Focus Actions**: The three highest-leverage actions to complete first, offering to draft replies or block focus time if approved.

## Approval Rules (Approval-First Design)

- **Low Approval (Auto-Run)**: Reading calendars, emails, tasks, notes, and Drive files to generate the briefing.
- **Medium Approval (Ask Before Executing)**: Creating draft emails, adding new tasks to Google Tasks, or creating tentative focus blocks on Calendar.
- **High Approval (Strict Confirmation Required)**: Sending emails, modifying existing meeting times with external attendees, declining invitations, or changing Drive file permissions.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "I will list all 40 unread newsletters in the morning brief" | Dumping promotional noise defeats the purpose of an executive brief. Filter strictly for human senders and actionable items. |
| "I will just list event titles without links or prep context" | Every calendar event, email thread, and Drive file must include its clickable Workspace link and relevant cross-app context. |

## Verification

- [ ] Calendar, Gmail, Tasks, and Drive were queried in parallel before synthesizing.
- [ ] Schedule conflicts and meeting prep documents are explicitly highlighted.
- [ ] Every mentioned email, event, and file includes a verified clickable Workspace URL.
- [ ] No mutating action (sending mail, editing events) was taken without explicit user confirmation.
