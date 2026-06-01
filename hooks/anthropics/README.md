# hooks/anthropics/

Hooks officiels tirés de la documentation Anthropic Claude Code.

Source : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contenu

| Fichier | Événement | Description |
|---------|-----------|-------------|
| `notification_desktop.sh` | Notification | Notification Windows/Linux/macOS |
| `pre_tool_use_protect_files.sh` | PreToolUse | Bloque l'édition de fichiers protégés |
| `pre_tool_use_block_rm_rf.sh` | PreToolUse | Bloque les `rm -rf` |
| `post_tool_use_log_bash.sh` | PostToolUse | Journalise toutes les commandes Bash |
| `post_tool_use_prettier.sh` | PostToolUse | Auto-formate après écriture |
| `session_start_reinject_context.sh` | SessionStart | Réinjecte le contexte après compaction |

## Usage

Référencer dans `.claude/settings.json` :

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "bash /chemin/vers/pre_tool_use_protect_files.sh"
          }
        ]
      }
    ]
  }
}
```
