---
name: forge:build
description: AO-native build phase with internalized Ralph loop and BLOCKING test gate
argument-hint: "[plan reference or skip if following workflow]"
disable-model-invocation: true
---

# /forge:build

Execute implementation plans with internalized TDD discipline. Build completion is BLOCKED until all tests pass.

**CRITICAL:** This is AO-native mode. No subagents. No prompts. File-based state only.

---

## Phase Entry Protocol

Execute in strict sequence:

```bash
# 1. State update
.claude/forge/scripts/forge-state.sh set-phase build

# 2. Read required knowledge
read docs/forge/knowledge/decisions.md
read docs/forge/knowledge/constraints.md
read docs/forge/handoffs/test-to-build.md

# 3. Update workflow tracking
cat > docs/forge/active-workflow.md << 'EOF'
# Active Workflow State

**Current Phase:** build
**Started:** $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Status:** in_progress

**Entry Conditions:**
- [x] Decisions reviewed
- [x] Constraints reviewed
- [x] Test handoff received

**Current Task:** Reading implementation plan
**Next Gate:** Test gate (BLOCKING)

**Artifacts:**
- Input: docs/forge/handoffs/test-to-build.md
- Output: docs/forge/phases/build.md (pending)
- Output: docs/forge/handoffs/build-to-validate.md (pending)
EOF
```

---

## Input Processing

### Read Plan

Extract from plan document:
- Task list with priorities
- Dependencies between tasks
- Acceptance criteria per task
- Files to modify/create

```bash
# Plan location priority:
# 1. Argument provided: /forge:build <plan-path>
# 2. Handoff reference: docs/forge/handoffs/test-to-build.md
# 3. Default: docs/forge/plan.md
```

---

## Ralph Loop (Internalized)

The TDD loop runs internally within this session. No subagent spawning.

```
FOR each task in plan:
    iteration = 0
    max_iterations = 5

    WHILE iteration < max_iterations:
        iteration += 1

        # 1. Run all test gates
        gate_results = run_test_gates()

        # 2. Evaluate results
        IF all_gates_pass(gate_results):
            COMMIT "task: Complete [task-name]"
            BREAK

        # 3. Analyze failures
        failures = analyze_failures(gate_results)

        # 4. Make minimal fix
        fix_applied = implement_fix(failures)

        # 5. Commit the fix
        IF fix_applied:
            COMMIT "fix: [task-name] - [brief description]"

        # 6. Continue loop (will re-run tests at top)
    END WHILE

    IF iteration >= max_iterations:
        LOG_FAILURE "Max iterations reached for task: [task-name]"
        MARK_TASK_BLOCKED task
        CONTINUE
    END IF
END FOR
```

### Test Gates (BLOCKING)

All gates must pass. Build cannot proceed until they do.

| Gate | Command | Pass Criteria | On Failure |
|------|---------|---------------|------------|
| 1. Type Check | `tsc --noEmit` | Zero errors | Fix types, loop continues |
| 2. Lint | `npm run lint` or `eslint` | Zero errors/warnings | Auto-fix or manual fix, loop continues |
| 3. Unit Tests | `npm test` or equivalent | 100% pass | Analyze, fix, loop continues |
| 4. Coverage | Coverage report | >= 80% | Add tests, loop continues |

**Test Gate Function:**
```
FUNCTION run_test_gates():
    results = {}

    # Gate 1: Type Check
    results.types = run("tsc --noEmit")
    IF results.types.exit_code != 0:
        results.passed = false
        results.failures.append({gate: "types", output: results.types.output})
        RETURN results

    # Gate 2: Lint
    results.lint = run("npm run lint")
    IF results.lint.exit_code != 0:
        results.passed = false
        results.failures.append({gate: "lint", output: results.lint.output})
        RETURN results

    # Gate 3: Unit Tests
    results.tests = run("npm test")
    IF results.tests.exit_code != 0:
        results.passed = false
        results.failures.append({gate: "tests", output: results.tests.output})
        RETURN results

    # Gate 4: Coverage
    results.coverage = extract_coverage(results.tests.output)
    IF results.coverage < 80:
        results.passed = false
        results.failures.append({gate: "coverage", actual: results.coverage, required: 80})
        RETURN results

    results.passed = true
    RETURN results
END FUNCTION
```

### Failure Analysis

```
FUNCTION analyze_failures(gate_results):
    failures = gate_results.failures
    analysis = []

    FOR failure IN failures:
        SWITCH failure.gate:
            CASE "types":
                # Parse TypeScript errors
                errors = parse_tsc_output(failure.output)
                FOR error IN errors:
                    analysis.append({
                        type: "type_error",
                        file: error.file,
                        line: error.line,
                        message: error.message,
                        fix_strategy: infer_type_fix(error)
                    })

            CASE "lint":
                # Parse lint errors
                errors = parse_lint_output(failure.output)
                FOR error IN errors:
                    analysis.append({
                        type: "lint_error",
                        file: error.file,
                        rule: error.rule,
                        fix_strategy: error.auto_fixable ? "auto_fix" : "manual_fix"
                    })

            CASE "tests":
                # Parse test failures
                failures = parse_test_output(failure.output)
                FOR fail IN failures:
                    analysis.append({
                        type: "test_failure",
                        test: fail.test_name,
                        expected: fail.expected,
                        actual: fail.actual,
                        fix_strategy: infer_test_fix(fail)
                    })

            CASE "coverage":
                analysis.append({
                    type: "coverage_gap",
                    actual: failure.actual,
                    required: failure.required,
                    fix_strategy: "add_tests"
                })
        END SWITCH
    END FOR

    RETURN analysis
END FUNCTION
```

