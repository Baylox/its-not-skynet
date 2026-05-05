# hooks/

Scripts exécutés par Claude Code à des événements précis du cycle de vie.

→ Retour au [CLAUDE.md](../CLAUDE.md)

## Démarrage rapide

1. Choisir un hook dans la liste ci-dessous
2. Lire son `META.md` pour comprendre ce qu'il fait
3. Copier le bloc `settings.json` fourni dans le META dans votre `~/.claude/settings.json` ou `.claude/settings.json`
4. Remplacer `/chemin/vers/` par `$CLAUDE_PROJECT_DIR/hooks/` — cette variable est exposée nativement par Claude Code

## Structure

```
hooks/
├── anthropics/        # Hooks officiels Anthropic
│   └── nom_du_hook/
│       ├── hook.sh
│       └── META.md
└── nom_du_hook/       # Hooks personnels/communautaires
    ├── hook.sh        # ou hook.json pour les hooks type prompt
    └── META.md
```

## Hooks disponibles

### [anthropics/](anthropics/README.md) — Officiels Anthropic

| Hook | Événement | Description |
|------|-----------|-------------|
| [notification_desktop](anthropics/notification_desktop/META.md) | `Notification` | Alerte desktop cross-platform |
| [pre_tool_use_protect_files](anthropics/pre_tool_use_protect_files/META.md) | `PreToolUse` | Bloque l'édition de fichiers sensibles |
| [pre_tool_use_block_rm_rf](anthropics/pre_tool_use_block_rm_rf/META.md) | `PreToolUse` | Bloque les `rm -rf` |
| [post_tool_use_log_bash](anthropics/post_tool_use_log_bash/META.md) | `PostToolUse` | Journalise les commandes Bash |
| [post_tool_use_prettier](anthropics/post_tool_use_prettier/META.md) | `PostToolUse` | Auto-formate avec Prettier |
| [session_start_reinject_context](anthropics/session_start_reinject_context/META.md) | `SessionStart` | Réinjecte le contexte après compaction |

### Personnels — Baylo

| Hook | Événement | Type | Description |
|------|-----------|------|-------------|
| [no_coauthor](no_coauthor/META.md) | `PostToolUse` | shell | Bloque les `Co-Authored-By` dans les commits |
| [claude_md_sync](claude_md_sync/META.md) | `PostToolUse` | shell + prompt | Vérifie la cohérence de CLAUDE.md après chaque commit |

> `claude_md_sync` existe en deux versions : shell (zéro token, recommandée) et prompt (⚠️ coûte des tokens à chaque commit).

## Exemple d'activation

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/no_coauthor/hook.sh\""
          }
        ]
      }
    ]
  }
}
```

`$CLAUDE_PROJECT_DIR` est une variable native de Claude Code — aucun `.env` requis.
