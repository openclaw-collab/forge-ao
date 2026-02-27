# Decisions Registry

## Format

```yaml
---
id: "D{phase}{number}"
phase: "brainstorm|research|design|plan|..."
title: "Short decision title"
status: "proposed|accepted|superseded|rejected"
supersedes: []  # IDs of decisions this replaces
date: "YYYY-MM-DD"
---
```

## Active Decisions

### D{phase}{number}: Title

**Context:** What led to this decision

**Options Considered:**
1. Option A
2. Option B
3. Option C

**Decision:** The chosen path

**Rationale:** Why this was selected

**Consequences:**
- Positive:
- Negative:

**Constraints Imposed:**
- Constraint 1
- Constraint 2

**Kill-Switch Conditions:**
- [ ] Condition that would invalidate this decision

---

## Superseded Decisions

*Moved here when replaced by newer decisions*

---

## Decision Rules

1. **Decisions are immutable** - Never edit; create new decision that supersedes
2. **Every decision must reference debate** - Link to debate synthesis if applicable
3. **Decisions must specify constraints** - What they lock in for future phases
4. **Kill-switch conditions required** - When to reconsider

---

*Last updated: Automatically maintained by FORGE phases*
