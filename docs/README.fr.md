<div align="center">

# its-not-skynet

**Des ressources CLI/IA validées par des humains. Pas de magie. Pas de réseau non maîtrisé. Juste des outils qui marchent.**

[![validate](https://github.com/baylox/its-not-skynet/actions/workflows/validate.yml/badge.svg)](https://github.com/baylox/its-not-skynet/actions/workflows/validate.yml)

[Démarrage](#démarrage-rapide) · [Contribuer avec un agent](#contribuer-avec-un-agent) · [Contenu](#ce-quon-y-trouve) · [Philosophie](#pourquoi-ce-repo)

[English](../README.md)

</div>

---

## Pourquoi ce repo

L'écosystème des outils IA en CLI déborde de configs copiées-collées, de hooks jamais testés et de skills qui « marchaient sur la machine de quelqu'un ». **its-not-skynet** prend le contre-pied : chaque ressource a été **créée ou testée en conditions réelles** par son auteur.

> **Une seule règle, non négociable :** une ressource est soit **créée**, soit **explicitement validée** par son contributeur. Rien d'importé à l'aveugle. Rien qui dépende d'un réseau non maîtrisé à l'exécution.

Un catalogue de confiance pour quiconque travaille avec des agents CLI IA — Claude Code, Codex CLI, Antigravity CLI, MCP, Ollama, ou tout autre outil.

## Ce qu'on y trouve

| Dossier | Description |
|---------|-------------|
| [`hooks/`](hooks/README.md) | Scripts déclenchés par Claude Code — `PreToolUse`, `PostToolUse`, `Notification`… |
| [`skills/`](skills/README.md) | Skills réutilisables : slash commands et agents spécialisés |
| [`configs/`](configs/README.md) | Fichiers de configuration prêts à copier — `settings.json`, `.mcp.json`, Ollama… |
| [`subagents/`](subagents/) | Définitions de subagents spécialisés |
| [`architecture/`](architecture/README.md) | Schémas et décisions d'architecture du projet |

Chaque ressource a un **`META.md`** : auteur, statut, usage, installation, environnement testé.

## Démarrage rapide

1. Parcourez le dossier qui vous intéresse — `hooks/`, `skills/` ou `configs/`.
2. Lisez le `META.md` de la ressource.
3. Copiez le bloc d'installation dans votre `settings.json` ou votre projet.

```jsonc
// Exemple : activer un hook dans .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          { "type": "command", "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/Baylox/no_coauthor/hook.sh\"" }
        ]
      }
    ]
  }
}
```

> `$CLAUDE_PROJECT_DIR` est exposée nativement par Claude Code — aucun `.env` requis.

## Contribuer avec un agent

Ouvrez ce repo dans votre agent CLI et décrivez la ressource que vous voulez :

> *« Je veux un hook qui bloque les commits le vendredi »*

L'agent lit le fichier de contexte du projet et génère **la structure complète** en respectant les conventions du repo :

```
hooks/<votre-pseudo>/pre_tool_use_block_friday_commit/
├── pre_tool_use_block_friday_commit.sh
└── META.md
```

Chaque agent CLI dispose de son propre fichier de contexte :

| Agent | Fichier de contexte |
|-------|---------------------|
| Claude Code | [`CLAUDE.md`](CLAUDE.md) |
| Codex CLI | [`AGENTS.md`](AGENTS.md) |
| Antigravity CLI | [`ANTIGRAVITY.md`](ANTIGRAVITY.md) |

Les fichiers générés sont toujours des **drafts**. Le statut du `META.md` reste `draft` tant que **vous** n'avez pas exécuté la ressource en conditions réelles. On ne commite qu'après validation humaine — c'est la promesse du repo.

**Vous gardez la main, l'agent fait la plomberie.**

## Outillage

Des helpers pur-shell sous [`scripts/`](../scripts/) — déterministes, zéro réseau, aucune dépendance au-delà de coreutils (`jq` optionnel). Le catalogue d'outils CLI validés a droit à ses propres outils CLI validés.

| Script | Rôle |
|--------|------|
| `scripts/validate.sh` | Lint de chaque ressource : `META.md` présent, sections requises, statut valide (`stable`/`beta`/`draft`), nommage, fichier par type. Exit 0/1. |
| `scripts/build-index.sh` | Génère `CATALOG.md` (+ statistiques) et `index.json`. `--check` échoue si désynchronisé. |
| `scripts/find.sh` | Recherche par mot-clé / type / statut / contributeur — `scripts/find.sh -t hooks -s stable`. |
| `scripts/new.sh` | Scaffolde une ressource (`scripts/new.sh <type> <pseudo> <nom>`) avec un `META.md` pré-rempli (statut `draft`) et un stub. Les skills reçoivent une description orientée déclenchement et un dossier `references/` (progressive disclosure). |
| `scripts/install.sh` | Installe une ressource dans un projet cible — `scripts/install.sh skills/<pseudo>/<nom> /chemin/du/projet`. Copie un skill (avec ses `references/`) vers `.claude/skills/<nom>/`, un subagent vers `.claude/agents/`, les scripts d'un hook vers `.claude/hooks/` (+ le bloc `settings.json` à câbler). Fini le copier-coller manuel. |
| `scripts/doctor.sh` | Bilan avant PR : enchaîne lint + catalogue + audit sécurité et indique quoi corriger. |
| `scripts/audit-hooks.sh` | Scan sécurité des hooks — réseau à l'exécution, `curl \| sh`, `eval`, `rm -rf`. Consultatif ; `# audit:allow` neutralise une ligne. |
| `scripts/test.sh` | Teste l'outillage lui-même sur des fixtures jetables. |

Une GitHub Action rejoue `test.sh`, `validate.sh`, `build-index.sh --check` et `audit-hooks.sh --strict` sur chaque PR.

## Conventions

| Élément | Règle |
|---------|-------|
| Dossiers de skills | `kebab-case` |
| Dossiers de hooks / configs | `snake_case` |
| Chemin d'une ressource | `<type>/<pseudo-contributeur>/<nom>/` |
| Hooks | Shell pur privilégié. Toute dépendance LLM doit être déclarée dans le `META.md`. |

## Contribuer à la main

Forkez, créez votre dossier `<type>/<pseudo>/<nom>/`, ajoutez un `META.md` (template dans [CONTRIBUTING.md](CONTRIBUTING.md)), testez en conditions réelles, ouvrez une PR.

## Licence

Le travail original des contributeurs est sous licence **[MIT](LICENSE)**.

⚠️ **Le MIT ne couvre AUCUN contenu tiers.** Les ressources sous `anthropics/` sont l'œuvre d'Anthropic, restent leur propriété exclusive et sont régies par leurs propres termes (`LICENSE.txt` Apache-2.0 dans chaque dossier). Détails dans la section *Third-party content* du [LICENSE](LICENSE).

---

<div align="center">

*Construit par des devs qui testent ce qu'ils partagent.*

</div>
