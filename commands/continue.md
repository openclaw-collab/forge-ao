---
name: forge:continue
description: Resume a paused or interrupted FORGE workflow from saved state
argument-hint: "[optional: workflow phase to resume]"
disable-model-invocation: true
---

# /forge:continue

Resume a paused, interrupted, or saved FORGE workflow from its last known state.

## Usage

```bash
/forge:continue                    # Resume most recent workflow
/forge:continue build              # Resume specific phase
/forge:continue --list             # Show available saved states
/forge:continue --archive          # Archive completed workflow
```

## State Detection

### Automatic State Discovery

```
/forge:continue

🔍 Scanning for active workflows...

Found: User Profile Feature (Build phase)
├── Started: 2 days ago
├── Last activity: 6 hours ago
├── Completed: 3/5 tasks
├── Current task: task-04-ui (pending)
└── Context: Building user profile UI with React Hook Form

Resume this workflow? [Y/n]
```

### Multiple Workflows

```
/forge:continue --list

Available Workflows:
[1] User Profile Feature (Build phase) - 3/5 tasks complete
[2] Payment Integration (Plan phase) - 2/4 tasks complete
[3] Auth Refactor (Test phase) - 4/5 tasks complete

Select workflow to resume (1-3):
```

## Resumption Process

### Step 1: Read State

```
Reading workflow state...
✓ Loaded .claude/forge/active-workflow.md
✓ Phase: build
✓ Status: in_progress
✓ Last updated: 2026-02-26T18:00:00Z
```

### Step 2: Display Context

```
═══════════════════════════════════════════════════
Resuming: User Profile Feature
═══════════════════════════════════════════════════

Phase: Build
Progress: 60% (3/5 tasks)

Completed:
✓ task-01-init - Project setup
✓ task-02-api - Backend API endpoints
✓ task-03-auth - Authentication integration

Current:
⏳ task-04-ui - Profile UI components

Pending:
⏸ task-05-tests - Unit and integration tests

Recent Decisions:
• Using React Hook Form for validation
• Avatar images stored in R2
• Profile data cached for 5 minutes

═══════════════════════════════════════════════════
```

### Step 3: Resume Current Task

```
Resuming task-04-ui...

Last checkpoint:
├── Profile page component created
├── Avatar upload implemented
└── Form validation pending

Next steps:
1. Complete form validation
2. Add profile edit mode
3. Implement save/cancel actions

Continue from checkpoint? [Y/n/custom]
```

## State Recovery Scenarios

### Scenario 1: Browser Crash

```
User: /forge:continue
FORGE: Detected incomplete session

Your browser crashed 2 hours ago during task-04-ui.
All progress was auto-saved.

Current state recovered:
• 3 files modified (not committed)
• Form validation 70% complete
• No test changes since last checkpoint

Resume from auto-save? [Y/n]
```

### Scenario 2: Multi-Day Workflow

```
/forge:continue

Workflow started 3 days ago.
Last worked on: Yesterday at 6pm

Quick context refresh:
• Building user profile feature
• Currently on UI components (task-04)
• React Hook Form for validation
• Avatar upload to R2 complete

Review full context? [Y/n]
Resume directly? [Y/n]
```

### Scenario 3: Interrupted by Higher Priority

```
/forge:continue

Active workflow found: User Profile Feature
⚠️  Interrupted by: Hotfix - Auth Bug

You switched to an urgent hotfix yesterday.
The profile feature workflow was auto-paused.

Options:
[1] Resume profile feature
[2] Check hotfix status
[3] View both workflows
```

## Manual State Specification

### Resume Specific Phase

```bash
/forge:continue plan

Forcing resume of Plan phase...
⚠️  Warning: Current workflow is in Build phase

Options:
[override] - Switch to Plan phase
[continue] - Resume current Build phase
[archive]  - Archive current, start Plan
```

### Resume From Archive

