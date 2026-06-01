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

## Organisation des ressources

Chaque ressource vit dans son propre dossier : `<dossier>/<pseudo-contributeur>/<nom-ressource>/`

Exemple : `hooks/anthropics/notification_desktop/`

Chaque dossier de ressource **doit** contenir un `META.md` avec :
- l'auteur et le statut (Créé / Validé)
- le contexte d'usage
- les instructions d'installation
- l'environnement testé

Le `META.md` est le point d'entrée unique pour comprendre et installer une ressource.

## Navigation rapide

Pour trouver une ressource : parcourir `hooks/`, `skills/`, ou `configs/` → lire le `META.md` du dossier qui t'intéresse.
Pour contribuer : voir [CONTRIBUTING.md](./CONTRIBUTING.md).

## Mode contributeur assisté

Quand un contributeur décrit une ressource à créer (en langage naturel ou via un fichier MD), Claude génère la structure complète sans intervention manuelle.

### Protocole

1. Identifier le type (hook / skill / config) et le pseudo du contributeur
2. Créer `<type>/<pseudo>/<nom>/` avec la convention de nommage du type
3. Générer les fichiers requis selon le type :

| Type | Fichiers à créer | Nommage dossier |
|------|-----------------|-----------------|
| Hook | `nom_hook.sh` + `META.md` | `snake_case` |
| Skill | `SKILL.md` + `META.md` | `kebab-case` |
| Config | fichier(s) config + `META.md` | `kebab-case` |

4. Remplir le `META.md` en suivant le template dans [CONTRIBUTING.md](./CONTRIBUTING.md) — statut : `À tester — non validé`
5. Mettre à jour le `README.md` du dossier parent avec la nouvelle entrée

Pour les hooks, référence complète des événements et exit codes dans [hooks/README.md](./hooks/README.md).

> **Important :** Les fichiers générés sont des drafts. Le statut du `META.md` doit rester `À tester — non validé` jusqu'à ce que le contributeur ait testé la ressource en conditions réelles. Le commit ne doit intervenir qu'après validation humaine et mise à jour du statut.

## Conventions de nommage

Les dossiers sont en `kebab-case` pour les skills, `snake_case` pour les hooks et configs.

## Hooks

Les hooks privilégient le déterminisme (shell pur).
Les hooks avec dépendances LLM sont acceptés mais doivent être
explicitement marqués comme tels dans leur META.md.
