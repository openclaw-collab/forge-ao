---
name: forge-help
description: Use when needing workflow guidance, phase detection, or smart orchestration of FORGE workflows
---

# FORGE Help

Smart orchestrator for the FORGE 9-phase development workflow. Detects current phase and recommends next steps.

## Philosophy

**"Guide, don't guess"** - Intelligent orchestration that detects state and recommends optimal path forward.

## Commands

| Command | Purpose |
|---------|---------|
| `/forge:help` | Show current phase, recommend next step |
| `/forge:status` | Display workflow progress |
| `/forge:next` | Advance to next phase |
| `/forge:start` | Begin workflow from current state |

## Phase Detection

**Checks for existing artifacts:**

```
1. docs/forge/brainstorm.md exists? → Brainstorm complete
2. docs/forge/research.md exists? → Research complete
3. docs/forge/design.md exists? → Design complete
4. docs/forge/plan.md exists? → Plan complete
5. Code changes exist? → Build in progress/complete
6. docs/forge/test-results.md exists? → Test complete
7. docs/forge/validation.md exists? → Validate complete
8. docs/forge/review.md exists? → Review complete
9. Learnings captured? → Learn complete
```

## Smart Recommendations

**Based on current state:**

| State | Recommendation |
|-------|----------------|
| No artifacts | Start with `/forge:brainstorm` |
| Brainstorm only | Continue to `/forge:research` |
| Research only | Continue to `/forge:design` |
| Design only | Continue to `/forge:plan` |
| Plan only | Continue to `/forge:build` |
| Build in progress | Continue building or `/forge:test` |
| Test results | Continue to `/forge:validate` |
| Validation done | Continue to `/forge:review` |
| Review done | Continue to `/forge:learn` |

## Quick Mode

**`/forge:quick [description]`** - Streamlined workflow:

1. Skips explicit Brainstorm/Research/Design
2. Auto-generates minimal Plan
3. Executes Build immediately
4. Runs quick Test/Validate
5. Captures minimal Learn

**Best for:** Bug fixes, small features, prototypes

## Help Output Format

```
┌─────────────────────────────────────────────────────────┐
│  FORGE Workflow Status                                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Current Phase: Build (in progress)                      │
│  Progress: 5 of 9 phases                                 │
│                                                          │
│  ✅ Brainstorm    - docs/forge/brainstorm.md             │
│  ✅ Research      - docs/forge/research.md               │
│  ✅ Design        - docs/forge/design.md                 │
│  ✅ Plan          - docs/forge/plan.md                   │
│  🔄 Build         - 3 of 5 tasks complete                │
│  ⏳ Test          - Pending                              │
│  ⏳ Validate      - Pending                              │
│  ⏳ Review        - Pending                              │
│  ⏳ Learn          - Pending                              │
│                                                          │
│  Recommendation:                                         │
│  Continue with `/forge:build` to complete remaining      │
│  tasks, or run `/forge:test` if build is complete.       │
│                                                          │
│  Quick Actions:                                          │
│  • /forge:next    - Advance to next phase                │
│  • /forge:status  - Show detailed progress               │
│  • /forge:quick   - Start quick mode (skips phases)      │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

## Configuration-Based Recommendations

**Reads `forge-config` for:**
- Artifact level (minimal/intelligent/maximal)
- Quality gates enabled/disabled
- Karpathy enforcement status

**Adjusts recommendations:**
- Minimal level: Suggests skipping phases
- Gates disabled: Skips validate
- Karpathy disabled: No surgical precision checks

## Ralph Loop Integration

**When to use Ralph Loop vs FORGE phases:**

| Scenario | Use |
|----------|-----|
| Plan has 10+ steps, clearly defined | `/ralph-loop` with plan |
| Success criteria clear, tests defined | `/ralph-loop` |
| Overnight/long-running tasks | `/ralph-loop` with max-iterations |
| Design decisions needed | `/forge:brainstorm` |
| Unclear requirements | `/forge:brainstorm` |
| Multi-file complex refactoring | `/forge:build` with agent teams |

**Ralph Loop prevents false success:**
- Iterates until completion promise detected
- Each iteration sees previous work
- No premature "I'm done" declarations

**Example:**
```bash
/ralph-loop "Implement all steps from docs/forge/plan.md. Output <promise>COMPLETE</promise> when all tests pass." --max-iterations 50 --completion-promise "COMPLETE"
```

## Subagent vs Agent Teams Decision

**Use Subagents (Task tool) when:**
- Single independent task
- < 10 files involved
- No need for coordination between agents
- Short-lived (minutes, not hours)
- Example: Research one topic, implement one component

**Use Agent Teams (TeamCreate) when:**
- Multiple agents need to work together
- Complex cross-cutting changes
- > 10 files involved
- Need persistent shared state
- Long-running (hours)
- Example: Major feature, architecture refactoring

**Decision Flowchart:**
```
Complex task?
├── Yes → Multiple agents needed?
│         ├── Yes → Agent Teams (TeamCreate)
│         └── No  → Subagent (Task)
└── No  → Subagent (Task) - simpler, faster
```

## Workflow Visualization

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Brainstorm│ -> │ Research │ -> │  Design  │ -> │   Plan   │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
     ^                                              |
     |                                              v
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  Learn   │ <- │  Review  │ <- │ Validate │ <- │  Build   │
│   ✅     │    │          │    │          │    │          │
└──────────┘    └──────────┘    └──────────┘    └──────────┘
      ^                                              |
      |                                              |
   Ralph Loop (optional for large plans) -------------
```

## Integration

**Auto-invokes:**
- `forge-config` - Check settings
- `forge-context` - Detect current phase

**Used by:**
- All other phases - Recommend next steps
- User - Navigate workflow

## BMAD-Style Help

Inspired by BMAD's `/bmad-help`:

**Inspects project:**
- Reads existing artifacts
- Detects workflow state
- Recommends next action

**Auto-runs after workflows:**
- After each phase completes
- Shows next recommended step
- Offers to continue
