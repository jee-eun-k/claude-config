# TDD Core Workflow Steps

## Step 1: Write User Journeys
```
As a [role], I want to [action], so that [benefit]

Example:
As a user, I want to search for markets semantically,
so that I can find relevant markets even without exact keywords.
```

## Step 2: Generate Test Cases
```typescript
describe('Semantic Search', () => {
  it('returns relevant markets for query', async () => {
    // Test implementation
  })
  it('handles empty query gracefully', async () => {
    // Test edge case
  })
  it('falls back to substring search when Redis unavailable', async () => {
    // Test fallback behavior
  })
  it('sorts results by similarity score', async () => {
    // Test sorting logic
  })
})
```

## Step 3: Run Tests (They Should FAIL)
```bash
npm test
# Tests should fail - we haven't implemented yet
```

## Step 4: Implement Code
Write minimal code to make tests pass:
```typescript
export async function searchMarkets(query: string) {
  // Implementation guided by tests
}
```

## Step 5: Run Tests Again
```bash
npm test
# Tests should now pass
```

## Step 6: Refactor
Improve code quality while keeping tests green:
- Remove duplication
- Improve naming
- Optimize performance
- Enhance readability

## Step 7: Verify Coverage
```bash
npm run test:coverage
# Verify 80%+ coverage achieved
```

## Coverage Thresholds
```json
{
  "jest": {
    "coverageThresholds": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```
