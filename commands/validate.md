---
name: forge:validate
description: Verify implementation against requirements with evidence-based validation
disable-model-invocation: true
---

# /forge:validate

Quality gates with evidence-based validation against acceptance criteria.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to validate phase
.claude/forge/scripts/forge-state.sh set-phase validate
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next review

# Write artifact
cat > docs/forge/validation-report.md << 'EOF'
# Validation Report: [Objective]

## Evidence Summary
...
EOF
```

## Process

1. **Run verifications** - TypeScript, tests, build
2. **Gather evidence** - Command outputs
3. **Check criteria** - Against plan
4. **Document findings** - Write to `docs/forge/validation-report.md`
5. **User approval** - If configured

## Validation Checklist

### Functional Validation
- [ ] All requirements from plan implemented
- [ ] Acceptance criteria met
- [ ] Edge cases handled
- [ ] Error scenarios tested

### Technical Validation
- [ ] TypeScript compiles without errors
- [ ] All tests pass
- [ ] Lint checks pass
- [ ] Coverage threshold met

### Design Validation
- [ ] UI matches design specs
- [ ] Responsive behavior correct
- [ ] Accessibility requirements met
- [ ] Performance acceptable

## Evidence Required

Collect evidence for each validation:

```markdown
## Evidence

### TypeScript Compilation
```
[Command output showing success]
```

### Test Results
```
[Command output showing all tests pass]
```

### Design Compliance
- [Screenshot or reference]
```

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

## Acceptance Criteria

This phase is complete when:
- [ ] TypeScript compiles without errors
- [ ] All tests pass (unit, integration, e2e)
- [ ] Lint checks pass
- [ ] Coverage threshold met
- [ ] Design specs verified
- [ ] Acceptance criteria validated
- [ ] Evidence collected and documented
- [ ] `docs/forge/validation-report.md` written
- [ ] State updated: phase=validate, status=completed
- [ ] Next phase set to review

## Phase Artifacts

**Writes to:** `docs/forge/validation-report.md`

### Artifact Structure
```markdown
# Validation Report: [Objective]

## Summary

**Status:** ✅ PASSED / ❌ FAILED / ⚠️ PARTIAL
**Date:** [ISO timestamp]

## Requirements Validation

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Req 1 | ✅ | [Evidence] |
| Req 2 | ⚠️ | [Evidence with notes] |

## Technical Validation

### TypeScript
- Status: ✅ Pass
- Errors: 0
- Warnings: [count]

### Tests
- Unit: N/N passed
- Integration: N/N passed
- E2E: N/N passed

### Coverage
- Overall: X%
- Statements: X%
- Branches: X%

## Design Validation

- UI matches specs: ✅/❌
- Responsive: ✅/❌
- Accessible: ✅/❌

## Issues Found

- [Issue 1 and severity]
- [Issue 2 and severity]

## Recommendations

- [Recommendation 1]
- [Recommendation 2]
```

## AO Mode Considerations

In AO mode:
- Validation runs within single session
- Report is written to workspace for AO to track
- Failed validations block workflow
- AO can spawn separate validation session if needed

## Next Steps

After validate:
- `/forge:review` - Final code review
- `/forge:build` - If fixes needed

## Required Skill

**REQUIRED:** `@forge-validate`
