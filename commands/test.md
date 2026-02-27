---
name: forge:test
description: Create test strategy with risk-based testing - AO-native
disable-model-invocation: true
---

# /forge:research

Create comprehensive test strategy with risk-based testing approach. AO-native only - no standalone mode, no prompts, file-based state.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/knowledge/risks.md
cat docs/forge/handoffs/plan-to-test.md
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: test
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
---
```

---

## Phase Execution

### Step 1: Risk Analysis

Calculate risk scores from plan and risks registry:

```markdown
## Risk-Based Test Analysis

### Risk Scoring Matrix

| Risk ID | Description | Probability | Impact | Risk Score | Test Priority |
|---------|-------------|-------------|--------|------------|---------------|
| R001 | [Risk from registry] | 1-5 | 1-5 | P×I | P0/P1/P2 |
| R002 | [Risk from registry] | 1-5 | 1-5 | P×I | P0/P1/P2 |

### Risk Score Interpretation
- 20-25: Critical (P0 - exhaustive testing required)
- 12-16: High (P0/P1 - thorough testing required)
- 6-10: Medium (P1 - standard testing)
- 1-5: Low (P2 - minimal testing)

### High-Risk Areas Identified
| Area | Risk Score | Testing Approach |
|------|------------|------------------|
| [Component A] | 20 | Full coverage + edge cases |
| [Component B] | 15 | Standard coverage + key paths |
```

### Step 2: Generate Test Strategy Document

Write to `docs/forge/phases/test.md`:

```markdown
---
phase: test
generated_at: "<ISO-timestamp>"
objective: "<from plan handoff>"
status: in_progress
---

# Test Strategy: [Objective]

## Context

### From Planning Phase
[Summary from plan-to-test.md handoff]

### Implementation Steps to Test
[List steps from plan with test requirements]

### Risk Areas
[High-risk areas from risk analysis]

### Constraints Applied
[List relevant constraints from constraints.md]

## Test Approach

### Risk-Based Test Prioritization

#### P0 Tests (Critical - Must Pass)
| Test Area | Risk Score | Coverage Target | Test Types |
|-----------|------------|-----------------|------------|
| [Area 1] | 20 | 100% | Unit, Integration, E2E |
| [Area 2] | 16 | 95%+ | Unit, Integration |

#### P1 Tests (High - Should Pass)
| Test Area | Risk Score | Coverage Target | Test Types |
|-----------|------------|-----------------|------------|
| [Area 3] | 12 | 80%+ | Unit, Integration |

#### P2 Tests (Normal - Nice to Have)
| Test Area | Risk Score | Coverage Target | Test Types |
|-----------|------------|-----------------|------------|
| [Area 4] | 6 | 60%+ | Unit |

## Test Types

### Unit Tests

**Framework:** [Jest/Vitest/etc]
**Coverage Target:** 80% overall, 100% for P0 areas

| Component | Priority | Test Cases | Mock Strategy |
|-----------|----------|------------|---------------|
| [Component A] | P0 | [List key cases] | [What to mock] |
| [Component B] | P1 | [List key cases] | [What to mock] |

### Integration Tests

**Framework:** [Testing Library/Supertest/etc]
**Focus Areas:** API contracts, component interactions

| Integration Point | Priority | Test Scenario |
|-------------------|----------|---------------|
| [API X] → [DB] | P0 | [Scenario] |
| [Component A] → [Component B] | P1 | [Scenario] |

### End-to-End Tests

**Framework:** [Playwright/Cypress]
**Focus:** Critical user flows only (P0 areas)

| User Flow | Priority | Steps | Assertions |
|-----------|----------|-------|------------|
| [Flow 1] | P0 | [Steps] | [What to verify] |
| [Flow 2] | P1 | [Steps] | [What to verify] |

## ATDD Test Cases

Tests written before implementation (Acceptance Test-Driven Development):

### Feature: [Feature Name]

#### Test: [Test Name]
**Priority:** P0/P1/P2
**Risk Score:** [Score]
**Type:** Unit/Integration/E2E

**Given:** [Setup state]
**When:** [Action performed]
**Then:** [Expected result]

**Evidence Required:**
- [ ] Test passes
- [ ] Coverage meets threshold
- [ ] No regression in related tests

---

### Feature: [Next Feature]
...

## Test Data Strategy

### Fixtures
| Fixture | Purpose | Data Contents |
|---------|---------|---------------|
| [fixture.json] | [Purpose] | [Key data points] |

### Mock Data
| Service | Mock Strategy | Location |
|---------|---------------|----------|
| [API X] | [Strategy] | [File path] |

## Test Gates

Quality gates that must pass:

| Gate | Threshold | Action on Fail |
|------|-----------|----------------|
| Unit test pass rate | 100% | Block build |
| Integration pass rate | 100% | Block build |
| Type check | 0 errors | Block build |
| Lint errors | 0 errors | Block build |
| Code coverage | 80% | Warn/Block |
| P0 test pass rate | 100% | Block build |
| P1 test pass rate | 90%+ | Warn |

## Ralph Loop for Tests

Internalized test loop:

```
LOOP until tests pass:
  1. Run tests
  2. If fail:
     - Analyze failures
     - Fix issues
     - COMMIT fixes
     - Continue loop
  3. If pass:
     - Exit loop
     - Mark phase complete
```

## Coverage Targets by Risk

