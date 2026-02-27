---
name: forge-ralph
description: Use when implementing a large plan with clearly defined steps, tests, and success criteria - especially for overnight or long-running tasks
---

# FORGE Ralph Loop

**Iterative execution mode** for large plans where false success declarations are a risk.

## When to Use Ralph Loop

**Use `/forge:ralph` when:**
- Plan has 10+ steps
- Tests are clearly defined
- Success criteria is objective and verifiable
- Task will run for extended period (overnight, multiple hours)
- Risk of agent falsely declaring success is high

**Do NOT use Ralph Loop when:**
- Design decisions required (use `/forge:design`)
- Success criteria is unclear or subjective
- Human judgment needed throughout
- One-shot operation
- Debugging production issues (use systematic-debugging)

## Why Ralph Loop Helps

**The Problem:** Agents sometimes declare success prematurely:
- "Task complete" when tests actually fail
- Missing steps but claiming completion
- Not running verification commands

**The Solution:** Ralph Loop runs the SAME prompt repeatedly:
```bash
while :; do
  cat PROMPT.md | claude-code --continue
done
```

Each iteration:
1. Claude sees previous work in files
2. Continues from where it left off
3. Runs verification (tests, checks)
4. Only stops when promise detected

## Ralph Loop vs Regular FORGE

| Aspect | Regular FORGE | Ralph Loop |
|--------|---------------|------------|
| Best for | Normal development | Large plans, overnight tasks |
| Steps | 9 distinct phases | Iterative same-phase |
| Human involvement | High (decisions at each phase) | Low (set it and monitor) |
| Success verification | Per phase | Continuous |
| False success risk | Lower (human checkpoints) | Prevented by iteration |
| Time | Interactive | Can run hours/overnight |

## Usage

```bash
/forge:ralph "Implement user authentication system" \
  --plan docs/forge/plan.md \
  --test-plan docs/forge/test-plan.md \
  --completion-promise "MINOR GATES PASS: Unit tests green, TypeScript clean" \
  --final-gate "FULL GATES PASS: Integration + E2E tests pass" \
  --max-iterations 50
```

**Required flags:**
- `--plan`: Path to implementation plan
- `--test-plan`: Path to test plan (created in `/forge:test` phase)
- `--completion-promise`: Text that signals minor gate completion
- `--final-gate`: Text that signals full test suite completion
- `--max-iterations`: Safety limit (prevents infinite loops)

**Test Gates (from Test phase):**
- **Minor Gates**: Run every iteration (unit tests, type checks)
- **Full Gates**: Run before final commit (integration, E2E)

**Completion Promise Examples:**
```
"ALL TESTS PASS AND COVERAGE > 80%"
"TYPE CHECK PASSES AND BUILD SUCCEEDS"
"VERIFICATION COMPLETE: [checklist all checked]"
```

## How It Works

1. **Load Plan:** Read implementation plan
2. **Set Promise:** Define what true completion looks like
3. **Iterate:**
   - Execute next incomplete task
   - Run tests/verification
   - Check for promise in output
   - If no promise → repeat
   - If promise detected → stop
4. **Report:** Summary of iterations and final state

## Integration with FORGE Phases

**Option 1: Ralph Loop replaces Build phase**
```
Brainstorm → Research → Design → Plan → RALPH LOOP → Validate → Review → Learn
```

**Option 2: Ralph Loop within Build phase**
```
Brainstorm → Research → Design → Plan → Build (with Ralph for large tasks) → Test → Validate → Review → Learn
```

## Safety Features

**Max Iterations:**
- Prevents infinite loops
- Default: 50 iterations
- Override: `--max-iterations 100`

**Verification Required:**
- Each iteration runs tests
- Must see promise to stop
- No promise = keep working

**State Persistence:**
- Work saved in files each iteration
- Can resume if interrupted
- Git commits recommended

## Example: Overnight Task

```bash
# Start before leaving work
/forge:ralph "Complete API migration" \
  --plan docs/plans/migration.md \
  --completion-promise "MIGRATION COMPLETE: All endpoints tested, old code deleted, migration guide written" \
  --max-iterations 100

# Next morning:
# Check iteration count
# Review git log
# Run final verification
```

## Best Practices

1. **Clear Plan:** Ralph needs detailed plan with verifiable steps
2. **Objective Success:** Promise must be objectively checkable
3. **Good Tests:** Tests prevent false success declarations
4. **Regular Commits:** Each iteration should commit progress
5. **Monitor:** Check progress periodically, not just at end

## Ralph Loop + Agent Teams

**For very large tasks, combine approaches:**
1. Use Agent Teams for parallel work streams
2. Use Ralph Loop within each agent for iteration
3. Team coordinates, Ralph ensures completion

**Why this works:**
- Teams handle coordination (no classifyHandoff errors)
- Ralph ensures each agent actually completes
- Best of both approaches

## When Ralph Loop Fails

**Ralph will NOT help if:**
- Plan is unclear or incomplete
- Success criteria is subjective
- Tests don't actually verify correctness
- Task requires human design decisions

**Signs Ralph isn't right:**
- Agent stuck in loop (same error repeatedly)
- Iterations not making progress
- Promise criteria too vague

**Solution:** Fall back to regular FORGE with human checkpoints.
