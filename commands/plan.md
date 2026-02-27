---
name: forge:plan
description: Create surgical implementation plans with file-level precision
argument-hint: "[feature to plan]"
disable-model-invocation: true
---

# /forge:plan

Create detailed, surgical implementation plans with file-level precision.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to plan phase
.claude/forge/scripts/forge-state.sh set-phase plan
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next test

# Write artifact
cat > docs/forge/plan.md << 'EOF'
# Plan: [Objective]

## Implementation Steps
...
EOF
```

## Usage

```bash
/forge:plan "user authentication system"
/forge:plan "API rate limiting"
/forge:plan "database migration"
```

## Process

1. **Read existing code** - Understand current architecture
2. **Define surgical changes** - File-by-file modifications
3. **Identify dependencies** - What must change first
4. **Estimate effort** - Time/complexity for each step
5. **Document plan** - Write to `docs/forge/plan.md`

## Surgical Planning Principles

Following Karpathy guidelines:

- **Minimal surface area** - Touch fewest files possible
- **Clear ordering** - Dependencies explicitly stated
- **Testable chunks** - Each step verifiable
- **Rollback plan** - How to undo if needed

## Plan Structure

```markdown
## Implementation Steps

### Step 1: [Name]
**Files:** `src/file.ts`, `src/other.ts`
**Changes:**
- Add function X to file.ts
- Update type Y in other.ts
**Tests:** Verify Z
**Estimated:** 30 min
**Blocked by:** None

### Step 2: [Name]
...
```

## AO Mode Considerations

In AO mode:
- Plans should include checkpoints for AO to verify
- Consider breaking large plans into multiple AO sessions
- Include "commit points" where AO can snapshot progress

## Acceptance Criteria

This phase is complete when:
- [ ] Existing codebase analyzed
- [ ] All files to modify identified
- [ ] Changes specified file-by-file
- [ ] Dependencies mapped and ordered
- [ ] Test approach defined for each step
- [ ] Effort estimated for each step
- [ ] Total effort estimated
- [ ] `docs/forge/plan.md` written
- [ ] State updated: phase=plan, status=completed
- [ ] Next phase set to test

## Phase Artifacts

**Writes to:** `docs/forge/plan.md`

### Artifact Structure
```markdown
# Plan: [Objective]

## Overview

**Approach:** [Brief description]
**Estimated Effort:** [X hours]
**Risk Level:** Low/Medium/High

## Prerequisites

- [ ] List of things needed before starting

## Implementation Steps

### Step N: [Name]

**Files to Modify:**
- `path/to/file.ts` - [what to change]
- `path/to/other.ts` - [what to change]

**Implementation:**
```typescript
// Specific code to add/modify
```

**Tests to Add:**
- Test case 1
- Test case 2

**Verification:**
- How to verify this step works

**Estimated:** [time]
**Blocked by:** [Step X] or None

## Rollback Plan

If issues arise:
1. Step to revert
2. Recovery procedure

## Checkpoints

- [ ] Checkpoint 1: After Step N
- [ ] Checkpoint 2: After Step M
```

## Next Steps

After plan, continue with:
- `/forge:test` - Create test strategy
- `/forge:build` - Skip to implementation

## Required Skill

**REQUIRED:** `@forge-plan`
