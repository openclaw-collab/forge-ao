---
name: state-tracking
description: Use when managing workflow state, tracking progress across sessions, or implementing resumable workflows. Tracks phase, status, tasks, and metadata in document frontmatter.
---

# State Tracking System

## Overview

State tracking enables workflows to be resumed across sessions. State is stored in YAML frontmatter of workflow documents, making progress visible and resumable.

## State Frontmatter Format

### Workflow State Template

```yaml
---
# Identity
phase: build
workflow: forge-build
version: "1.0"

# Status
status: in_progress          # pending | in_progress | paused | completed | failed
started_at: 2026-02-26T10:00:00Z
last_updated: 2026-02-26T14:30:00Z
completed_at: null

# Progress
completed_tasks:
  - task-01-init
  - task-02-setup
  - task-03-api
pending_tasks:
  - task-04-ui
  - task-05-tests
blocked_tasks:
  - task-06-deploy          # Blocked by: waiting for CI

# Context
context:
  feature: "user-profile"
  branch: "feat/user-profile"
  related_docs:
    - docs/plans/user-profile-plan.md
    - docs/design/profile-design.md
  decisions:
    - "Using React Hook Form for validation"
    - "Avatar images stored in R2"

# Metadata
metadata:
  estimated_hours: 8
  actual_hours: 5.5
  risk_level: medium
  priority: high
---
```

## State Fields Reference

### Core Fields

| Field | Type | Description |
|-------|------|-------------|
| `phase` | string | Current workflow phase (brainstorm, plan, build, etc.) |
| `status` | string | Workflow status (pending, in_progress, paused, completed, failed) |
| `started_at` | ISO8601 | When workflow started |
| `last_updated` | ISO8601 | Last state modification |
| `completed_at` | ISO8601 | When workflow finished (null if in progress) |

### Progress Fields

| Field | Type | Description |
|-------|------|-------------|
| `completed_tasks` | array | List of completed task IDs |
| `pending_tasks` | array | Tasks remaining to do |
| `blocked_tasks` | array | Tasks that can't proceed (with reason) |
| `current_task` | string | Active task being worked on |
| `task_history` | array | Chronological task completion log |

### Context Fields

| Field | Type | Description |
|-------|------|-------------|
| `feature` | string | Feature or project name |
| `branch` | string | Git branch |
| `related_docs` | array | Related documentation files |
| `decisions` | array | Key decisions made |
| `notes` | string | Free-form notes |

## State Management Patterns

### Pattern 1: Task Completion

```markdown
## Completing a Task

1. Move task from `pending_tasks` to `completed_tasks`
2. Update `last_updated` timestamp
3. Set `current_task` to next pending task (if any)
4. If no more pending tasks, set `status: completed`
```

### Pattern 2: Task Blocking

```markdown
## Blocking a Task

1. Move task from `pending_tasks` to `blocked_tasks`
2. Add blocker reason in context
3. Update `last_updated`
4. Set `current_task` to next available task
```

### Pattern 3: Session Resumption

```markdown
## Resuming Workflow

1. Read state document
2. Parse frontmatter
3. Identify `current_task` or first `pending_task`
4. Display summary to user
5. Continue from identified task
```

### Pattern 4: State Recovery

```markdown
## Recovering from Interruption

1. Check `.claude/forge/active-workflow.md` for active workflows
2. Find most recent by `last_updated`
3. Read the workflow document
4. Present recovery option to user
5. On confirmation, resume from saved state
```

## Session Start Hook Integration

### forge-init.sh Enhancement

```bash
# Check for in-progress workflows
if [ -f ".claude/forge/active-workflow.md" ]; then
  WORKFLOW_STATE=$(grep -A 20 "^---$" .claude/forge/active-workflow.md | head -30)
  PHASE=$(echo "$WORKFLOW_STATE" | grep "^phase:" | cut -d':' -f2 | tr -d ' ')
  STATUS=$(echo "$WORKFLOW_STATE" | grep "^status:" | cut -d':' -f2 | tr -d ' ')

  if [ "$STATUS" = "in_progress" ]; then
    echo "📋 Active FORGE Workflow Detectated"
    echo "Phase: $PHASE"
    echo ""
    echo "Resume with: /forge:continue"
    echo ""
  fi
fi
```

