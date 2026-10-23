---
name: code-guard
description: Enforces Test-Driven Development (Red-Green-Refactor), five-axis code review, and OWASP/LLM security hardening before any code ships. Use when implementing logic, fixing bugs, reviewing pull requests or diffs, auditing dependencies, or securing inputs, auth, and external integrations.
---

# Code Guard

Synthesizes three core engineering quality gates from Addy Osmani's `agent-skills`: `test-driven-development`, `code-review-and-quality`, and `security-and-hardening`. It ensures every code change is proven by tests, structurally sound across five review axes, and hardened against both classic web exploits and LLM-specific vulnerabilities.

## When to Use

- Implementing new features, modifying behavior, or fixing bugs (enforces the TDD Prove-It Pattern).
- Reviewing a pull request, local diff, or AI-generated code before merging (`/code-guard` or `/review`).
- Auditing authentication, user input handlers, file operations, dependencies, or AI/LLM integrations for security flaws.

## Core Workflow

### Gate 1: Test-Driven Development & The Prove-It Pattern

1. **Discover Repository Tooling First**: Inspect `package.json`, `pyproject.toml`, `Makefile`, `Cargo.toml`, or `go.mod` to identify the exact test runner before running commands.
2. **Execute the RED -> GREEN -> REFACTOR Loop**:
   - **RED**: Write a focused test that describes the desired behavior (or reproduces the reported bug). Run it and confirm it **fails**.
   - **GREEN**: Write the minimal implementation code required to make the failing test pass.
   - **REFACTOR**: Clean up duplication and naming while keeping the test suite green.
3. **Follow High-Signal Test Design**:
   - **Test State, Not Interactions**: Assert on final outputs and state rather than internal mock call sequences.
   - **DAMP Over DRY**: Keep each test self-contained and readable without tracing through complex shared helpers.
   - **Real Over Mocks**: Prefer real implementations or in-memory fakes over heavy mocking.

### Gate 2: Five-Axis Code Review & Change Sizing

Keep diffs small (`~100-300 lines`; split diffs approaching `1,000 lines` or files exceeding `1,000 total lines`). Evaluate every change across five axes:

1. **Correctness**: Matches spec requirements, handles null/boundary edge cases and error paths, and tests actually fail when conditions are inverted (mutation check).
2. **Readability & Simplicity**: Clear naming, flat control flow, zero dead code (`_unused`, commented-out blocks), and no bolted-on conditionals where a clean model/helper belongs.
3. **Architecture**: Respects module boundaries, avoids circular dependencies, keeps feature logic out of shared utilities, and reduces the number of concepts a reader must hold.
4. **Performance**: No N+1 queries, no unbounded loops or unpaginated list fetches, and no blocking sync I/O on hot paths.
5. **Dependency Discipline**: Prefer standard library over new packages. Upgrade one dependency per change, review the changelog and lockfile diff, and verify with a green test suite.

Label every review finding clearly by severity:

- **`Critical:`** Security vulnerability, data loss, or broken functionality (blocks merge).
- **`(no prefix)`** Required structural or correctness fix before merge.
- **`Optional:` / `Consider:`** Non-blocking improvement suggestion.
- **`Nit:`** Minor formatting or style polish.

### Gate 3: Threat Modeling & Security Hardening (STRIDE + OWASP + LLM)

Map trust boundaries before approving any code that touches external input, files, auth, or LLMs:

- **Input, Injection & XSS**: Validate schemas at system boundaries (Zod/Pydantic), parameterize 100% of database/shell queries, and encode outputs.
- **Auth, Sessions & Secrets**: Keep secrets strictly in environment variables (never in code, logs, or git history); use `httpOnly`, `secure`, `sameSite` cookies and shared-store rate limiting on auth endpoints.
- **SSRF & Destructive Paths**: Allowlist schemes/hosts and block private IP ranges (`127.0.0.1`, `169.254.169.254`, RFC1918) on server-side URL fetches. For file deletes/moves, resolve symlinks and verify allowlisted root, minimum depth, and ownership first.
- **AI / LLM Security (OWASP LLM Top 10)**: Treat model output as untrusted input (never pass directly to `eval`, SQL, shell, or `innerHTML`); isolate untrusted documents from system instructions; scope tool permissions and require confirmation for destructive actions.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "I will write the tests after the implementation works" | Post-hoc tests verify your implementation assumptions rather than the behavior contract. Write the failing test first. |
| "The tests pass, so the PR is ready to merge (`LGTM`)" | Passing tests do not catch leaked secrets, N+1 queries, architectural drift, or missing edge-case coverage. Walk all five axes. |
| "This is an internal script or prototype, security can wait" | Prototypes become production, and internal tools are prime lateral-movement targets. Enforce boundary checks from day one. |

## Verification

- [ ] New behavior or bug fix is backed by a test that failed before the change and passes now.
- [ ] All five review axes were evaluated and findings are labeled by severity (`Critical`, Required, `Optional`, `Nit`).
- [ ] No secrets exist in code/diffs, inputs are validated at boundaries, and lockfile changes are audited.
