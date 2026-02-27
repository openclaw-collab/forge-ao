---
name: forge:validate
description: Evidence-based verification against requirements - AO-native
disable-model-invocation: true
---

# /forge:validate

Quality gates with evidence-based validation against acceptance criteria. AO-native only - no standalone mode, no prompts, file-based state.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/knowledge/risks.md
cat docs/forge/handoffs/build-to-validate.md
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: validate
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
---
```

---

## Phase Execution

### Step 1: Gather Evidence

Execute validation commands and capture output:

```bash
# TypeScript compilation
echo "## TypeScript Compilation" >> docs/forge/phases/validate.md
npm run type-check 2>&1 | tee -a docs/forge/phases/validate.md

# Run tests
echo "## Test Results" >> docs/forge/phases/validate.md
npm test 2>&1 | tee -a docs/forge/phases/validate.md

# Coverage report
echo "## Coverage Report" >> docs/forge/phases/validate.md
npm test -- --coverage 2>&1 | tee -a docs/forge/phases/validate.md

# Lint checks
echo "## Lint Results" >> docs/forge/phases/validate.md
npm run lint 2>&1 | tee -a docs/forge/phases/validate.md

# Build verification
echo "## Build Verification" >> docs/forge/phases/validate.md
npm run build 2>&1 | tee -a docs/forge/phases/validate.md
```

### Step 2: Generate Validation Document

Write to `docs/forge/phases/validate.md`:

```markdown
---
phase: validate
generated_at: "<ISO-timestamp>"
objective: "<from build handoff>"
status: in_progress
---

# Validation: [Objective]

## Context

### From Build Phase
[Summary from build-to-validate.md handoff]

### Implementation Completed
[What was built per plan]

### Test Strategy Reference
[From test-strategy.md]

### Constraints Applied
[List relevant constraints from constraints.md]

## Evidence Collection

### TypeScript Compilation
**Command:** `npm run type-check`
**Status:** ✅ PASS / ❌ FAIL
**Evidence:**
```
[Paste command output]
```

### Unit Tests
**Command:** `npm test -- --testPathPattern=unit`
**Status:** ✅ PASS / ❌ FAIL
**Pass Rate:** X%
**Evidence:**
```
[Paste test output]
```

### Integration Tests
**Command:** `npm test -- --testPathPattern=integration`
**Status:** ✅ PASS / ❌ FAIL
**Pass Rate:** X%
**Evidence:**
```
[Paste test output]
```

### E2E Tests
**Command:** `npm run test:e2e`
**Status:** ✅ PASS / ❌ FAIL
**Pass Rate:** X%
**Evidence:**
```
[Paste test output]
```

### Coverage Report
**Command:** `npm test -- --coverage`
**Status:** ✅ PASS / ❌ FAIL
**Evidence:**
```
[Paste coverage table]
```

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Statements | 80% | X% | ✅/❌ |
| Branches | 80% | X% | ✅/❌ |
| Functions | 80% | X% | ✅/❌ |
| Lines | 80% | X% | ✅/❌ |

### Lint Checks
**Command:** `npm run lint`
**Status:** ✅ PASS / ❌ FAIL
**Errors:** [N]
**Warnings:** [N]
**Evidence:**
```
[Paste lint output]
```

### Build Verification
**Command:** `npm run build`
**Status:** ✅ PASS / ❌ FAIL
**Evidence:**
```
[Paste build output]
```

## Requirements Validation

### Functional Requirements

| Requirement | From Plan | Evidence | Status |
|-------------|-----------|----------|--------|
| [Req 1] | Plan Step X | [Test/Output] | ✅/⚠️/❌ |
| [Req 2] | Plan Step Y | [Test/Output] | ✅/⚠️/❌ |

### Acceptance Criteria

| Criterion | Test Method | Evidence | Status |
|-----------|-------------|----------|--------|
| [Criterion 1] | [How tested] | [Result] | ✅/⚠️/❌ |
| [Criterion 2] | [How tested] | [Result] | ✅/⚠️/❌ |

## Design Validation

### UI/UX Compliance
| Spec | Verification | Status |
|------|--------------|--------|
| Matches design.md | [Screenshot/comparison] | ✅/❌ |
| Responsive | [Test method] | ✅/❌ |
| Accessible | [a11y test results] | ✅/❌ |

### Performance Validation
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Load time | <Xms | Yms | ✅/❌ |
| Bundle size | <XKB | YKB | ✅/❌ |

## Risk Validation

| Risk ID | From Registry | Mitigation Verified | Status |
|---------|---------------|---------------------|--------|
| R001 | [Description] | [How verified] | ✅/⚠️/❌ |
| R002 | [Description] | [How verified] | ✅/⚠️/❌ |

## Ralph Loop for Validation

Internalized validation loop:

```
LOOP until validation passes:
  1. Run validation checks
  2. If any fail:
     - Analyze failure
     - Fix issue
     - COMMIT fix
     - Continue loop
  3. If all pass:
     - Exit loop
     - Generate report
```

## Issues Found

| Issue | Severity | Location | Fix Required | Status |
|-------|----------|----------|--------------|--------|
| [Issue 1] | Critical/High/Med/Low | [File] | Yes/No | Open/Fixed |
```

### Step 3: Execute Ralph Loop (if needed)

If any validation fails:

```bash
# Fix issues and re-run
# Each fix must be committed

