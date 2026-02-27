---
name: ci-cd-setup
description: Use when configuring CI/CD pipelines, setting up test automation, or implementing quality gates. Provides platform-specific configurations for GitHub Actions, GitLab CI, Jenkins, and Azure DevOps.
---

# CI/CD Setup

## Overview

Configure continuous integration and continuous deployment pipelines for automated testing, quality checks, and deployment.

## Platform Selection

### Supported Platforms

| Platform | Config File | Best For |
|----------|-------------|----------|
| GitHub Actions | `.github/workflows/*.yml` | Open source, GitHub repos |
| GitLab CI | `.gitlab-ci.yml` | GitLab repos, self-hosted |
| Jenkins | `Jenkinsfile` | Enterprise, complex pipelines |
| Azure DevOps | `azure-pipelines.yml` | Microsoft stack, Azure deployment |
| CircleCI | `.circleci/config.yml` | Fast, simple setup |
| Travis CI | `.travis.yml` | Multi-platform testing |

## Configuration Templates

### GitHub Actions

#### Basic Test Pipeline

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '20'
        cache: 'npm'

    - name: Install dependencies
      run: npm ci

    - name: Run linter
      run: npm run lint

    - name: Type check
      run: npm run type-check

    - name: Run tests
      run: npm run test:ci

    - name: Upload coverage
      uses: codecov/codecov-action@v3
```

#### Advanced Pipeline with Matrix

```yaml
name: CI

on: [push, pull_request]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint

  test:
    needs: lint
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: ['18', '20', '21']

    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: 'npm'

      - run: npm ci
      - run: npm run test:unit -- --coverage

  e2e:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npx playwright install --with-deps
      - run: npm run test:e2e
```

### GitLab CI

```yaml
stages:
  - lint
  - test
  - e2e
  - deploy

variables:
  NODE_VERSION: "20"

cache:
  paths:
    - node_modules/
    - .npm/

lint:
  stage: lint
  image: node:$NODE_VERSION
  script:
    - npm ci --cache .npm --prefer-offline
    - npm run lint
    - npm run type-check

test:unit:
  stage: test
  image: node:$NODE_VERSION
  script:
    - npm ci
    - npm run test:unit -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

test:integration:
  stage: test
  image: node:$NODE_VERSION
  services:
    - postgres:15
  variables:
    POSTGRES_DB: test
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
  script:
    - npm ci
    - npm run test:integration

e2e:
  stage: e2e
  image: mcr.microsoft.com/playwright:v1.40.0-jammy
  script:
    - npm ci
    - npm run test:e2e
  artifacts:
    when: always
    paths:
      - playwright-report/
```

## Quality Gates

### Gate Configuration

```yaml
# quality-gates.yml
gates:
  - name: lint
    required: true
    command: npm run lint
    failure_message: "Linting failed"

  - name: type-check
    required: true
    command: npm run type-check
    failure_message: "Type checking failed"

  - name: unit-tests
    required: true
    command: npm run test:unit
    min_coverage: 80
    failure_message: "Unit tests failed or coverage below 80%"

  - name: integration-tests
    required: true
    command: npm run test:integration
    failure_message: "Integration tests failed"

  - name: e2e-tests
    required: false
    command: npm run test:e2e
    failure_message: "E2E tests failed"
```

### Gate Enforcement

```bash
#!/bin/bash
# enforce-gates.sh

GATE_STATUS=0

run_gate() {
    local name=$1
    local command=$2

    echo "Running gate: $name"
    if eval $command; then
        echo "✅ $name passed"
    else
        echo "❌ $name failed"
        GATE_STATUS=1
    fi
}

run_gate "Lint" "npm run lint"
run_gate "Type Check" "npm run type-check"
run_gate "Unit Tests" "npm run test:unit -- --coverage"

exit $GATE_STATUS
```

## Caching Strategies

### Dependency Caching

**GitHub Actions:**
```yaml
- uses: actions/setup-node@v4
  with:
    node-version: '20'
    cache: 'npm'
```

**GitLab CI:**
```yaml
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - node_modules/
    - .npm/
  policy: pull-push
```

**Azure DevOps:**
```yaml
- task: Cache@2
  inputs:
    key: 'npm | "$(Agent.OS)" | package-lock.json'
    restoreKeys: |
      npm | "$(Agent.OS)"
    path: $(npm_config_cache)
```

## Parallel Execution

### Job Dependencies

```yaml
jobs:
  lint:
    runs-on: ubuntu-latest
    steps: [...]

  unit-tests:
    needs: lint
    runs-on: ubuntu-latest
    steps: [...]

  integration-tests:
    needs: lint
    runs-on: ubuntu-latest
    steps: [...]

  e2e-tests:
    needs: [unit-tests, integration-tests]
    runs-on: ubuntu-latest
    steps: [...]
```

## Artifact Management

### Test Reports

```yaml
- name: Run tests
  run: npm test -- --reporter=junit --output-file=junit.xml

- name: Upload test results
  uses: actions/upload-artifact@v4
  if: always()
  with:
    name: test-results
    path: junit.xml
```

### Coverage Reports

```yaml
- name: Upload coverage
  uses: codecov/codecov-action@v3
  with:
    files: ./coverage/lcov.info
    fail_ci_if_error: true
```

## Deployment

### Staged Deployment

```yaml
deploy-staging:
  needs: [lint, test]
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/develop'
  steps:
    - uses: actions/checkout@v4
    - name: Deploy to Staging
      run: |
        echo "Deploying to staging..."

deploy-production:
  needs: deploy-staging
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'
  environment: production
  steps:
    - uses: actions/checkout@v4
    - name: Deploy to Production
      run: |
        echo "Deploying to production..."
```

## Security

### Secrets Management

**GitHub Actions:**
```yaml
- name: Deploy
  env:
    API_KEY: ${{ secrets.API_KEY }}
  run: |
    deploy --api-key $API_KEY
```

**GitLab CI:**
```yaml
script:
  - deploy --api-key $API_KEY
```

### Vulnerability Scanning

```yaml
security-scan:
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4

    - name: Run security audit
      run: npm audit --audit-level=high

    - name: Run CodeQL
      uses: github/codeql-action/init@v2
      with:
        languages: javascript

    - name: Autobuild
      uses: github/codeql-action/autobuild@v2

    - name: Perform CodeQL Analysis
      uses: github/codeql-action/analyze@v2
```

## Notifications

### Slack Notifications

```yaml
- name: Notify Slack
  uses: 8398a7/action-slack@v3
  if: always()
  with:
    status: ${{ job.status }}
    fields: repo,message,commit,author,action,eventName
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

## Best Practices

1. **Fail Fast**: Run linting and type checking first
2. **Fast Feedback**: Keep PR checks under 10 minutes
3. **Parallelize**: Run independent jobs in parallel
4. **Cache**: Cache dependencies and build artifacts
5. **Artifacts**: Store test results and coverage
6. **Matrix**: Test multiple versions/platforms
7. **Security**: Scan for vulnerabilities
8. **Notifications**: Alert on failures

## Troubleshooting

### Common Issues

**Slow Pipeline:**
- Add caching
- Run jobs in parallel
- Use smaller Docker images

**Flaky Tests:**
- Retry failed tests
- Isolate test dependencies
- Use test fixtures

**Large Artifacts:**
- Only upload necessary files
- Use artifact retention policies
- Compress before upload
