---
name: tdd-workflow
description: Use this skill when writing new features, fixing bugs, or refactoring code. Enforces test-driven development with 80%+ coverage including unit, integration, and E2E tests.
---

# Test-Driven Development Workflow

This skill ensures all code development follows TDD principles with comprehensive test coverage.

## When to Activate

- Writing new features or functionality
- Fixing bugs or issues
- Refactoring existing code
- Adding API endpoints
- Creating new components

## Core Principles

1. **Tests BEFORE Code** - ALWAYS write tests first, then implement
2. **80%+ Coverage** - Unit + integration + E2E, all edge cases
3. **Three Test Types Required:**
   - **Unit Tests** - Individual functions, components, utilities
   - **Integration Tests** - API endpoints, database ops, service interactions
   - **E2E Tests (Playwright)** - Critical user flows, browser automation

## TDD Cycle

```
RED → GREEN → REFACTOR → VERIFY
```

1. Write user journey → generate test cases
2. Run tests — they should **FAIL** (RED)
3. Write minimal code to pass (GREEN)
4. Refactor while keeping tests green (REFACTOR)
5. Verify 80%+ coverage (VERIFY)

For detailed workflow steps and coverage thresholds, read `ref/core-workflow.md`.

## Reference Files

Load these on demand based on what phase you're in:

### Writing Tests
Read `ref/core-workflow.md` for:
- User journey → test case generation
- Step-by-step RED-GREEN-REFACTOR cycle
- Coverage threshold configuration

### Test Patterns & Mocking
Read `ref/test-patterns.md` for:
- Unit test patterns (Jest/Vitest)
- API integration test patterns
- E2E test patterns (Playwright)
- Mocking external services (Supabase, Redis, OpenAI)
- Test file organization

### Quality & Anti-Patterns
Read `ref/best-practices.md` for:
- Common testing mistakes to avoid
- 10 best practices
- CI/CD integration
- Success metrics

**Remember**: Tests are not optional. They are the safety net that enables confident refactoring, rapid development, and production reliability.
