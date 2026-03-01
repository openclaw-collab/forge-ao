# /forge:security

**Security gate - Spawn security reviewer agent**

## Usage

```
/forge:security [debate-id]
```

## Description

Spawns a security-focused agent that performs automated security analysis of the codebase. This is a mandatory gate in the FORGE workflow that blocks advancement if critical vulnerabilities are found.

## Security Checks Performed

### 1. Secret Scanning
- API keys in source code
- Database credentials
- JWT secrets
- Private keys
- Passwords

### 2. Injection Vulnerabilities
- SQL/NoSQL injection
- Command injection
- XSS (Cross-Site Scripting)
- LDAP injection
- XPath injection

### 3. Authentication Issues
- Weak password policies
- Session fixation
- JWT vulnerabilities
- Missing MFA
- Insecure password storage

### 4. Authorization Issues
- IDOR (Insecure Direct Object Reference)
- Missing access control checks
- Privilege escalation
- Broken function-level authorization

### 5. Dependency Audit
- Known CVEs in dependencies
- Outdated packages with security fixes
- Transitive dependency vulnerabilities

### 6. Configuration Issues
- Debug mode in production
- Insecure CORS
- Missing security headers
- Weak TLS settings

## Output

Security review is written to `docs/forge/phases/security.md`:

```markdown
---
phase: security
debate_id: forge-1234567890-abc
completed_at: 2026-01-15T10:30:00Z
verdict: pass|fail
---

## Security Review Report

### Critical Issues
...

### High Severity Issues
...

### Medium Severity Issues
...

### Dependency Audit
...
```

## Workflow Integration

The security phase is automatically triggered:

1. After `/forge:validate` completes
2. Before `/forge:review` can run
3. Can be manually triggered with `/forge:security`

## Blocking Behavior

- **Critical issues found**: Workflow BLOCKED until resolved
- **High issues found**: Warning, requires explicit override
- **Medium/Low issues found**: Non-blocking, documented

## Commands

### Run Security Review
```bash
/forge:security
```

### Check Security Status
```bash
/forge:status
# Shows: security phase status, issue counts, verdict
```

### Override (Emergency Only)
```bash
/forge:security --override "Reason for bypass"
# Requires explicit justification logged to decisions.md
```

## Environment

When spawned via AO:
- `AO_FORGE_PHASE=security`
- `AO_FORGE_ROLE=security-reviewer`
- `SECURITY_STRICT_MODE=true`

## Integration with CI/CD

Security gate fails the build if:
- Critical vulnerabilities found
- `--require-security-pass` flag set
- Security review older than 7 days

## See Also

- `/forge:validate` - Pre-security validation
- `/forge:review` - Post-security code review
- `ao forge security <debate-id>` - CLI command
