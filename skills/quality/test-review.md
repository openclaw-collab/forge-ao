---
name: test-review
description: Use when reviewing test quality, auditing test suites, or evaluating test coverage. Provides 0-100 scoring across 8 dimensions of test quality.
---

# Test Review

## Overview

Audit and review test suites for quality, coverage, and maintainability. Provides comprehensive scoring across multiple dimensions.

## Quality Dimensions

### Scoring System (0-100)

Tests are evaluated across 8 dimensions:

| Dimension | Max Points | What We Check |
|-----------|-----------|---------------|
| Coverage | 15 | Unit >80%, Integration >60% |
| Reliability | 15 | No flaky tests, deterministic |
| Maintainability | 15 | DRY, clear naming, focused |
| Speed | 10 | Fast feedback (<5 min suite) |
| Readability | 10 | Structure, assertions, flow |
| Completeness | 15 | Happy paths, errors, edges |
| Independence | 10 | No dependencies, isolated |
| Documentation | 10 | Descriptions, intent clear |

### Score Interpretation

| Score | Grade | Interpretation |
|-------|-------|----------------|
| 90-100 | A | Excellent - maintain with pride |
| 80-89 | B | Good - minor improvements needed |
| 70-79 | C | Acceptable - significant gaps |
| 60-69 | D | Poor - needs major rework |
| <60 | F | Critical - rebuild recommended |

## Dimension Details

### 1. Coverage (15 points)

**Unit Tests (5 points):**
- ⭐⭐⭐⭐⭐ >90%
- ⭐⭐⭐⭐☆ 80-89%
- ⭐⭐⭐☆☆ 70-79%
- ⭐⭐☆☆☆ 60-69%
- ⭐☆☆☆☆ <60%

**Integration Tests (5 points):**
- ⭐⭐⭐⭐⭐ >70% coverage
- ⭐⭐⭐⭐☆ 60-69%
- ⭐⭐⭐☆☆ 50-59%
- ⭐⭐☆☆☆ 40-49%
- ⭐☆☆☆☆ <40%

**Critical Paths (5 points):**
- ⭐⭐⭐⭐⭐ All critical paths tested
- ⭐⭐⭐⭐☆ Most critical paths
- ⭐⭐⭐☆☆ Some critical paths
- ⭐⭐☆☆☆ Few critical paths
- ⭐☆☆☆☆ Critical paths untested

### 2. Reliability (15 points)

**No Flaky Tests (5 points):**
- ⭐⭐⭐⭐⭐ Zero known flaky tests
- ⭐⭐⭐⭐☆ 1-2 flaky tests
- ⭐⭐⭐☆☆ 3-5 flaky tests
- ⭐⭐☆☆☆ 6-10 flaky tests
- ⭐☆☆☆☆ >10 flaky tests

**Deterministic (5 points):**
- ⭐⭐⭐⭐⭐ Always same result
- ⭐⭐⭐⭐☆ Occasionally timing-dependent
- ⭐⭐⭐☆☆ Some order dependencies
- ⭐⭐☆☆☆ External service dependencies
- ⭐☆☆☆☆ Non-deterministic

**Isolated (5 points):**
- ⭐⭐⭐⭐⭐ Fully isolated
- ⭐⭐⭐⭐☆ Shared test fixtures only
- ⭐⭐⭐☆☆ Some shared state
- ⭐⭐☆☆☆ Significant shared state
- ⭐☆☆☆☆ Tests depend on each other

### 3. Maintainability (15 points)

**DRY (5 points):**
- ⭐⭐⭐⭐⭐ Excellent reuse, no duplication
- ⭐⭐⭐⭐☆ Minor duplication
- ⭐⭐⭐☆☆ Some duplication
- ⭐⭐☆☆☆ Significant duplication
- ⭐☆☆☆☆ Heavy duplication

