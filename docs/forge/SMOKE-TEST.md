# FORGE-AO Smoke Test

**Version:** 2.0.0
**Purpose:** Verify AO-native FORGE functionality through three core test scenarios

---

## Prerequisites

- AO environment with `AO_SESSION` set
- FORGE plugin installed: `/forge:start` available
- Empty or test workspace (do not run on production code)

---

## Test 1: Phase Progression

**Objective:** Verify init → brainstorm with debate → research progression

### Steps

#### 1.1 Initialize FORGE

```bash
/forge:start "Test feature for smoke testing"
```

**Expected Output:**
```
FORGE Initialization Complete
Project type detected: [detected type]
Configuration created: .claude/forge/config.json

Next: /forge:brainstorm
```

**Verify Files Created:**
- [ ] `.claude/forge/config.json` exists
- [ ] `.claude/forge/active-workflow.md` exists with phase: "init"
- [ ] `docs/forge/knowledge/brief.md` created

#### 1.2 Start Brainstorm Phase

```bash
/forge:brainstorm
```

**Expected Output:**
```
Brainstorm Phase Started
Generating options...
Creating debate plan...

Debate ID: brainstorm-20260127-143022
Location: docs/forge/debate/brainstorm-20260127-143022/
```

**Verify Files Created:**
- [ ] `docs/forge/brainstorm-options.md` (3+ approaches documented)
- [ ] `docs/forge/debate/brainstorm-<id>/debate-plan.md` exists
- [ ] `.claude/forge/active-workflow.md` updated:
  - phase: "brainstorm"
  - phase_status: "in_progress"
  - debate_status: "pending"
  - debate_id: "brainstorm-<timestamp>"

#### 1.3 Verify Debate Plan Contents

Read `docs/forge/debate/brainstorm-<id>/debate-plan.md`:

**Required Sections:**
- [ ] YAML frontmatter with debate_id, phase, objective, status
- [ ] Options Under Consideration (3+ options)
- [ ] Role Prompts (Advocate, Skeptic, Operator, Synthesizer)
- [ ] Expected Outputs list
- [ ] Completion Criteria

**Expected AO Commands Output:**
```markdown
## AO Debate Execution Plan

Execute via AO:
```bash
ao spawn <project> "FORGE: Write advocate.md for debate <id>"
ao spawn <project> "FORGE: Write skeptic.md for debate <id>"
ao spawn <project> "FORGE: Write operator.md for debate <id>"
ao spawn <project> "FORGE: Write synthesis.md for debate <id>"
```
```

#### 1.4 Check Debate Status

```bash
/forge:debate --status --id brainstorm-<id>
```

**Expected Output (Before Completion):**
```
## Debate Status: brainstorm-<id>

**Phase:** brainstorm
**Status:** INCOMPLETE

### Artifacts
| File | Status |
|------|--------|
| debate-plan.md | ✓ Complete |
| advocate.md | ⏳ Pending |
| skeptic.md | ⏳ Pending |
| operator.md | ⏳ Pending |
| synthesis.md | ⏳ Pending |

### Gate Status
**BLOCKED** - 1/5 artifacts complete
```

#### 1.5 Simulate Debate Completion

Manually create debate role files (simulating AO-spawned sessions):

