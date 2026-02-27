---
name: forge-init
description: Initialization phase for FORGE - detects workspace state and personalizes workflow for new or existing projects
---

# FORGE Initialization

**Phase 0 of 9** - Detect workspace state and configure FORGE for this specific project.

## Purpose

**"Start smart"** - Before brainstorming, understand what we're working with:
- New project? → Guide through full workflow
- Existing project? → Sync with current state
- In-progress? → Resume where left off

## Detection Logic

```
Workspace State Detection:
├── Has FORGE artifacts?
│   ├── Yes → Check progress → Resume or Restart
│   └── No  → New project → Full setup
└── Has existing code?
    ├── Yes → Analyze codebase → Suggest workflow
    └── No  → Greenfield → Full workflow
```

## Initialization Steps

### 1. Detect Project Type

**Analyze codebase:**
- `package.json` → React/Vue/Node.js
- `requirements.txt` → Python
- `Cargo.toml` → Rust
- `go.mod` → Go
- `pom.xml` → Java
- `Gemfile` → Ruby

**Output:** Project type detected

### 2. Check FORGE State

**Look for:**
- `docs/forge/*.md` → Previous FORGE runs
- `.claude/forge/config.json` → Saved configuration
- `.claude/memory/forge/` → Session history

**Determine:**
- Fresh start
- Resume in-progress
- Existing project, new FORGE

### 3. Personalize Configuration

**Based on project type:**

| Project Type | Suggested Level | Auto-Enable |
|--------------|-----------------|-------------|
| React/Next.js | intelligent | frontend-design |
| Python API | intelligent | type-check on save |
| Legacy codebase | maximal | strict reviews |
| Greenfield | minimal | quick iteration |

### 4. User Prompt

**New Project:**
```
═══════════════════════════════════════════════════
FORGE Initialization
═══════════════════════════════════════════════════

Detected: New React project

What are we building?
→ [User describes objective]

Suggested workflow:
• All 9 phases (Brainstorm → Learn)
• Intelligent artifact level
• Karpathy guidelines enforced

Start with Phase 1: Brainstorm?
→ [yes/customize/no]
═══════════════════════════════════════════════════
```

**Existing Project:**
```
═══════════════════════════════════════════════════
FORGE Initialization
═══════════════════════════════════════════════════

Detected: Existing Python project
Found FORGE artifacts:
  ✅ Brainstorm complete
  ✅ Research complete
  ⏳ Plan incomplete (2 of 5 tasks)

Resume from Plan phase?
→ [yes/restart/customize]
═══════════════════════════════════════════════════
```

## Configuration Generation

**Create `.claude/forge/config.json`:**
```json
{
  "project_type": "react",
  "initialized": "2024-01-15",
  "artifact_level": "intelligent",
  "phases": {
    "completed": ["brainstorm", "research"],
    "current": "design",
    "pending": ["plan", "test", "build", "validate", "review", "learn"]
  },
  "preferences": {
    "karthy_enforced": true,
    "security_checks": true,
    "auto_lint": true
  },
  "detected": {
    "framework": "next.js",
    "styling": "tailwind",
    "testing": "jest",
    "typescript": true
  }
}
```

## Hook Installation

**Auto-install recommended hooks:**
```bash
# Based on project type
hooks/
├── PostToolUse/
│   ├── format-on-save.sh      # If prettier found
│   ├── lint-on-save.sh        # If eslint found
│   └── type-check.sh          # If TypeScript
├── PreToolUse/
│   ├── block-env-edits.sh     # Always
│   └── confirm-destructive.sh # If git repo
└── SessionStart/
    └── forge-init.sh          # Always
```

## Integration

**Called by:**
- `/forge:start` - Full workflow entry
- SessionStart hook - Auto-init on new sessions

**Hands off to:**
- `/forge:brainstorm` - If new project
- Phase in progress - If resuming
- `/forge:help` - If user needs guidance

## Arguments

| Argument | Description |
|----------|-------------|
| `--detect-only` | Just analyze, don't configure |
| `--force-reset` | Reset FORGE state, start fresh |
| `--level=minimal\|intelligent\|maximal` | Override detected level |
| `--skip-hooks` | Don't install hooks |

## Success Criteria

Initialization complete when:
- [ ] Project type detected
- [ ] FORGE state assessed
- [ ] Config file created/updated
- [ ] Recommended hooks identified
- [ ] User confirmed next step

## Resume Capability

**State tracking:**
```json
{
  "session": {
    "started": "2024-01-15T10:00:00Z",
    "last_phase": "design",
    "last_action": "awaiting_user_input",
    "artifacts_created": ["brainstorm.md", "research.md"]
  }
}
```

**Resume logic:**
1. Read state file
2. Check phase outputs exist
3. Present status
4. Ask: continue/restart/abort
