---
name: test-automation
description: Use when setting up test frameworks, configuring test runners, or implementing automated testing. Covers Playwright, Cypress, Jest, pytest, and other testing tools.
---

# Test Automation

## Overview

Set up and configure automated testing frameworks for unit, integration, and end-to-end testing.

## Framework Selection

### Unit Testing

| Framework | Language | Best For |
|-----------|----------|----------|
| Jest | JavaScript/TypeScript | React, Node.js, general JS |
| Vitest | JavaScript/TypeScript | Fast alternative to Jest, Vite projects |
| pytest | Python | Python applications |
| JUnit | Java | Java/Kotlin projects |
| Go test | Go | Go applications |
| RSpec | Ruby | Ruby/Rails projects |

### E2E Testing

| Framework | Browser | Best For |
|-----------|---------|----------|
| Playwright | Chromium, Firefox, WebKit | Modern web apps, cross-browser |
| Cypress | Chrome, Firefox, Edge | Developer experience, debugging |
| Selenium | All browsers | Legacy support, complex scenarios |
| Puppeteer | Chromium | Chrome-specific, scraping |

## Jest Setup

### Installation

```bash
npm install --save-dev jest @types/jest ts-jest
```

### Configuration

```javascript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80,
    },
  },
};
```

### React Testing

```bash
npm install --save-dev @testing-library/react @testing-library/jest-dom
```

```javascript
// Component test example
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { Button } from './Button';

describe('Button', () => {
  it('renders with correct text', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', async () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    await userEvent.click(screen.getByText('Click me'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

## Playwright Setup

### Installation

```bash
npm init playwright@latest
```

### Configuration

```javascript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './e2e',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 2 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['junit', { outputFile: 'playwright-report/junit.xml' }],
  ],
  use: {
    baseURL: 'http://localhost:3000',
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
  webServer: {
    command: 'npm run dev',
    url: 'http://localhost:3000',
    reuseExistingServer: !process.env.CI,
  },
});
```

### Test Example

```typescript
// e2e/auth.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Authentication', () => {
  test('user can login', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[name="email"]', 'user@example.com');
    await page.fill('[name="password"]', 'password123');
    await page.click('button[type="submit"]');

    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('h1')).toContainText('Dashboard');
  });

  test('shows error for invalid credentials', async ({ page }) => {
    await page.goto('/login');

    await page.fill('[name="email"]', 'wrong@example.com');
    await page.fill('[name="password"]', 'wrong');
    await page.click('button[type="submit"]');

    await expect(page.locator('.error')).toContainText('Invalid credentials');
  });
});
```

## Cypress Setup

### Installation

```bash
npm install --save-dev cypress
npx cypress open
```

### Configuration

```javascript
// cypress.config.ts
import { defineConfig } from 'cypress';

export default defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    supportFile: 'cypress/support/e2e.ts',
    specPattern: 'cypress/e2e/**/*.cy.ts',
    video: false,
    screenshotOnRunFailure: true,
    viewportWidth: 1280,
    viewportHeight: 720,
  },
  component: {
    devServer: {
      framework: 'next',
      bundler: 'webpack',
    },
  },
});
```

### Test Example

```typescript
// cypress/e2e/checkout.cy.ts
describe('Checkout', () => {
  beforeEach(() => {
    cy.visit('/products');
  });

  it('completes purchase flow', () => {
    cy.contains('Add to Cart').first().click();
    cy.get('[data-testid="cart-count"]').should('contain', '1');

    cy.visit('/cart');
    cy.contains('Checkout').click();

    cy.url().should('include', '/checkout');
    cy.get('[name="email"]').type('user@example.com');
    cy.get('[name="card"]').type('4242424242424242');
    cy.contains('Pay').click();

    cy.contains('Thank you for your order').should('be.visible');
  });
});
```

## pytest Setup

### Installation

```bash
pip install pytest pytest-cov
```

### Configuration

```python
# pytest.ini
[pytest]
testpaths = tests
python_files = test_*.py
python_classes = Test*
python_functions = test_*
addopts = --cov=src --cov-report=term-missing --cov-report=html
```

### Test Example

```python
# tests/test_calculator.py
import pytest
from calculator import Calculator

