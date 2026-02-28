# OpenClaw → PRD → AO → FORGE Workflow

**Status**: Core bridge implemented. Some features are specifications requiring additional work.

---

## 1. Current Architecture (Implemented)

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              CURRENT IMPLEMENTATION                                  │
└─────────────────────────────────────────────────────────────────────────────────────┘

PHASE 1: BMAD PRD CREATION (openclaw-collab/BMAD_Openclaw)
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                      │
│  User: "I need a task management app..."                                             │
│       │                                                                              │
│       ▼                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │  BMAD PM Agent (pm.agent.yaml)                                               │    │
│  │  ├── Step 01-12: Progressive PRD creation                                    │    │
│  │  │   (workflow-create-prd.md + step files)                                   │    │
│  │  └── Output: docs/prd.md                                                     │    │
│  │       ├── YAML frontmatter (workflowType, stepsCompleted)                    │    │
│  │       ├── Executive Summary                                                  │    │
│  │       ├── Functional Requirements (20-50 FRs)                                │    │
│  │       └── Non-Functional Requirements                                        │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                          │                                           │
│                                          ▼                                           │
│                              docs/prd.md (COMPLETE)                                  │
└─────────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          │ PRD file exists
                                          ▼
PHASE 2: AO FORGE BRIDGE (openclaw-collab/agent-orchestrator)
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                      │
│  Command: ao forge init-from-prd docs/prd.md my-project                             │
│       │ (IMPLEMENTED: packages/cli/src/commands/forge.ts)                           │
│       ▼                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │  1. parsePRD(prdPath)                                                        │    │
│  │     ├── Extracts frontmatter                                                 │    │
│  │     ├── Parses title, executive summary                                      │    │
│  │     └── Extracts functional requirements                                     │    │
│  │                                                                              │    │
│  │  2. createDebatePlanFromPRD(prdInfo)                                         │    │
│  │     └── Generates debate plan YAML with:                                     │    │
│  │         ├── advocate, skeptic, operator, synthesizer roles                   │    │
│  │         └── explore, validate, decide phases                                 │    │
│  │                                                                              │    │
│  │  3. fm.createDebate(planPath, projectId)                                     │    │
│  │     └── Creates debate JSON in ~/.agent-orchestrator/<project>/debates/      │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                          │                                           │
│                                          ▼                                           │
│  Command: ao forge run <debate-id>                                                   │
│       │ (IMPLEMENTED: packages/core/src/forge-manager.ts)                           │
│       ▼                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │  spawnDebateRoles() - IMPLEMENTED:                                           │    │
│  │                                                                              │    │
│  │  1. bootstrapForgeWorkspace(project.path, status.planPath)                   │    │
│  │     ├── Creates .claude/forge/knowledge/                                     │    │
│  │     │   └── brief.md, decisions.md, risks.md, etc.                           │    │
│  │     ├── Creates docs/forge/{phases,handoffs,debate}/                         │    │
│  │     └── Copies PRD content to brief.md                                       │    │
│  │                                                                              │    │
│  │  2. sessionManager.spawn() with:                                             │    │
│  │     ├── forgeContext: {debateId, debatePlanPath, role, phase}                │    │
│  │     └── env: {                                                                │    │
│  │         AO_FORGE_DEBATE_ID: "forge-123...",                                   │    │
│  │         AO_FORGE_ROLE: "advocate",                                            │    │
│  │         AO_FORGE_PHASE: "explore",                                            │    │
│  │         AO_FORGE_PROJECT_ID: "my-project",                                    │    │
│  │         CLAUDE_ENV: "forge"                                                   │    │
│  │     }                                                                          │    │
│  │     (IMPLEMENTED: SessionSpawnConfig.env field added to types.ts)            │    │
│  │     (IMPLEMENTED: session-manager.ts passes env to runtime.create())         │    │
│  │                                                                              │    │
│  │  3. writeMetadata() with forgeDebateId, forgeRole, forgePhase                │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                          │                                           │
│                                          ▼                                           │
│                         Sessions spawned with FORGE env vars                         │
└─────────────────────────────────────────────────────────────────────────────────────┘
                                          │
                                          │ Sessions running
                                          ▼
