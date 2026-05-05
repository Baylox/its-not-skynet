# its-not-skynet — Contexte projet

## But

Centraliser des ressources CLI/IA (skills, prompts, architectures, configs) validées par leurs auteurs.

## Règle fondamentale

Chaque ressource est soit **créée**, soit **explicitement validée** par son contributeur.
Aucune ressource importée sans test personnel n'est acceptée.

## Scope accepté

- Claude Code (skills, hooks, subagents, configs)
- MCP (serveurs, configs)
- Ollama (modèles, configs)
- Outils CLI IA en général

## Scope exclu

- Dépendances npm non auditées
- Plugins marketplace non vérifiés
- Tout ce qui nécessite un **réseau non maîtrisé à l'exécution**

## Conventions de nommage

Les fichiers sont en `snake_case`, préfixés par domaine :

- `symfony_code_review.md`
- `mcp_server_setup.md`
- `ollama_local_config.json`

## Hooks

Les hooks privilégient le déterminisme (shell pur).
Les hooks avec dépendances LLM sont acceptés mais doivent être
explicitement marqués comme tels dans leur META.md.

Chaque hook vit dans son propre dossier :

```
hooks/
└── nom_du_hook/
    ├── hook.sh
    └── META.md
```

Les hooks officiels Anthropic sont dans `hooks/anthropics/nom_du_hook/`.

## Conventions META.md

Chaque hook doit avoir un `META.md` avec :
- Source (auteur, lien)
- Contexte d'usage
- Événement + matcher
- Exemple de configuration `settings.json`
- Environnement testé (outil uniquement, pas l'OS)
