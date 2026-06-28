# its-not-skynet — Contexte projet

## But

Centraliser des ressources CLI/IA (skills, prompts, architectures, configs) validées par leurs auteurs.

## Règle fondamentale

Chaque ressource est soit **créée**, soit **explicitement validée** par son contributeur.
Aucune ressource importée sans test personnel n'est acceptée.

## Scope

Accepté : Claude Code (skills, hooks, subagents, configs), MCP, Ollama, outils CLI IA.
Exclu : dépendances npm non auditées, plugins marketplace non vérifiés, tout ce qui nécessite un réseau non maîtrisé à l'exécution.

## Structure

| Dossier | Contenu |
|---------|---------|
| `hooks/` | Scripts shell exécutés par Claude Code (PreToolUse, PostToolUse…) |
| `skills/` | Skills Claude Code réutilisables |
| `configs/` | Fichiers de configuration copiables (settings.json, .mcp.json, Ollama) |
| `architecture/` | Schémas et décisions d'architecture |
| `subagents/` | Définitions de subagents |

## Organisation des ressources

Chaque ressource vit dans `<type>/<pseudo>/<nom>/` et contient un `META.md` (auteur, statut, usage, installation, environnement testé). C'est le point d'entrée unique pour comprendre et installer une ressource.

## Mode contributeur assisté

Quand un contributeur décrit une ressource, Claude génère la structure complète.

### Protocole

1. Identifier le type (hook / skill / config) et le pseudo du contributeur
2. Créer le dossier selon la convention :

| Type | Fichiers | Nommage dossier |
|------|----------|-----------------|
| Hook | `nom_hook.sh` + `META.md` | `snake_case` |
| Skill | `SKILL.md` + `META.md` | `kebab-case` |
| Config | fichier(s) config + `META.md` | `kebab-case` |

3. Remplir le `META.md` (template dans CONTRIBUTING.md) — statut : `draft`
4. Mettre à jour le `README.md` du dossier parent

Raccourci : `bash scripts/new.sh <type> <pseudo> <nom>` crée le dossier + `META.md` (draft) + stub à la bonne convention.

Référence hooks (événements, exit codes) : `hooks/README.md`.
Statut `draft` obligatoire jusqu'à test en conditions réelles. Commit uniquement après validation humaine.

## Outillage (`scripts/`)

Outils pur-shell, déterministes, zéro réseau (`jq` optionnel) :
- `scripts/new.sh` — scaffolder une ressource (dossier + `META.md` draft + stub).
- `scripts/validate.sh` — lint des ressources (META, sections, statut valide, nommage, fichier requis). Exit 0/1.
- `scripts/build-index.sh` — génère `CATALOG.md` (+ stats) + `index.json` ; `--check` échoue si désynchro.
- `scripts/find.sh` — recherche par mot-clé / type / statut / contributeur.
- `scripts/audit-hooks.sh` — scan sécurité des hooks (réseau, `curl|sh`, `eval`, `rm -rf`) ; consultatif, `--strict` en CI. Faux positif : `# audit:allow` en fin de ligne.
- `scripts/doctor.sh` — bilan pré-PR : enchaîne lint + catalogue + audit avec messages actionnables.
- `scripts/test.sh` — teste l'outillage sur des fixtures jetables.

Avant tout commit de ressource : `bash scripts/doctor.sh` (ou `validate.sh` puis `build-index.sh`). La CI (`.github/workflows/validate.yml`) rejoue `test.sh`, `validate.sh`, `build-index.sh --check` et `audit-hooks.sh --strict` sur chaque PR.

## Hooks

Les hooks privilégient le déterminisme (shell pur).
Les hooks avec dépendances LLM doivent être explicitement marqués dans leur `META.md`.
