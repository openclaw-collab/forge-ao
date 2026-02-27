---
name: menu-system
description: Use when designing agent interactions, creating guided workflows, or implementing user-facing agent menus. Provides patterns for interactive menu-driven experiences.
---

# Menu System for Agents

## Overview

Menu-driven agent interactions improve usability by presenting clear options instead of requiring users to know what to ask. Every agent should present a menu when activated.

## Menu Pattern

### Standard Menu Format

```markdown
## [Agent Name] Menu

[Emoji] [Title]

[1] [Option 1]     - [Brief description]
[2] [Option 2]     - [Brief description]
[3] [Option 3]     - [Brief description]
[4] [Option 4]     - [Brief description]
[5] [Option 5]     - [Brief description]

Select option (1-N) or describe what you need:
```

### Menu Principles

1. **Clear Options** - Each option has a number and description
2. **Concise Descriptions** - Brief explanation of what each option does
3. **Wait for Input** - Agent pauses after presenting menu
4. **Handle Free Text** - Users can type their need instead of selecting number
5. **Contextual Menus** - Show relevant options based on context

## Agent Menu Templates

### Skill Router Menu

```
🔀 Skill Router

Route tasks to appropriate skills automatically.

[1] Route Current Task   - Analyze and route this task
[2] List Available Skills - Show all skills I can use
[3] Skill Help           - Explain a specific skill
[4] Bypass Routing       - Force specific skill

What would you like to do?
```

### Brainstormer Menu

```
🧠 Brainstormer

Explore ideas from multiple angles.

[1] Technical Approach   - Feasibility and implementation
[2] User Experience      - UX and usability angles
[3] Pragmatic View       - Simplicity and constraints
[4] Risk Analysis        - Edge cases and pitfalls
[5] Full Exploration     - All angles in parallel

What aspect should we explore?
```

### Researcher Menu

```
🔍 Researcher

Gather information and best practices.

[1] Codebase Analysis    - Understand current patterns
[2] Best Practices       - Industry standards
[3] Technology Review    - Evaluate options
[4] Documentation        - Find relevant docs
[5] Deep Dive            - Comprehensive research

What should I research?
```

### Builder Menu

```
🔨 Builder

Implement features with TDD discipline.

[1] TDD Mode            - Red-Green-Refactor cycle
[2] Feature Implementation - Build with tests
[3] Refactoring         - Improve existing code
[4] Bug Fix             - Fix with regression test
[5] Pair Programming    - Guide through implementation

What should we build?
```

### Security Reviewer Menu

```
🔒 Security Reviewer

Audit code for security vulnerabilities.

[1] Full Security Audit  - Comprehensive scan
[2] OWASP Top 10         - Check common vulnerabilities
[3] Authentication       - Auth/AuthZ review
[4] Input Validation     - Injection prevention
[5] Dependency Check     - Known vulnerabilities

What security concern should I focus on?
```

### Design Reviewer Menu

```
🎨 Design Reviewer

Validate UI/UX against design systems.

[1] Visual Design       - Aesthetics and branding
[2] UX Patterns         - Usability and flow
[3] Accessibility       - WCAG compliance
[4] Responsive          - Mobile/desktop adaptation
[5] Component Structure - Architecture review

What design aspect should I review?
```

### Performance Guardian Menu

```
⚡ Performance Guardian

Optimize for speed and efficiency.

[1] Bundle Analysis     - Size optimization
[2] Runtime Performance - Execution speed
[3] Memory Usage        - Memory leaks/optimization
[4] Database Queries    - Query optimization
[5] Full Audit          - Comprehensive analysis

What performance area should I analyze?
```

### Mass Change Menu

```
🔄 Mass Change

Execute large-scale refactoring safely.

[1] Rename Symbol       - Rename across codebase
[2] Extract Pattern     - Create reusable abstraction
[3] Update API          - Migrate API usage
[4] Format Standardize  - Enforce code style
[5] Custom Refactor     - Describe your change

What refactoring should we perform?
```

### Archivist Menu

```
📚 Archivist

Capture and organize knowledge.

[1] Extract Pattern     - Document reusable pattern
[2] Capture Learning    - Record insight from work
[3] Update CLAUDE.md    - Refresh project memory
[4] Create Decision Record - Document architecture decision
[5] Knowledge Graph     - Update entity relationships

What knowledge should we capture?
```

## Implementation Pattern

### Agent File Structure

```markdown
---
name: agent-name
description: Agent role and when to use
tools: [...]
triggers: [...]
---

# Agent Name

Brief description of agent's purpose.

## Menu

[Present menu as shown above]

## Option Handlers

### Option 1: [Name]

Instructions for handling this option...

### Option 2: [Name]

Instructions for handling this option...

## Free Text Handling

If user describes need instead of selecting number:
1. Parse intent
2. Map to closest option
3. Confirm understanding
4. Execute
```

## Menu System Skill

### When to Use

Agents should present menus:
- On explicit activation (`@agent-name`)
- When triggered but context is ambiguous
- When multiple valid approaches exist
- For complex tasks requiring user direction

### When NOT to Use

Menus are optional when:
- Context clearly indicates specific action
- Agent is part of automated workflow
- Single obvious path exists

### Menu Design Tips

1. **3-7 Options** - Too few feels limiting, too many overwhelming
2. **Logical Grouping** - Group related options together
3. **Clear Hierarchies** - Most common options first
4. **Exit Option** - Always provide way to exit or try different approach
5. **Shortcuts** - Support both numbers and keywords ("1" or "technical")

## Example: Complete Agent with Menu

```markdown
---
name: example-agent
description: Example agent demonstrating menu system
---

# Example Agent

Does example things.

## Menu

🎯 Example Agent

[1] Do Thing A    - Description of A
[2] Do Thing B    - Description of B
[3] Do Thing C    - Description of C

What would you like to do?

## Handlers

### Option 1: Do Thing A

1. Validate prerequisites
2. Execute thing A
3. Report results

### Option 2: Do Thing B

1. Analyze context
2. Execute thing B
3. Verify outcome

### Option 3: Do Thing C

1. Check dependencies
2. Execute thing C
3. Clean up

## Free Text

Parse user input for keywords:
- "A", "first", "thing a" → Option 1
- "B", "second", "thing b" → Option 2
- "C", "third", "thing c" → Option 3
```

## Integration with FORGE

Use menu system in:
- `/forge:brainstorm` - Brainstormer agent menu
- `/forge:research` - Researcher agent menu
- `/forge:build` - Builder agent menu
- `/forge:review` - Reviewer agent menus
- `/forge:learn` - Archivist agent menu

## Best Practices

1. **Consistent Format** - Same structure across all agents
2. **Emoji Icons** - Visual differentiation
3. **Help Text** - Brief but descriptive
4. **Error Handling** - Graceful handling of invalid input
5. **Confirmation** - Confirm before destructive actions
