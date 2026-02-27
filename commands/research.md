---
name: forge:research
description: BMAD-style parallel research to validate technical approaches - AO-native
disable-model-invocation: true
---

# /forge:research

Validate brainstormed approaches through BMAD-style parallel research. AO-native only - no standalone mode, no prompts, file-based state.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/handoffs/brainstorm-to-research.md
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: research
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
---
```

---

## Phase Execution

### Step 1: Generate Research Document

Write exploration to `docs/forge/phases/research.md`:

```markdown
---
phase: research
generated_at: "<ISO-timestamp>"
objective: "<from brainstorm handoff>"
status: in_progress
---

# Research: [Objective]

## Context

### From Previous Phase
[Summary from brainstorm-to-research.md handoff]

### Selected Approach
[Option X - Name from brainstorm decision]

### Key Questions to Validate
[List from brainstorm handoff TODO list]

### Constraints Applied
[List relevant constraints from constraints.md]

## Context7 Research

### [Library/Technology 1]
**Query:** [What was asked]
**Version:** X.Y.Z
**Key Findings:**
- [Capability 1]
- [Capability 2]
- [Limitation discovered]

**Relevant Code Examples:**
```typescript
// Example from documentation
```

### [Library/Technology 2]
...

## Pattern Analysis

### Existing Patterns in Memory
| Pattern | Location | Applicability | Notes |
|---------|----------|---------------|-------|
| [Pattern 1] | `.claude/memory/patterns/...` | High/Medium/Low | [Why] |
| [Pattern 2] | `.claude/memory/patterns/...` | High/Medium/Low | [Why] |

### New Patterns Discovered
| Pattern | Source | Relevance |
|---------|--------|-----------|
| [Pattern] | [Context7/docs] | [How it applies] |

## Technical Validation

### Feasibility Assessment

| Criterion | Status | Evidence |
|-----------|--------|----------|
| Can be built | ✅/⚠️/❌ | [Evidence] |
| Scales to requirements | ✅/⚠️/❌ | [Evidence] |
| Integrates with existing | ✅/⚠️/❌ | [Evidence] |

### Performance Characteristics

| Metric | Expected | Acceptable | Notes |
|--------|----------|------------|-------|
| Latency | Xms | <Yms | [Evidence] |
| Throughput | X req/s | >Y req/s | [Evidence] |
| Memory | XMB | <YMB | [Evidence] |

### Security Implications

| Risk | Severity | Mitigation | Status |
|------|----------|------------|--------|
| [Risk 1] | High/Med/Low | [Mitigation] | ✅/⚠️/❌ |
| [Risk 2] | High/Med/Low | [Mitigation] | ✅/⚠️/❌ |

## Risk Assessment

### Validated Risks
| Risk | Probability | Impact | Validation Result |
|------|-------------|--------|-------------------|
| [Risk from brainstorm] | High/Med/Low | High/Med/Low | [Confirmed/Mitigated/Disproven] |

### New Risks Discovered
| Risk | Source | Mitigation |
|------|--------|------------|
| [New risk] | [Research finding] | [Approach] |

## Assumption Validation

| Assumption | From | Validated | Method | Result |
|------------|------|-----------|--------|--------|
| [Assumption 1] | brainstorm | Yes/No | [How tested] | [Result] |

## Recommendation

**Proceed with selected approach:** Yes/No/Modified

**Confidence Level:** High/Medium/Low

**Required Modifications:**
- [Modification 1 based on research]
- [Modification 2 based on research]

**Alternative if Primary Fails:**
[Fallback option from brainstorm]
```

### Step 2: Execute Research Tasks

Research angles to explore (all within single AO session):

```bash
# 1. Context7 Query - Check official documentation
# Query relevant libraries from selected approach

# 2. Pattern Search - Look for existing patterns in memory
ls .claude/memory/patterns/
cat .claude/memory/patterns/[relevant-pattern].json

# 3. Best Practice Validation - Verify against industry standards
# Research via web search if needed

# 4. Risk Assessment - Identify potential issues
# Cross-reference with risks.md

# 5. Document findings - Already written to phases/research.md
```

### Step 3: Update Risk Registry

Append new risks discovered to `docs/forge/knowledge/risks.md`:

```markdown
## R{phase}{number}: [Risk Title]

**Discovered in:** research phase
**Date:** YYYY-MM-DD

