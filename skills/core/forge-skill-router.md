---
name: forge-skill-router
description: Auto-loads and routes to appropriate skills based on task type, file extensions, and context. Use at session start or when task type changes.
version: 1.0.0
---

# FORGE Skill Router

Automatically detects task types and routes to appropriate skills. Ensures the right expertise is applied to each task without manual skill selection.

## When to Use

Activate this skill when:
- Starting a new session (auto-triggered)
- Task type changes mid-session
- Unclear which skill applies to current work
- User asks to "route this task" or "find right skill"

## Task Detection Matrix

| Signal | Detected Task Type | Skill to Route |
|--------|-------------------|----------------|
| `.tsx`, `.jsx`, `.vue`, `.svelte` files | Frontend component | `forge-react-generator` + `forge-design-system` |
| `dashboard`, `interface`, `ui design`, `design a` | Interface design | `frontend-design` + `forge-design-system` |
| `animation`, `motion`, `transition` | Animation work | `interaction-design` + `12-principles-of-animation` |
| `design system`, `color palette`, `typography` | Design system | `forge-design-system` |
| `stitch`, `generate screen`, `mockup` | Visual design | `forge-stitch-master` |
| `worker`, `cloudflare`, `hono`, `api` | Backend integration | `forge-cloudflare-integrator` |
| `/api/`, `endpoint`, `route` | API development | `forge-cloudflare-integrator` |
| `test`, `spec`, `cypress`, `playwright` | Testing | `forge-test` + `test-driven-development` |
| `audit`, `accessibility`, `a11y`, `wcag` | Quality audit | `forge-quality-auditor` |
| `debug`, `fix bug`, `error` | Debugging | `systematic-debugging` |
| `plan`, `implement feature` | Planning | `writing-plans` + `forge-plan` |
| `review code`, `pr review` | Code review | `forge-review` + `arkived-agents` |
| `performance`, `slow`, `optimize` | Performance | `performance-oracle` |
| `security`, `vulnerability`, `auth` | Security | `security-sentinel` |
| `refactor`, `simplify` | Simplification | `code-simplicity-reviewer` |
| `brainstorm`, `explore` | Brainstorming | `arkived-brainstorming` + `forge-brainstorm` |
| `research`, `best practice` | Research | `forge-research` |
| `personalize`, `customize setup`, `configure` | Personalization | `forge-personalize` |
| `automation`, `hooks`, `mcp servers` | Automation setup | `claude-automation-recommender` |
| `document solution`, `that worked`, `it's fixed` | Knowledge capture | `compound-docs` |

## Routing Rules

### Rule 1: File Extension Priority
When files are mentioned or edited:
- `.tsx/.jsx` → Frontend skills
- `.py` → Python skills
- `.rb` → Rails/Ruby skills
- `.go` → Go skills
- `.rs` → Rust skills

### Rule 2: Task Keyword Priority
When user describes task:
- "create component" → `forge-react-generator`
- "design system" → `forge-design-system`
- "generate mockup" → `forge-stitch-master`
- "add backend" → `forge-cloudflare-integrator`
- "write tests" → `test-driven-development`
- "debug error" → `systematic-debugging`
- "review code" → `forge-review`

### Rule 3: Workflow Phase Priority
When in FORGE workflow:
- Phase 1 (Brainstorm) → `forge-brainstorm`
- Phase 2 (Research) → `forge-research`
- Phase 3 (Design) → `forge-design` + `forge-stitch-master`
- Phase 4 (Plan) → `forge-plan` + `writing-plans`
- Phase 5 (Test) → `forge-test` + `test-driven-development`
- Phase 6 (Build) → `forge-build` + `subagent-driven-development`
- Phase 7 (Validate) → `forge-validate` + `verification-before-completion`
- Phase 8 (Review) → `forge-review` + `arkived-agents`
- Phase 9 (Learn) → `forge-learn`

## Routing Process

```
1. Analyze context (files, task description, current phase)
2. Match against detection matrix
3. Select primary skill (highest confidence)
4. Select supporting skills (contextual)
5. Announce routing decision
6. Activate primary skill
```

## Usage

### Automatic (Session Start Hook)
```
Session starts → Skill router analyzes workspace → Loads relevant skills
```

### Manual
```
User: "Route this to the right skill"
→ Analyze current task
→ Return routing recommendation
→ Activate recommended skill
```

### Example Routing

**Input**: "Create a login form component in React"

**Analysis**:
- Keywords: "create", "component", "React"
- File type: .tsx implied
- Task: Frontend UI

**Routing**:
- Primary: `forge-react-generator`
- Secondary: `forge-design-system` (for consistent styling)
- Optional: `forge-quality-auditor` (for accessibility)

**Output**: "Routing to `forge-react-generator` for React component creation with `forge-design-system` for styling consistency."

## Integration

Works with:
- `forge-init` for session start routing
- `forge-help` for skill recommendations
- All workflow skills for phase-appropriate routing
- Hooks for automatic skill loading on file operations

## Configuration

User can customize routing rules in `.claude/forge/config.json`:

```json
{
  "skill_router": {
    "auto_route": true,
    "confirm_before_switch": false,
    "custom_rules": [
      {
        "pattern": "my-custom-pattern",
        "skill": "my-custom-skill"
      }
    ]
  }
}
```
