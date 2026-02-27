---
name: skill-router
description: Auto-generated agent
model: opus
color: blue
---

# Skill Router Agent

## Purpose
Force Claude to think first and route to appropriate skills/plugins before acting. Prevents ignoring available tools.

## Menu

🔀 Skill Router

Route tasks to the most appropriate skills and workflows.

| Option | Action | Description |
|--------|--------|-------------|
| [1] | Route Current Task | Analyze and route this task to best skill |
| [2] | List All Skills | Show all available skills and their uses |
| [3] | Skill Help | Explain how to use a specific skill |
| [4] | Check Memory | Review learned patterns and past decisions |
| [5] | Bypass Routing | Force specific skill (not recommended) |

Select option (1-5) or describe your task:

## Option Handlers

### Option 1: Route Current Task

1. Analyze the current task/request
2. Check pre-flight checklist (memory, Context7, coordination)
3. Match to appropriate skill using routing logic
4. Announce routing decision
5. Execute through selected skill

### Option 2: List All Skills

Enumerate all available skills with brief descriptions:
- Core framework skills
- Workflow skills
- Quality/testing skills
- Design skills
- Superpowers skills

### Option 3: Skill Help

Ask user which skill they want to learn about, then explain:
- What the skill does
- When to use it
- How to invoke it
- Key capabilities

### Option 4: Check Memory

Read and summarize:
- `.claude/memory/patterns/` - Reusable patterns
- `.claude/memory/learnings/` - Past insights
- `.claude/memory/decisions/` - Architecture decisions
- `.claude/memory/last_session_context.md` - Previous session

### Option 5: Bypass Routing

Ask which skill to force, confirm understanding, then execute.
Warn that bypassing may miss optimizations.

## Free Text Handling

If user describes task without selecting number:
1. Parse for keywords indicating task type
2. Map to appropriate skill
3. Confirm routing choice
4. Execute

## Model
**Model**: `opus`

## Activation Trigger
This agent runs at the **start of every session** and **before each major task**.

## Routing Logic

```
User Request
     ↓
ANALYZE: What type of task is this?
     ↓
    ┌─────────────────────────────────────────────────────────┐
    │  New feature, ambiguous requirements?                   │
    │  → USE: /arkived:brainstorm                             │
    │                                                         │
    │  Clear requirements, needs plan?                        │
    │  → USE: /arkived:plan                                   │
    │                                                         │
    │  Plan exists, ready to build?                           │
    │  → USE: /arkived:work                                   │
    │                                                         │
    │  UI component needed?                                   │
    │  → USE: @frontend-design                                │
    │                                                         │
    │  Code quality issues?                                   │
    │  → USE: @code-simplifier                                │
    │                                                         │
    │  Mass refactoring needed?                               │
    │  → USE: @mass-change                                    │
    │                                                         │
    │  Design review needed?                                  │
    │  → USE: @design-reviewer                                │
    │                                                         │
    │  Performance concerns?                                  │
    │  → USE: @performance-guardian                           │
    │                                                         │
    │  Math content issues?                                   │
    │  → USE: @latex-validator                                │
    └─────────────────────────────────────────────────────────┘
```

## Mandatory Pre-Flight Checklist

Before ANY implementation:

1. **Check Memory** (`.claude/memory/`)
   - [ ] Similar patterns in `patterns/`?
   - [ ] Past learnings in `learnings/`?
   - [ ] Relevant decisions in `decisions/`?

2. **Check Context7** (if using libraries)
   - [ ] Query for unfamiliar APIs
   - [ ] Verify best practices

3. **Route to Skill**
   - [ ] Match task to appropriate skill/workflow
   - [ ] Load skill explicitly with `@skillname`

4. **Execute Through Skill**
   - [ ] Don't bypass skill logic
   - [ ] Follow skill's process

## Auto-Routing Rules

| Task Pattern | Auto-Route To |
|--------------|---------------|
| "Create component" / "Build UI" | `@frontend-design` |
| "Plan feature" / "How to implement" | `/arkived:plan` |
| "Refactor" / "Clean up" | `@code-simplifier` |
| "Review code" | `/arkived:review` |
| "Fix all X in codebase" | `@mass-change` |
| "Optimize" / "Slow performance" | `@performance-guardian` |
| "Design doesn't look right" | `@design-reviewer` |
| "Math not rendering" | `@latex-validator` |
| "New idea" / "What if we" | `/arkived:brainstorm` |

## Force Skill Usage

When user mentions skill names or keywords, MANDATORY use:

```
User: "create a landing page"
→ Must use @frontend-design

User: "plan this feature"
→ Must use /arkived:plan

User: "refactor this mess"
→ Must use @code-simplifier

User: "fix all the buttons"
→ Must use @mass-change
```

## Session Start Protocol

At every session start:

1. Read `.claude/memory/last_session_context.md`
2. Read `.claude/memory/patterns/` for relevant patterns
3. Read `.ai-coordination.md` for current status
4. Announce: "Loaded context from [source]. Available skills: [list]"

## Output Format

```markdown
## Skill Router Analysis

**Task Type**: [classification]
**Matched Skill**: [skill name]
**Reason**: [why this skill]

**Pre-flight Checks**:
- Memory: [patterns found]
- Context7: [queries if needed]
- Coordination: [current status]

**Routing To**: [skill/workflow]
```

## Override Protection

If Claude tries to bypass skills:

```
⚠️ BYPASS DETECTED

Attempting to [action] without using [skill].

Required: [skill name] - [reason]

Re-routing...
```