class TestCalculator:
    @pytest.fixture
    def calc(self):
        return Calculator()

    def test_add(self, calc):
        assert calc.add(2, 3) == 5

    def test_add_negative(self, calc):
        assert calc.add(-1, -1) == -2

    def test_divide_by_zero(self, calc):
        with pytest.raises(ValueError):
            calc.divide(1, 0)
```

## Test Organization

### File Structure

```
project/
├── src/
│   ├── components/
│   ├── utils/
│   └── api/
├── tests/
│   ├── unit/
│   │   ├── components/
│   │   ├── utils/
│   │   └── api/
│   ├── integration/
│   │   └── api/
│   └── e2e/
│       └── flows/
└── e2e/ (Playwright/Cypress)
    └── specs/
```

### Naming Conventions

```
Unit:          [name].test.ts / test_[name].py
Integration:   [name].integration.test.ts
E2E:           [feature].spec.ts / [feature].cy.ts
```

## Test Patterns

### AAA Pattern

```typescript
// Arrange
const user = { name: 'John', age: 30 };

// Act
const greeting = formatGreeting(user);

// Assert
expect(greeting).toBe('Hello, John!');
```

### Given-When-Then

```typescript
test('should update user profile', () => {
  // Given
  const user = createUser({ name: 'Old Name' });

  // When
  const updated = updateUser(user, { name: 'New Name' });

  // Then
  expect(updated.name).toBe('New Name');
});
```

### Page Object Model (E2E)

```typescript
// e2e/pages/LoginPage.ts
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

// Usage
const loginPage = new LoginPage(page);
await loginPage.goto();
await loginPage.login('user@example.com', 'password');
```

## Coverage Configuration

### Jest Coverage

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80,
      "statements": 80
    }
  },
  "collectCoverageFrom": [
    "src/**/*.{ts,tsx}",
    "!src/**/*.d.ts",
    "!src/**/index.ts"
  ]
}
```

### Excluding Files

```typescript
// istanbul ignore next
function debugOnly() {
  // This won't count against coverage
}

/* istanbul ignore if */
if (process.env.DEBUG) {
  // Debug code excluded
}
```

## Flaky Test Prevention

### Strategies

1. **Avoid Timeouts**: Use explicit waits, not fixed delays
2. **Isolate Tests**: Each test should be independent
3. **Retry Mechanism**: Configure automatic retries
4. **Deterministic Data**: Use fixed test data

### Playwright Auto-Waiting

```typescript
// Good - Playwright auto-waits
await page.click('button');
await expect(page.locator('text=Success')).toBeVisible();

// Bad - Fixed waits
await page.waitForTimeout(1000);
```

### Test Retries

```typescript
// jest.config.js
module.exports = {
  retry: 3,
};

// playwright.config.ts
export default defineConfig({
  retries: process.env.CI ? 2 : 0,
});
```

## Debugging Tests

### Jest Debug

```bash
# Debug specific test
node --inspect-brk node_modules/.bin/jest --runInBand

# Debug with VS Code
```

### Playwright Debug

```bash
# Run in headed mode
npx playwright test --headed

# Run with debugger
npx playwright test --debug

# Show trace viewer
npx playwright show-trace trace.zip
```

### Cypress Debug

```bash
# Open Cypress UI
npx cypress open

# Run specific spec
npx cypress run --spec "cypress/e2e/auth.cy.ts"
```

## Best Practices

1. **Test Behavior, Not Implementation**: Test what, not how
2. **One Concept Per Test**: Single responsibility
3. **Descriptive Names**: Test names should explain behavior
4. **Fast Tests**: Unit tests < 100ms
5. **Deterministic**: Same input = same output
6. **Independent**: No shared state between tests
7. **Readable**: Clear arrange/act/assert sections