```bash
# Create advocate.md
cat > docs/forge/debate/brainstorm-<id>/advocate.md << 'EOF'
# Advocate Position

## Core Argument
Option A provides the best balance of simplicity and capability for our requirements.

## Key Strengths
- Low complexity
- Proven approach
- Easy to maintain

## Comparative Advantages
Vs Option B: Lower resource requirements
Vs Option C: Better understood by team

## Success Criteria
- Implementation under 2 weeks
- Test coverage >80%
- No performance regressions

## Risk Acceptance
- Scaling limitations acceptable for MVP
EOF

# Create skeptic.md
cat > docs/forge/debate/brainstorm-<id>/skeptic.md << 'EOF'
# Skeptic Analysis

## Critical Questions
1. What happens at 10x scale?
2. How do we handle edge cases?
3. What's the migration path?

## Hidden Assumptions
- Team familiarity with approach
- Current infrastructure supports it

## Failure Modes
- Performance degradation under load
- Technical debt accumulation

## Risk Analysis
| Risk | Probability | Impact | Score |
|------|-------------|--------|-------|
| Scaling issues | Medium | High | 6 |
| Maintenance burden | Low | Medium | 2 |
EOF

# Create operator.md
cat > docs/forge/debate/brainstorm-<id>/operator.md << 'EOF'
# Operator Assessment

## Resource Requirements
- 2 developers
- 2 weeks
- Standard tooling

## Timeline Reality Check
- Optimistic: 1.5 weeks
- Realistic: 2 weeks
- Pessimistic: 3 weeks

## Dependency Analysis
- No external dependencies
- Uses existing infrastructure

## Operational Constraints
- Standard monitoring applies
- No special maintenance required

## Go/No-Go Recommendation
GO - Feasible with acceptable risk
EOF

# Create synthesis.md
cat > docs/forge/debate/brainstorm-<id>/synthesis.md << 'EOF'
# Synthesis: Final Decision

## Debate Summary
Advocate argued for Option A based on simplicity and team familiarity.
Skeptic raised scaling concerns that are acceptable for MVP scope.
Operator confirmed feasibility within timeline.

## Key Tradeoffs
Simplicity vs Future scalability - accepting simplicity for MVP

## Final Decision
**Selected:** Option A - Simple Approach

**Decision Statement:** Proceed with Option A for MVP, with explicit plan to reassess at 1000 user mark.

**Confidence Level:** High

## Decision Criteria
| Criterion | Weight | Score |
|-----------|--------|-------|
| Simplicity | 30% | 5/5 |
| Performance | 25% | 4/5 |
| Maintainability | 25% | 4/5 |
| Risk | 20% | 4/5 |

## Kill-Switch Criteria
**We will ABORT and reconsider if:**
- User count exceeds 1000 before planned reassessment
- Performance degrades >20% under normal load

## Fallback Plan
If Option A fails: Migrate to Option B (estimated 1 week migration)

## Risks Accepted
| Risk | Likelihood | Impact | Owner |
|------|------------|--------|-------|
| Scaling limitations | Medium | Medium | Team Lead |

## Action Items
| # | Action | Owner | Due |
|---|--------|-------|-----|
| 1 | Implement Option A | Dev Team | 2 weeks |
| 2 | Set up monitoring | DevOps | 1 week |

## Next Phase Input
Research validation needed for specific implementation details.
EOF
```

#### 1.6 Verify Debate Completion

```bash
/forge:debate --status --id brainstorm-<id>
```

**Expected Output:**
```
## Debate Status: brainstorm-<id>

**Phase:** brainstorm
**Status:** COMPLETE

### Artifacts
| File | Status |
|------|--------|
| debate-plan.md | ✓ Complete |
| advocate.md | ✓ Complete |
| skeptic.md | ✓ Complete |
| operator.md | ✓ Complete |
| synthesis.md | ✓ Complete |

### Gate Status
**PASSED** - 5/5 artifacts complete
```

#### 1.7 Complete Brainstorm Phase

```bash
/forge:brainstorm --complete
```

**Expected:**
- [ ] `docs/forge/brainstorm.md` created from synthesis
- [ ] Decisions extracted to `docs/forge/knowledge/decisions.md`
- [ ] Risks extracted to `docs/forge/knowledge/risks.md`
- [ ] Phase handoff created: `docs/forge/handoffs/brainstorm-to-research.md`
- [ ] `.claude/forge/active-workflow.md` updated:
  - phase: "brainstorm"
  - phase_status: "completed"
  - next_phase: "research"

#### 1.8 Proceed to Research Phase

```bash
/forge:research
```

**Expected Output:**
```
Research Phase Started
Reading handoff from brainstorm...
Validating decisions against best practices...

Research ID: research-20260127-143500
```

