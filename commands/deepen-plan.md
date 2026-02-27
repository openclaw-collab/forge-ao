---
name: forge:deepen-plan
description: Enhance a plan with research-driven insights for each section
disable-model-invocation: true
---

# Deepen Plan - Research Enhancement

**Note: The current year is 2026.**

Enhances an existing plan with research-driven insights, best practices, and implementation details.

## AO Mode vs Standalone

**AO Mode (when AO_SESSION is set):**
- Sequential research in current session
- Produces "Parallel Research Plan" for AO to execute externally
- No subagent spawning

**Standalone Mode:**
- Can spawn parallel Task agents for research
- Gathers all results in parallel

## Plan File

<plan_path> #$ARGUMENTS </plan_path>

**If empty:** Check `docs/forge/plan.md` or `ls docs/plans/`

## Main Tasks

### 1. Parse Plan Structure

Extract:
- Overview/Problem Statement
- Technical Approach sections
- Implementation phases/steps
- Technologies/frameworks mentioned
- Domain areas (data models, APIs, UI, etc.)

### 2. Research (AO Mode = Sequential, Standalone = Parallel)

**AO Mode - Sequential in Session:**
```bash
# Research each section sequentially
for section in sections:
  research_section(section)      # Read skill, search docs
  document_findings(section)
```

**Standalone - Parallel Tasks:**
```bash
# Spawn parallel research agents
Task Explore: "Research: [section 1]"
Task Explore: "Research: [section 2]"
# ... etc
```

### 3. AO Mode: Parallel Research Plan

In AO mode, produce external research commands:

```markdown
## Parallel Research Plan

For comprehensive research, AO can spawn:

```bash
ao spawn <project> "research: React Query best practices 2026"
ao spawn <project> "research: TypeScript performance patterns"
ao spawn <project> "research: [technology] security considerations"
```

Run these externally, then provide results to continue.
```

### 4. Discover Skills (Read Only, No Spawn)

Read relevant skills sequentially:
```bash
# Check for relevant skills
ls .claude/skills/
cat [skill-path]/SKILL.md  # If relevant to plan
```

**AO Mode:** Read and apply skills directly in session.

### 5. Check Learnings/Solutions

```bash
find docs/solutions -name "*.md" 2>/dev/null
```

Read relevant ones, extract insights.

### 6. Synthesize Findings

Combine research into enhancement sections.

## Enhancement Format

```markdown
## [Original Section Title]

[Original content preserved]

### Research Insights

**Best Practices:**
- [Recommendation 1]
- [Recommendation 2]

**Implementation Details:**
```[language]
// Code example from research
```

**Edge Cases:**
- [Edge case and handling]
```

## Auto-Completion Criteria

Completes when:
- [ ] All plan sections analyzed
- [ ] Research completed (sequential or parallel)
- [ ] Skills applied
- [ ] Learnings integrated
- [ ] Enhancement sections written
- [ ] Original plan updated

## Phase Artifact

**Updates:** Original plan file or `[plan]-deepened.md`

## Required Skill

**REQUIRED:** `@forge-research`
