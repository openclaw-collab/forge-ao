---
name: forge:review
description: Comprehensive code review with parallel specialized reviewers - AO-native
disable-model-invocation: true
---

# /forge:review

Comprehensive code review with parallel specialized review angles. AO-native only - no standalone mode, no prompts, file-based state.

---

## Phase Entry Protocol

### Step 1: Read Prerequisites

```bash
# Read these files before execution:
cat docs/forge/knowledge/decisions.md
cat docs/forge/knowledge/constraints.md
cat docs/forge/validation-report.md
cat docs/forge/handoffs/validate-to-review.md
```

### Step 2: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: review
phase_status: in_progress
phase_started_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
  - validate
---
```

---

## Phase Execution

### Step 1: Generate Review Document

Write to `docs/forge/phases/review.md`:

```markdown
---
phase: review
generated_at: "<ISO-timestamp>"
objective: "<from validate handoff>"
status: in_progress
---

# Review: [Objective]

## Context

### From Validation Phase
[Summary from validate-to-review.md handoff]

### Validation Results
- Status: [Passed/Partial]
- Gates passed: [N]/[Total]
- Known issues: [N resolved, N outstanding]

### Files to Review
[List from implementation plan]

### Constraints Applied
[List relevant constraints from constraints.md]

## Review Angles

### 1. Karpathy Guidelines Review

| Guideline | Assessment | Evidence | Status |
|-----------|------------|----------|--------|
| Simpler is better | [Assessment] | [File:line] | ✅/⚠️/❌ |
| Surgical precision | [Assessment] | [Files touched] | ✅/⚠️/❌ |
| No premature abstraction | [Assessment] | [Example] | ✅/⚠️/❌ |
| Read before writing | [Assessment] | [Evidence] | ✅/⚠️/❌ |
| Evidence-based | [Assessment] | [Tests exist] | ✅/⚠️/❌ |
| Lines per edit < 50 | [Assessment] | [Avg lines] | ✅/⚠️/❌ |
| One logical change | [Assessment] | [Commit analysis] | ✅/⚠️/❌ |
| No scope creep | [Assessment] | [vs plan] | ✅/⚠️/❌ |

**Karpathy Score:** [X]/8 guidelines followed

### 2. Design Compliance Review

| Spec | Verification | Status |
|------|--------------|--------|
| Matches design.md | [Comparison] | ✅/⚠️/❌ |
| Design system followed | [Check] | ✅/⚠️/❌ |
| UI/UX consistent | [Check] | ✅/⚠️/❌ |
| Responsive correct | [Check] | ✅/⚠️/❌ |
| Accessibility met | [a11y check] | ✅/⚠️/❌ |

### 3. Performance Review

| Aspect | Finding | Severity | Recommendation |
|--------|---------|----------|----------------|
| Unnecessary complexity | [Finding] | High/Med/Low | [Rec] |
| Algorithm efficiency | [Finding] | High/Med/Low | [Rec] |
| Memory usage | [Finding] | High/Med/Low | [Rec] |
| Bundle size impact | [Finding] | High/Med/Low | [Rec] |
| N+1 queries | [Finding] | High/Med/Low | [Rec] |

### 4. Security Review

| Check | Finding | Severity | Status |
|-------|---------|----------|--------|
| Input validation | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Authentication correct | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Authorization checks | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Secrets handling | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Injection prevention | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| XSS prevention | [Finding] | High/Med/Low | ✅/⚠️/❌ |

### 5. Code Quality Review

| Aspect | Finding | Severity | Status |
|--------|---------|----------|--------|
| Naming clear | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Functions focused | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Error handling proper | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Documentation adequate | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Type safety | [Finding] | High/Med/Low | ✅/⚠️/❌ |
| Test coverage | [Finding] | High/Med/Low | ✅/⚠️/❌ |

## Findings Summary

### Critical Issues (Block Release)
| ID | Issue | Location | Fix Required |
|----|-------|----------|--------------|
| C1 | [Description] | [File:line] | Yes |

### High Priority Issues
| ID | Issue | Location | Recommendation |
|----|-------|----------|----------------|
| H1 | [Description] | [File:line] | [Rec] |

### Medium Priority Issues
| ID | Issue | Location | Recommendation |
|----|-------|----------|----------------|
| M1 | [Description] | [File:line] | [Rec] |

### Low Priority / Suggestions
| ID | Suggestion | Location |
|----|------------|----------|
| L1 | [Suggestion] | [File:line] |

## Code Review Checklist

- [ ] No secrets in code
- [ ] No console.logs in production code
- [ ] Error handling in all async paths
- [ ] Type safety maintained
- [ ] No commented-out code
- [ ] Consistent naming conventions
- [ ] Proper JSDoc/comments
- [ ] Tests cover edge cases
- [ ] No unnecessary dependencies
- [ ] Bundle size acceptable
```

### Step 2: Execute Multi-Angle Review

Review from all angles within single AO session:

```bash
# Review each file from plan
for file in [files from plan]; do
  # Karpathy check
  # Design compliance check
  # Performance check
  # Security check
  # Quality check
done
```

---

## Phase Exit Protocol

### Step 1: Write Final Review Report

Write to `docs/forge/review-report.md`:

```markdown
---
phase: review
completed_at: "<ISO-timestamp>"
objective: "<objective>"
status: complete
---

# Review Report: [Objective]

## Summary

