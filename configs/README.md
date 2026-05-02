# configs/

Exemples de configurations validées : `settings.json`, `.mcp.json`, configs Ollama, etc.

## Où les copier

Selon le type de config :

| Fichier | Destination cible |
|---|---|
| `settings.json` | `.claude/settings.json` du projet |
| `.mcp.json` | racine du projet |
| config Ollama | selon l'OS (`~/.ollama/`) |

## Convention

Fichiers en `snake_case`, préfixés par outil — ex: `mcp_filesystem_config.json`, `ollama_mistral_config.json`.
