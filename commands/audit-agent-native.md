---
name: audit-agent-native
description: Run agent-native architecture review with sequential or parallel analysis
disable-model-invocation: true
---

# Agent-Native Architecture Audit

Conduct a review of the codebase against agent-native architecture principles.

## AO Mode vs Standalone

**AO Mode (AO_SESSION set):**
- Sequential analysis in current session
- Produces "Parallel Audit Plan" for AO to execute externally
- No subagent spawning

**Standalone Mode:**
- Can spawn 8 parallel Task agents (one per principle)
- Gathers all results in parallel

## Core Principles

1. **Action Parity** - "Whatever the user can do, the agent can do"
2. **Tools as Primitives** - "Tools provide capability, not behavior"
3. **Context Injection** - "System prompt includes dynamic context"
4. **Shared Workspace** - "Agent and user work in same data space"
5. **CRUD Completeness** - "Every entity has full CRUD"
6. **UI Integration** - "Agent actions reflected in UI"
7. **Capability Discovery** - "Users can discover agent capabilities"
8. **Prompt-Native Features** - "Features defined as prompts"

## Workflow

### Step 1: Load Skill

Invoke agent-native-architecture skill:
```
@agent-native-architecture
```

### Step 2: Analysis

**AO Mode - Sequential:**
```bash
# Audit each principle sequentially in session
for principle in principles:
  audit_principle(principle)
  document_findings(principle)
```

**Standalone - Parallel:**
```bash
# Spawn 8 parallel agents (one per principle)
Task Explore: "Audit Action Parity..."
Task Explore: "Audit Tools as Primitives..."
# ... etc
```

### Step 3: AO Mode: Parallel Audit Plan

In AO mode, produce external audit commands:

```markdown
## Parallel Audit Plan

For comprehensive audit, AO can spawn:

```bash
ao spawn <project> "audit: action parity analysis"
ao spawn <project> "audit: tools as primitives"
ao spawn <project> "audit: context injection"
ao spawn <project> "audit: shared workspace"
ao spawn <project> "audit: CRUD completeness"
ao spawn <project> "audit: UI integration"
ao spawn <project> "audit: capability discovery"
ao spawn <project> "audit: prompt-native features"
```

Run these externally, then provide results to compile report.
```

### Step 4: Compile Report

Combine findings into summary:

```markdown
## Agent-Native Architecture Review

| Principle | Score | Status |
|-----------|-------|--------|
| Action Parity | X/Y | ✅/⚠️/❌ |
| Tools as Primitives | X/Y | ✅/⚠️/❌ |
| ... | ... | ... |

**Overall Score: X%**

### Top Recommendations
1. [Priority action]
2. ...
```

## Auto-Completion Criteria

Completes when:
- [ ] All 8 principles audited
- [ ] Numeric scores calculated (X/Y format)
- [ ] Summary table compiled
- [ ] Recommendations prioritized
- [ ] Report written to `docs/forge/agent-native-audit.md`

## Phase Artifact

**Writes to:** `docs/forge/agent-native-audit.md`

## Required Skill

**REQUIRED:** `@agent-native-architecture`
