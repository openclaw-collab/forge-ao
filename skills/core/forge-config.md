---
name: forge-config
description: Use when configuring FORGE workflow settings, artifact levels, or quality gates
---

# FORGE Configuration

Central configuration system for the FORGE 9-phase development workflow.

## Configuration Location

**User-level config:** `~/.claude/forge/config.json`

**Project-level config:** `.claude/forge/config.json` (overrides user-level)

## Configuration Schema

```json
{
  "artifact_level": "intelligent",
  "quality_gates": {
    "enabled": true,
    "gates": ["design_complete", "plan_clear", "tests_defined", "implementation_ready", "validation_passed"]
  },
  "karpathy_guidelines": {
    "enforced": true,
    "max_lines_per_edit": 50,
    "require_tests": true,
    "require_evidence": true
  },
  "phases": {
    "brainstorm": { "agent_count": 4, "debate_enabled": true },
    "research": { "parallel_agents": 3, "timeout_ms": 300000 },
    "design": { "stitch_enabled": true, "auto_prototype": false },
    "plan": { "max_steps": 20, "tdd_required": true },
    "build": { "teams": 3, "parallel": true, "subagent_review": true },
    "test": { "browser": true, "unit": true, "coverage_threshold": 80 },
    "validate": { "user_approval": true, "evidence_required": true },
    "review": { "parallel_reviewers": true, "karthy_focused": true },
    "learn": { "auto_update_claude_md": true, "capture_patterns": true }
  },
  "skills": {
    "auto_load": true,
    "dynamic_loading": true
  },
  "memory": {
    "capture_learnings": true,
    "extract_patterns": true,
    "update_project_context": true
  }
}
```

## Artifact Levels

### Minimal
- **Creates:** Plan + Learn documents only
- **Best for:** Quick fixes, spikes, prototypes
- **Time:** Fastest (skips intermediate docs)

### Intelligent (Default)
- **Creates:** Brainstorm, Plan, Test, Review, Learn
- **Best for:** Most features, balanced approach
- **Time:** Moderate

### Maximal
- **Creates:** All 9 phases + intermediate docs
- **Best for:** Complex projects, onboarding, critical systems
- **Time:** Most comprehensive

## Quality Gates

Gates can be configured per project. Each gate blocks progression until passed.

| Gate | Phase | Validates |
|------|-------|-----------|
| `design_complete` | After Design | Design specs ready |
| `plan_clear` | After Plan | Implementation plan clear |
| `tests_defined` | After Plan | Test strategy defined |
| `implementation_ready` | Before Build | All prerequisites met |
| `validation_passed` | After Validate | All verifications passed |

## Dynamic Skill Loading

FORGE automatically loads skills based on task signals:

| Task Signal | Auto-Loaded Skills |
|-------------|-------------------|
| `.tsx` edit | `@frontend-design`, `@vercel-react-best-practices` |
| `animation` | `@interaction-design`, `@12-principles-of-animation` |
| `API`, `endpoint` | `@cloudflare-full-stack-integration` |
| `LaTeX`, `math` | `@latex-validator` |
| `design`, `UI` | `@design-system`, `@design-lab` |
| `test` | `test-driven-development` (if installed) |
| `fix`, `debug` | `systematic-debugging` (if installed) |

## Karpathy Guidelines Enforcement

When enabled, all phases enforce:

1. **"Simpler is better"** - Debate phase weights simplicity
2. **"Don't refactor unrelated code"** - Pre-edit scope validation
3. **"One logical change per edit"** - Post-edit validation
4. **"Changed lines < 50"** - karpathy-reviewer check
5. **"Evidence before assertions"** - Required verification
6. **"Surface assumptions"** - Debate phase surfaces assumptions

## Command Line Overrides

Any config value can be overridden via command flags:

```
/forge:plan --artifact-level=minimal
/forge:build --karthy-enforced=false
/forge:quick --skip-gates
```

## Default Configuration

If no config exists, FORGE uses intelligent defaults optimized for general development.
