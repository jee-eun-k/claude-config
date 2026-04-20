> 1-page A4 landscape · 8pt mono · Companion to `wall-reference.md`

# DELIBERATION & CHALLENGE CHEAT SHEET

## I NEED TO... → USE THIS

| Goal | Tool | Layer | Invoke |
|------|------|-------|--------|
| Explore a vague idea | Brainstorm | SP | `/brainstorm` |
| Stress-test requirements (math-scored) | Deep Interview | OMC | `deep-interview "idea"` |
| Get Planner/Architect/Critic consensus | Ralplan | OMC | `ralplan "task"` or `ralplan --interactive` |
| Write a PRD from scratch | BMAD create-prd | BMAD | `"Run BMAD workflow create-prd"` |
| Design system architecture | BMAD create-arch | BMAD | `"Run BMAD workflow bmad-create-architecture"` |
| Break epic into stories | BMAD epics+stories | BMAD | `"Run BMAD workflow bmad-create-epics-and-stories"` |
| Quick analysis / scope check | BMAD quick-flow | BMAD | `"Run BMAD workflow bmad-quick-flow"` |
| Challenge an architecture | Architect agent | ECC | `"Run architect agent on [module]"` |
| Plan implementation steps | Planner agent | ECC | `/plan` |
| Review code quality | Code Reviewer | ECC | `/code-review` |
| Review code (BMAD perspective) | BMAD code-review | BMAD | `"Run BMAD workflow bmad-code-review"` |
| Audit security | Security Reviewer | ECC | `"Run security-reviewer on [module]"` |
| Validate with test cycles | UltraQA | OMC | `ultraqa --tests` / `--build` / `--lint` |
| Compare UI to mockup | Visual Verdict | OMC | `visual-verdict` |
| Get external second opinion | Gemini | Ext | `gemini "problem + context"` |
| Get external third opinion | OpenCode | Ext | `opencode run "problem + context"` |
| Multi-perspective parallel review | Team / Ultrawork | OMC | `/team` or `/ultrawork` |
| Retrospective after sprint | BMAD retro | BMAD | `"Run BMAD workflow bmad-retrospective"` |

## PIPELINES — How Much Deliberation?

```
Full epic:    BMAD create-prd → create-arch → stories → deep-interview → ralplan → /autopilot
Feature:      /brainstorm → /plan → /tdd → /code-review
Story:        /plan → /tdd → /code-review
Bug/hotfix:   /tdd
Pre-merge:    /build-fix → /refactor-clean → /e2e
```

**Match deliberation depth to uncertainty, not task size.**

## SAY THIS — Challenge Phrases

| Goal | Phrase |
|------|--------|
| Challenge assumptions | "What assumptions am I making? Challenge them." |
| Trade-off analysis | "Give me 3 approaches with honest trade-offs" |
| Steelman opposite | "Steelman the approach I'm NOT taking" |
| Simplify | "What's the simplest version that's still valuable?" |
| Find risks | "What will go wrong with this plan?" |
| Scope check | "Is this over-engineered for the actual need?" |
| Reality check | "What would a senior engineer push back on here?" |
| Pre-mortem | "Imagine this shipped and failed. Why did it fail?" |
| Validate constraints | "Which of these constraints are real vs assumed?" |

## QUALITY GATES

| Gate | Question | Fail signal |
|------|----------|-------------|
| deep-interview | Do we know what to build? | Ambiguity > 20% |
| ralplan | Is the approach sound? | Critic REJECT |
| /brainstorm | Is the design right? | User rejects |
| /plan | Can we break this down? | Missing paths/steps |
| /tdd | Does the code work? | Tests fail, cov < 80% |
| ultraqa | Does it stay working? | 5 cycles no green |
| architect | Will this scale? | Unresolved trade-offs |
| code-reviewer | Is it maintainable? | Critical/High issues |
| security-reviewer | Is it safe? | OWASP / leaked secrets |
| BMAD code-review | Does it match spec? | AC gaps, bad patterns |

## WHEN TO CONSULT EXTERNALLY

`gemini` — going in circles (3+ attempts) · cross-repo decisions · agent disagreement
`opencode run` — alt architecture perspective · never without `run` subcommand
Both + Claude — **mandatory** for epic-level planning and major refactors

## DON'T DELIBERATE WHEN

Specific file+function+AC given → just execute · Single-file clear bug → `/tdd` · User says "just do it" → respect intent · Well-scoped story with full AC → `/autopilot`

---
*v2026-04-16 · Layers: ECC (agents/commands) · OMC (skills) · SP (Superpowers) · BMAD (workflows) · Ext (gemini/opencode)*
