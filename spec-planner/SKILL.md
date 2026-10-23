---
name: spec-planner
description: Transforms vague goals into structured specifications (PRDs) and vertical-slice implementation plans with dependency graphs and verification checkpoints. Use when starting a new project or feature, clarifying ambiguous requirements, or breaking complex work into small, testable tasks before execution.
---

# Spec Planner

Unifies the strategic framing of Tom's Guide (`/strategy`) with Addy Osmani's `spec-driven-development` and `planning-and-task-breakdown` skills. It prevents agents from jumping prematurely into code or execution by enforcing a gated workflow: Scope Check -> Specify -> Plan -> Vertical Task Breakdown.

## When to Use

- Starting a new project, feature, multi-step workflow, or architectural change where no specification exists yet.
- Requirements are vague, incomplete, or span multiple subsystems/files.
- Breaking an approved specification or complex goal into ordered, verifiable tasks (`/spec-planner`, `/spec`, `/plan`, or `/strategy`).

## Core Workflow

### Phase 0: Capability Map (For Multi-Module Initiatives Only)

If a single request bundles several independently testable capabilities (e.g., auth + billing + notifications), propose a compact **Capability Map** table first (Module ID, Responsibility, Depends On, Build Order) with one-way dependencies and zero cycles before writing detailed specs.

### Phase 1: Specify (Surface Assumptions & Define the Contract)

1. **Surface Assumptions Explicitly**: Before drafting the spec, list what you are assuming (`ASSUMPTIONS: 1... 2...`) or ask concise clarifying questions if critical requirements are missing.
2. **Reframe Vague Goals into Measurable Criteria**: Translate abstract wishes (e.g., "make it fast") into testable targets (e.g., "LCP < 2.5s, API response < 300ms").
3. **Draft the 6-Point Specification**:
   - **Objective & Success Criteria**: What is being built, for whom, and exact testable conditions for "done".
   - **Tech Stack & Environment**: Languages, frameworks, and exact commands (`Build`, `Test`, `Lint`, `Dev`).
   - **Architecture & File Layout**: Where components, logic, and tests live.
   - **Code/Output Conventions**: One concrete example snippet demonstrating the expected pattern.
   - **Testing & Verification Strategy**: Unit, integration, and end-to-end verification methods.
   - **Three-Tier Boundaries**:
     - *Always do*: Run tests before commit, validate inputs, follow conventions.
     - *Ask first*: Schema changes, adding new dependencies, changing CI/permissions.
     - *Never do*: Commit secrets, delete failing tests, overwrite existing plans without asking.

*Gate*: If the user only asked for a spec, save it (e.g., `SPEC.md` or Google Doc) and pause for approval before starting implementation.

### Phase 2: Dependency Graph & Vertical Slicing

When breaking a spec or goal into an execution plan:

1. **Operate in Read-Only Mode First**: Inspect existing files and check whether an incomplete `tasks/plan.md` or `tasks/todo.md` already exists (never overwrite an active plan for different work without asking).
2. **Map the Dependency Graph Bottom-Up**: Identify foundational schemas/models first, then core logic/APIs, then UI/delivery layers.
3. **Slice Vertically, Never Horizontally**:
   - *Bad (Horizontal)*: Task 1: All DB tables -> Task 2: All APIs -> Task 3: All UI.
   - *Good (Vertical)*: Task 1: User registration end-to-end (schema + API + UI + test) -> Task 2: User login end-to-end.

### Phase 3: Atomic Tasks & Verification Checkpoints

Size every task to **Small (1-2 files)** or **Medium (3-5 files)**. If a task touches 8+ files or has "and" in the title, split it further:

```markdown
- [ ] **Task N: [Short imperative title]**
  - **Acceptance**: [Specific, testable outcomes]
  - **Verify**: [Exact test/build command or manual check]
  - **Dependencies**: [Prior task IDs or None]
  - **Files**: [Target file paths, max ~5 files]
```

Insert an explicit **Verification Checkpoint** after every 2-3 tasks requiring all tests and builds to pass before advancing.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "This is simple enough to figure out while coding" | Ten minutes of specification and vertical slicing prevents hours of tangled rework. |
| "I will write the spec after the code works" | Writing it after the fact is documentation, not specification. The value lies in catching ambiguity upfront. |

## Verification

- [ ] Implicit assumptions were surfaced and vague goals converted into testable success criteria.
- [ ] Three-tier boundaries (`Always` / `Ask First` / `Never`) are defined.
- [ ] Tasks are sliced vertically (<= 5 files per task) and ordered by dependency with explicit verification commands and checkpoints.
