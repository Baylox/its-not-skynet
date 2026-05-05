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

## Structure

| Dossier | Contenu | Détails |
|---------|---------|---------|
| [`hooks/`](hooks/README.md) | Scripts shell exécutés par Claude Code | Événements PreToolUse, PostToolUse, etc. |
| [`skills/`](skills/README.md) | Skills Claude Code réutilisables | Slash commands, agents spécialisés |
| [`configs/`](configs/README.md) | Fichiers de configuration copiables | settings.json, .mcp.json, Ollama |
| `architecture/` | Schémas et décisions d'architecture | |
| `subagents/` | Définitions de subagents | |

## Conventions de nommage

Les dossiers sont en `kebab-case` pour les skills, `snake_case` pour les hooks et configs.

## Hooks

→ Voir [`hooks/README.md`](hooks/README.md)

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

## Skills

→ Voir [`skills/README.md`](skills/README.md)

Chaque skill vit dans son propre dossier :

```
skills/
└── contributeur/
    └── nom-du-skill/
        ├── SKILL.md
        └── META.md
```

## Configs

→ Voir [`configs/README.md`](configs/README.md)

Chaque config vit dans son propre dossier :

```
configs/
└── contributeur/
    └── nom-de-la-config/
        ├── config.json
        └── META.md
```

## Conventions META.md

Chaque ressource doit avoir un `META.md` avec :
- Source (auteur, lien)
- Contexte d'usage
- Instructions d'installation / configuration
- Environnement testé (outil uniquement, pas l'OS)
