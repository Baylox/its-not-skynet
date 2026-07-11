# ⚙️ configs/

Fichiers de configuration validés et copiables pour les outils CLI/IA.

[⬅ README](../README.md) · [📒 Catalogue](../CATALOG.md) · [🤝 Contribuer](../CONTRIBUTING.md)

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

Les configs sont des points de départ — copiez, adaptez et personnalisez à votre convenance avant de les appliquer.

Chaque `META.md` indique la destination cible. Exemples courants :

| Type | Destination |
|------|-------------|
| `settings.json` | `~/.claude/settings.json` (global) ou `.claude/settings.json` (projet) |
| `.mcp.json` | racine du projet |
| Config Ollama | selon la doc Ollama |

## Configs disponibles

### anthropics/

| Config | Description |
|--------|-------------|
| [global-base](anthropics/global-base/META.md) | `~/.claude/settings.json` — base personnelle (modèle, langue, protection fichiers sensibles) |
| [project-base](anthropics/project-base/META.md) | `.claude/settings.json` — base projet partagée (permissions git équipe) |