# Example fix cycle:
# 1. Analyze failure from evidence
# 2. Fix issue
# 3. git add .
# 4. git commit -m "fix: [description]"
# 5. Re-run validation
# 6. Update evidence in validate.md
```

---

## Phase Exit Protocol

### Step 1: Write Final Validation Report

Write to `docs/forge/validation-report.md`:

```markdown
---
phase: validate
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
---

# Validation Report: [Objective]

## Summary

**Overall Status:** ✅ PASSED / ❌ FAILED / ⚠️ PARTIAL
**Date:** [ISO timestamp]
**Build Reference:** [Commit hash]

## Gate Results

| Gate | Threshold | Actual | Status |
|------|-----------|--------|--------|
| TypeScript | 0 errors | [N] errors | ✅/❌ |
| Unit Tests | 100% pass | [N]% | ✅/❌ |
| Integration Tests | 100% pass | [N]% | ✅/❌ |
| E2E Tests | 100% pass | [N]% | ✅/❌ |
| Coverage | 80% | [N]% | ✅/❌ |
| Lint | 0 errors | [N] errors | ✅/❌ |
| Build | Success | [Status] | ✅/❌ |

## Requirements Validation

| Requirement | Status | Evidence |
|-------------|--------|----------|
| [Req 1] | ✅/⚠️/❌ | [Reference to evidence] |
| [Req 2] | ✅/⚠️/❌ | [Reference to evidence] |

**Requirements Met:** [N]/[Total] ([N]%)

## Issues Summary

| Severity | Count | Resolved | Outstanding |
|----------|-------|----------|-------------|
| Critical | [N] | [N] | [N] |
| High | [N] | [N] | [N] |
| Medium | [N] | [N] | [N] |
| Low | [N] | [N] | [N] |

## Recommendations

- [Recommendation 1 if partial/fail]
- [Recommendation 2]

## Full Validation Document

See: `docs/forge/phases/validate.md`
```

### Step 2: Write Handoff Document

Write to `docs/forge/handoffs/validate-to-review.md`:

```markdown
---
from_phase: validate
to_phase: review
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: validate → review

## Summary

### What Was Done
Executed evidence-based validation against all quality gates.

### Key Outcomes
- Validation status: [Passed/Failed/Partial]
- Gates passed: [N]/[Total]
- Issues found: [N] ([Critical]/[High]/[Medium]/[Low])
- Issues resolved: [N]

## Validation Results

### Gate Status
| Gate | Result | Evidence Location |
|------|--------|-------------------|
| TypeScript | ✅/❌ | In validation report |
| Tests | ✅/❌ | In validation report |
| Coverage | ✅/❌ | In validation report |
| Build | ✅/❌ | In validation report |

### Requirements Status
| Requirement | Validated | Evidence |
|-------------|-----------|----------|
| [Req 1] | Yes/No | [Reference] |

## For Review Phase

### Areas Requiring Review Focus
| Area | Risk | Suggested Review Angle |
|------|------|------------------------|
| [Area 1] | High | Security/Performance |
| [Area 2] | Med | Code quality |

### Known Issues (Resolved)
| Issue | Resolution | Commit |
|-------|------------|--------|
| [Issue] | [How fixed] | [Hash] |

### Outstanding Issues (if partial)
| Issue | Severity | Action |
|-------|----------|--------|
| [Issue] | Med/Low | Address in review or defer |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Validation Detail | docs/forge/phases/validate.md | Complete |
| Validation Report | docs/forge/validation-report.md | Complete |
| Evidence | [Test outputs] | Captured |

## Reference Materials

- Phase output: `docs/forge/phases/validate.md`
- Test Strategy: `docs/forge/test-strategy.md`
- Implementation Plan: `docs/forge/phases/plan.md`
- Risks: `docs/forge/knowledge/risks.md`

## Sign-off

Phase completed: Yes/Partial
Blocked by: [None/Issues]
Ready to proceed: Yes/Conditional
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: validate
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
  - validate
next_phase: review
---
```

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] TypeScript compilation verified with evidence
- [x] All tests executed with evidence
- [x] Coverage measured with evidence
- [x] Lint checks executed with evidence
- [x] Build verified with evidence
- [x] Requirements validated against plan
- [x] Acceptance criteria checked
- [x] Design specs verified
- [x] Risks validated
- [x] Issues documented and resolved (or deferred)
- [x] Ralph loop completed (if failures)
- [x] `docs/forge/phases/validate.md` written
- [x] `docs/forge/validation-report.md` written
- [x] `docs/forge/handoffs/validate-to-review.md` written
- [x] `docs/forge/active-workflow.md` updated

---

## Next Phase

Auto-proceeds to: `/forge:review` (code review)

---

## Required Skill

**REQUIRED:** `@forge-validate`

---

## Key Principles

1. **Evidence-Based** - Every claim backed by command output
2. **No standalone mode** - AO-native only
3. **Non-interactive** - No prompts, no menus, file-based state only
4. **Ralph Loop** - Fix failures, commit, re-validate
5. **Hard Gates** - Failed gates block progression
6. **Full Documentation** - All evidence captured

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── validation-report.md            # Final artifact
├── phases/
│   └── validate.md                # Detailed validation with evidence
├── handoffs/
│   ├── build-to-validate.md       # Input (read)
│   └── validate-to-review.md      # Output (write)
└── knowledge/
    ├── decisions.md               # Read on entry
    ├── constraints.md             # Read on entry
    └── risks.md                   # Read on entry
```
