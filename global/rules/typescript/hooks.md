---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
---
# TypeScript/JavaScript Hooks

> This file extends [common/hooks.md](../common/hooks.md) with TypeScript/JavaScript specific content.

## PostToolUse Hooks

Configure in `~/.claude/settings.json` or `.claude/settings.json`:

- **Prettier**: Auto-format JS/TS files after edit
- **TypeScript check**: Run `tsc --noEmit` after editing `.ts`/`.tsx` files
- **console.log warning**: Warn about `console.log` in edited files

### Example: Auto Typecheck Hook

Adapted from BRS-api's compile-check pattern — runs typecheck after every file edit:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "file_path=$(echo \"$TOOL_INPUT\" | python3 -c \"import sys,json; print(json.load(sys.stdin).get('file_path',''))\" 2>/dev/null); [[ \"$file_path\" == *.ts || \"$file_path\" == *.tsx ]] && npx tsc --noEmit --pretty 2>&1 | tail -20 || exit 0",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

## Stop Hooks

- **console.log audit**: Check all modified files for `console.log` before session ends