## Status Command Enhancement

### /forge:status State Display

```markdown
## FORGE Status

### Current Workflow
**Phase:** Build
**Status:** In Progress
**Duration:** 5.5 hours (started 2 days ago)

### Progress
✅ Completed (3):
- [x] task-01-init
- [x] task-02-setup
- [x] task-03-api

⏳ Pending (2):
- [ ] task-04-ui
- [ ] task-05-tests

🚫 Blocked (1):
- [ ] task-06-deploy (waiting for CI)

### Recent Activity
- 2 hours ago: Completed task-03-api
- 5 hours ago: Started task-03-api
- 2 days ago: Workflow started

### Next Steps
Next task: task-04-ui
Run: /forge:continue
```

## State Persistence Strategy

### Primary State Document

Location: `.claude/forge/active-workflow.md`

This is the source of truth for current workflow state.

### Session Snapshots

Location: `.claude/forge/snapshots/YYYYMMDD-HHMMSS.md`

Periodic snapshots for recovery:
- On phase transition
- Every hour during active work
- On manual save (`/forge:save`)

### Archive

Location: `.claude/forge/archive/`

Completed workflows moved here with timestamp.

## Implementation Examples

### Creating Initial State

```yaml
---
phase: plan
status: in_progress
started_at: 2026-02-26T10:00:00Z
last_updated: 2026-02-26T10:00:00Z
completed_tasks: []
pending_tasks:
  - task-01-research
  - task-02-design
  - task-03-estimate
blocked_tasks: []
current_task: task-01-research
context:
  feature: "new-feature"
  branch: "feat/new-feature"
---
```

### Updating State on Task Complete

```yaml
# Before
completed_tasks: [task-01-research]
pending_tasks: [task-02-design, task-03-estimate]
current_task: task-02-design

# After completing task-02-design
completed_tasks: [task-01-research, task-02-design]
pending_tasks: [task-03-estimate]
current_task: task-03-estimate
last_updated: 2026-02-26T11:30:00Z
```

### Handling Blockers

```yaml
# Blocker encountered
current_task: null
blocked_tasks:
  - task: task-03-estimate
    reason: "Waiting for stakeholder approval on scope"
    blocked_at: 2026-02-26T12:00:00Z
notes: "Scope discussion scheduled for tomorrow"
```

## Best Practices

1. **Update Timestamp** - Always update `last_updated` on changes
2. **Atomic Updates** - Complete state changes in single edit
3. **Context Preservation** - Keep `related_docs` and `decisions` current
4. **Regular Snapshots** - Save progress periodically
5. **Clear Status** - Use standard status values consistently
6. **Document Blockers** - Always include reason for blocked tasks

## Integration with FORGE

### Commands

- `/forge:start` - Creates initial state
- `/forge:continue` - Resumes from saved state
- `/forge:status` - Displays current state
- `/forge:pause` - Sets status to paused
- `/forge:abort` - Sets status to failed with reason

### Hooks

- `SessionStart` - Check for active state, offer resume
- `PreCompact` - Save snapshot before context compaction

### Agents

All agents should:
1. Read current state on activation
2. Update state on task completion
3. Preserve state context in responses

## State Recovery Scenarios

### Scenario 1: Browser Crash

```
User: My browser crashed, where were we?
FORGE: Detected active workflow:
  Phase: Build
  Last task: task-03-api (completed 2 hours ago)
  Next: task-04-ui
Resume with /forge:continue?
```

### Scenario 2: New Session

```
User: /forge:continue
FORGE: Resuming Build phase
  Completed: 3 tasks
  Current: task-04-ui (pending)
  Context: Building user profile UI with React Hook Form
Continue with task-04-ui?
```

### Scenario 3: Multi-Day Workflow

```
User: /forge:status
FORGE: Active workflow (started 3 days ago)
  Phase: Build
  Progress: 60% (3/5 tasks complete)
  Last activity: Yesterday, 6pm

  Next task: task-04-ui
  Estimated remaining: 2 hours

Resume: /forge:continue
Archive: /forge:complete
```
