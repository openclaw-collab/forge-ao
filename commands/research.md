---
name: forge:research
description: BMAD-style parallel research to validate technical approaches
argument-hint: "[topic to research]"
disable-model-invocation: true
---

# /forge:research

Validate brainstormed approaches through BMAD-style parallel research.

## State Update Protocol

**ON ENTRY:**
```bash
# Update state to research phase
.claude/forge/scripts/forge-state.sh set-phase research
```

**ON EXIT:**
```bash
# Mark phase complete and set next
.claude/forge/scripts/forge-state.sh complete-phase
.claude/forge/scripts/forge-state.sh set-next design

# Write artifact
cat > docs/forge/research.md << 'EOF'
# Research: [Objective]

## Technical Validation
...
EOF
```

## Usage

```bash
/forge:research "authentication best practices"
/forge:research "React state management options"
/forge:research "database selection for high write throughput"
```

## Process

1. **Context7 Query** - Check official documentation
2. **Pattern Search** - Look for existing patterns in memory
3. **Best Practice Validation** - Verify against industry standards
4. **Risk Assessment** - Identify potential issues
5. **Document findings** - Write to `docs/forge/research.md`

## Research Angles

For comprehensive research, explore:
- **Technical feasibility** - Can it be built?
- **Performance characteristics** - Will it scale?
- **Security implications** - Is it secure?
- **Maintenance burden** - Can it be maintained?
- **Integration complexity** - Does it fit existing architecture?

## AO Mode: Parallel Task Plan

In AO mode, research can be parallelized:

```bash
ao spawn <project> "research: Context7 query for [library]"
ao spawn <project> "research: best practices for [pattern]"
ao spawn <project> "research: security considerations for [approach]"
ao spawn <project> "research: performance benchmarks for [technology]"
```

## Acceptance Criteria

This phase is complete when:
- [ ] Context7 documentation queried for relevant libraries
- [ ] Existing patterns from memory reviewed
- [ ] Technical feasibility validated
- [ ] Security implications assessed
- [ ] Performance characteristics documented
- [ ] Risks identified with mitigations
- [ ] `docs/forge/research.md` written
- [ ] State updated: phase=research, status=completed
- [ ] Next phase set to design

## Phase Artifacts

**Writes to:** `docs/forge/research.md`

### Artifact Structure
```markdown
# Research: [Objective]

## Context7 Findings

### [Library Name]
- Version: X.Y.Z
- Key capabilities
- Relevant code examples

## Pattern Analysis

### Existing Patterns in Memory
- [Pattern 1] - Applicability: High/Medium/Low
- [Pattern 2] - Applicability: High/Medium/Low

## Technical Validation

### Feasibility: ✅ VALIDATED / ⚠️ RISKS / ❌ BLOCKED

**Evidence:**
- [Supporting evidence]

**Concerns:**
- [Identified concerns]

## Security Assessment

| Risk | Severity | Mitigation |
|------|----------|------------|
| ...  | ...      | ...        |

## Performance Analysis

Expected performance characteristics...

## Recommendation

Proceed with / modify / reject approach based on research findings.
```

## Next Steps

After research, continue with:
- `/forge:design` - Create UI/technical designs
- `/forge:plan` - Skip to implementation planning

## Required Skill

**REQUIRED:** `@forge-research`
