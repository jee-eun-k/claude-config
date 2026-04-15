# TDD Best Practices & Common Mistakes

## Common Testing Mistakes

### WRONG: Testing Implementation Details
```typescript
expect(component.state.count).toBe(5)
```

### CORRECT: Test User-Visible Behavior
```typescript
expect(screen.getByText('Count: 5')).toBeInTheDocument()
```

### WRONG: Brittle Selectors
```typescript
await page.click('.css-class-xyz')
```

### CORRECT: Semantic Selectors
```typescript
await page.click('button:has-text("Submit")')
await page.click('[data-testid="submit-button"]')
```

### WRONG: No Test Isolation
```typescript
test('creates user', () => { /* ... */ })
test('updates same user', () => { /* depends on previous test */ })
```

### CORRECT: Independent Tests
```typescript
test('creates user', () => {
  const user = createTestUser()
  // Test logic
})
test('updates user', () => {
  const user = createTestUser()
  // Update logic
})
```

## Best Practices

1. **Write Tests First** - Always TDD
2. **One Assert Per Test** - Focus on single behavior
3. **Descriptive Test Names** - Explain what's tested
4. **Arrange-Act-Assert** - Clear test structure
5. **Mock External Dependencies** - Isolate unit tests
6. **Test Edge Cases** - Null, undefined, empty, large
7. **Test Error Paths** - Not just happy paths
8. **Keep Tests Fast** - Unit tests < 50ms each
9. **Clean Up After Tests** - No side effects
10. **Review Coverage Reports** - Identify gaps

## Continuous Testing

### Watch Mode During Development
```bash
npm test -- --watch
```

### Pre-Commit Hook
```bash
npm test && npm run lint
```

### CI/CD Integration
```yaml
- name: Run Tests
  run: npm test -- --coverage
- name: Upload Coverage
  uses: codecov/codecov-action@v3
```

## Success Metrics

- 80%+ code coverage achieved
- All tests passing (green)
- No skipped or disabled tests
- Fast test execution (< 30s for unit tests)
- E2E tests cover critical user flows
- Tests catch bugs before production
