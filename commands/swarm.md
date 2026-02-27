---
name: forge:swarm
description: Generate parallel task plans for AO execution or run sequential tasks
argument-hint: "[task description] [--sequential|--plan-only]"
disable-model-invocation: true
---

# /forge:swarm

Generate parallel task plans for AO execution, or run sequential tasks in standalone mode.

## CRITICAL: AO Mode Behavior

**In AO mode (AO_SESSION set), this command ONLY generates plans.**

FORGE never spawns internal subagents. AO handles all parallel execution.

## Usage

```bash
# AO Mode: Generate parallel execution plan
/forge:swarm "complex feature"
# Output: AO spawn commands to execute externally

# Standalone Mode: Run tasks
/forge:swarm "complex feature"
# Executes: runs tasks sequentially in session

# Sequential mode (both)
/forge:swarm "step-by-step task" --sequential
```

## AO Mode Output

When AO_SESSION is set, produces:

```markdown
## AO Parallel Execution Plan

Execute these tasks in parallel via AO:

```bash
ao spawn <project> "Task 1: [specific scope]"
ao spawn <project> "Task 2: [specific scope]"
ao spawn <project> "Task 3: [specific scope]"
```

**Synchronization Point:**
Wait for all tasks to complete, then synthesize results.

**Expected Artifacts:**
- Task 1 → `docs/forge/swarm/task-1-result.md`
- Task 2 → `docs/forge/swarm/task-2-result.md`
- Task 3 → `docs/forge/swarm/task-3-result.md`
```

## Standalone Mode Behavior

When no AO_SESSION:

```bash
# Parallel (simulated via rapid sequential execution)
for task in tasks:
    execute_task(task)
    write_result(task)

# Sequential (--sequential flag)
for task in tasks:
    execute_task(task)
    # Wait for completion before next
```

## Task Decomposition

Swarm automatically decomposes tasks:

```
"Build user dashboard"
├── Task 1: Create user data models
├── Task 2: Build profile UI components
├── Task 3: Implement avatar upload
└── Task 4: Add settings panel
```

## Mode Comparison

| Aspect | AO Mode | Standalone |
|--------|---------|------------|
| Execution | AO spawns sessions | Sequential in session |
| Parallelism | True parallel | Simulated |
| Output | Spawn plan | Direct execution |
| Subagents | **Never** | Sequential only |

## When to Use

**Use /forge:swarm when:**
- Task can be broken into independent sub-tasks
- Multiple angles/perspectives needed
- Research or exploration phase

**Don't use when:**
- Tasks have tight dependencies
- Single coherent implementation needed
- In AO mode and you want AO to handle spawning

## Alternative: Direct AO Spawn

Instead of `/forge:swarm`, you can directly plan AO spawns:

```bash
# More explicit control
ao spawn <project> "Research: auth patterns"
ao spawn <project> "Research: UI libraries"
```

## Required Skills

**REQUIRED:** `@forge-orchestrator`
