---
name: critic-review
description: Subjects ideas, strategies, writing, and architectural decisions to adversarial red-team scrutiny to eliminate sycophancy and uncover hidden flaws. Use when the user asks to critique a proposal, stress-test a business plan, find logical gaps, or challenge a high-stakes technical decision before execution.
---

# Critic Review

Unifies the anti-sycophancy `/critic` workflow from Tom's Guide with Addy Osmani's 5-step `doubt-driven-development` adversarial loop (`CLAIM -> EXTRACT -> DOUBT -> RECONCILE -> STOP`). It replaces default AI agreeableness with rigorous, actionable scrutiny across both strategic writing and software architecture.

## When to Use

- The user wants honest, constructive criticism on an idea, pitch, article, business strategy, or system design.
- Stress-testing a project plan or technical architecture for hidden failure modes, unstated assumptions, or edge cases.
- About to commit to a high-stakes, irreversible decision (production deployment, database migration, security logic, or public launch).
- The user invokes `/critic-review` or asks "what is wrong with this approach?"

## Core Workflow

### Step 1: CLAIM - Surface the Core Hypothesis

Before critiquing, state the core thesis or decision being evaluated in 2-3 compact lines:

- **CLAIM**: What the proposal or artifact asserts will work and why.
- **STAKES**: What breaks or fails if this claim turns out to be wrong.

### Step 2: EXTRACT - Isolate the Artifact and Contract

Separate the actual artifact (the draft text, business plan, or code diff) from the author's persuasive backstory:

- Identify the **Contract**: The objective goals, constraints, audience needs, or system invariants the artifact must satisfy.
- Strip away self-justifying explanations so the artifact is evaluated purely on its merits against the contract.

### Step 3: DOUBT - Execute Adversarial Examination

Adopt the posture of a rigorous, independent reviewer biased to find failure modes rather than to validate. Do not open with generic praise or reassurance. Systematically hunt for:

1. **Unstated & Weak Assumptions**: What must be true in the real world for this to succeed, and where is the evidence missing?
2. **Logical Gaps & Contradictions**: Where does section B undermine section A, or where does the conclusion not follow from the premises?
3. **Edge Cases & Failure Modes**: What happens under unexpected input, budget cuts, competitor retaliation, or peak load?
4. **Hidden Coupling & Second-Order Effects**: What downstream process, team, or module will this inadvertently break?
5. **The Strongest Counter-Argument (Steelman Opposition)**: Articulate the single most compelling argument an intelligent skeptic or competitor would make against this position.

### Step 4: RECONCILE - Classify and Prioritize Findings

Do not invent artificial problems just to sound harsh. Evaluate every potential flaw against the actual text or code and classify findings in strict priority order:

| Severity Class | Definition | Required Action |
| :--- | :--- | :--- |
| **1. Critical Flaw** | Breaks the core goal, causes data/financial loss, or rests on a false premise | Must redesign or fix before proceeding; provide a concrete alternative. |
| **2. Actionable Gap** | Missing evidence, unhandled edge case, or weak argument that undermines credibility | Supply the missing proof, tighten the logic, or add the guardrail. |
| **3. Explicit Trade-off** | Real limitation where the cost of fixing exceeds the benefit | Document the trade-off transparently so stakeholders accept it knowingly. |
| **4. What Works (Anchor)** | Specific elements that are genuinely strong and should be preserved during revision | Keep intact so fixes do not break existing strengths. |

### Step 5: STOP - Bounded Iteration

- Present the prioritized critique along with concrete, actionable remedies for every Critical Flaw and Actionable Gap.
- Limit adversarial refinement loops to a maximum of 3 cycles. If fundamental issues remain after 3 iterations, recommend stepping back to re-scope the objective.

## Common Rationalizations

| Rationalization | Reality |
| :--- | :--- |
| "I should start with a paragraph of praise to be polite" | Performative praise buries critical warnings. Respect the user's time by leading directly with substantive findings. |
| "The idea looks mostly fine, so I will just suggest minor wording tweaks" | Nitpicking surface style while ignoring a broken underlying assumption is review theater. Check the core premises first. |
| "I need to find 20 issues to prove I am being thorough" | Padding a review with trivial noise dilutes real risks. Three high-conviction structural findings beat twenty cosmetic nits. |

## Verification

- [ ] Zero generic flattery or filler opening remarks were used.
- [ ] Unstated assumptions, logical gaps, and the strongest counter-argument were explicitly surfaced.
- [ ] Every criticism is paired with a specific, actionable remedy or alternative direction.
- [ ] Findings are categorized clearly so the user knows what is a blocker versus a trade-off.