PHASE 3: FORGE SESSION INITIALIZATION (openclaw-collab/forge-ao)
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                                                                      │
│  Claude Code SessionStart Hook (hooks/SessionStart/forge-init.sh)                   │
│       │ (IMPLEMENTED)                                                               │
│       ▼                                                                              │
│  ┌─────────────────────────────────────────────────────────────────────────────┐    │
│  │  if [ -n "$AO_FORGE_DEBATE_ID" ]; then                                       │    │
│  │                                                                              │    │
│  │     echo "🔥 FORGE-AO Session Detected"                                      │    │
│  │     echo "Debate ID: ${AO_FORGE_DEBATE_ID}"                                  │    │
│  │     echo "Role: ${AO_FORGE_ROLE}"                                            │    │
│  │     echo "Phase: ${AO_FORGE_PHASE}"                                          │    │
│  │                                                                              │    │
│  │     # Load FORGE system prompt                                               │    │
│  │     FORGE_SYSTEM_PROMPT=".../forge-system-prompt.md"                         │    │
│  │     touch "${FORGE_DIR}/.ao_forge_active"  # Marker file                     │    │
│  │                                                                              │    │
│  │     # Ensure directory structure                                             │    │
│  │     mkdir -p "${FORGE_DIR}/knowledge"                                        │    │
│  │     mkdir -p "${WORKSPACE_ROOT}/docs/forge/{phases,handoffs,debate}"         │    │
│  │                                                                              │    │
│  │     exit 0  # Skip normal FORGE init                                         │    │
│  │  fi                                                                          │    │
│  └─────────────────────────────────────────────────────────────────────────────┘    │
│                                          │                                           │
│                                          ▼                                           │
│                         Session ready with FORGE context loaded                      │
└─────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Component Contracts (Implemented)

### BMAD → AO

| Output | File Path | Format |
|--------|-----------|--------|
| PRD | `docs/prd.md` | Markdown with YAML frontmatter |

**Evidence** (`bmad-method/bmm/workflows/2-plan-workflows/create-prd/templates/prd-template.md`):
```yaml
---
stepsCompleted: []
inputDocuments: []
workflowType: 'prd'
---
# Product Requirements Document - {{project_name}}
```

### AO → FORGE Environment Variables

**Evidence** (`packages/core/src/forge-manager.ts:spawnDebateRoles`):
```typescript
const session = await sessionManager.spawn({
  projectId: status.projectId,
  prompt: rolePrompt,
  agent: role.model || undefined,  // FIXED: was no-op before
  forgeContext: { debateId, debatePlanPath, role, phase },
  env: {
    AO_FORGE_DEBATE_ID: debateId,
    AO_FORGE_ROLE: role.name,
    AO_FORGE_PHASE: firstPhase.name,
    AO_FORGE_PROJECT_ID: status.projectId,
    AO_FORGE_PLAN_PATH: status.planPath,
    AO_FORGE_OUTPUT_FILE: status.outputFile || "",
    CLAUDE_ENV: "forge",
  },
});
```

### FORGE Session Detection

**Evidence** (`hooks/SessionStart/forge-init.sh`):
```bash
IS_AO_FORGE_SESSION=false
if [ -n "$AO_FORGE_DEBATE_ID" ]; then
  IS_AO_FORGE_SESSION=true
fi

if [ "$IS_AO_FORGE_SESSION" = true ]; then
  # Load FORGE system prompt
  # Create marker file
  # Initialize workspace structure
fi
```

---

## 3. Command Runbook (Working Commands)

```bash
# 1. Create PRD (BMAD workflow - 12 steps)
openclaw create-prd
# ... follow PM agent dialogue through steps 1-12 ...
# Output: docs/prd.md

# 2. Initialize AO project
ao init --auto

# 3. Create FORGE debate from PRD (IMPLEMENTED)
ao forge init-from-prd docs/prd.md my-project
# Output: Debate ID (e.g., forge-1234567890-abc)

# 4. Start debate - spawns role sessions (IMPLEMENTED)
ao forge run <debate-id>
# Output: Sessions spawned for advocate, skeptic, operator, synthesizer

# 5. Monitor debate status
ao forge status <debate-id>
# OR: open http://localhost:3000 for dashboard

# 6. Inside FORGE session (auto-loaded via SessionStart hook)
/forge:continue
# OR
/forge:brainstorm  # Creates debate plan, AO spawns debate roles

# 7. Progress through phases
/forge:research    # Validates with Context7
/forge:design      # System design first, then UI/UX
/forge:plan        # Surgical implementation plan
/forge:test        # Risk-based test strategy
/forge:build       # TDD with Ralph loop
/forge:validate    # Evidence-based verification
/forge:review      # Karpathy compliance check
/forge:learn       # Pattern extraction

# 8. AO CI/review loops (auto-handled)
ao status  # Shows sessions, PRs, CI status

# 9. Cleanup
ao session cleanup
```

---

## 4. Gaps and Next Steps to Optimal

### Gap 1: System Prompt Injection (PARTIAL)

**Current**: SessionStart hook detects env vars and prints message
**Gap**: System prompt file is not actually appended to Claude session
**Fix**:
- Location: `hooks/SessionStart/forge-init.sh` OR agent launch config
- Change: Use `claude --append-system-prompt $(cat .../forge-system-prompt.md)`
- OR: Set `CLAUDE_SYSTEM_PROMPT` env var if supported

