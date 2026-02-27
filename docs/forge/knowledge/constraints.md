# Constraints Registry

## Hard Constraints

Non-negotiable limitations that must be respected by all phases.

| ID | Constraint | Source | Phase Introduced | Impact |
|----|------------|--------|------------------|--------|
| C1 | | | | |

## Soft Constraints

Preferences that should be followed but can be challenged with justification.

| ID | Constraint | Source | Phase Introduced | Challenge Process |
|----|------------|--------|------------------|-------------------|
| S1 | | | | |

## Derived Constraints

Constraints that emerge from decisions made during workflow.

| ID | Derived From | Constraint | Locked By Phase |
|----|--------------|------------|-----------------|
| DC1 | | | |

## Debate Configuration Constraints

Debate behavior is configurable but follows these constraints:

| ID | Constraint | Rationale |
|----|------------|-----------|
| DC-D1 | Brainstorm phase requires debate by default | Ensures structured evaluation of all approaches |
| DC-D2 | `--debate` flag overrides all trigger conditions | Allows explicit debate request regardless of config |
| DC-D3 | `--no-debate` flag skips debate even when triggered | Emergency override for time-critical situations |
| DC-D4 | Risk threshold minimum is 1, maximum is 10 | Standard risk matrix bounds |
| DC-D5 | Component threshold minimum is 2 | Single component changes don't need debate |

### Debate Trigger Thresholds

| Trigger Mode | Condition | Default Threshold |
|--------------|-----------|-------------------|
| always | Every phase with debate_enabled | N/A |
| major_decision | Components affected > threshold | 3 |
| risk_threshold | Risk score ≥ threshold | 6 |
| never | Never auto-trigger | N/A |
| explicit_only | Only with --debate flag | N/A |

## Constraint Interaction Matrix

| Constraint | Conflicts With | Resolution |
|------------|----------------|------------|
| | | |

## Constraint Validation

Every phase must:
1. Read all constraints before starting
2. Document any new constraints discovered
3. Validate outputs against existing constraints
4. Flag violations immediately (triggers debate)

---

*Last updated: Automatically maintained by FORGE phases*
