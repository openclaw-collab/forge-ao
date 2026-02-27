# FORGE Agent Rules (Quick Reference)

## Golden Rules

1. **State First**: Always update `active-workflow.md` on phase entry/exit
2. **No Subagents**: In AO mode, produce parallel task plans instead of spawning
3. **Artifact Required**: Every phase writes to `docs/forge/`
4. **AO Sync**: Metadata auto-syncs when `AO_SESSION` is present
5. **Evidence-Based**: Verify before claiming completion

## Phase Checklist

### Initialize
- [ ] Update state: phase=initialize, status=in_progress
- [ ] Detect project type
- [ ] Configure FORGE for project
- [ ] Write artifact: `docs/forge/initialization.md`
- [ ] Update state: completed_phases=[initialize], next_phase=brainstorm

### Brainstorm
- [ ] Update state: phase=brainstorm, status=in_progress
- [ ] Generate multiple approaches (4+ angles)
- [ ] Document tradeoffs
- [ ] Select recommended approach
- [ ] Write artifact: `docs/forge/brainstorm.md`
- [ ] Update state: completed_phases+=[brainstorm], next_phase=research

### Research
- [ ] Update state: phase=research, status=in_progress
- [ ] Validate technical feasibility
- [ ] Check existing patterns
- [ ] Identify risks
- [ ] Write artifact: `docs/forge/research.md`
- [ ] Update state: completed_phases+=[research], next_phase=design

### Design
- [ ] Update state: phase=design, status=in_progress
- [ ] Create UI designs (if applicable)
- [ ] Define technical design
- [ ] Document APIs/contracts
- [ ] Write artifact: `docs/forge/design.md`
- [ ] Update state: completed_phases+=[design], next_phase=plan

### Plan
- [ ] Update state: phase=plan, status=in_progress
- [ ] Break into surgical steps
- [ ] Identify files to modify
- [ ] Estimate effort
- [ ] Write artifact: `docs/forge/plan.md`
- [ ] Update state: completed_phases+=[plan], next_phase=test

### Test Strategy
- [ ] Update state: phase=test, status=in_progress
- [ ] Define test approach
- [ ] Create test scaffolding
- [ ] Write test cases (before implementation)
- [ ] Write artifact: `docs/forge/test-strategy.md`
- [ ] Update state: completed_phases+=[test], next_phase=build

### Build
- [ ] Update state: phase=build, status=in_progress
- [ ] Implement with TDD discipline
- [ ] Ralph loop: test → fix → commit → repeat
- [ ] Document changes
- [ ] Write artifact: `docs/forge/build-log.md`
- [ ] Update state: completed_phases+=[build], next_phase=validate

### Validate
- [ ] Update state: phase=validate, status=in_progress
- [ ] Run full test suite
- [ ] Verify against requirements
- [ ] Check edge cases
- [ ] Write artifact: `docs/forge/validation-report.md`
- [ ] Update state: completed_phases+=[validate], next_phase=review

### Review
- [ ] Update state: phase=review, status=in_progress
- [ ] Code quality check
- [ ] Security review
- [ ] Performance check
- [ ] Write artifact: `docs/forge/review-report.md`
- [ ] Update state: completed_phases+=[review], next_phase=learn

### Learn
- [ ] Update state: phase=learn, status=in_progress
- [ ] Extract patterns
- [ ] Document decisions
- [ ] Update CLAUDE.md if needed
- [ ] Write artifact: `docs/forge/learnings.md`
- [ ] Archive workflow
- [ ] Update state: status=completed

## State Update Commands

```bash
# Initialize workflow
.claude/forge/scripts/forge-state.sh init \
  --objective "Implement feature X" \
  --issue "123" \
  --branch "feature/x"

# Set phase
.claude/forge/scripts/forge-state.sh set-phase brainstorm

# Mark phase complete
.claude/forge/scripts/forge-state.sh complete-phase

# Set next phase
.claude/forge/scripts/forge-state.sh set-next research
```

## Emergency Commands

```
/forge:continue - Resume from last state
/forge:status   - Show current workflow state
/forge:help     - Get context-aware guidance
```