**Verify:**
- [ ] `docs/forge/research.md` created
- [ ] `.claude/forge/active-workflow.md` updated:
  - phase: "research"
  - phase_status: "in_progress"

---

## Test 2: Debate Plan Generation

**Objective:** Verify debate plan structure and AO command output

### Steps

#### 2.1 Generate Debate Plan

```bash
/forge:debate --plan --phase brainstorm --topic "Database selection for user data"
```

**Verify debate-plan.md Structure:**

```yaml
---
debate_id: "brainstorm-20260127-144200"
phase: "brainstorm"
objective: "Select database for user data storage"
status: "pending"
---
```

**Required Content Sections:**
- [ ] Objective statement (clear, specific)
- [ ] Options Under Consideration (3+ distinct options)
- [ ] Role Prompts section with:
  - [ ] Advocate instructions
  - [ ] Skeptic instructions
  - [ ] Operator instructions
  - [ ] Synthesizer instructions
- [ ] Expected Outputs list
- [ ] Completion Criteria

#### 2.2 Verify Role Prompt Completeness

Each role prompt must include:
- [ ] Clear objective for that role
- [ ] Output file path
- [ ] Required sections structure
- [ ] Rules/constraints

#### 2.3 Check AO Command Format

Output must include AO spawn commands in format:
```bash
ao spawn <project> "FORGE: Write [role].md for debate [id]"
```

---

## Test 3: Interruption and Resume

**Objective:** Verify `/forge:continue` restores state correctly

### Steps

#### 3.1 Start a Phase and Interrupt

```bash
/forge:design
```

Wait for partial completion, then simulate interruption (close session or Ctrl+C).

**Verify State Before Interruption:**
- [ ] `.claude/forge/active-workflow.md` shows:
  - phase: "design"
  - phase_status: "in_progress"
  - current_task: [task name]
  - completed_tasks: [list]
  - pending_tasks: [list with remaining work]

#### 3.2 Resume with Continue

In new session:
```bash
/forge:continue
```

**Expected Output:**
```
## Workflow Resumption

**Phase:** design
**Status:** in_progress
**Last Updated:** 2026-01-27T14:45:00Z

### Context Loaded
- ✓ decisions.md (3 active decisions)
- ✓ constraints.md (2 hard constraints)
- ✓ assumptions.md (1 open assumption)
- ✓ risks.md (2 medium risks)

### From Previous Handoff
**Locked Decisions:**
- D1: Use React for frontend

**Open Assumptions:**
- A1: API will support pagination

**TODO for this Phase:**
1. [x] Define component structure
2. [ ] Design API contracts
3. [ ] Create data flow diagrams

### Next Action
Continue with: Design API contracts
```

#### 3.3 Verify State Recovery

Check that FORGE loaded:
- [ ] Previous phase handoff (brainstorm-to-design.md)
- [ ] All knowledge files (decisions, constraints, assumptions, risks)
- [ ] Current phase output (design.md partial content)
- [ ] Correct task position in workflow

#### 3.4 Test Debate Blocking Resume

Start brainstorm, generate debate plan, then interrupt before debate completion:

```bash
/forge:brainstorm
# Let it generate debate plan, then interrupt
```

Resume:
```bash
/forge:continue
```

**Expected Output:**
```
## Workflow Resumption

**Phase:** brainstorm
**Status:** blocked
**Debate Status:** pending
**Debate ID:** brainstorm-20260127-145000

### Debate Gate Status
Status: BLOCKED on debate

Missing artifacts:
- advocate.md: pending
- skeptic.md: pending
- operator.md: pending
- synthesis.md: pending

Phase cannot complete until debate synthesis exists.
FORGE will re-check on next /forge:continue
```

#### 3.5 Complete Debate and Resume

Complete debate files as in Test 1.5, then:

```bash
/forge:continue
```

**Expected:**
- FORGE detects debate completion
- Unblocks phase
- Proceeds with brainstorm completion

