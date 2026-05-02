# Architecture — its-not-skynet

## Les 5 couches

| Dossier | Contenu |
|---|---|
| `CLAUDE.md` | Contexte projet, lu automatiquement par Claude Code |
| `skills/` | Skills Claude Code réutilisables |
| `hooks/` | Hooks shell déterministes (aucune IA dedans) |
| `subagents/` | Définitions de subagents spécialisés |
| `configs/` | Configs MCP, Ollama, CLI validées |

## Principes

- Les hooks sont déterministes — aucune logique IA, uniquement du shell
- Les skills suivent la convention snake_case préfixée par domaine
- Rien ne dépend d'un réseau non maîtrisé à l'exécution

## Ressources officielles

Les skills préfixés `anthropics/` dans `skills/` proviennent du repo
officiel Anthropic sur [anthropics/skills](https://github.com/anthropics/skills). Ils sont intégrés sans
modification du contenu original.
