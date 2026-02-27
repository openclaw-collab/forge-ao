---
name: risk-based-testing
description: Use when designing test strategies, prioritizing test efforts, or assessing what to test based on risk. Applies probability-impact scoring to determine test depth.
---

# Risk-Based Testing

## Overview

Risk-based testing allocates testing effort based on risk level. Higher risk = more testing. Lower risk = less testing.

**Formula:** `Risk Score = Probability × Impact`

---

## Risk Calculation

### Probability (Likelihood of Defects)

| Level | Description | Examples |
|-------|-------------|----------|
| P5 | Almost certain (>90%) | Complex new feature, tight deadline, unfamiliar tech |
| P4 | Likely (60-90%) | Integration points, user-facing changes, data migrations |
| P3 | Possible (30-60%) | Refactoring, dependency updates, config changes |
| P2 | Unlikely (10-30%) | Simple bug fixes, cosmetic changes, documentation |
| P1 | Rare (<10%) | Typo fixes, comment updates, formatting |

### Impact (Consequence of Failure)

| Level | Description | Examples |
|-------|-------------|----------|
| I5 | Critical | System down, data loss, security breach, compliance violation |
| I4 | High | Major feature broken, significant revenue impact, data corruption |
| I3 | Medium | Feature degraded, workaround exists, minor data issues |
| I2 | Low | Minor inconvenience, visual issues, non-core feature affected |
| I1 | Trivial | Cosmetic only, no functional impact, internal tools only |

---

## Risk Matrix

| Probability \ Impact | I1 (Trivial) | I2 (Low) | I3 (Medium) | I4 (High) | I5 (Critical) |
|---------------------|--------------|----------|-------------|-----------|---------------|
| **P5 (Certain)** | 5 🟢 | 10 🟡 | 15 🟠 | 20 🔴 | 25 🔴 |
| **P4 (Likely)** | 4 🟢 | 8 🟡 | 12 🟠 | 16 🟠 | 20 🔴 |
| **P3 (Possible)** | 3 🟢 | 6 🟡 | 9 🟡 | 12 🟠 | 15 🟠 |
| **P2 (Unlikely)** | 2 ⚪ | 4 🟢 | 6 🟡 | 8 🟡 | 10 🟡 |
| **P1 (Rare)** | 1 ⚪ | 2 ⚪ | 3 🟢 | 4 🟢 | 5 🟢 |

### Risk Levels

| Score | Level | Color | Test Depth |
|-------|-------|-------|------------|
| 20-25 | Critical | 🔴 | Comprehensive: Unit + Integration + E2E + Exploratory + Security |
| 15-19 | High | 🟠 | Thorough: Unit + Integration + Key E2E |
| 10-14 | Medium | 🟡 | Standard: Unit + Integration |
| 5-9 | Low | 🟢 | Light: Unit tests only |
| 1-4 | Minimal | ⚪ | Smoke tests |

---

## Assessment Process

### Step 1: Identify Features

List all features, user stories, or components to test:

```
1. User registration
2. Payment processing
3. Profile management
4. Search functionality
5. Admin dashboard
...
```

### Step 2: Assess Probability

For each feature, ask:
- How complex is the code?
- How much change is happening?
- How well do we understand the domain?
- What's the team's experience with this tech?
- Are there tight deadlines?

### Step 3: Assess Impact

For each feature, ask:
- How many users are affected?
- What's the business impact if it fails?
- Is data integrity at risk?
- Are there regulatory/compliance implications?
- What's the reputational damage?

### Step 4: Calculate Risk

Multiply Probability × Impact:

```
User Registration:
- Probability: P4 (complex form validation, email integration)
- Impact: I4 (blocks new users, first impression)
- Risk: 4 × 4 = 16 (High)

Profile Management:
- Probability: P2 (well-understood CRUD)
- Impact: I2 (degraded experience, workaround exists)
- Risk: 2 × 2 = 4 (Low)
```

### Step 5: Prioritize

Sort by risk score (highest first):

```
1. Payment Processing: 20 (Critical)
2. User Registration: 16 (High)
3. Search: 12 (High)
4. Admin Dashboard: 9 (Medium)
5. Profile Management: 4 (Low)
```

### Step 6: Design Tests

Match test effort to risk:

```
Payment (Risk 20):
- Comprehensive unit tests (>90% coverage)
- Full integration test suite
- Critical path E2E tests
- Security/penetration testing
- Load testing
- Contract testing

Profile (Risk 4):
- Basic unit tests (>60% coverage)
- No integration tests
- No E2E tests
```

