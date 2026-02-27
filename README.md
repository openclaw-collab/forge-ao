# FORGE-AO

**Agent-native 10-phase development workflow for Agent Orchestrator.**

FORGE-AO is a purpose-built workflow plugin designed exclusively for Agent Orchestrator (AO). It provides structured, deterministic software development with mandatory debate gates, drift-resistant phase handoffs, and AO-native execution.

## Key Characteristics

- **AO-Only**: Requires `AO_SESSION` environment variable. No standalone mode.
- **No Internal Subagents**: All parallel work executed via AO session spawning
- **Deterministic Artifacts**: Files are source of truth, not chat context
- **Mandatory Debate Gates**: Structured debate required before phase completion
- **Drift-Resistant**: Phase handoffs with locked decisions and explicit constraints

## 10-Phase Workflow

```
Initialize → Brainstorm (Debate Gate) → Research → Design → Plan → Test → Build → Validate → Review → Learn
```

| Phase | Command | Purpose |
|-------|---------|---------|
| 1 | `/forge:start` | Personalize FORGE for the project |
| 2 | `/forge:brainstorm` | Explore approaches with mandatory debate |
| 3 | `/forge:research` | Validate decisions with best practices |
| 4 | `/forge:design` | Create design specifications |
| 5 | `/forge:plan` | Detailed implementation planning |
| 6 | `/forge:test` | Test strategy and ATDD |
| 7 | `/forge:build` | Execute with TDD discipline |
| 8 | `/forge:validate` | Verify against requirements |
| 9 | `/forge:review` | Code review from multiple angles |
| 10 | `/forge:learn` | Capture knowledge and patterns |

## Installation

### For AO Projects

Add to your `agent-orchestrator.yaml`:

```yaml
projects:
  - name: my-project
    postCreate:
      - "node .claude/plugins/forge-ao/integrations/agent-orchestrator/install.mjs --workspace ."
    agentConfig:
      systemPromptFile: ".claude/forge/forge-system-prompt.md"
```

### Manual Installation

```bash
cd your-project
node /path/to/forge-ao/integrations/agent-orchestrator/install.mjs --workspace .
```

## Debate Gate

The Debate Gate is a mandatory checkpoint within the Brainstorm phase (and optionally others) that ensures structured evaluation before commitment.

### Required Files

```
docs/forge/debate/<phase>-<timestamp>/
├── debate-plan.md      # Debate structure
├── advocate.md         # Case FOR the approach
├── skeptic.md          # Concerns and risks
├── operator.md         # Feasibility assessment
└── synthesis.md        # Final decision
```

### AO Mode Execution

In AO mode, FORGE generates the debate plan and outputs AO spawn commands:

```bash
# FORGE generates these commands
ao spawn <project> "FORGE DEBATE: Write advocate.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write skeptic.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write operator.md for debate <id>"
ao spawn <project> "FORGE DEBATE: Write synthesis.md for debate <id>"
```

AO spawns the sessions externally. FORGE detects completion via file existence.

## Commands

### Workflow Commands
- `/forge:start` - Initialize FORGE for the project
- `/forge:brainstorm` - Explore approaches (includes Debate Gate)
- `/forge:research` - Validate with best practices
- `/forge:design` - Create design specifications
- `/forge:plan` - Implementation planning
- `/forge:test` - Test strategy
- `/forge:build` - Execute implementation
- `/forge:validate` - Verify requirements
- `/forge:review` - Code review
- `/forge:learn` - Capture learnings

### Utility Commands
- `/forge:continue` - Resume from saved state
- `/forge:status` - Show workflow status
- `/forge:debate` - Manage debate lifecycle
- `/forge:quick` - Quick task execution
- `/forge:help` - Show workflow help

## Agents