**Priority**: HIGH - Without this, sessions don't actually run FORGE protocol

### Gap 2: Debate File Detection (NOT IMPLEMENTED)

**Current**: FORGE commands describe polling for synthesis.md
**Gap**: No actual file watcher or notification system exists
**Fix**:
- Location: `packages/core/src/forge-manager.ts`
- Change: Add file watcher for `docs/forge/debate/<id>/synthesis.md`
- When detected, advance phase automatically

**Priority**: HIGH - Brainstorm phase never unblocks without this

### Gap 3: Desloppify Agent Spawn (SPECIFIED, NOT IMPLEMENTED)

**Current**: Command document exists but no AO integration
**Gap**: `ao spawn` doesn't support `--role` or custom env vars cleanly
**Fix**:
- Location: `packages/cli/src/commands/spawn.ts`
- Change: Add `--forge-role` and `--env` flags to `ao spawn`
- OR: Create `ao spawn-forge-role` command

**Priority**: MEDIUM - Can work around with manual `ao spawn`

### Gap 4: State Sync AO ↔ FORGE (NOT IMPLEMENTED)

**Current**: AO writes metadata, FORGE writes files, no sync
**Gap**: AO dashboard doesn't show FORGE phase progress
**Fix**:
- Location: `packages/core/src/session-manager.ts`
- Change: File watcher for `.claude/forge/active-workflow.md`
- Sync phase/status to AO session metadata

**Priority**: MEDIUM - Dashboard shows stale data

### Gap 5: PRD Auto-Trigger (NOT IMPLEMENTED)

**Current**: User manually runs `ao forge init-from-prd`
**Gap**: No automatic trigger when BMAD completes PRD
**Fix**:
- Location: `bmad-method/bmm/workflows/2-plan-workflows/create-prd/steps-c/step-12-complete.md`
- Change: Add menu option `[F] Launch FORGE Implementation`
- Calls `ao forge init-from-prd` via shell exec or API

**Priority**: LOW - Manual command works fine

### Gap 6: Role-Specific Model Selection (BUG)

**Current**: `agent: role.model || undefined` passes model but agent plugin may ignore
**Gap**: No verification that correct model is used
**Fix**:
- Test with role.model = "claude-opus-4-6" vs default
- Verify AO respects model override

**Priority**: LOW - Uses project default (works but not optimal)

---

## 5. Minimal Changes for Production

To make the workflow production-ready, implement in this order:

### Week 1: System Prompt Injection
```bash
# Test current behavior
echo $AO_FORGE_DEBATE_ID  # Should show ID

# Expected: Session should auto-load FORGE system prompt
# Fix: Modify agent launch to include --append-system-prompt
```

### Week 2: Debate File Detection
```typescript
// In forge-manager.ts
import { watch } from 'fs';

function watchDebateCompletion(debateId: string, projectPath: string) {
  const synthesisPath = join(projectPath, 'docs', 'forge', 'debate', debateId, 'synthesis.md');
  const watcher = watch(dirname(synthesisPath), (event, filename) => {
    if (filename === 'synthesis.md' && existsSync(synthesisPath)) {
      advancePhase(debateId);
      watcher.close();
    }
  });
}
```

### Week 3: State Sync
```typescript
// In session-manager.ts
function watchForgeState(sessionId: string, projectPath: string) {
  const workflowPath = join(projectPath, '.claude', 'forge', 'active-workflow.md');
  watch(workflowPath, () => {
    const state = parseWorkflowFile(workflowPath);
    updateMetadata(sessionId, { forgePhase: state.phase, forgeStatus: state.phase_status });
  });
}
```

### Week 4: Testing
- End-to-end test: PRD → AO → FORGE → Implementation
- Verify all env vars present
- Verify system prompt loaded
- Verify debate unblocks correctly

---

## 6. Files Changed (Pushed to GitHub)

### agent-orchestrator (commit dfbcbf6)
- `packages/core/src/types.ts` - Added `env?: Record<string, string>` to SessionSpawnConfig
- `packages/core/src/session-manager.ts` - Pass spawnConfig.env to runtime
- `packages/core/src/forge-manager.ts` - Added bootstrapForgeWorkspace(), env vars
- `packages/cli/src/commands/forge.ts` - Added init-from-prd command

### forge-ao (commit f5d7bef)
- `hooks/SessionStart/forge-init.sh` - AO FORGE session detection
- `commands/desloppify.md` - Autonomous agent spawn specification

---

## Summary

**Working**: PRD parsing, debate creation, session spawning, env var passing, SessionStart hook

**Needs Work**: System prompt injection, debate file detection, state sync

**Design Complete**: Desloppify integration, BMAD auto-trigger