**Naming (5 points):**
- ⭐⭐⭐⭐⭐ Clear, descriptive names
- ⭐⭐⭐⭐☆ Mostly clear names
- ⭐⭐⭐☆☆ Some unclear names
- ⭐⭐☆☆☆ Many unclear names
- ⭐☆☆☆☆ Poor naming throughout

**Single Responsibility (5 points):**
- ⭐⭐⭐⭐⭐ One concept per test
- ⭐⭐⭐⭐☆ Occasionally multiple concepts
- ⭐⭐⭐☆☆ Some tests too large
- ⭐⭐☆☆☆ Many tests too large
- ⭐☆☆☆☆ Tests are massive

### 4. Speed (10 points)

**Suite Time (5 points):**
- ⭐⭐⭐⭐⭐ <2 minutes
- ⭐⭐⭐⭐☆ 2-5 minutes
- ⭐⭐⭐☆☆ 5-10 minutes
- ⭐⭐☆☆☆ 10-20 minutes
- ⭐☆☆☆☆ >20 minutes

**Individual Tests (5 points):**
- ⭐⭐⭐⭐⭐ Most <50ms
- ⭐⭐⭐⭐☆ Most <100ms
- ⭐⭐⭐☆☆ Some >100ms
- ⭐⭐☆☆☆ Many >100ms
- ⭐☆☆☆☆ Tests are slow

### 5. Readability (10 points)

**Structure (5 points):**
- ⭐⭐⭐⭐⭐ Clear AAA or Given/When/Then
- ⭐⭐⭐⭐☆ Mostly structured
- ⭐⭐⭐☆☆ Some structure
- ⭐⭐☆☆☆ Poor structure
- ⭐☆☆☆☆ No structure

**Assertions (5 points):**
- ⭐⭐⭐⭐⭐ Clear, meaningful assertions
- ⭐⭐⭐⭐☆ Mostly good assertions
- ⭐⭐⭐☆☆ Some weak assertions
- ⭐⭐☆☆☆ Many weak assertions
- ⭐☆☆☆☆ Assertions don't verify behavior

### 6. Completeness (15 points)

**Happy Paths (5 points):**
- ⭐⭐⭐⭐⭐ All main flows covered
- ⭐⭐⭐⭐☆ Most main flows
- ⭐⭐⭐☆☆ Some main flows
- ⭐⭐☆☆☆ Few main flows
- ⭐☆☆☆☆ Happy paths untested

**Error Cases (5 points):**
- ⭐⭐⭐⭐⭐ Comprehensive error testing
- ⭐⭐⭐⭐☆ Most errors covered
- ⭐⭐⭐☆☆ Some error cases
- ⭐⭐☆☆☆ Few error cases
- ⭐☆☆☆☆ No error testing

**Edge Cases (5 points):**
- ⭐⭐⭐⭐⭐ Boundary conditions tested
- ⭐⭐⭐⭐☆ Most boundaries
- ⭐⭐⭐☆☆ Some boundaries
- ⭐⭐☆☆☆ Few boundaries
- ⭐☆☆☆☆ No boundary testing

### 7. Independence (10 points)

**Order Independence (5 points):**
- ⭐⭐⭐⭐⭐ Any order works
- ⭐⭐⭐⭐☆ Minor ordering issues
- ⭐⭐⭐☆☆ Some dependencies
- ⭐⭐☆☆☆ Many dependencies
- ⭐☆☆☆☆ Tests must run in order

**No Shared State (5 points):**
- ⭐⭐⭐⭐⭐ Clean state each test
- ⭐⭐⭐⭐☆ Minor shared state
- ⭐⭐⭐☆☆ Some shared state
- ⭐⭐☆☆☆ Significant shared state
- ⭐☆☆☆☆ Heavy shared state

### 8. Documentation (10 points)

