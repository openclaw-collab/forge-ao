---
name: forge:build
description: Execute implementation plans with automatic TDD loop and test gates
argument-hint: "[plan reference or skip if following workflow]"
disable-model-invocation: true
---

# /forge:build

Execute implementation plans with TDD discipline and automatic test/fix loop.

## State Update Protocol

**ON ENTRY:**
```bash
.claude/forge/scripts/forge-state.sh set-phase build
```

**ON EXIT:**
```bash
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next validate
```

## Usage

```bash
/forge:build                    # Execute current plan
/forge:build docs/forge/plan.md  # Execute specific plan
```

## Process

### 1. Read Plan

Extract tasks:
- Task list with priorities
- Dependencies between tasks
- Acceptance criteria

### 2. Automatic Ralph Loop

**Each task runs in automatic loop:**

```bash
for task in tasks:
  while tests_not_passing:
    implement_task()
    run_tests()
    if tests_fail:
      analyze_failure()
      make_fix()
      git_commit_fix()
    else:
      mark_task_complete()
      git_commit_progress()
      break
```

**No blocking prompts** - loop continues until tests pass or max iterations (5).

### 3. Test Gates (3 Gates)

| Gate | Check | On Failure |
|------|-------|------------|
| 1. Type Check | `tsc --noEmit` | Fix types, retry |
| 2. Lint | ESLint/Prettier | Auto-fix, retry |
| 3. Tests | Unit tests pass | Fix code, retry |

All gates must pass before task is marked complete.

## AO Mode Behavior

In AO mode:
- **No subagent spawning** - all work in current session
- **Sequential task execution** - one task at a time
- **Frequent commits** - each task has at least one commit
- **Auto-retry on failure** - up to 5 attempts per task
- **Proceeds automatically** - no user prompts

## Max Iteration Protection

To prevent infinite loops:
- Max 5 attempts per task
- If still failing after 5: document issue, skip task, continue

## Auto-Completion Criteria

Phase auto-completes when:
- [ ] All plan tasks implemented
- [ ] All 3 test gates pass
- [ ] Coverage threshold met (80%)
- [ ] Code follows Karpathy guidelines
- [ ] All changes committed
- [ ] `docs/forge/build-log.md` written

## Phase Artifact

**Writes to:** `docs/forge/build-log.md`

```markdown
# Build Log: [Objective]

## Summary
**Tasks:** N/N complete
**Commits:** N
**Duration:** X minutes

## Tasks

### Task N: [Name]
**Status:** ✅ Complete
**Files:** `path/to/file.ts`
**Commits:** `abc123` - message
**Test Results:** ✅ Pass

## Issues Encountered
- [Issue and resolution]
```

## Next Phase

Auto-proceeds to: `/forge:validate`

## Required Skill

**REQUIRED:** `@forge-build`
