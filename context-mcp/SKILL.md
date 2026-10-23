---
name: context-mcp
description: Optimizes agent context budgets (GEMINI.md, progressive disclosure, 75% trimming) and builds high-signal Model Context Protocol (MCP) servers in Python and TypeScript. Use when setting up project context files, fixing context degradation in long sessions, or building and testing MCP servers for external APIs.
---

# Context MCP

Unifies Addy Osmani's `context-engineering` skill with the `mcp-builder` specification from `awesome-llm-skills` and `agentic-awesome-skills`. It solves both halves of the agent context problem: curating what lives inside the context window and designing token-efficient MCP tools to fetch live external context on demand.

## When to Use

- Setting up `GEMINI.md`, `AGENTS.md`, or rules files for a new repository or workspace.
- Agent output quality is degrading mid-session due to context flooding, stale history, or lost-in-the-middle attention drift.
- Designing, implementing, or evaluating a custom Model Context Protocol (MCP) server in Python (`FastMCP`) or TypeScript (`@modelcontextprotocol/sdk`).

## Part 1: Context Engineering & Budget Management

### Step 1: Structure the 5-Level Context Hierarchy

Organize information from most persistent to most transient:

1. **Level 1 - Global/Project Rules (`GEMINI.md` / `AGENTS.md`)**: Keep under ~100-150 lines. Include only tech stack, exact build/test/lint commands, core naming conventions, and `Always / Ask First / Never` boundaries. Move specialized workflows into on-demand `SKILL.md` files.
2. **Level 2 - Feature Spec Excerpts**: Load only the spec section relevant to the active task, never a 5,000-line monolith.
3. **Level 3 - Target Source Files & 1 Canonical Example**: Read the files being modified plus one existing file that demonstrates the project's idiomatic pattern. Aim for `<2,000 lines` of focused code context per task.
4. **Level 4 - Focused Error/Test Output**: Feed only the failing stack trace or assertion, not 500 lines of passing logs.
5. **Level 5 - Active Working Memory**: Position the active task definition and current error at the **very end** of the prompt window to avoid the *lost-in-the-middle* effect.

### Step 2: Trim Proactively at the 75% Capacity Threshold

Do not wait until the context window hits 100%:

- **Compress Before Dropping**: Summarize resolved debugging dead-ends and long tool outputs into a single 1-sentence conclusion breadcrumb (`"Resolved circular import in db.ts by moving shared types to types/index.ts"`).
- **Protected Context**: Never trim the original task goal, active hard constraints, or the file currently being edited.
- **Restartable Session Handoff**: When switching major features, persist task status, modified files, and verification commands to `tasks/plan.md` or `tasks/todo.md` before starting a fresh session.

## Part 2: Building Token-Efficient MCP Servers

When extending Gemini with custom external tools via MCP:

### Step 1: Design for Agent Workflows, Not Raw API Endpoints

1. **Consolidate Multi-Step Operations**: Build high-leverage workflow tools (e.g., `schedule_event_with_conflict_check`) rather than 1-to-1 wrappers around low-level REST endpoints.
2. **Protect the Agent's Context Budget**:
   - Support a `response_format` parameter (`"concise"` vs `"detailed"`, defaulting to Markdown or compact JSON).
   - Enforce a strict character/token truncation ceiling (e.g., `CHARACTER_LIMIT = 25000`) with clear pagination metadata (`next_cursor`, `has_more`).
   - Return human-readable names alongside opaque IDs.
3. **Write Educational Error Messages**: When a call fails, return actionable recovery guidance (e.g., `"Rate limit exceeded or payload too large; retry with filter='active' and limit=20"`).

### Step 2: Implement with Strict Schemas & Tool Annotations

- **Python (`FastMCP`)**: Use Pydantic v2 models (`model_config = ConfigDict(extra="forbid")`), `async/await` I/O, and `@mcp.tool()` decorators.
- **TypeScript (`@modelcontextprotocol/sdk`)**: Use `server.registerTool` with `.strict()` Zod schemas and strict TypeScript types (zero `any`).
- **Mandatory Annotations**: Attach `readOnlyHint`, `destructiveHint`, `idempotentHint`, and `openWorldHint` to every registered tool so Gemini knows when to prompt the user for confirmation.

### Step 3: Safe Testing & Evaluation Harness

- Never run a stdio MCP server bare in the main foreground shell (it waits on stdin indefinitely and hangs). Validate syntax (`python -m py_compile` or `npm run build`), run with `timeout 5s`, or test via the MCP inspector/evaluation harness.
- Register in Gemini CLI via `gemini mcp add <name> --command "<cmd>"` or `.gemini/settings.json`.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "The model has a 1M token window, so I will dump the whole repo and raw API JSON into context" | Context capacity is not attention budget. Flooding the window degrades reasoning accuracy and triples token spend. |
| "I will wrap every REST endpoint 1-to-1 as an MCP tool" | Granular CRUD endpoints force the agent to make 10 sequential tool calls. Consolidate into workflow-level tools. |

## Verification

- [ ] Project rules (`GEMINI.md`) are concise and separated from on-demand `SKILL.md` workflows.
- [ ] Long session history is compressed at 75% capacity while keeping active task constraints at the end of the window.
- [ ] Custom MCP tools validate inputs with Zod/Pydantic, cap output length, include `readOnlyHint`/`destructiveHint` annotations, and provide actionable error messages.
