---
name: forge:review
description: Comprehensive code review with parallel specialized reviewers
disable-model-invocation: true
---

# /forge:review

Comprehensive code review with parallel specialized review angles.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to review phase
.claude/forge/scripts/forge-state.sh set-phase review
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next learn

# Write artifact
cat > docs/forge/review-report.md << 'EOF'
# Review Report: [Objective]

## Findings Summary
...
EOF
```

## Process

1. **Multi-angle review** - Different perspectives
2. **Collect findings** - Synthesize results
3. **Address issues** - If found
4. **Document results** - Write to `docs/forge/review-report.md`

## Review Angles

Instead of spawning subagents, review from multiple angles:

### 1. Karpathy Guidelines Review
- Simpler is better?
- Surgical precision?
- No premature abstraction?
- Read before writing followed?
- Evidence-based?

### 2. Design Compliance Review
- Matches design specs?
- Design system followed?
- UI/UX consistent?
- Responsive correct?

### 3. Performance Review
- Unnecessary complexity?
- Inefficient algorithms?
- Memory leaks?
- Bundle size impact?

### 4. Security Review
- Input validation?
- Authentication correct?
- Authorization checks?
- Secrets handling?

### 5. Code Quality Review
- Naming clear?
- Functions focused?
- Error handling proper?
- Documentation adequate?

## AO Mode: Parallel Task Plan

In AO mode, for comprehensive review, suggest:

```bash
ao spawn <project> "review: Karpathy guidelines compliance"
ao spawn <project> "review: security audit"
ao spawn <project> "review: performance analysis"
ao spawn <project> "review: code quality"
```

Synthesize findings from all reviews.

## Acceptance Criteria

This phase is complete when:
- [ ] Karpathy guidelines compliance checked
- [ ] Design specs compliance verified
- [ ] Performance issues identified (if any)
- [ ] Security issues identified (if any)
- [ ] Code quality issues identified (if any)
- [ ] Critical issues addressed or documented
- [ ] `docs/forge/review-report.md` written
- [ ] State updated: phase=review, status=completed
- [ ] Next phase set to learn

## Phase Artifacts

**Writes to:** `docs/forge/review-report.md`

### Artifact Structure
```markdown
# Review Report: [Objective]

## Summary

**Overall Grade:** A/B/C/D
**Critical Issues:** N
**Warnings:** N
**Suggestions:** N

## Karpathy Guidelines

| Guideline | Status | Notes |
|-----------|--------|-------|
| Simpler is better | ✅ | Clean implementation |
| Surgical precision | ⚠️ | File X could be smaller |
| No premature abstraction | ✅ | Appropriate |
| Evidence-based | ✅ | Tests validate |

## Design Compliance

- UI specs: ✅/❌
- Design system: ✅/❌
- Responsive: ✅/❌
- Accessibility: ✅/❌

## Performance

| Metric | Value | Threshold | Status |
|--------|-------|-----------|--------|
| Bundle size | XKB | <YKB | ✅/❌ |
| Load time | Xms | <Yms | ✅/❌ |

## Security

- Input validation: ✅/❌
- Auth/Authz: ✅/❌
- Secrets: ✅/❌

## Critical Issues

1. **[Issue]** - Severity: Critical
   - [Description]
   - [Recommendation]

## Warnings

1. **[Warning]**
   - [Description]
   - [Recommendation]

## Suggestions

- [Suggestion 1]
- [Suggestion 2]

## Action Items

- [ ] Fix critical issue 1
- [ ] Address warning 2
```

## Karpathy Check

- Lines < 50 per edit
- One logical change
- No scope creep
- Evidence required

## Next Steps

After review:
- `/forge:learn` - Capture patterns and learnings
- `/forge:build` - If fixes needed

## Required Skill

**REQUIRED:** `@forge-review`
