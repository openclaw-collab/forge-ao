---
name: forge-personalize
description: Personalize FORGE configuration for a specific project. Use when user wants to customize FORGE settings, create project-specific workflows, or adapt the plugin to their team's needs.
version: 1.0.0
---

# FORGE Personalize Workflow

Customize FORGE for your specific project needs. This workflow guides you through personalizing configuration, skills, hooks, and agents for your codebase.

## When to Use

Activate this skill when:
- User says "personalize FORGE" or "/forge:personalize"
- Setting up FORGE on a new project for the first time
- Want to customize FORGE behavior for specific team needs
- Need to create project-specific skills or hooks
- Want to adapt artifact levels or quality gates

## Personalization Areas

### 1. Project Detection & Analysis

**Analyze your codebase:**
- Framework (React, Vue, Rails, Django, etc.)
- Language (TypeScript, Python, Ruby, Go, etc.)
- Testing setup (Jest, pytest, RSpec, etc.)
- Existing conventions and patterns

**Output:** `docs/forge/project-profile.md`

### 2. Configuration Customization

**Create `.claude/forge/config.json`:**

```json
{
  "artifact_level": "intelligent",
  "quality_gates": {
    "enabled": true,
    "gates": ["implementation_ready", "validation_passed"]
  },
  "karpathy_guidelines": {
    "enforced": true,
    "max_lines_per_edit": 50
  },
  "phases": {
    "brainstorm": { "agent_count": 4, "debate_enabled": true },
    "research": { "parallel_agents": 3 },
    "design": { "stitch_enabled": true },
    "plan": { "tdd_required": true },
    "build": { "teams": 3, "parallel": true },
    "test": { "coverage_threshold": 70 },
    "validate": { "evidence_required": true },
    "review": { "karthy_focused": true },
    "learn": { "auto_update_claude_md": true }
  },
  "skill_router": {
    "auto_route": true,
    "confirm_before_switch": false,
    "custom_rules": []
  }
}
```

### 3. Hooks Personalization

**Create `.claude/hooks/settings.json`:**

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "name": "format-on-save",
        "pattern": "\\.(ts|tsx|js|jsx)$",
        "command": "npx prettier --write {{file}}"
      },
      {
        "name": "type-check",
        "pattern": "\\.(ts|tsx)$",
        "command": "npx tsc --noEmit"
      }
    ],
    "PreToolUse": [
      {
        "name": "block-env-edits",
        "pattern": "\\.env",
        "action": "warn",
        "message": "About to edit .env file. Continue?"
      }
    ]
  }
}
```

### 4. Project-Specific Skills

**Create custom skills in `.claude/skills/`:**

| Skill | Purpose | When to Create |
|-------|---------|----------------|
| `new-component` | Component scaffolding | React/Vue projects with consistent patterns |
| `api-doc` | API documentation | Projects with API endpoints |
| `create-migration` | Database migrations | Projects with schema changes |
| `release-notes` | Release documentation | Projects with versioned releases |
| `project-conventions` | Code style guide | Teams with specific patterns |

### 5. Team Agents

**Create custom agents in `.claude/agents/`:**

| Agent | Purpose | When to Create |
|-------|---------|----------------|
| `domain-expert` | Domain-specific review | Specialized business logic |
| `api-reviewer` | API design review | Microservices/API-heavy projects |
| `ui-reviewer` | UI/UX compliance | Design system enforcement |
| `test-reviewer` | Test quality | Test-heavy projects |

### 6. MCP Server Configuration

**Create `.mcp.json` for team sharing:**

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-playwright"]
    }
  }
}
```

## Personalization Workflow

### Step 1: Detect Project Type
```
Analyze codebase → Identify framework/patterns → Document in project-profile.md
```

### Step 2: Recommend Personalizations
```
Based on project type → Suggest skills, hooks, agents → Explain rationale
```

### Step 3: User Selection
```
Present options → User selects what to personalize → Create configurations
```

### Step 4: Generate Configurations
```
Write config.json → Write hooks → Create template skills/agents
```

### Step 5: Validate Setup
```
Test configurations → Verify hooks work → Document in CLAUDE.md
```

## Integration with claude-automation-recommender

This skill leverages `claude-automation-recommender` for initial analysis:

1. Run automation recommender to analyze codebase
2. Convert recommendations to FORGE-specific configurations
3. Create personalized hooks, skills, and agents
4. Document everything in project-profile.md

## Output

After personalization:
- `.claude/forge/config.json` - FORGE configuration
- `.claude/hooks/settings.json` - Hook configurations
- `.claude/skills/` - Project-specific skills (if created)
- `.claude/agents/` - Project-specific agents (if created)
- `.mcp.json` - MCP server configuration
- `docs/forge/project-profile.md` - Project analysis document
- Updated `CLAUDE.md` with FORGE-specific guidance

## Commands

**`/forge:personalize`** - Start full personalization workflow
**`/forge:personalize --hooks`** - Personalize hooks only
**`/forge:personalize --skills`** - Create project-specific skills
**`/forge:personalize --agents`** - Create project-specific agents
