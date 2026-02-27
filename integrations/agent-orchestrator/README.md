# FORGE Agent Orchestrator Integration

This integration package adapts FORGE to run natively within Agent Orchestrator (AO) workspaces.

## Overview

When FORGE runs inside an AO-managed session:
- It operates on the workspace (git repo), not the plugin directory
- It writes workflow state to `.claude/forge/active-workflow.md`
- It syncs metadata with AO for dashboard visibility
- It avoids spawning subagents (AO manages session lifecycle)

## Installation

### From within an AO workspace

```bash
# Auto-detect AO mode (checks for AO_SESSION env)
node /path/to/forge/integrations/agent-orchestrator/install.mjs

# Explicit AO mode
node /path/to/forge/integrations/agent-orchestrator/install.mjs --mode ao

# Standalone mode (normal Claude Code usage)
node /path/to/forge/integrations/agent-orchestrator/install.mjs --mode standalone
```

### Via AO project configuration

Add to your `agent-orchestrator.yaml`:

```yaml
projects:
  - name: my-project
    postCreate:
      - "node tools/forge/integrations/agent-orchestrator/install.mjs --workspace ."
    agentConfig:
      systemPromptFile: ".claude/forge/forge-system-prompt.md"
```

## What Gets Installed

1. **Hooks** → `.claude/forge/hooks/`
   - AO metadata sync hook
   - FORGE lifecycle hooks
   - Safety hooks (env/lockfile protection)

2. **Settings** → `.claude/settings.json`
   - Merged with existing config
   - PostToolUse hooks for AO sync and FORGE checks
   - SessionStart hook for FORGE init

3. **System Prompt** → `.claude/forge/forge-system-prompt.md`
   - AO-optimized FORGE protocol
   - Referenced by `agentConfig.systemPromptFile`

4. **State Directory** → `.claude/forge/`
   - `active-workflow.md` - Current workflow state
   - `snapshots/` - Session checkpoints
   - `archive/` - Completed workflows

## AO Environment Variables

FORGE detects and uses these AO-injected variables:

| Variable | Purpose |
|----------|---------|
| `AO_SESSION` | Unique session identifier |
| `AO_DATA_DIR` | Path to AO metadata directory |
| `AO_SESSION_NAME` | Human-readable session name |
| `AO_ISSUE_ID` | Associated issue ID (if any) |

## Workflow State Sync

When `AO_SESSION` and `AO_DATA_DIR` are present, FORGE automatically syncs:

- `forge_phase` - Current phase (brainstorm, research, etc.)
- `forge_status` - in_progress, paused, completed, failed
- `forge_objective` - Current objective
- `forge_next` - Next recommended action

These appear in the AO dashboard for visibility.

## Differences from Standalone Mode

| Feature | Standalone | AO Mode |
|---------|------------|---------|
| Subagent spawning | Yes | No (AO manages sessions) |
| Hook location | Plugin directory | Workspace .claude/ |
| State location | Plugin directory | Workspace .claude/forge/ |
| Metadata sync | No | Yes (AO dashboard) |
| System prompt | Default | AO-optimized |

## Troubleshooting

### Installation not working

Check that the workspace is a git repository:
```bash
git rev-parse --show-toplevel
```

### Metadata not syncing

Verify AO environment variables:
```bash
echo $AO_SESSION $AO_DATA_DIR
```

Check that metadata file exists:
```bash
ls -la "$AO_DATA_DIR/$AO_SESSION"
```

### Hooks not running

Ensure `.claude/settings.json` is valid JSON and contains the hook configurations.

## Files

- `install.mjs` - Main installer (Node, no dependencies)
- `install.sh` - Thin wrapper for shell execution
- `forge-system-prompt.md` - AO-optimized FORGE protocol
- `forge-agent-rules.md` - Short agent rules reference
- `selftest.sh` - Automated test suite
