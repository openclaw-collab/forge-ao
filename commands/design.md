---
name: forge:design
description: Create visual designs with Stitch and technical architecture
argument-hint: "[design requirements]"
disable-model-invocation: true
---

# /forge:design

Create visual designs using Stitch and define technical architecture.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to design phase
.claude/forge/scripts/forge-state.sh set-phase design
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next plan

# Write artifact
cat > docs/forge/design.md << 'EOF'
# Design: [Objective]

## UI Design
...
EOF
```

## Usage

```bash
/forge:design "user profile page with avatar upload"
/forge:design "dashboard with charts and metrics"
/forge:design "mobile-first navigation"
```

## Process

1. **Stitch Integration** - Generate UI mockups via Stitch MCP
2. **Design System Compliance** - Check against existing design system
3. **Technical Architecture** - Define component structure
4. **API Contracts** - Define data interfaces
5. **Document designs** - Write to `docs/forge/design.md`

## Stitch Workflow

If Stitch MCP is available:

```
1. Generate initial designs with Stitch
2. Review for design system compliance
3. Iterate based on feedback
4. Export to `docs/designs/`
5. Reference in design.md
```

## Design System Check

Before finalizing:
- [ ] Colors match design system
- [ ] Typography follows guidelines
- [ ] Spacing uses design tokens
- [ ] Components use existing library
- [ ] Accessibility requirements met

## AO Mode Considerations

In AO mode:
- Stitch MCP should be configured in `.mcp.json`
- Design iteration happens within single session
- Export designs to workspace for AO to track

## Acceptance Criteria

This phase is complete when:
- [ ] UI designs created (via Stitch or documented)
- [ ] Design system compliance verified
- [ ] Component hierarchy defined
- [ ] API contracts specified
- [ ] Data flow diagrammed
- [ ] Accessibility considerations documented
- [ ] `docs/forge/design.md` written
- [ ] State updated: phase=design, status=completed
- [ ] Next phase set to plan

## Phase Artifacts

**Writes to:** `docs/forge/design.md`

### Artifact Structure
```markdown
# Design: [Objective]

## UI Design

### Screens

#### [Screen Name]
- Description
- Key elements
- Interactions

### Design System Compliance

| Element | Token | Value |
|---------|-------|-------|
| Primary Color | --color-primary | #... |
| ... | ... | ... |

## Technical Architecture

### Component Hierarchy
```
Component
├── Subcomponent A
│   └── Element 1
└── Subcomponent B
```

### API Contracts

```typescript
interface FeatureProps {
  // Document all props
}
```

### Data Flow

[Diagram or description]

## Accessibility

- Keyboard navigation: [spec]
- Screen reader: [spec]
- Color contrast: [spec]

## Assets

- Generated designs: `docs/designs/[name].png`
```

## Next Steps

After design, continue with:
- `/forge:plan` - Create implementation plan
- `/forge:test` - Skip to test strategy

## Required Skill

**REQUIRED:** `@forge-design`
