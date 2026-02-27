---
name: forge:learn
description: Capture patterns, learnings, and update documentation after workflow completion
disable-model-invocation: true
---

# /forge:learn

Continuous learning with pattern extraction and CLAUDE.md updates. This command captures knowledge from completed work to make future work easier.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to learn phase
.claude/forge/scripts/forge-state.sh set-phase learn
```

**ON EXIT:**
```bash
# Mark phase complete and archive workflow
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh archive

# Write artifact
cat > docs/forge/learnings.md << 'EOF'
# Learnings: [Objective]

## Patterns Extracted
...
EOF
```

## Purpose

Document solved problems as reusable knowledge. This command captures patterns, learnings, and solutions for future reference.

**Auto-triggers with**: `/forge:insights` (which runs usage report + learn) at 5% context remaining.

## Process

### 1. Identify What Was Solved

- What problem did you solve?
- What approach did you take?
- What patterns emerged?
- What would you do differently?

### 2. Capture to Memory System

**Patterns** (`.claude/memory/patterns/`):
```json
{
  "pattern_id": "uuid",
  "name": "pattern-name",
  "category": "frontend|backend|design|architecture",
  "context": "when to use",
  "implementation": "how to implement",
  "example": "code example",
  "success_rate": 0.95,
  "source_files": ["file1.tsx"],
  "extracted_at": "2026-02-10T12:00:00Z"
}
```

**Learnings** (`.claude/memory/learnings/`):
```json
{
  "learning_id": "uuid",
  "type": "success|failure|insight|anti-pattern",
  "title": "Brief title",
  "context": "What we were trying to do",
  "what_happened": "What actually happened",
  "why": "Root cause analysis",
  "action": "What to do in the future",
  "confidence": "high|medium|low",
  "extracted_at": "2026-02-10T12:00:00Z"
}
```

**Decisions** (`.claude/memory/decisions/`):
```json
{
  "decision_id": "uuid",
  "decision": "what was decided",
  "context": "why",
  "consequences": ["expected outcomes"],
  "status": "accepted|pending|rejected",
  "date": "2026-02-10",
  "reversibility": "high|medium|low"
}
```

### 3. Update Knowledge Graph

- Link related entities
- Document relationships
- Tag with technologies
- Update temporal facts

### 4. Update CLAUDE.md

Auto-update project documentation with:
- New patterns discovered
- Updated conventions
- Learnings from failures
- Architecture decisions

## Acceptance Criteria

This phase is complete when:
- [ ] Patterns extracted to `.claude/memory/patterns/`
- [ ] Learnings recorded in `.claude/memory/learnings/`
- [ ] Decisions archived in `.claude/memory/decisions/`
- [ ] CLAUDE.md updated with new patterns
- [ ] `docs/forge/learnings.md` written
- [ ] Workflow archived
- [ ] State updated: phase=learn, status=completed

## Phase Artifacts

**Writes to:**
- `docs/forge/learnings.md`
- `.claude/memory/patterns/`
- `.claude/memory/learnings/`
- `.claude/memory/decisions/`
- `CLAUDE.md` (updated)

### Artifact Structure
```markdown
# Learnings: [Objective]

## Workflow Summary

**Completed:** [Date]
**Phases:** N/10
**Key Challenge:** [Description]

## Patterns Extracted

### [Pattern Name]
**Category:** frontend|backend|design|architecture
**Context:** When to use this pattern
**Implementation:**
```typescript
// Example code
```
**Files:** [Source files]

## Learnings

### Success: [Title]
**What:** Description of what worked
**Why:** Why it worked
**Apply:** When to apply in future

### Failure/Anti-pattern: [Title]
**What:** What didn't work
**Why:** Root cause
**Avoid:** How to avoid in future

## Decisions Made

| Decision | Context | Reversibility |
|----------|---------|---------------|
| ... | ... | ... |

## CLAUDE.md Updates

- [List of changes made]

## Compounding Effect

This workflow makes future work easier:
- First: 95 min (research + solve + document)
- Second: 10 min (search + apply)
- Third: 2 min (pattern known)
```

## Compounding Effect

Each workflow makes future work easier:
- First: 95 min (research + solve + document)
- Second: 10 min (search + apply)
- Third: 2 min (pattern known)

## Next Steps

After learn:
- Workflow is complete
- Patterns available for future use
- Resume normal development

## Required Skill

**REQUIRED:** `@forge-learn`
