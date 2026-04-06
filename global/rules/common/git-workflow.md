# Git Workflow

## Branch Naming

### Format

```
<type>/<issue-ref>-<short-description>
```

- **Lowercase only** — no `ERP-PAYJSON` or `Onboarding-Training-Bonus`
- **Hyphens only** — no underscores, no camelCase (`payout-ledger`, not `payoutLedger`)
- **Issue reference required** — `#123` for GitHub Issues (`feature/#123-settlement-ui`)
- **Short description** — 2-4 words, kebab-case

### Branch Types

| Prefix | Purpose | Base branch | Merge target |
|--------|---------|-------------|--------------|
| `feature/` | New functionality | `*-dev` | `*-dev` |
| `fix/` | Bug fixes | `*-dev` | `*-dev` |
| `hotfix/` | Critical production fixes | `*-prd` | `*-prd` + cherry-pick to `*-dev` |
| `refactor/` | Code restructuring | `*-dev` | `*-dev` |
| `chore/` | Tooling, deps, CI/CD | `*-dev` | `*-dev` |
| `docs/` | Documentation only | `*-dev` | `*-dev` |
| `test/` | Test additions/fixes | `*-dev` | `*-dev` |

### Examples

```
feature/#329-error-pages        ✅
feature/#651-deposit-filtering  ✅
fix/#412-date-format-bug        ✅
hotfix/monthly-summary          ✅ (hotfix exempt from issue ref)
chore/e2e-smoke-tests           ✅

ERP-PAYJSON                     ❌ bare name, uppercase
compliance-refactor              ❌ no type prefix
brs-firmbanking_io_payoutLedger  ❌ underscores, camelCase
feature/298/virtual-account/tag  ❌ nested slashes
```

### Rules

1. **No bare branch names** — always use a type prefix
2. **One slash only** — `feature/#123-desc`, not `feature/123/module/desc`
3. **Hotfixes** are the only type exempt from issue reference requirement
4. **Delete branches** after merge — do not accumulate stale remote branches

## Commit Message Format
```
<type>: <description>

<optional body>
```

Types: feat, fix, refactor, docs, test, chore, perf, ci

Prohibited in commit messages:
- `Co-Authored-By` headers — attribution is disabled globally via ~/.claude/settings.json
- AI tool signatures or watermarks

## Pull Request Workflow

When creating PRs:
1. Analyze full commit history (not just latest commit)
2. Use `git diff [base-branch]...HEAD` to see all changes
3. Draft comprehensive PR summary
4. Include test plan with TODOs
5. Push with `-u` flag if new branch

> For the full development process (planning, TDD, code review) before git operations,
> see [development-workflow.md](./development-workflow.md).