| Agent | Purpose | Trigger |
|-------|---------|---------|
| `@skill-router` | Route tasks to skills | Session start |
| `@builder` | TDD implementation | Build phase |
| `@researcher` | Best practices research | Research phase |
| `@security-reviewer` | Security audit | Review phase |
| `@performance-guardian` | Performance optimization | Optimization requests |
| `@brainstormer` | Ideation and exploration | Brainstorm phase |
| `@mass-change` | Large-scale refactoring | Mass change requests |
| `@docs-maintainer` | Documentation maintenance | Doc drift |

### Debate Role Agents

| Agent | Role | Output |
|-------|------|--------|
| `@advocate` | Argues FOR the approach | `advocate.md` |
| `@skeptic` | Probes weaknesses | `skeptic.md` |
| `@operator` | Assesses feasibility | `operator.md` |
| `@synthesizer` | Produces final decision | `synthesis.md` |

## Skills

### Core Skills
- `@forge-init` - Initialize FORGE
- `@forge-context` - Load workflow context
- `@forge-memory` - Memory management
- `@forge-config` - Configuration management
- `@state-tracking` - Workflow state tracking

### Workflow Skills
- `@forge-brainstorm` - Brainstorm phase
- `@forge-research` - Research phase
- `@forge-design` - Design phase
- `@forge-plan` - Plan phase
- `@forge-test` - Test phase
- `@forge-build` - Build phase
- `@forge-validate` - Validate phase
- `@forge-review` - Review phase
- `@forge-learn` - Learn phase

### Quality Skills
- `@atdd-workflow` - Acceptance Test Driven Development
- `@risk-based-testing` - Risk-based test strategy
- `@test-automation` - Test automation patterns
- `@test-review` - Test review guidelines
- `@ci-cd-setup` - CI/CD pipeline setup

## Hooks

FORGE-AO registers these hooks:

- **SessionStart**: Initialize FORGE state
- **PreToolUse**: Block destructive edits, confirm large overwrites
- **PostToolUse**: Type check, lint, sync AO metadata
- **PreCompact**: Save workflow snapshots

## Configuration

### Environment Variables

- `AO_SESSION` - AO session ID (required for AO mode)
- `AO_DATA_DIR` - AO metadata directory (required for AO mode)
- `FORGE_ARTIFACT_LEVEL` - minimal|intelligent|maximal

### Settings File

`.claude/forge.local.md`:

```yaml
---
artifact_level: intelligent
default_agent: claude-code
debate_required: true
auto_phase_transition: false
---
```

## File Structure

```
.claude/forge/
├── active-workflow.md     # Current workflow state
├── config.json            # FORGE configuration
├── forge-system-prompt.md # System prompt for AO
└── debate/                # Debate artifacts
    └── <phase>-<id>/
        ├── debate-plan.md
        ├── advocate.md
        ├── skeptic.md
        ├── operator.md
        └── synthesis.md

docs/forge/
├── brainstorm.md
├── research.md
├── design.md
├── plan.md
├── test-strategy.md
├── build-log.md
├── validation-report.md
├── review-report.md
└── learnings.md
```

## AO Metadata Sync

FORGE-AO syncs these keys to AO metadata:

- `forge_phase` - Current phase
- `forge_status` - Workflow status
- `forge_next` - Next phase
- `forge_summary` - Brief summary
- `forge_debate_id` - Active debate ID
- `forge_debate_status` - Debate status
- `forge_debate_pending` - Debate pending flag
- `forge_branch` - Git branch
- `forge_issue` - Related issue
- `forge_version` - Workflow version
- `forge_started_at` - Start timestamp
- `forge_last_updated` - Last update

## Testing

Run the self-test:

```bash
./integrations/agent-orchestrator/selftest.sh
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Run self-test
5. Submit pull request

## License

MIT

## See Also

- [Debate Schema](docs/debate-schema.md) - Debate gate specification
- [Action Checklist](docs/action-checklist.md) - Implementation checklist
- [Audit Synthesis](docs/synthesis.md) - Audit findings summary
