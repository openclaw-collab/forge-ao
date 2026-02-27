---
name: forge:design
description: Technical system design and UI/UX design - AO-native, non-interactive, file-based
argument-hint: "[design requirements]"
disable-model-invocation: true
---

# /forge:design

Create technical system design and derive UI/UX design. AO-native only - no standalone mode, no prompts, file-based state.

**CRITICAL:** Planning cannot begin until system design is complete.

---

## Two-Layer Design Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    LAYER 1: SYSTEM DESIGN                       │
│                    (MUST complete first)                        │
├─────────────────────────────────────────────────────────────────┤
│  Architecture → Components → Data Models → APIs → Auth → Failures│
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼ (derives from)
┌─────────────────────────────────────────────────────────────────┐
│                    LAYER 2: UI/UX DESIGN                        │
│              (derived from System Design)                       │
├─────────────────────────────────────────────────────────────────┤
│  User Flows → Interface Designs → Interactions → Accessibility  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Phase Entry Protocol

**ON ENTRY - MANDATORY READS:**

```bash
# 1. Read prior decisions
READ docs/forge/knowledge/decisions.md

# 2. Read constraints
READ docs/forge/knowledge/constraints.md

# 3. Read research handoff
READ docs/forge/handoffs/research-to-design.md

# 4. Update active workflow state
echo "phase: design" > docs/forge/active-workflow.md
echo "layer: system" >> docs/forge/active-workflow.md
echo "status: in_progress" >> docs/forge/active-workflow.md
```

---

## Layer 1: System Design (Required First)

### 1.1 Architecture

Define the system architecture:

```markdown
## System Architecture

### Pattern
[Monolith / Microservices / Serverless / Event-Driven / Layered / Hexagonal]

### Rationale
[Why this pattern fits the requirements]

### Diagram
```
[Client] → [API Gateway] → [Service Layer] → [Data Layer]
                ↓
         [Message Queue] → [Worker]
```

### Technology Stack
| Layer | Technology | Version | Purpose |
|-------|------------|---------|---------|
| Frontend | | | |
| Backend | | | |
| Database | | | |
| Cache | | | |
| Queue | | | |
```

### 1.2 Components

Define all system components:

```markdown
## Component Inventory

### Component: [Name]
| Attribute | Value |
|-----------|-------|
| Responsibility | [Single sentence] |
| Interface | [Contract] |
| Dependencies | [List] |
| Failure Mode | [How it fails] |
| Recovery | [How it recovers] |

### Component Hierarchy
```
System
├── Component A
│   ├── Subcomponent A1
│   └── Subcomponent A2
├── Component B
└── Component C
```
```

### 1.3 Data Models

Define all data structures:

