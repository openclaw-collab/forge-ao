---
name: forge:debug
description: Standalone debugging workflow for bugs, test failures, or unexpected behavior - outside the main 9-phase flow
argument-hint: "[bug description or error message]"
disable-model-invocation: true
---

# /forge:debug

**Standalone debugging workflow** - Use for bugs, test failures, or unexpected behavior without running the full FORGE flow.

## When to Use

Use `/forge:debug` when:
- Production bug needs fixing
- Test is failing
- Unexpected behavior observed
- Error in logs
- Performance issue

**Do NOT use for:**
- New features (use `/forge:brainstorm`)
- Refactoring (use `/forge:plan`)
- General development (use full FORGE flow)

## Debug Workflow (4 Phases)

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Analyze   │ -> │  Reproduce  │ -> │    Fix      │ -> │   Verify    │
│    (Root)   │    │   (Confirm) │    │  (Minimal)  │    │   (Test)    │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

### Phase 1: Root Cause Analysis

**Using systematic-debugging skill:**
1. Read error messages carefully
2. Reproduce consistently
3. Check recent changes
4. Trace data flow
5. Form hypothesis

**Output:** `docs/forge/debug/root-cause.md`

### Phase 2: Reproduction

**Create minimal reproduction:**
1. Isolate the issue
2. Create failing test
3. Document exact steps
4. Confirm failure reason

**Output:** `docs/forge/debug/reproduction.md`

### Phase 3: Fix

**Minimal fix following Karpathy guidelines:**
1. Address root cause (not symptom)
2. logical change
3. Ensure changes are updated across all phases
4. TDD approach (test first if possible)

### Phase 4: Verify

**Confirm fix works:**
1. Reproduction test passes
2. All other tests pass
3. TypeScript compiles
4. No regressions

**Output:** `docs/forge/debug/verification.md`

## Usage

```bash
# Debug a failing test
/forge:debug "Login test failing with timeout error"

# Debug production bug
/forge:debug "Users report 500 error on checkout page"

# Debug from error logs
/forge:debug "TypeError: Cannot read property 'id' of undefined in user.ts:45"

# Debug performance issue
/forge:debug "Page load time increased from 1s to 5s after last deploy"
```

## Required Skill

**REQUIRED:** `@systematic-debugging`

## Integration with Full FORGE

**After debug complete:**
- If fix is trivial → Done
- If fix needs proper implementation → Continue to `/forge:plan`
- If bug reveals design flaw → Continue to `/forge:brainstorm`

## Output Files

```
docs/forge/debug/
├── root-cause.md      # Analysis and hypothesis
├── reproduction.md    # Steps to reproduce
├── fix.md            # Fix applied
└── verification.md   # Verification results
```

## Success Criteria

Debug is complete when:
- [ ] Root cause identified
- [ ] Issue reproduced consistently
- [ ] Minimal fix applied
- [ ] Fix verified with tests
- [ ] No regressions introduced

## Quick Debug vs Full Debug

| Aspect | Quick Debug | Full Debug |
|--------|-------------|------------|
| Time | < 30 minutes | As needed |
| Documentation | Minimal | Full |
| Tests | Existing tests | New test created |
| Use for | Simple bugs | Complex issues |

## Related

- `/forge:brainstorm` - For ambiguous problems needing exploration
- `/forge:plan` - For implementing proper fixes
- `/forge:test` - For creating comprehensive test coverage