```bash
/forge:continue --from-archive user-profile-v1

Loading archived workflow...
✓ Found: docs/archive/user-profile-v1-workflow.md
✓ Phase: validate
✓ Status: completed

This workflow was completed and archived.
Options:
[reopen]   - Reopen as active workflow
[clone]    - Create new workflow from this template
[view]     - View summary only
```

## State Management

### During Session

```
Working on task-04-ui...
Progress auto-saved every 5 minutes.

Current session:
├── Duration: 2 hours
├── Files modified: 5
├── Tests added: 3
└── Last save: 3 minutes ago
```

### Pre-Compact Hook

```
⚠️  Context at 10% - Triggering pre-compact save...

Saving workflow state:
✓ Task progress recorded
✓ Decisions captured
✓ Context summarized
✓ State document updated

You can resume with /forge:continue
```

### Session End

```
Session ending...

Auto-save workflow state? [Y/n]
[Y] - Save and exit (resume with /forge:continue)
[n]  - Exit without saving (risk losing progress)
```

## Context Refresh

### Decision Review

```
/forge:continue --refresh

Key decisions in this workflow:
1. React Hook Form for validation
   Rationale: Simpler than Formik, built-in TypeScript

2. R2 for avatar storage
   Rationale: Cheaper than S3, CDN integration

3. No optimistic updates
   Rationale: Prevent stale data issues

Review all decisions? [Y/n]
```

### Progress Summary

```
/forge:continue --summary

User Profile Feature
═══════════════════
Timeline:
Day 1: Plan phase complete (4 hours)
Day 2: Design phase complete (3 hours)
Day 3: Build phase in progress (5 hours so far)

Velocity: ~1 task per 2 hours
Estimated remaining: 4 hours

Blockers: None
Risks: API rate limiting on avatar uploads
```

## Integration with Other Commands

### After Continue

```
/forge:continue
✓ Resumed task-04-ui

Options:
/forge:status     - View detailed progress
/forge:test       - Run tests for current task
/forge:pause      - Pause and save state
/forge:abort      - Abandon workflow
```

### With Test Integration

```
/forge:continue
✓ Resumed task-04-ui

Running test checkpoint...
✓ 12 tests passing
⚠️  2 tests failing (profile validation)

Fix tests before continuing? [Y/n]
```

## Error Handling

### No Active Workflow

```
/forge:continue

❌ No active workflow found

No saved state in .claude/forge/

Start a new workflow:
/forge:start "feature description"

Or create from template:
/forge:template
```

### Corrupted State

```
/forge:continue

⚠️  State file appears corrupted

Attempting recovery from backup...
✓ Recovered from snapshot: 2026-02-26T14:30:00Z

⚠️  2 hours of work may be missing
Last known good state: task-03-auth complete

Continue from recovered state? [Y/n]
```

### Concurrent Modification

```
/forge:continue

⚠️  Workflow state modified externally

State was updated 10 minutes ago on another machine.

Options:
[local]   - Use your local state
[remote]  - Use the newer remote state
[merge]   - Attempt to merge both states
[view]    - Compare differences
```

## State File Format

```yaml
---
workflow_id: user-profile-2026-02-24
phase: build
status: in_progress
started_at: 2026-02-24T10:00:00Z
last_updated: 2026-02-26T18:30:00Z

progress:
  completed_tasks:
    - task-01-init
    - task-02-api
    - task-03-auth
  current_task: task-04-ui
  pending_tasks:
    - task-05-tests

context:
  feature: "User Profile"
  branch: "feat/user-profile"
  decisions:
    - "React Hook Form for validation"
    - "R2 for avatar storage"
  blockers: []

session:
  total_hours: 12
  current_session_hours: 2.5
  last_commit: "abc123"
---
```

## Required Skill

**REQUIRED:** `@state-tracking`

## See Also

- `/forge:start` - Start new workflow
- `/forge:pause` - Pause current workflow
- `/forge:status` - View workflow status
- `/forge:abort` - Abandon workflow
