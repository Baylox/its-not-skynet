# configs/

Fichiers de configuration validés et copiables pour les outils CLI/IA.

→ Retour au [CLAUDE.md](../CLAUDE.md)

## Structure

```
configs/
├── anthropics/        # Configs officielles Anthropic
└── contributeur/      # Configs personnelles/communautaires
    └── nom-de-la-config/
        ├── config.json   (ou settings.json, .mcp.json, etc.)
        └── META.md
```

## Comment utiliser une config

Chaque `META.md` indique la destination cible. Exemples courants :

| Type | Destination |
|------|-------------|
| `settings.json` | `~/.claude/settings.json` (global) ou `.claude/settings.json` (projet) |
| `.mcp.json` | racine du projet |
| Config Ollama | selon la doc Ollama |

## Configs disponibles

Aucune config pour le moment.
