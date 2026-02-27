---
name: atdd-workflow
description: Use when implementing Acceptance Test-Driven Development. Generate failing acceptance tests before implementation to define "done" criteria and drive development.
---

# ATDD Workflow

## Overview

Acceptance Test-Driven Development (ATDD) is a practice where the team defines acceptance criteria and writes acceptance tests **before** implementation begins.

**Core Principle:** Write failing acceptance tests (RED), then implement to make them pass (GREEN).

## ATDD Cycle

```
┌─────────────────────────────────────────────────┐
│ 1. Discuss Requirements                         │
│    Team discusses feature with stakeholder      │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ 2. Define Acceptance Criteria                   │
│    Write Given/When/Then scenarios              │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ 3. Write Failing Tests (RED)                    │
│    Automate acceptance criteria as tests        │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ 4. Implement Feature (GREEN)                    │
│    Write code to make tests pass                │
└──────────────┬──────────────────────────────────┘
               │
               ▼
┌─────────────────────────────────────────────────┐
│ 5. Refactor                                     │
│    Clean up while tests remain green            │
└─────────────────────────────────────────────────┘
```

## Given/When/Then Format

### Structure

```gherkin
Given [initial context]
When [action/event occurs]
Then [expected outcome]
```

### Example: User Registration

```gherkin
Feature: User Registration

  Scenario: Successful registration
    Given the user is on the registration page
    When they enter valid email "user@example.com"
    And they enter valid password "SecurePass123!"
    And they click "Register"
    Then they should see "Registration successful"
    And they should receive a confirmation email
    And a user record should exist in database

  Scenario: Invalid email format
    Given the user is on the registration page
    When they enter email "invalid-email"
    And they click "Register"
    Then they should see error "Please enter a valid email"
    And no user record should be created

  Scenario: Duplicate email
    Given a user exists with email "existing@example.com"
    And the user is on the registration page
    When they enter email "existing@example.com"
    And they click "Register"
    Then they should see error "Email already registered"
```

## Writing Good Acceptance Criteria

### Rules

1. **Test Behavior, Not Implementation**
   ```gherkin
   # Good - What user sees
   Then they should see "Welcome, John!"

   # Bad - How it's implemented
   Then the UserService.updateName method should be called
   ```

2. **Use Concrete Examples**
   ```gherkin
   # Good - Specific data
   When they enter email "john.doe@example.com"

   # Bad - Abstract
   When they enter valid email
   ```

3. **One Concept Per Scenario**
   ```gherkin
   # Good - Single focus
   Scenario: Password too short
     Given...
     When they enter password "123"
     Then they should see error "Password must be at least 8 characters"

   # Bad - Multiple concepts
   Scenario: All validation errors
     Given...
     When they enter invalid email, short password, and mismatched confirmation
     Then they should see 3 errors...
   ```

4. **Independent Scenarios**
   - No dependencies between scenarios
   - Each scenario sets up its own context
   - Can run scenarios in any order

5. **Declarative, Not Imperative**
   ```gherkin
   # Good - Declarative (what)
   When they submit the registration form

   # Bad - Imperative (how)
   When they click the email field
   And they type "user@example.com"
   And they click the password field
   And they type "password123"
   And they click the submit button
   ```

## ATDD by Feature Type

### API/Backend Feature

```gherkin
Feature: Payment Processing API

  Scenario: Successful payment
    Given a customer with valid payment method
    When they POST /api/payments with amount $100
    Then response status should be 201
    And response should contain payment ID
    And payment status should be "completed"
    And charge should be $100.00

  Scenario: Insufficient funds
    Given a customer with $50 balance
    When they POST /api/payments with amount $100
    Then response status should be 402
    And response should contain error "Insufficient funds"
    And no payment record should be created
```

**Test Implementation (Jest + Supertest):**
```typescript
// payments.api.test.ts
describe('POST /api/payments', () => {
  it('creates successful payment', async () => {
    const customer = await createCustomer({ balance: 200 });

    const response = await request(app)
      .post('/api/payments')
      .set('Authorization', `Bearer ${customer.token}`)
      .send({ amount: 100 })
      .expect(201);

    expect(response.body).toHaveProperty('paymentId');
    expect(response.body.status).toBe('completed');
    expect(response.body.amount).toBe(100);
  });

  it('returns 402 for insufficient funds', async () => {
    const customer = await createCustomer({ balance: 50 });

    const response = await request(app)
      .post('/api/payments')
      .set('Authorization', `Bearer ${customer.token}`)
      .send({ amount: 100 })
      .expect(402);

    expect(response.body.error).toBe('Insufficient funds');
  });
});
```

### UI/Frontend Feature

```gherkin
Feature: Shopping Cart

  Scenario: Add item to cart
    Given the user is viewing a product
    When they click "Add to Cart"
    Then the cart count should show "1"
    And they should see "Added to cart" confirmation
    And the cart should contain the product

  Scenario: Remove item from cart
    Given the user has 2 items in cart
    When they click remove on the first item
    Then the cart count should show "1"
    And the removed item should not be in cart
```