**Overall Grade:** A/B/C/D
**Critical Issues:** [N]
**High Priority:** [N]
**Medium Priority:** [N]
**Suggestions:** [N]

**Recommendation:** Approve / Approve with changes / Request changes

## Grade Breakdown

| Category | Score | Weight | Weighted |
|----------|-------|--------|----------|
| Karpathy Guidelines | X/8 | 25% | X |
| Design Compliance | X/5 | 20% | X |
| Performance | X/5 | 20% | X |
| Security | X/6 | 20% | X |
| Code Quality | X/6 | 15% | X |
| **Overall** | | | **X%** |

## Critical Issues (Must Fix)

| ID | Issue | File | Fix Required |
|----|-------|------|--------------|
| C1 | [Description] | [File] | [What to do] |

## Action Items

### Required (Block Merge)
- [ ] Fix C1: [Description]
- [ ] Fix H1: [Description]

### Recommended (Should Fix)
- [ ] Address M1: [Description]
- [ ] Address M2: [Description]

### Optional (Nice to Have)
- [ ] Consider L1: [Suggestion]

## Positive Findings

- [What was done well]
- [Clean implementation examples]

## Full Review Document

See: `docs/forge/phases/review.md`
```

### Step 2: Write Handoff Document

Write to `docs/forge/handoffs/review-to-learn.md`:

```markdown
---
from_phase: review
to_phase: learn
generated_at: "<ISO-timestamp>"
workflow_id: "<workflow-id>"
status: final
---

# Phase Handoff: review → learn

## Summary

### What Was Done
Comprehensive multi-angle code review completed.

### Key Outcomes
- Review grade: [A/B/C/D]
- Critical issues: [N]
- High priority: [N]
- Recommendation: [Approve/Changes requested]

## Review Results

### Grade by Category
| Category | Score | Notes |
|----------|-------|-------|
| Karpathy Guidelines | X/8 | [Brief] |
| Design Compliance | X/5 | [Brief] |
| Performance | X/5 | [Brief] |
| Security | X/6 | [Brief] |
| Code Quality | X/6 | [Brief] |

### Issues Summary
| Severity | Count | Resolved | Outstanding |
|----------|-------|----------|-------------|
| Critical | [N] | [N] | [N] |
| High | [N] | [N] | [N] |
| Medium | [N] | [N] | [N] |
| Low | [N] | [N] | [N] |

## For Learn Phase

### Patterns to Extract
| Pattern | Location | Quality | Notes |
|---------|----------|---------|-------|
| [Pattern 1] | [File] | Good/Bad | [Why] |
| [Pattern 2] | [File] | Good/Bad | [Why] |

### Learnings to Capture
| Type | Topic | Context |
|------|-------|---------|
| Success | [What worked] | [Context] |
| Anti-pattern | [What to avoid] | [Context] |

### Decisions to Archive
| Decision | Context | Outcome |
|----------|---------|---------|
| [Decision] | [Why made] | [Result] |

## Artifacts Produced

| Artifact | Location | Status |
|----------|----------|--------|
| Review Detail | docs/forge/phases/review.md | Complete |
| Review Report | docs/forge/review-report.md | Complete |

## Reference Materials

- Phase output: `docs/forge/phases/review.md`
- Validation Report: `docs/forge/validation-report.md`
- Implementation Plan: `docs/forge/phases/plan.md`
- Design: `docs/forge/phases/design.md`

## Sign-off

Phase completed: Yes
Blocked by: None
Ready to proceed: Yes
```

### Step 3: Update active-workflow.md

```yaml
---
workflow_id: "<workflow-id>"
current_phase: review
phase_status: completed
phase_started_at: "<ISO-timestamp>"
phase_completed_at: "<ISO-timestamp>"
completed_phases:
  - brainstorm
  - research
  - design
  - plan
  - test
  - build
  - validate
  - review
next_phase: learn
---
```

---

## Acceptance Criteria

Phase completes when:

- [x] Phase Entry Protocol executed (all reads completed)
- [x] Karpathy guidelines compliance checked
- [x] Design specs compliance verified
- [x] Performance issues identified (if any)
- [x] Security issues identified (if any)
- [x] Code quality issues identified (if any)
- [x] Critical issues documented
- [x] High priority issues documented
- [x] Medium/low issues documented
- [x] Overall grade assigned
- [x] Recommendation made
- [x] `docs/forge/phases/review.md` written
- [x] `docs/forge/review-report.md` written
- [x] `docs/forge/handoffs/review-to-learn.md` written
- [x] `docs/forge/active-workflow.md` updated

---

## Next Phase

Auto-proceeds to: `/forge:learn` (pattern extraction and workflow completion)

---

## Required Skill

**REQUIRED:** `@forge-review`

---

## Key Principles

1. **Multi-Angle Review** - All perspectives in single session
2. **Karpathy Compliance** - Strict adherence to guidelines
3. **No standalone mode** - AO-native only
4. **Non-interactive** - No prompts, no menus, file-based state only
5. **Evidence-Based** - Specific file:line references
6. **Graded Assessment** - Clear A/B/C/D rating

---

## File Structure

```
docs/forge/
├── active-workflow.md              # Updated on entry/exit
├── review-report.md                # Final artifact
├── phases/
│   └── review.md                  # Detailed review findings
├── handoffs/
│   ├── validate-to-review.md      # Input (read)
│   └── review-to-learn.md         # Output (write)
└── knowledge/
    ├── decisions.md               # Read on entry
    └── constraints.md             # Read on entry
```