### Fix Implementation

```
FUNCTION implement_fix(analysis):
    FOR item IN analysis:
        SWITCH item.fix_strategy:
            CASE "auto_fix":
                run("npm run lint:fix")
                RETURN true

            CASE "type_fix":
                file = read_file(item.file)
                fixed = apply_type_fix(file, item)
                write_file(item.file, fixed)
                RETURN true

            CASE "test_fix":
                # Fix implementation code (not tests)
                target_file = find_implementation_for_test(item.test)
                file = read_file(target_file)
                fixed = apply_test_fix(file, item)
                write_file(target_file, fixed)
                RETURN true

            CASE "add_tests":
                # Add missing test coverage
                uncovered = find_uncovered_lines()
                FOR line IN uncovered:
                    test = generate_test_for_line(line)
                    append_to_test_file(test)
                RETURN true

            DEFAULT:
                LOG "Unknown fix strategy: " + item.fix_strategy
                RETURN false
        END SWITCH
    END FOR
END FUNCTION
```

---

## Implementation Rules

1. **One task at a time** - Complete each task fully before next
2. **Test gate is BLOCKING** - No task completes until tests pass
3. **Commit every loop** - Each fix gets its own commit
4. **Max 5 iterations** - After 5, mark blocked and continue
5. **No user prompts** - All decisions internal
6. **File-based state** - All progress in files

---

## Phase Exit Protocol

Execute only when ALL tasks complete or are marked blocked:

### 1. Write Build Log

```bash
cat > docs/forge/phases/build.md << 'EOF'
# Build Phase Log

**Phase:** build
**Started:** [ISO timestamp]
**Completed:** [ISO timestamp]
**Status:** [complete|partial|blocked]

## Summary

| Metric | Value |
|--------|-------|
| Total Tasks | N |
| Completed | N |
| Blocked | N |
| Total Commits | N |
| Ralph Loops | N |
| Time Elapsed | N minutes |

## Tasks

### Task: [Name]
**Status:** [✅ Complete | ⛔ Blocked]
**Files Modified:**
- `path/to/file.ts`
**Commits:**
- `abc1234` - Initial implementation
- `def5678` - fix: Type error in handler
- `ghi9012` - fix: Test assertion
**Test Results:** [✅ Pass | ⛔ Fail]
**Iterations:** N

## Issues Encountered

| Task | Issue | Resolution |
|------|-------|------------|
| Task 2 | Type mismatch in API | Added proper interface |
| Task 3 | Flaky test | Increased timeout |

## Decisions Made

- Decision D-build-1: [Description]
- Decision D-build-2: [Description]

## Constraints Added

- Constraint DC-build-1: [Description]

## Coverage Report

```
File                  | Stmts | Branch | Funcs | Lines |
----------------------|-------|--------|-------|-------|
All files             | 85.2  | 78.5   | 90.1  | 85.2  |
```

## Exit Criteria Checklist

- [ ] All tasks attempted
- [ ] All passing tasks committed
- [ ] Test gate passed for completed tasks
- [ ] Build log written
- [ ] Handoff document written
EOF
```

### 2. Write Handoff to Validate

```bash
cat > docs/forge/handoffs/build-to-validate.md << 'EOF'
# Handoff: Build → Validate

**Source:** build phase
**Target:** validate phase
**Date:** [ISO timestamp]

## What Was Built

### Completed Tasks
1. [Task name] - [Brief description]
2. [Task name] - [Brief description]

### Blocked Tasks
1. [Task name] - [Reason blocked]

## Files Created/Modified

```
src/
  new-feature/
    index.ts          (new)
    types.ts          (new)
  existing/
    modified.ts       (+45/-12 lines)
```

## Test Results

- **Status:** [All Pass | Partial | None]
- **Passing:** N/N tests
- **Coverage:** N%

## Known Issues

- [Issue 1 and workaround]
- [Issue 2 pending resolution]

## Validation Focus Areas

1. [Area needing extra scrutiny]
2. [Edge case to verify]

## Commits Since Last Phase

```
abc1234 - task: Implement feature X
def5678 - fix: Handle edge case
ghi9012 - fix: Correct type errors
```
EOF
```

### 3. Update Workflow State

```bash
cat > docs/forge/active-workflow.md << 'EOF'
# Active Workflow State

**Current Phase:** build (complete)
**Next Phase:** validate
**Status:** handoff_ready

**Exit Conditions:**
- [x] Build log written
- [x] Handoff document written
- [x] All changes committed

**Next Phase Input:** docs/forge/handoffs/build-to-validate.md
EOF

# State update
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next validate
```

---

## Error Handling

### Test Gate Persistent Failure

If a task fails test gate after 5 iterations:

1. Document in build log
2. Mark task as BLOCKED
3. Continue to next task
4. Note in handoff for validation focus

### Unrecoverable Errors

| Error | Action |
|-------|--------|
| Build system failure | Abort, document in build log |
| Git failure | Abort, manual intervention required |
| Missing dependencies | Abort, update constraints.md |
| Circular dependency | Mark blocked, continue |

---

## Required Skill

**REQUIRED:** `@forge-build`

This skill provides:
- Test runner integration
- Failure analysis patterns
- Fix generation templates
- Commit message formatting

---

## Command Reference

```bash
/forge:build                    # Execute from handoff or default plan
/forge:build docs/forge/plan.md # Execute specific plan
```

---

## AO-Native Guarantees

1. **No standalone mode** - AO execution only
2. **No subagent spawning** - Ralph loop internalized
3. **Test gate BLOCKING** - Build cannot complete without passing tests
4. **Non-interactive** - Zero prompts
5. **File-based state** - All progress tracked in files