**Test Implementation (Playwright):**
```typescript
// cart.spec.ts
test('add item to cart', async ({ page }) => {
  await page.goto('/products/laptop');

  await page.click('button:has-text("Add to Cart")');

  await expect(page.locator('[data-testid="cart-count"]'))
    .toHaveText('1');

  await expect(page.locator('.toast'))
    .toContainText('Added to cart');

  await page.click('[data-testid="cart-link"]');
  await expect(page.locator('.cart-item'))
    .toContainText('Laptop');
});
```

### Database/Model Feature

```gherkin
Feature: User Lifecycle

  Scenario: Create user
    When a user is created with email "test@example.com"
    Then the user should exist in database
    And created_at should be set
    And status should be "active"

  Scenario: Soft delete user
    Given a user exists
    When they are deleted
    Then they should not appear in active users
    And deleted_at should be set
    But the record should still exist
```

## Test Implementation Patterns

### Page Object Model (E2E)

```typescript
// pages/LoginPage.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto('/login');
  }

  async login(email: string, password: string) {
    await this.page.fill('[name="email"]', email);
    await this.page.fill('[name="password"]', password);
    await this.page.click('button[type="submit"]');
  }

  async getErrorMessage() {
    return this.page.locator('.error').textContent();
  }
}

// Usage in test
test('user can login', async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login('user@example.com', 'password');
  await expect(page).toHaveURL('/dashboard');
});
```

### Test Data Builders

```typescript
// builders/UserBuilder.ts
class UserBuilder {
  private user = {
    email: 'test@example.com',
    name: 'Test User',
    role: 'user'
  };

  withEmail(email: string) {
    this.user.email = email;
    return this;
  }

  withRole(role: string) {
    this.user.role = role;
    return this;
  }

  async build() {
    return await db.users.create(this.user);
  }
}

// Usage
const admin = await new UserBuilder()
  .withEmail('admin@example.com')
  .withRole('admin')
  .build();
```

## Running ATDD Tests

### Development Workflow

```bash
# 1. Generate failing tests first (RED)
npm run test:atdd

# Expected output:
# FAIL  src/features/auth/auth.atdd.test.ts
#   User Registration
#     ✕ Successful registration (50ms)
#     ✕ Invalid email format (20ms)
#     ✕ Duplicate email (15ms)
#
# Test Suites: 1 failed, 1 total
# Tests:       3 failed, 3 total

# 2. Implement feature
# ... write code ...

# 3. Run tests again (GREEN)
npm run test:atdd

# Expected output:
# PASS  src/features/auth/auth.atdd.test.ts
#   User Registration
#     ✓ Successful registration (150ms)
#     ✓ Invalid email format (80ms)
#     ✓ Duplicate email (90ms)
#
# Test Suites: 1 passed, 1 total
```

### Watch Mode

```bash
# Run ATDD tests in watch mode
npm run test:atdd -- --watch

# Run only failing tests
npm run test:atdd -- --onlyFailures
```

## Integration with FORGE

### /forge:test atdd Command

```bash
/forge:test atdd user-registration

🔶 ATDD Workflow

Generating acceptance tests for: User Registration

Step 1: Define Acceptance Criteria
Based on requirements, I identify these scenarios:

[1] Successful registration
[2] Invalid email format
[3] Password too weak
[4] Duplicate email
[5] Missing required fields

Which scenarios should I generate? (1-5, or 'all'):
```

### During /forge:plan

```
Plan Phase:

When planning features, use ATDD to define "done":

For each feature:
1. Write acceptance criteria (Given/When/Then)
2. Generate failing tests
3. Tests become part of definition of done
4. Tests guide implementation in /forge:build
```

### During /forge:build

```
Build Phase:

Before implementing:
✓ Run ATDD tests (should be failing)
✓ Review acceptance criteria

During implementation:
→ Make one test pass at a time
→ Refactor after each green test

After implementation:
✓ All ATDD tests passing
✓ Unit tests added for edge cases
```

## Common Pitfalls

1. **Testing Implementation Details**
   - Test what, not how
   - Avoid testing internal methods

2. **Brittle Tests**
   - Use data-testid attributes
   - Avoid testing exact text (unless critical)
   - Test behavior, not presentation

3. **Slow Tests**
   - Mock external services
   - Use test databases
   - Parallelize test execution

4. **Incomplete Coverage**
   - Always test error cases
   - Test boundary conditions
   - Don't forget edge cases

## Best Practices

1. **Three Amigos Meeting** - Developer, Tester, Business discuss scenarios
2. **Living Documentation** - Tests document behavior
3. **Executable Specifications** - Tests are the spec
4. **Continuous Validation** - Run tests on every change
5. **Refactor Safely** - Tests catch regressions

## Tools

- **Cucumber** - Gherkin parser for multiple languages
- **Jest-Cucumber** - Gherkin for Jest
- **Playwright** - E2E testing
- **Cypress** - E2E testing with great DX
- **SpecFlow** - .NET BDD framework
- **Behave** - Python BDD framework
