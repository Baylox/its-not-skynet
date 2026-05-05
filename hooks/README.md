# hooks/

Scripts shell déterministes exécutés par Claude Code à des événements précis.

→ Retour au [CLAUDE.md](../CLAUDE.md)

## Structure

```
hooks/
├── anthropics/        # Hooks officiels Anthropic
└── nom_du_hook/       # Hooks personnels/communautaires
    ├── hook.sh
    └── META.md
```

## Hooks disponibles

### [anthropics/](anthropics/README.md)

| Hook | Événement | Description |
|------|-----------|-------------|
| [notification_desktop](anthropics/notification_desktop/META.md) | `Notification` | Alerte desktop cross-platform |
| [pre_tool_use_protect_files](anthropics/pre_tool_use_protect_files/META.md) | `PreToolUse` | Bloque l'édition de fichiers sensibles |
| [pre_tool_use_block_rm_rf](anthropics/pre_tool_use_block_rm_rf/META.md) | `PreToolUse` | Bloque les `rm -rf` |
| [post_tool_use_log_bash](anthropics/post_tool_use_log_bash/META.md) | `PostToolUse` | Journalise les commandes Bash |
| [post_tool_use_prettier](anthropics/post_tool_use_prettier/META.md) | `PostToolUse` | Auto-formate avec Prettier |
| [session_start_reinject_context](anthropics/session_start_reinject_context/META.md) | `SessionStart` | Réinjecte le contexte après compaction |

### Personnels

| Hook | Événement | Description |
|------|-----------|-------------|
| [no_coauthor](no_coauthor/META.md) | `PreToolUse` | Bloque les `Co-Authored-By` dans les commits |
| [claude_md_sync](claude_md_sync/META.md) | `PostToolUse` | Vérifie la cohérence de CLAUDE.md après chaque commit — version shell (zéro token) et version prompt (⚠️ coûte des tokens) |

## Comment utiliser un hook

Référencer le script dans `.claude/settings.json` :

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/hook.sh" }]
      }
    ]
  }
}
```
