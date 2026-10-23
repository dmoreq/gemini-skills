---
name: doc-writer
description: Authors structured Google Docs (SOPs, reports, proposals, guides) and refines prose to be clear, tight, and natural without AI cliches. Use when the user asks to write or format a document, create an SOP or report in Google Docs, or rewrite and polish existing text while preserving the author's voice.
---

# Doc Writer

Combines the structured document generation workflow of `spark-docs-generator` and `googleworkspace/cli` (`gws-docs`) with the editorial tightening rules of Tom's Guide (`/rewrite`). It produces publication-ready Google Docs and polished prose free from robotic buzzwords.

## When to Use

- Creating structured documents in Google Docs: Standard Operating Procedures (SOPs), executive reports, project proposals, meeting summaries, or study guides.
- Rewriting, tightening, or adjusting the tone of an existing draft, email, or article (`/doc-writer` or `/rewrite`).
- Stacking with `deep-research` or `spec-planner` to turn raw findings into a formatted deliverable.

## Core Workflow

### Phase 1: Determine Mode (New Document vs. Editorial Rewrite)

1. **Mode A - Structured Document Creation**: When asked to create a report, SOP, guide, or proposal, prefer creating a native Google Doc (create an empty file first, then populate via the Docs tool/agent) unless the user requests a local file or inline text.
2. **Mode B - Editorial Tightening (`/rewrite`)**: When given existing text to improve, refine it directly while strictly preserving the author's original meaning, personality, and factual claims.

### Phase 2: Apply Structural Architecture (For Mode A)

Match the document template to the requested deliverable type:

| Deliverable Type | Required Structural Elements |
| :--- | :--- |
| **SOP / Playbook** | Purpose & Trigger, Prerequisites/Tools, Numbered Step-by-Step Procedure, Exception Handling, Verification Checklist |
| **Executive Report** | Title, Executive Summary, Thematic Analysis with Markdown Comparison Tables, Strategic Recommendations, Inline Citations & References |
| **Proposal / Brief** | Problem Statement, Proposed Solution, Scope & Deliverables Table, Timeline/Milestones, Risks & Next Steps |

### Phase 3: Enforce Editorial Quality & Anti-Cliche Rules (Both Modes)

Apply these strict writing standards to every paragraph:

1. **Preserve Voice and Meaning**: In rewrites, remove repetition, awkward phrasing, and filler words without making the writing sound sterile or overly formal. Never invent facts or claims not present in the source material.
2. **Ban Corporate & AI Buzzwords**: Never use empty superlatives or cliches such as *"synergistic"*, *"paradigm"*, *"holistic"*, *"actionable insights"*, *"multifaceted"*, *"delve"*, *"tapestry"*, *"undisputed gold standard"*, *"flawlessly"*, or *"100% correct"*. Let concrete nouns and active verbs do the work.
3. **Format for Scannability**:
   - Use clean hierarchy (`# Title`, `## Section`, `### Sub-section`) with plain text headers.
   - Prefer compact Markdown tables over repetitive bullet lists when comparing options or presenting multi-attribute data.
   - Keep bullet lists grammatically parallel (start every item in a list with the same grammatical form).
   - Embed verified clickable inline links `[Source](URL)` on entities and claims.

### Phase 4: Deliver Cleanly Without Chat Dumping

- When the deliverable is saved to a Google Doc, lead the chat response with the clickable link `[Document Title](URL)` and a concise executive summary of key takeaways. Never dump the entire multi-page document verbatim into the chat window unless explicitly requested.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "I will make the user's casual email sound like a legal contract to be professional" | Over-formalizing destroys the author's voice. Match the formality of the original intent. |
| "I will paste the entire 10-page Google Doc into the chat reply too" | Repeating full file contents in chat floods the user's screen. Share the clickable link and a concise summary. |

## Verification

- [ ] All AI buzzwords and self-congratulatory superlatives are eliminated.
- [ ] Original meaning and factual accuracy are 100% preserved (no fabricated details).
- [ ] Tables and parallel lists are properly formatted, and all external facts carry inline links.
- [ ] If a Google Doc was created, its clickable link is placed in the opening sentence of the response.