---

## Verification Checklist

### File Outputs at Each Step

| Phase | Files Created | Location |
|-------|--------------|----------|
| Init | config.json, active-workflow.md, brief.md | .claude/forge/, docs/forge/knowledge/ |
| Brainstorm | brainstorm-options.md, debate-plan.md | docs/forge/, docs/forge/debate/<id>/ |
| Debate | advocate.md, skeptic.md, operator.md, synthesis.md | docs/forge/debate/<id>/ |
| Complete | brainstorm.md, handoff, decisions/risks updated | docs/forge/, docs/forge/knowledge/, docs/forge/handoffs/ |
| Research | research.md | docs/forge/ |

### State File Verification

`.claude/forge/active-workflow.md` must maintain:
- [ ] Valid YAML frontmatter
- [ ] Accurate phase tracking
- [ ] Correct status values (pending, in_progress, blocked, completed)
- [ ] Debate state when applicable
- [ ] Timestamps for audit trail

### Knowledge Base Verification

`docs/forge/knowledge/decisions.md` must:
- [ ] Record decisions from debate synthesis
- [ ] Include decision ID, phase, status
- [ ] Link to debate synthesis
- [ ] Specify constraints imposed

`docs/forge/knowledge/risks.md` must:
- [ ] Record risks from debate
- [ ] Include likelihood and impact
- [ ] Assign risk owners
- [ ] Track mitigation status

---

## Success Criteria

All tests pass when:

1. **Phase Progression:**
   - [ ] Init creates required files
   - [ ] Brainstorm generates debate plan
   - [ ] Debate status correctly reports incomplete/complete
   - [ ] Phase completes only after debate synthesis exists
   - [ ] Research phase reads brainstorm handoff

2. **Debate Plan Generation:**
   - [ ] Plan includes all required sections
   - [ ] Role prompts are complete and actionable
   - [ ] AO commands are properly formatted
   - [ ] Completion criteria are clear

3. **Interruption Recovery:**
   - [ ] `/forge:continue` reads active-workflow.md
   - [ ] Context is fully restored (decisions, constraints, etc.)
   - [ ] Task position is accurate
   - [ ] Blocked phases report blocking reason
   - [ ] Unblocking works when conditions met

---

## Troubleshooting

### Issue: No active workflow found

**Cause:** `.claude/forge/active-workflow.md` missing or corrupted

**Fix:**
```bash
/forge:start "new test objective"
```

### Issue: Debate status shows incomplete when files exist

**Cause:** File paths incorrect or synthesis.md missing required sections

**Check:**
```bash
ls -la docs/forge/debate/brainstorm-*/
cat docs/forge/debate/brainstorm-*/synthesis.md | grep -E "(Final Decision|Kill-Switch|Fallback)"
```

### Issue: Continue loads wrong phase

**Cause:** Corrupted frontmatter in active-workflow.md

**Fix:**
1. Read active-workflow.md
2. Verify frontmatter YAML is valid
3. Correct phase field if needed

---

## Automated Test Script

For CI/CD integration:

```bash
#!/bin/bash
# forge-smoke-test.sh

set -e

echo "=== FORGE-AO Smoke Test ==="

# Test 1: Phase Progression
echo "Test 1: Phase Progression"
/forge:start "Smoke test feature"
[ -f .claude/forge/active-workflow.md ] || exit 1
[ -f .claude/forge/config.json ] || exit 1

echo "  ✓ Init passed"

/forge:brainstorm
[ -f docs/forge/brainstorm-options.md ] || exit 1
DEBATE_ID=$(grep debate_id docs/forge/debate/brainstorm-*/debate-plan.md | head -1 | cut -d'"' -f2)
[ -n "$DEBATE_ID" ] || exit 1

echo "  ✓ Brainstorm started"

# Simulate debate completion
# ... (create debate files) ...

echo "=== All Tests Passed ==="
```

---

*Last updated: 2026-02-27*
*FORGE-AO Version: 2.0.0*