---

## Test Depth Guidelines

### Critical (Score 20-25)

**Coverage Targets:**
- Unit: >90%
- Integration: All major paths
- E2E: All critical user journeys

**Test Types:**
- Unit tests for every function
- Integration tests for all service interactions
- E2E tests for complete workflows
- Security tests (OWASP top 10)
- Performance tests (load, stress)
- Contract tests for APIs
- Exploratory testing sessions

**Review:**
- Mandatory peer review of all tests
- Architecture review of test design
- Regular test maintenance

### High (Score 15-19)

**Coverage Targets:**
- Unit: >80%
- Integration: Key paths
- E2E: Primary workflows

**Test Types:**
- Unit tests for core logic
- Integration tests for external dependencies
- E2E tests for main user paths
- Contract tests

**Review:**
- Peer review recommended
- Spot checks on test quality

### Medium (Score 10-14)

**Coverage Targets:**
- Unit: >70%
- Integration: Major integrations
- E2E: Optional

**Test Types:**
- Unit tests for business logic
- Integration tests for APIs/databases
- Smoke tests for E2E

**Review:**
- Self-review acceptable
- Occasional quality audits

### Low (Score 5-9)

**Coverage Targets:**
- Unit: >60%

**Test Types:**
- Unit tests only
- Happy path and main errors

**Review:**
- Trust developers
- Fix issues as found

### Minimal (Score 1-4)

**Coverage Targets:**
- Smoke tests

**Test Types:**
- Basic "does it run" checks
- No formal test suite required

---

## Example Assessment

### E-commerce Application

| Feature | P | I | Risk | Level | Test Strategy |
|---------|---|---|------|-------|---------------|
| Payment Processing | P4 | I5 | 20 | 🔴 Critical | Full suite: unit (>90%), integration, E2E, security, load |
| User Registration | P4 | I4 | 16 | 🟠 High | Thorough: unit (>80%), integration, key E2E |
| Product Search | P3 | I4 | 12 | 🟠 High | Standard+: unit (>80%), integration, limited E2E |
| Shopping Cart | P3 | I3 | 9 | 🟡 Medium | Standard: unit (>70%), integration |
| Product Reviews | P2 | I2 | 4 | 🟢 Low | Light: unit only (>60%) |
| Admin Reports | P2 | I2 | 4 | 🟢 Low | Light: unit only |
| About Page | P1 | I1 | 1 | ⚪ Minimal | Smoke tests only |

---

## Tools and Templates

### Risk Assessment Template

```markdown
# Risk Assessment: [Project Name]

Date: [YYYY-MM-DD]
Assessor: [Name]

## Features

| ID | Feature | Description | P | I | Risk | Priority |
|----|---------|-------------|---|---|------|----------|
| 1 | | | | | | |
| 2 | | | | | | |
| 3 | | | | | | |

## Risk Summary

- Critical (20-25): X features
- High (15-19): X features
- Medium (10-14): X features
- Low (5-9): X features
- Minimal (1-4): X features

## Test Resource Allocation

- 50% effort on Critical features
- 30% effort on High features
- 15% effort on Medium features
- 5% effort on Low/Minimal features

## Action Items

- [ ] Review assessment with team
- [ ] Assign test owners for Critical/High
- [ ] Schedule test design sessions
- [ ] Set up test environments
```

### Quick Risk Calculator

```
Probability:
□ New feature (P5)
□ Integration point (P4)
□ Refactoring (P3)
□ Bug fix (P2)
□ Cosmetic (P1)

Impact:
□ System down (I5)
□ Revenue impact (I4)
□ Degraded experience (I3)
□ Minor issue (I2)
□ Cosmetic (I1)

Risk = P × I
```

---

## Best Practices

1. **Reassess Regularly** - Risk changes as code changes
2. **Team Calibration** - Align on P/I ratings across team
3. **Document Rationale** - Why did you rate something P4?
4. **Balance Coverage** - Don't over-test low-risk, under-test high-risk
5. **Automate Where Possible** - CI/CD should enforce coverage gates
6. **Review After Incidents** - Did risk assessment miss something?

---

## Integration with FORGE

Use this skill during:
- `/forge:plan` - Assess risk for planned features
- `/forge:test` - Determine test depth needed
- `/forge:review` - Verify test coverage matches risk
- `/forge:learn` - Capture risk patterns from incidents

---

## References

- Risk-Based Testing (Wikipedia)
- ISTQB Risk-Based Testing Guidelines
- Google's Testing Blog: "Risk Analysis"
