---
name: forge-context
description: Use when loading or updating progressive context across FORGE workflow phases
---

# FORGE Progressive Context

BMAD-inspired progressive context building - each phase outputs documents that inform the next.

## Context Architecture

```
Phase 1: BRAINSTORM    → docs/forge/brainstorm.md
Phase 2: RESEARCH      → docs/forge/research.md
Phase 3: DESIGN        → docs/forge/design.md
Phase 4: PLAN          → docs/forge/plan.md
Phase 5: BUILD         → Working code
Phase 6: TEST          → docs/forge/test-results.md
Phase 7: VALIDATE      → docs/forge/validation.md
Phase 8: REVIEW        → docs/forge/review.md
Phase 9: LEARN         → .claude/memory/

ACCUMULATING: docs/forge/project-context.md ("constitution")
```

## Project Context (Constitution)

The `docs/forge/project-context.md` is a living document loaded by every phase:

```markdown
---
updated: YYYY-MM-DD
---

# Project Context

## Technology Stack
- Framework: React 19 + TypeScript
- Styling: Tailwind CSS 4
- Backend: Cloudflare Workers + Hono
- Database: D1

## Critical Rules
1. NO unused variables (TypeScript strict mode)
2. Use AuthContext, never direct localStorage
3. Credit check: isUnlimitedPlan() before chargeCredits()

## Design System
- Colors: paper-base #F3EEE3, blueprint-navy #1E3A5F, stamp-red #C53030
- Fonts: Source Serif 4 (headlines), Inter (UI), JetBrains Mono (code)
- Animations: EASING.entrance [0.0, 0, 0.2, 1]

## Known Patterns
- Form stagger: delay 0.5 + i * 0.1
- Error seal: bg-stamp-red/10, border-2, drop animation
- 3D buttons: whileHover={{ y: -1 }}, whileTap={{ y: 2 }}
```

## Phase-to-Phase Context Flow

### Brainstorm → Research
```
brainstorm.md outputs:
- Selected approach
- Key decisions
- Open questions

research.md loads:
- Selected approach (focus research)
- Open questions (research targets)
```

### Research → Design
```
research.md outputs:
- Patterns discovered
- Best practices found
- Similar implementations

design.md loads:
- Patterns (apply to design)
- Best practices (compliance check)
```

### Design → Plan
```
design.md outputs:
- UI specs
- Component structure
- Asset requirements

plan.md loads:
- Component structure (file list)
- Asset requirements (dependencies)
- UI specs (acceptance criteria)
```

### Plan → Build
```
plan.md outputs:
- Task list with file paths
- Validation criteria per task
- Test strategy

build phase loads:
- Exact task list
- File paths for each task
- Validation criteria (exit conditions)
```

## Context Loading Protocol

**Each phase MUST:**
1. Read project-context.md (if exists)
2. Read previous phase output (if exists)
3. Write phase output when complete
4. Update project-context.md if new patterns discovered

**Context loading order:**
1. Load forge-config (settings)
2. Load project-context.md (accumulated knowledge)
3. Load previous phase output (immediate context)
4. Load relevant skills (dynamic based on task)
5. Execute phase
6. Write phase output
7. Update project-context.md (if needed)

## Artifact Management by Level

### Minimal
- Keep: project-context.md, plan.md, learn.md
- Skip: All intermediate phase docs

### Intelligent
- Keep: project-context.md, brainstorm.md, plan.md, test-results.md, review.md, learn.md
- Skip: research.md, design.md (incorporate into plan)

### Maximal
- Keep: All 9 phase documents
- Plus: Intermediate decision logs

## Context Persistence

**Temporary (phase outputs):**
- Stored in `docs/forge/`
- Can be cleaned up per artifact level
- Used for phase-to-phase handoff

**Permanent (memory):**
- Stored in `.claude/memory/`
- Patterns, learnings, decisions
- Cross-session persistence

## Context Size Management

**When context grows too large:**
1. Summarize old phase outputs
2. Extract key decisions to project-context.md
3. Archive full outputs to `docs/forge/archive/`
4. Keep only summaries in active docs

## Cross-Reference Format

When referring to previous phases:

```markdown
**Context from [Phase]:**
- See: [docs/forge/previous-phase.md#section]
- Key decision: [summary]
- Relevant code: [file:line]
```