| Risk Level | Line Coverage | Branch Coverage | Function Coverage |
|------------|---------------|-----------------|-------------------|
| Critical (20-25) | 100% | 100% | 100% |
| High (12-16) | 95% | 90% | 95% |
| Medium (6-10) | 80% | 75% | 80% |
| Low (1-5) | 60% | 50% | 60% |
```

### Step 3: Generate Test Scaffolding

Create test file structure:

```bash
# Create test directories based on plan
mkdir -p src/__tests__/unit/[component]
mkdir -p src/__tests__/integration/[feature]
mkdir -p src/__tests__/e2e/[flow]

# Create test files for P0 areas
touch src/__tests__/unit/[component]/[test].test.ts
touch src/__tests__/integration/[feature]/[test].test.ts
touch src/__tests__/e2e/[flow]/[test].spec.ts
```

---

## Phase Exit Protocol

### Step 1: Write Final Test Strategy Artifact

Write to `docs/forge/test-strategy.md`:

```markdown
---
phase: test
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
---

# Test Strategy: [Objective]

## Summary

**Risk-Based Approach:** Yes
**Total Test Cases:** [N]
**P0 (Critical):** [N] tests
**P1 (High):** [N] tests
**P2 (Normal):** [N] tests

**Coverage Targets:**
- Overall: 80%
- P0 Areas: 100%
- P1 Areas: 95%
- P2 Areas: 60%

## Risk Summary

| Risk Level | Areas | Test Focus |
|------------|-------|------------|
| Critical (20-25) | [N] | Exhaustive |
| High (12-16) | [N] | Thorough |
| Medium (6-10) | [N] | Standard |
| Low (1-5) | [N] | Minimal |

## Quick Reference

### Test Commands
```bash
# Run all tests
npm test

# Run P0 only
npm test -- --grep "P0"

# Run with coverage
npm test -- --coverage

# Run specific area
npm test -- src/__tests__/unit/[component]
```

### Test Gates
- Unit: 100% pass required
- Integration: 100% pass required
- Type check: 0 errors required
- Coverage: 80% minimum

## Full Test Strategy

See: `docs/forge/phases/test.md`
```

### Step 2: Write Handoff Document

Write to `docs/forge/handoffs/test-to-build.md`:

```markdown
---
from_phase: test
to_phase: build
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: test → build

## Summary

### What Was Done
Created risk-based test strategy with [N] test cases prioritized by risk score.

### Key Outcomes
- Test strategy defined
- Test scaffolding created
- ATDD test cases written (ready for implementation)
- Risk-based prioritization applied
- Test gates defined

## Test Coverage by Implementation Step

| Plan Step | P0 Tests | P1 Tests | P2 Tests | Coverage Target |
|-----------|----------|----------|----------|-----------------|
| Step 1 | [N] | [N] | [N] | X% |
| Step 2 | [N] | [N] | [N] | X% |

## Critical Areas (P0)

| Area | Risk Score | Why Critical | Test Location |
|------|------------|--------------|---------------|
| [Area 1] | 20 | [Reason] | `src/__tests__/...` |
| [Area 2] | 16 | [Reason] | `src/__tests__/...` |

## Test Gates for Build Phase

| Gate | Threshold | Enforcement |
|------|-----------|-------------|
| Unit tests | 100% pass | Hard block |
| Integration | 100% pass | Hard block |
| Type check | 0 errors | Hard block |
| Coverage | 80% | Hard block |

## For Build Phase

### Test-First Workflow
1. Write failing test for step
2. Implement to make test pass
3. Refactor
4. Commit
5. Next test

### Ralph Loop
Build phase will iterate:
```
Run tests → Fix failures → Commit → Repeat until pass
```

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Test Strategy Detail | docs/forge/phases/test.md | Complete |
| Test Strategy Summary | docs/forge/test-strategy.md | Complete |
| Test Scaffolding | src/__tests__/ | Created |
| Test Fixtures | src/__tests__/fixtures/ | Created |

## Reference Materials

- Phase output: `docs/forge/phases/test.md`
- Implementation Plan: `docs/forge/phases/plan.md`
- Risk Registry: `docs/forge/knowledge/risks.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: test
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
next_phase: build
---
```

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] Risk analysis completed with scores
- [x] Test strategy defined based on plan
- [x] Risk-based prioritization applied (P0/P1/P2)
- [x] Test scaffolding created
- [x] ATDD test cases written for P0 areas
- [x] Unit test cases defined
- [x] Integration test cases defined
- [x] Critical path E2E tests defined
- [x] Test gates documented
- [x] Coverage targets set by risk level
- [x] `docs/forge/phases/test.md` written
- [x] `docs/forge/test-strategy.md` written
- [x] `docs/forge/handoffs/test-to-build.md` written
- [x] `docs/forge/active-workflow.md` updated

---

## Next Phase

Auto-proceeds to: `/forge:build` (implementation with TDD)

---

## Required Skills

**REQUIRED:** `@forge-test`
**OPTIONAL:** `@risk-based-testing` for risk assessment

---

## Key Principles

1. **Risk-Based Testing** - Prioritize by risk score, not coverage alone
2. **ATDD** - Tests written before implementation
3. **No standalone mode** - AO-native only
4. **Non-interactive** - No prompts, no menus, file-based state only
5. **Test Gates** - Hard gates block build on failure
6. **Ralph Loop** - Internalized test-fix-commit cycle

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── test-strategy.md                # Final artifact
├── phases/
│   └── test.md                    # Detailed test strategy
├── handoffs/
│   ├── plan-to-test.md            # Input (read)
│   └── test-to-build.md           # Output (write)
└── knowledge/
    ├── decisions.md               # Read on entry
    ├── constraints.md             # Read on entry
    └── risks.md                   # Read on entry (for risk scores)
```