**Description:** [What could go wrong]

**Probability:** High/Medium/Low
**Impact:** High/Medium/Low

**Mitigation:** [How to address]

**Owner:** [Who monitors this]
```

---

## Phase Exit Protocol

### Step 1: Write Final Research Artifact

Write to `docs/forge/research.md`:

```markdown
---
phase: research
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
---

# Research: [Objective]

## Summary

**Selected Approach:** [From brainstorm]
**Validation Result:** ✅ VALIDATED / ⚠️ MODIFIED / ❌ BLOCKED
**Confidence:** High/Medium/Low
**Recommendation:** Proceed / Proceed with changes / Do not proceed

## Key Findings

### Technical Feasibility
[2-3 sentence summary of what research revealed]

### Performance
[Expected characteristics]

### Security
[Key security considerations]

## Risks Validated

| Risk | Original Assessment | Research Finding | Status |
|------|---------------------|------------------|--------|
| [Risk 1] | High concern | Mitigated by X | Resolved |
| [Risk 2] | Low concern | Confirmed | Accepted |

## Assumptions Validated

| Assumption | Status | Evidence |
|------------|--------|----------|
| [Assumption 1] | ✅ Valid | [Evidence] |
| [Assumption 2] | ⚠️ Modified | [Evidence] |

## Required Changes to Approach

1. [Change 1 with rationale]
2. [Change 2 with rationale]

## Research Sources

| Source | Query | Relevance |
|--------|-------|-----------|
| Context7: [Library] | [Query] | High/Med/Low |
| Memory: [Pattern] | [Pattern search] | High/Med/Low |
| Web: [Source] | [Query] | High/Med/Low |

## Full Research Document

See: `docs/forge/phases/research.md`
```

### Step 2: Write Handoff Document

Write to `docs/forge/handoffs/research-to-design.md`:

```markdown
---
from_phase: research
to_phase: design
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: research → design

## Summary

### What Was Done
Validated selected approach through Context7 queries, pattern analysis, and risk assessment.

### Key Outcomes
- Validation result: [Validated/Modified/Blocked]
- Confidence level: [High/Medium/Low]
- New risks identified: [N]
- Assumptions validated: [N]

## Validated Technical Approach

### Confirmed Viable
[Summary of validated approach]

### Required Modifications
- [Modification 1]
- [Modification 2]

### Performance Expectations
| Metric | Expected | Source |
|--------|----------|--------|
| | | |

## Design Constraints

| Constraint ID | Description | Source |
|---------------|-------------|--------|
| C-R1 | [From research finding] | research |

## Open Questions for Design

1. [ ] How to handle [specific technical detail]
2. [ ] Which [component/library] to use for [purpose]

## Risk Summary

| Risk Level | Count | Notes |
|------------|-------|-------|
| High | [N] | [Brief] |
| Medium | [N] | |
| Low | [N] | |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Research Detail | docs/forge/phases/research.md | Complete |
| Research Summary | docs/forge/research.md | Complete |
| Risk Updates | docs/forge/knowledge/risks.md | Updated |

## Reference Materials

- Phase output: `docs/forge/phases/research.md`
- Decisions: `docs/forge/knowledge/decisions.md`
- Risks: `docs/forge/knowledge/risks.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: research
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
next_phase: design
---
```

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] Context7 documentation queried for relevant libraries
- [x] Existing patterns from memory reviewed
- [x] Technical feasibility validated with evidence
- [x] Security implications assessed
- [x] Performance characteristics documented
- [x] Risks identified with mitigations
- [x] Assumptions validated or flagged
- [x] `docs/forge/phases/research.md` written
- [x] `docs/forge/research.md` written
- [x] `docs/forge/handoffs/research-to-design.md` written
- [x] Risks updated in `docs/forge/knowledge/risks.md`
- [x] `docs/forge/active-workflow.md` updated

---

## Next Phase

Auto-proceeds to: `/forge:design` (system design)

---

## Required Skill

**REQUIRED:** `@forge-research`

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── research.md                     # Final artifact
├── phases/
│   └── research.md                # Detailed research
├── handoffs/
│   ├── brainstorm-to-research.md  # Input (read)
│   └── research-to-design.md      # Output (write)
└── knowledge/
    ├── decisions.md               # Read on entry
    ├── constraints.md             # Read on entry
    └── risks.md                   # Updated with new risks
```
