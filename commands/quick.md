---
name: forge:quick
description: Streamlined workflow for rapid development - skips exploration phases
argument-hint: "[feature or fix description]"
disable-model-invocation: true
---

# /forge:quick

Streamlined workflow for rapid development. Skips explicit Brainstorm/Research/Design.

## Usage

```bash
/forge:quick "fix login button color"
/forge:quick "add error handling to API"
/forge:quick "update navigation labels"
```

## Process

1. **Auto-plan** - Generate minimal plan
2. **Build** - Execute immediately
3. **Test** - Run quick tests
4. **Validate** - Basic verification
5. **Learn** - Capture minimal learnings

## When to Use

Best for:
- Bug fixes
- Small features (< 50 lines)
- Style changes
- Quick prototypes

## Equivalent To

```
/forge:plan --quick &&
/forge:build &&
/forge:test &&
/forge:validate &&
/forge:learn --minimal
```

## Required Skill

**REQUIRED:** `@forge-help` (for orchestration)
