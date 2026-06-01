<div align="center">

# its-not-skynet

**Des ressources CLI/IA validées par des humains. Pas de magie. Pas de réseau non maîtrisé. Juste des outils qui marchent.**

[![not skynet](https://img.shields.io/badge/not-skynet-success)](https://github.com/its-not-skynet)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-ready-7C3AED)](https://claude.ai/code)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen)](CONTRIBUTING.md)
[![License](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

[Démarrage](#démarrage-rapide) · [Contribuer avec Claude](#contribuer-en-langage-naturel) · [Contenu](#ce-quon-y-trouve) · [Philosophie](#pourquoi-ce-repo)

</div>

---

## Pourquoi ce repo

L'écosystème des outils IA en CLI déborde de configs copiées-collées, de hooks jamais testés et de skills qui « marchaient sur la machine de quelqu'un ». **its-not-skynet** prend le contre-pied : ici, chaque ressource a été **créée ou testée en conditions réelles** par son auteur, qui en assume la pertinence.

> **Une seule règle, non négociable :** une ressource est soit **créée**, soit **explicitement validée** par son contributeur. Rien d'importé à l'aveugle. Rien qui dépende d'un réseau non maîtrisé à l'exécution.

C'est un catalogue de confiance pour quiconque travaille avec **Claude Code, MCP, Ollama** et les outils IA en ligne de commande.

## Ce qu'on y trouve

| Dossier | Description |
|---------|-------------|
| [`hooks/`](hooks/README.md) | Scripts déclenchés par Claude Code à des événements précis — `PreToolUse`, `PostToolUse`, `Notification`… |
| [`skills/`](skills/README.md) | Skills réutilisables : slash commands et agents spécialisés |
| [`configs/`](configs/README.md) | Fichiers de configuration prêts à copier — `settings.json`, `.mcp.json`, Ollama… |
| [`subagents/`](subagents/) | Définitions de subagents spécialisés |
| [`architecture/`](architecture/overview.md) | Schémas et décisions d'architecture du projet |

Chaque ressource vit dans son propre dossier avec un **`META.md`** : qui l'a créée, ce qu'elle fait, comment l'installer, sur quel environnement elle a été testée.

## Démarrage rapide

1. **Parcourez** le dossier qui vous intéresse — `hooks/`, `skills/` ou `configs/`.
2. **Lisez le `META.md`** de la ressource pour comprendre ce qu'elle fait.
3. **Copiez** le bloc d'installation fourni dans votre `settings.json` ou votre projet.
4. C'est tout — aucune dépendance à auditer, aucun appel réseau surprise.

```jsonc
// Exemple : activer un hook dans .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/no_coauthor/hook.sh\"" }
        ]
      }
    ]
  }
}
```

> `$CLAUDE_PROJECT_DIR` est exposée nativement par Claude Code — aucun `.env` requis.

## Contribuer en langage naturel

Ce repo est **pensé pour être étendu depuis Claude Code lui-même.** Ouvrez-le dans une session Claude et décrivez la ressource que vous voulez :

> *« Je veux un hook qui bloque les commits le vendredi »*

Claude lit le `CLAUDE.md` du projet, puis génère **la structure complète** en respectant les conventions du repo :

```
hooks/<votre-pseudo>/pre_tool_use_block_friday_commit/
├── pre_tool_use_block_friday_commit.sh   # le script, prêt à l'emploi
└── META.md                               # source, usage, installation
```

Le garde-fou reste le même : les fichiers générés sont des **drafts**. Le statut du `META.md` reste `À tester — non validé` tant que **vous** n'avez pas exécuté la ressource en conditions réelles. On ne commite qu'après validation humaine — c'est la promesse du repo.

**Vous gardez la main, Claude fait la plomberie.**

## Conventions

| Élément | Règle |
|--------|-------|
| Dossiers de skills | `kebab-case` |
| Dossiers de hooks / configs | `snake_case` |
| Chemin d'une ressource | `<type>/<pseudo-contributeur>/<nom>/` |
| Hooks | Déterminisme privilégié (shell pur). Toute dépendance LLM doit être déclarée dans le `META.md`. |

## Contribuer à la main

Pas envie de passer par Claude ? La voie classique fonctionne tout aussi bien :

1. Forkez et créez votre dossier `<type>/<pseudo>/<nom>/`.
2. Ajoutez un `META.md` (template dans [CONTRIBUTING.md](CONTRIBUTING.md)) avec votre déclaration : **Créé par moi** ou **Validé par moi**.
3. Testez en conditions réelles.
4. Ouvrez une PR.

Tout est détaillé dans **[CONTRIBUTING.md](CONTRIBUTING.md)**.

## En savoir plus

- **[CLAUDE.md](CLAUDE.md)** — contexte projet complet, lu automatiquement par Claude Code
- **[CONTRIBUTING.md](CONTRIBUTING.md)** — guide de contribution et template `META.md`

---

<div align="center">

*Construit par des devs qui testent ce qu'ils partagent.*

</div>