```markdown
## Data Models

### Entity: [Name]
```typescript
interface EntityName {
  id: string;           // UUID v4
  createdAt: DateTime;  // ISO 8601
  updatedAt: DateTime;  // ISO 8601
  // ... fields with types and constraints
}
```

**Constraints:**
- [Field constraints, validation rules]

**Indexes:**
- [Index definitions for query performance]

### Entity Relationships
```
User ||--o{ Post : creates
Post ||--o{ Comment : has
```
```

### 1.4 APIs

Define all interfaces:

```markdown
## API Contracts

### [Operation Name]
| Attribute | Value |
|-----------|-------|
| Method | GET / POST / PUT / DELETE |
| Path | /api/v1/... |
| Auth | Required / Optional / None |
| Rate Limit | [requests per window] |

**Request:**
```typescript
interface RequestBody {
  // Fields with types
}
```

**Response (200):**
```typescript
interface ResponseBody {
  // Fields with types
}
```

**Error Responses:**
| Status | Condition | Response |
|--------|-----------|----------|
| 400 | | |
| 401 | | |
| 404 | | |
| 500 | | |
```

### 1.5 Auth Strategy

Define security model:

```markdown
## Authentication & Authorization

### Auth Pattern
[Session / JWT / OAuth2 / API Key / mTLS]

### Flow
```
[Step 1] → [Step 2] → [Step 3]
```

### Permissions Matrix
| Role | Resource | Action | Condition |
|------|----------|--------|-----------|
| | | | |

### Security Considerations
- [Specific security requirements]
```

### 1.6 Failure Modes

Define how the system handles failures:

```markdown
## Failure Mode Analysis

### Failure: [Scenario]
| Attribute | Value |
|-----------|-------|
| Trigger | [What causes it] |
| Impact | [What breaks] |
| Detection | [How we know] |
| Response | [Automatic action] |
| Recovery | [How to restore] |
| Escalation | [When to page] |

### Circuit Breakers
| Service | Threshold | Timeout | Fallback |
|---------|-----------|---------|----------|
| | | | |

### Retry Policy
| Operation | Strategy | Max Attempts | Backoff |
|-----------|----------|--------------|---------|
| | | | |
```

---

## Conditional Debate Gate

**TRIGGER CONDITIONS:**

Per `workflows/forge-workflow.json`, debate is triggered when:
- `debate_trigger`: "major_decision" (default)
- Design affects >3 components (component_threshold)
- Design challenges prior decision in decisions.md

Additional conditions that trigger debate:
- [ ] Design introduces new technology not in research
- [ ] Design changes auth or security model
- [ ] Failure modes have high impact (R9 per risk matrix)

**CLI FLAG OVERRIDES:**

```bash
# Force debate even if conditions not met
/forge:design "objective" --debate

# Skip debate even if conditions are met
/forge:design "objective" --no-debate
```

**DEBATE GATE PROTOCOL:**

```bash
# Check if debate should run:
# 1. Was --debate flag passed? -> FORCE DEBATE
# 2. Was --no-debate flag passed? -> SKIP DEBATE
# 3. Does design meet trigger conditions? -> DEBATE
# 4. Otherwise -> SKIP DEBATE

# If debate triggered:
# 1. Generate debate plan
cat > docs/forge/debate/design-$(date +%Y%m%d-%H%M%S)/debate-plan.md << 'EOF'
# Debate Plan: Design Decision
# [Standard debate plan structure]
EOF

# 2. Update workflow
echo "debate_triggered: true" >> docs/forge/active-workflow.md

# 3. HALT - Wait for debate resolution
# AO spawns debate agents externally
# FORGE continues only when synthesis.md exists
```

---

## Layer 2: UI/UX Design (Derived)

**ONLY proceed after System Design is complete.**

Update workflow:
```bash
echo "layer: uiux" >> docs/forge/active-workflow.md
```

### 2.1 User Flows

Map flows from system capabilities:

```markdown
## User Flows

### Flow: [Name]
**Trigger:** [What starts this flow]
**Goal:** [What user achieves]

**Steps:**
1. [Step] → System: [API/component used]
2. [Step] → System: [API/component used]
3. [Step] → System: [API/component used]

**Alternative Paths:**
- If [condition] → [alternate path]

**Error Paths:**
- If [failure] → [error handling]
```

### 2.2 Interface Designs

Define UI from user flows:

```markdown
## Interface Designs

### Screen: [Name]
**Purpose:** [What this screen does]
**Entry Points:** [How users arrive here]
**Exit Points:** [Where users go next]

**Layout:**
```
┌─────────────────────────────┐
│ [Header: Component X]       │
├─────────────────────────────┤
│ [Main: Component Y]         │
│                             │
├─────────────────────────────┤
│ [Footer: Component Z]       │
└─────────────────────────────┘
```

**Components:**
| Element | Type | Data Source | Interaction |
|---------|------|-------------|-------------|
| | | | |

**States:**
- Empty: [What shows when no data]
- Loading: [Loading state]
- Error: [Error state]
- Success: [Normal state]
```

### 2.3 Interactions

Define behavior:

```markdown
## Interaction Specifications

### Interaction: [Name]
**Trigger:** [Click / Hover / Scroll / Keypress / Auto]
**Element:** [Which component]

**Behavior:**
1. [What happens]
2. [System call: which API]
3. [UI update]

**Transitions:**
| From | To | Duration | Easing |
|------|-----|----------|--------|
| | | | |

**Feedback:**
- Visual: [What user sees]
- Haptic: [If applicable]
- Audio: [If applicable]
```

### 2.4 Accessibility

Define a11y requirements:

```markdown
## Accessibility Requirements

### Keyboard Navigation
| Element | Focus | Action | Trap |
|---------|-------|--------|------|
| | Tab order | Enter/Space | Yes/No |

### Screen Reader
| Element | Role | Label | State |
|---------|------|-------|-------|
| | ARIA role | aria-label | aria-* |

### Visual
- Minimum contrast: [Ratio]
- Focus indicator: [Style]
- Reduced motion: [Support]
- Color independence: [Not relying on color alone]

### Testing
- [ ] Keyboard-only navigation works
- [ ] Screen reader announces correctly
- [ ] Color contrast passes WCAG AA
```

---

## Phase Exit Protocol

**COMPLETION CHECKLIST:**

Layer 1 (System Design):
- [ ] Architecture defined with rationale
- [ ] All components documented with interfaces
- [ ] Data models with constraints and relationships
- [ ] API contracts with error responses
- [ ] Auth strategy with permissions matrix
- [ ] Failure modes with recovery procedures

Layer 2 (UI/UX Design):
- [ ] User flows mapped to system capabilities
- [ ] Interface designs for all screens
- [ ] Interaction specifications complete
- [ ] Accessibility requirements defined

Debate Gate:
- [ ] Checked against trigger conditions
- [ ] If triggered: debate completed and synthesis exists

**ON EXIT:**

```bash
# 1. Write design artifact
cat > docs/forge/phases/design.md << 'EOF'
# Design: [Objective]

## System Design

### Architecture
[Architecture section]

### Components
[Components section]

### Data Models
[Data models section]

### APIs
[API contracts section]

### Auth Strategy
[Auth section]

### Failure Modes
[Failure analysis section]

## UI/UX Design

### User Flows
[Flows section]

### Interface Designs
[Interface section]

### Interactions
[Interaction section]

### Accessibility
[Accessibility section]

## Design Decisions

| ID | Decision | Rationale | Constraints |
|----|----------|-----------|-------------|
| D1 | | | |

## New Constraints Identified

| ID | Constraint | Source |
|----|------------|--------|
| C1 | | |

## Debate Reference

[If debate triggered: link to debate files]
EOF

# 2. Write handoff to plan phase
cat > docs/forge/handoffs/design-to-plan.md << 'EOF'
# Handoff: Design to Plan

## System Design Summary

### Key Decisions
- [Decision 1 with rationale]
- [Decision 2 with rationale]

### Component Boundaries
[Clear boundaries for implementation]

### Data Flow
[How data moves through system]

### Integration Points
[External dependencies]

## Implementation Considerations

### High Priority
- [Must implement first]

### Technical Debt
- [Known compromises]

### Risks
- [From failure mode analysis]

## For Planning Phase

### Suggested Milestones
1. [Milestone 1: core infrastructure]
2. [Milestone 2: primary features]
3. [Milestone 3: polish]

### Dependencies
| Task | Depends On | Risk |
|------|------------|------|
| | | |

## Questions for Planning

[Open questions to resolve during planning]
EOF

# 3. Update decisions registry
# Append any new decisions to docs/forge/knowledge/decisions.md

# 4. Update constraints registry
# Append any new constraints to docs/forge/knowledge/constraints.md

# 5. Update workflow
cat > docs/forge/active-workflow.md << 'EOF'
phase: design
status: completed
completed_at: $(date -u +%Y-%m-%dT%H:%M:%SZ)
next_phase: plan
artifacts:
  - docs/forge/phases/design.md
  - docs/forge/handoffs/design-to-plan.md
debate_triggered: [true/false]
EOF
```

---

## Usage

```bash
/forge:design "user profile system with avatar upload"
/forge:design "dashboard with real-time metrics"
/forge:design "authentication and authorization system"

# Debate control flags
/forge:design "objective" --debate      # Force debate even if not triggered
/forge:design "objective" --no-debate   # Skip debate even if triggered
```

---

## Acceptance Criteria

Phase complete when:
- [ ] Phase Entry Protocol executed (all reads completed)
- [ ] Layer 1 (System Design) complete:
  - [ ] Architecture documented
  - [ ] Components defined with interfaces
  - [ ] Data models specified
  - [ ] APIs contracted
  - [ ] Auth strategy defined
  - [ ] Failure modes analyzed
- [ ] Debate Gate evaluated (triggered and resolved, or skipped)
- [ ] Layer 2 (UI/UX Design) complete:
  - [ ] User flows mapped
  - [ ] Interfaces designed
  - [ ] Interactions specified
  - [ ] Accessibility defined
- [ ] `docs/forge/phases/design.md` written
- [ ] `docs/forge/handoffs/design-to-plan.md` written
- [ ] Decisions registry updated
- [ ] Constraints registry updated
- [ ] `docs/forge/active-workflow.md` updated

---

## Required Skills

**REQUIRED:** `@forge-design`

---

## Key Principles

1. **System Design FIRST** - UI/UX derives from system capabilities
2. **No standalone mode** - AO-native only
3. **Non-interactive** - No prompts, no menus, file-based state only
4. **Debate Gate conditional** - Triggered by complexity or conflict
5. **Planning blocked** - Cannot proceed to plan without system design
6. **File-based state** - All state in files, not memory
