---
name: forge:personalize
description: Personalize FORGE configuration for your specific project
disable-model-invocation: true
---

# /forge:personalize

Customize FORGE for your project's specific needs.

## Usage

```bash
/forge:personalize              # Full personalization workflow
/forge:personalize --hooks      # Personalize hooks only
/forge:personalize --skills     # Create project-specific skills
/forge:personalize --agents     # Create project-specific agents
```

## What It Does

1. **Analyzes your codebase** - Detects framework, language, patterns
2. **Recommends automations** - Uses `claude-automation-recommender`
3. **Creates configurations** - Sets up `.claude/forge/config.json`
4. **Personalizes hooks** - Creates `.claude/hooks/settings.json`
5. **Optional: Custom skills/agents** - Project-specific extensions

## Output

- `.claude/forge/config.json` - FORGE configuration
- `.claude/hooks/settings.json` - Hook configurations
- `.mcp.json` - MCP server recommendations
- `docs/forge/project-profile.md` - Project analysis
- Updated `CLAUDE.md` with FORGE guidance

## When to Use

- Setting up FORGE on a new project
- Want to customize FORGE behavior
- Adding project-specific skills or hooks
- Optimizing FORGE for your team's workflow