**Test Descriptions (5 points):**
- ⭐⭐⭐⭐⭐ Clear what/why
- ⭐⭐⭐⭐☆ Mostly clear
- ⭐⭐⭐☆☆ Some unclear
- ⭐⭐☆☆☆ Many unclear
- ⭐☆☆☆☆ Descriptions unhelpful

**Code Comments (5 points):**
- ⭐⭐⭐⭐⭐ Comments where needed
- ⭐⭐⭐⭐☆ Some good comments
- ⭐⭐⭐☆☆ Few comments
- ⭐⭐☆☆☆ Missing comments
- ⭐☆☆☆☆ No comments

## Review Process

### Step 1: Gather Data

```bash
# Run tests with coverage
npm run test:coverage

# Run specific test suites
npm run test:unit
npm run test:integration

# Check for flakiness (run multiple times)
for i in {1..5}; do npm test; done
```

### Step 2: Analyze Code

- Review test file organization
- Check test naming
- Look for patterns/anti-patterns
- Identify duplication

### Step 3: Score Each Dimension

Use rubric above to score each dimension 0-5 or 0-15.

### Step 4: Calculate Total

Sum all dimension scores for 0-100 total.

### Step 5: Generate Report

## Review Report Template

```markdown
# Test Quality Audit Report

**Project:** [Name]
**Date:** [YYYY-MM-DD]
**Auditor:** [Name]

## Overall Score: [X]/100 ([Grade])

## Dimension Breakdown

| Dimension | Score | Max | Notes |
|-----------|-------|-----|-------|
| Coverage | [X] | 15 | [Specific findings] |
| Reliability | [X] | 15 | [Flaky tests, determinism] |
| Maintainability | [X] | 15 | [DRY, naming, focus] |
| Speed | [X] | 10 | [Suite time, individual] |
| Readability | [X] | 10 | [Structure, assertions] |
| Completeness | [X] | 15 | [Happy, error, edge] |
| Independence | [X] | 10 | [Order, shared state] |
| Documentation | [X] | 10 | [Descriptions, comments] |
| **TOTAL** | **[X]** | **100** | |

## Strengths

- [What's working well]

## Areas for Improvement

### Critical (Fix Immediately)
- [Issues that need immediate attention]

### High Priority
- [Issues to address soon]

### Medium Priority
- [Nice to have improvements]

### Low Priority
- [Refinements for later]

## Action Items

- [ ] [Specific task with owner]
- [ ] [Specific task with owner]
- [ ] [Specific task with owner]

## Recommendations

1. [Specific recommendation with rationale]
2. [Specific recommendation with rationale]
3. [Specific recommendation with rationale]
```

## Common Issues

### Anti-Patterns

**The Giant Test:**
```typescript
// Bad - tests too many things
test('app works', () => {
  // 100 lines testing everything
});

// Good - focused tests
test('calculates total with tax', () => {
  // Just this behavior
});
```

**The False Positive:**
```typescript
// Bad - assertion always passes
test('renders', () => {
  render(<Component />);
  expect(true).toBe(true);
});

// Good - meaningful assertion
test('renders title', () => {
  render(<Component />);
  expect(screen.getByText('Title')).toBeInTheDocument();
});
```

**The Brittle Test:**
```typescript
// Bad - depends on implementation details
test('calls internal method', () => {
  const spy = jest.spyOn(component, 'internalMethod');
  // ...
});

// Good - tests behavior
test('displays result', () => {
  render(<Component />);
  expect(screen.getByText('Result')).toBeVisible();
});
```

## Improvement Strategies

### Low Coverage
- Identify uncovered code with Istanbul
- Write tests for critical paths first
- Use coverage reports to find gaps

### Flaky Tests
- Remove timing dependencies
- Use explicit waits
- Mock external services
- Isolate test data

### Poor Maintainability
- Extract shared setup to fixtures
- Create test utilities
- Standardize naming
- Remove duplication

### Slow Tests
- Parallelize test execution
- Mock slow dependencies
- Reduce test scope
- Optimize test data creation
