---
name: security-review
description: Use this skill when adding authentication, handling user input, working with secrets, creating API endpoints, or implementing payment/sensitive features. Provides comprehensive security checklist and patterns.
---

# Security Review Skill

This skill ensures all code follows security best practices and identifies potential vulnerabilities.

## When to Activate

- Implementing authentication or authorization
- Handling user input or file uploads
- Creating new API endpoints
- Working with secrets or credentials
- Implementing payment features
- Storing or transmitting sensitive data
- Integrating third-party APIs

## Security Review Phases

Work through these phases based on what's relevant to the current change. Load each ref file only when you reach that phase.

### Phase 1: Secrets & Input Validation

Covers: hardcoded secrets detection, env var usage, schema-based input validation, file upload restrictions.

Read `ref/secrets-and-input.md` for patterns and checklists.

### Phase 2: Auth & Injection Prevention

Covers: JWT handling, authorization checks, Row Level Security, SQL injection prevention, parameterized queries.

Read `ref/auth-and-injection.md` for patterns and checklists.

### Phase 3: XSS, CSRF & Rate Limiting

Covers: HTML sanitization, CSP headers, CSRF tokens, SameSite cookies, API rate limiting.

Read `ref/xss-csrf-rate-limiting.md` for patterns and checklists.

### Phase 4: Data Exposure, Dependencies & Testing

Covers: log redaction, error message safety, dependency auditing, security test patterns, pre-deployment checklist.

Read `ref/data-deps-testing.md` for patterns and checklists.

## Quick Checklist (All Phases)

Before ANY commit involving security-sensitive code:

- [ ] No hardcoded secrets
- [ ] All user inputs validated
- [ ] Queries parameterized (no SQL injection)
- [ ] User content sanitized (no XSS)
- [ ] CSRF protection on state-changing operations
- [ ] Auth checks before sensitive operations
- [ ] Rate limiting on endpoints
- [ ] Error messages don't leak internals
- [ ] Dependencies audited (`npm audit`)
- [ ] Security tests written

**Remember**: Security is not optional. One vulnerability can compromise the entire platform.
