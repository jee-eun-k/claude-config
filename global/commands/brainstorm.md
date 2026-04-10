---
description: Pre-planning design exploration via Socratic dialogue. Explores intent, requirements, and design before implementation. From Superpowers.
---

# Brainstorm Command

This command invokes the **brainstorming** skill from Superpowers to turn vague ideas into fully formed designs through collaborative dialogue.

## What This Command Does

1. **Explore project context** - Check files, docs, recent commits
2. **Ask clarifying questions** - One at a time, understand purpose/constraints/criteria
3. **Propose 2-3 approaches** - With trade-offs and recommendation
4. **Present design** - In sections scaled to complexity, get approval after each
5. **Write design doc** - Save spec and commit
6. **Transition to planning** - Hand off to `/plan` for implementation planning

## When to Use

Use `/brainstorm` when:
- Starting work on a new feature with unclear scope
- You have a vague idea that needs refinement before planning
- Multiple design approaches are viable and need evaluation
- You want Socratic exploration before committing to a direction

## Hard Gate

NO implementation until design is presented and user approves. This applies to EVERY project regardless of perceived simplicity.

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design sections, get approval before moving on

## Integration

After brainstorming:
- Use `/plan` to create implementation plan from the approved design
- Use `/tdd` to implement with test-driven development
- The design doc serves as the spec for code review validation

## Source

Cherry-picked from [superpowers](https://github.com/obra/superpowers) skill: `brainstorming`
