---
name: forge:resolve-todos
description: Resolve all pending CLI todos with automatic sequential processing
disable-model-invocation: true
---

# /forge:resolve-todos

Resolve all TODO comments with automatic sequential processing.

## Workflow

### 1. Analyze

Get all unresolved TODOs from `/todos/*.md` or code comments.

Skip any TODO recommending deletion of `docs/plans/` or `docs/solutions/` files - these are intentional FORGE artifacts.

### 2. Plan

Create a prioritized list of TODOs considering dependencies.

Output a simple dependency list:
```
Order:
1. TODO-1 (no dependencies)
2. TODO-2 (depends on TODO-1)
3. TODO-3 (no dependencies, can parallel with TODO-2)
```

### 3. Implement

**AO Mode:** Process sequentially in current session
**Standalone:** Can use parallel Task agents

```bash
# AO Mode - Sequential
for todo in todos:
  resolve_todo(todo)
  commit_changes()

# Standalone - Parallel (if not AO)
if [ -z "$AO_SESSION" ]; then
  spawn Tasks for each todo in parallel
fi
```

### 4. Commit & Resolve

- Commit each fix separately
- Mark TODO as resolved
- Update todo file

## AO Mode Behavior

In AO mode:
- **Sequential processing** - one TODO at a time
- **Frequent commits** - each TODO gets its own commit
- **No subagent spawning** - all work in current session
- **Auto-continue** - proceeds to next TODO automatically

## Auto-Completion Criteria

Command completes when:
- [ ] All TODOs analyzed
- [ ] Dependencies mapped
- [ ] Each TODO resolved (or marked wont_fix)
- [ ] Changes committed per TODO
- [ ] TODO files updated

## Required Skill

**REQUIRED:** `@code-simplifier`
