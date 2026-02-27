---
name: forge-memory
description: Use when capturing patterns, learnings, and decisions during FORGE learn phase
---

# FORGE Memory Integration

Continuous learning system that captures knowledge from each workflow execution.

## Memory Architecture

```
.claude/memory/
├── patterns/              # Reusable code patterns
│   ├── frontend/
│   ├── backend/
│   └── workflows/
├── learnings/             # Solved problems and solutions
│   ├── YYYY-MM-DD-*.md
│   └── swarm-*.md
├── decisions/             # Architecture decisions
│   └── ADR-*.md
├── entities/              # Components, libraries
│   └── [entity-name].json
└── forge/
    └── metrics.json       # FORGE-specific metrics
```

## Learn Phase Outputs

### 1. Pattern Capture

**Location:** `.claude/memory/patterns/forge/{category}/{pattern-name}.md`

```markdown
---
name: pattern-name
date: YYYY-MM-DD
source: forge-workflow-{objective}
tags: [react, animation, performance]
---

# Pattern Name

## Problem
[What problem does this solve?]

## Solution
```typescript
// Code example
```

## When to Use
- [Use case 1]
- [Use case 2]

## When NOT to Use
- [Anti-case 1]

## Related Patterns
- [pattern-name-2](./pattern-name-2.md)
```

### 2. Learning Capture

**Location:** `.claude/memory/learnings/forge/YYYY-MM-DD-{objective}.md`

```markdown
---
date: YYYY-MM-DD
objective: "Fix text rendering in recognition phase"
status: solved
time_spent: 45min
phases_used: 5
---

# Learning: {Objective}

## Problem
[Clear problem statement]

## Root Cause
[Technical explanation]

## Solution
[Step-by-step fix]

## Prevention
[How to avoid in future]

## Related Issues
- [link to related learning]
```

### 3. Decision Capture

**Location:** `.claude/memory/decisions/forge/ADR-{NNN}-{decision-name}.md`

```markdown
---
date: YYYY-MM-DD
status: accepted
---

# ADR NNN: Decision Title

## Context
[What is the issue we're deciding?]

## Decision
[What we decided]

## Consequences
- Positive: [benefits]
- Negative: [trade-offs]

## Alternatives Considered
- [Option 1]: [why rejected]
- [Option 2]: [why rejected]
```

## CLAUDE.md Auto-Update

During Learn phase, FORGE can update project CLAUDE.md:

```typescript
// Using claude-md-management skill
Skill:claude-md-management:revise-claude-md
```

**Updates include:**
- New patterns discovered
- Updated gotchas
- New common tasks
- Refreshed key learnings

## Metrics Tracking

**Location:** `.claude/memory/forge/metrics.json`

```json
{
  "workflows_completed": 12,
  "by_phase": {
    "brainstorm": { "avg_duration": 5 },
    "research": { "avg_duration": 8 },
    "design": { "avg_duration": 15 },
    "plan": { "avg_duration": 10 },
    "build": { "avg_duration": 25 },
    "test": { "avg_duration": 12 },
    "validate": { "avg_duration": 8 },
    "review": { "avg_duration": 15 },
    "learn": { "avg_duration": 5 }
  },
  "patterns_extracted": 23,
  "learnings_captured": 18,
  "tests_pass_rate": 0.94,
  "karpathy_violations": 3,
  "most_used_skills": ["frontend-design", "karpathy-guidelines"]
}
```

## Capture Protocol

**After each workflow:**

1. **Extract patterns** from implementation
2. **Document learnings** (problems solved)
3. **Capture decisions** (architectural choices)
4. **Update metrics** (timing, success rates)
5. **Update CLAUDE.md** (if significant)

**Pattern extraction criteria:**
- Novel solution to common problem
- Reusable across projects
- Non-obvious approach
- Validated by success

## Search Integration

FORGE automatically searches memory during phases:

```
Brainstorm: Search learnings for similar problems
Research:   Search patterns for relevant approaches
Design:     Search patterns for UI solutions
Plan:       Search learnings for time estimates
Build:      Search patterns for code templates
Debug:      Search learnings for similar errors
```

## Compounding Principle

Each workflow should make future workflows easier:

```
First occurrence:  Research + solve + document (30 min)
Second occurrence: Search memory + apply (5 min)
Third occurrence:  Pattern already known (2 min)
```

**Knowledge compounds.**
