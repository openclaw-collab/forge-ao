---
name: forge:test
description: Run comprehensive tests with parallel testing agents - unit, integration, and e2e
argument-hint: "[test type or file pattern]"
disable-model-invocation: true
---

# /forge:test

Create test strategy and execute comprehensive tests with parallel testing agents. Supports unit, integration, and end-to-end testing.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to test phase
.claude/forge/scripts/forge-state.sh set-phase test
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next build

# Write artifact
cat > docs/forge/test-strategy.md << 'EOF'
# Test Strategy: [Objective]

## Test Coverage
...
EOF
```

## Usage

```bash
/forge:test                    # Run all tests
/forge:test unit               # Run only unit tests
/forge:test integration        # Run only integration tests
/forge:test e2e                # Run only e2e tests
/forge:test --watch            # Run in watch mode
/forge:test --coverage         # Run with coverage report
/forge:test src/components     # Run tests matching pattern
```

## Process

1. **Define Test Strategy** - Based on plan and design
2. **Create Test Scaffolding** - Setup test infrastructure
3. **Write Test Cases** - ATDD: tests before implementation
4. **Execute Tests** - Run test suite
5. **Document Results** - Write to `docs/forge/test-strategy.md`

## Test-First Workflow

**CRITICAL:** Tests are created AFTER Plan, BEFORE Build.

```
Plan → Test Strategy → Tests Written → Build → Validate Tests Pass
```

## Test Types

### 1. Unit Tests

Test individual functions, components, and modules in isolation.

**Scope:**
- Individual functions
- React components
- Utility modules
- Hooks

### 2. Integration Tests

Test interactions between multiple components/modules.

**Scope:**
- Component interactions
- API integration
- Database operations
- Service communication

### 3. End-to-End (E2E) Tests

Test complete user flows in a real browser environment.

**Scope:**
- Full user journeys
- Cross-page navigation
- Real browser behavior
- Visual regression

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

## Test Gates

Quality gates that must pass:

| Gate | Threshold | Action on Fail |
|------|-----------|----------------|
| Unit test pass rate | 100% | Block build |
| Integration pass rate | 100% | Block build |
| Type check | 0 errors | Block build |
| Lint errors | 0 errors | Block build |
| Code coverage | 80% | Warn/Block |
| E2E pass rate | 100% | Warn (optional) |

## Acceptance Criteria

This phase is complete when:
- [ ] Test strategy defined based on plan
- [ ] Test scaffolding created
- [ ] Unit test cases written
- [ ] Integration test cases written
- [ ] Critical path E2E tests defined
- [ ] All tests pass (if running after build)
- [ ] Coverage meets threshold (80% default)
- [ ] `docs/forge/test-strategy.md` written
- [ ] State updated: phase=test, status=completed
- [ ] Next phase set to build

## Phase Artifacts

**Writes to:** `docs/forge/test-strategy.md`

### Artifact Structure
```markdown
# Test Strategy: [Objective]

## Test Approach

### Unit Tests
- Framework: [Jest/Vitest/etc]
- Coverage target: 80%
- Key areas to test:
  - [Area 1]
  - [Area 2]

### Integration Tests
- Framework: [Testing Library/Supertest/etc]
- Integration points:
  - [Point 1]
  - [Point 2]

### E2E Tests
- Framework: [Playwright/Cypress]
- Critical user flows:
  - [Flow 1]
  - [Flow 2]

## Test Cases

### [Feature/Area]

#### Test: [Name]
- **Type:** Unit/Integration/E2E
- **Given:** [Setup]
- **When:** [Action]
- **Then:** [Expected result]
- **Priority:** P0/P1/P2

## Test Data

- Mock data for tests
- Test fixtures location

## Coverage Report

| File | Stmts | Branch | Funcs | Lines |
|------|-------|--------|-------|-------|
| All files | X% | X% | X% | X% |
```

## New Test Subcommands (BMAD TEA Integration)

### Risk-Based Testing

```bash
/forge:test risk
```

Calculate risk scores and prioritize testing effort.

### ATDD (Acceptance Test-Driven Development)

```bash
/forge:test atdd [feature-name]
```

Generate failing acceptance tests BEFORE implementation.

### Test Quality Audit

```bash
/forge:test review
```

Audit existing tests for quality (0-100 score).

### CI/CD Pipeline Setup

```bash
/forge:test ci
```

Configure test automation pipeline for CI/CD.

## AO Mode Considerations

In AO mode:
- Tests run within the single AO session
- Parallel testing is simulated, not via subagents
- Results are written to workspace for AO to track
- Test failures block workflow progression

## Next Steps

After test:
- `/forge:build` - Implement with TDD
- `/forge:validate` - Verify against requirements
- `/forge:review` - Code review

## Required Skill

**REQUIRED:** `@forge-test`
**OPTIONAL:** `@risk-based-testing` for risk assessment
