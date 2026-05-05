# hooks/anthropics/

Hooks officiels tirés de la documentation Anthropic Claude Code.

→ Retour à [hooks/](../README.md)

Source : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Hooks disponibles

| Dossier | Événement | Description |
|---------|-----------|-------------|
| [notification_desktop/](notification_desktop/META.md) | `Notification` | Alerte desktop cross-platform (macOS, Linux, Windows) |
| [pre_tool_use_protect_files/](pre_tool_use_protect_files/META.md) | `PreToolUse` | Bloque l'édition de fichiers sensibles |
| [pre_tool_use_block_rm_rf/](pre_tool_use_block_rm_rf/META.md) | `PreToolUse` | Bloque les `rm -rf` |
| [post_tool_use_log_bash/](post_tool_use_log_bash/META.md) | `PostToolUse` | Journalise les commandes Bash |
| [post_tool_use_prettier/](post_tool_use_prettier/META.md) | `PostToolUse` | Auto-formate avec Prettier |
| [session_start_reinject_context/](session_start_reinject_context/META.md) | `SessionStart` | Réinjecte le contexte après compaction |
