---
name: forge:ralph
description: Internalized iterative execution loop - no external dependencies
disable-model-invocation: true
---

# /forge:ralph

**Internalized iterative execution loop** - Implements the Ralph pattern directly without external dependencies.

## CRITICAL: No External Dependencies

The Ralph Loop is now **internalized** into FORGE core. No external `/ralph-wiggum` plugin needed.

## Usage

```bash
# Start Ralph Loop for large task
/forge:ralph "Implement user authentication" \
  --plan docs/forge/plan.md \
  --completion-promise "ALL TESTS PASS" \
  --max-iterations 50
```

## Ralph Loop Pattern (Internalized)

```bash
# The Ralph pattern is now built into /forge:build
# Automatically applied when:
# - Plan has 5+ tasks
# - Tests are defined
# - Running in extended mode

LOOP until completion_promise fulfilled:
  1. Execute current task
  2. Run tests
  3. If tests fail:
     - Analyze failure
     - Make minimal fix
     - COMMIT fix
     - Increment iteration counter
     - CONTINUE loop
  4. If tests pass:
     - Mark task complete
     - COMMIT progress
     - Move to next task
     - CHECK if all tasks done
     - If all done and promise fulfilled:
       - EXIT loop
```

## AO Mode vs Standalone

| Aspect | AO Mode | Standalone |
|--------|---------|------------|
| Loop execution | Sequential in session | Sequential in session |
| Test verification | Every iteration | Every iteration |
| Commit frequency | Each fix | Each fix |
| Max iterations | Enforced | Enforced |

**In both modes: NO internal subagents spawned.**

## Integration with Build Phase

Ralph Loop is automatically applied in `/forge:build` when:
- Task count > 5
- `--ralph` flag provided
- Long-running task detected

```bash
# Automatic Ralph Loop
/forge:build --ralph

# Or direct Ralph command for specific objective
/forge:ralph "Complete migration" --plan docs/forge/plan.md
```

## Max Iterations Protection

To prevent infinite loops:
- Default max: 50 iterations
- Configurable via `--max-iterations`
- After max: document issue, manual intervention required

## Completion Promise

The "promise" is text that must appear in output to signal completion:

```bash
--completion-promise "ALL TESTS PASS"
--completion-promise "MIGRATION VERIFIED"
--completion-promise "REFACTORING COMPLETE"
```

## When to Use

**Use Ralph Loop when:**
- Plan has 10+ steps
- Tests are clearly defined
- Success criteria is objective
- Extended runtime expected

**Built into Build phase:**
- You usually don't need to call `/forge:ralph` directly
- Use `/forge:build --ralph` instead

## Required Skill

**REQUIRED:** `@forge-ralph`
