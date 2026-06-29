---
name: new-resource
description: >
  Crée une nouvelle ressource its-not-skynet (hook, skill, config, subagent ou
  architecture) de bout en bout, en respectant la convention `<type>/<pseudo>/<nom>`
  et le « mode contributeur assisté » du CLAUDE.md. Le skill identifie le type et le
  pseudo, appelle `scripts/new.sh` pour scaffolder, remplit le `META.md` (statut
  draft), écrit le fichier de définition (SKILL.md / hook.sh / config…), met à jour le
  `README.md` du dossier parent, puis lance `scripts/doctor.sh` pour valider.
  À UTILISER quand l'utilisateur décrit une ressource à ajouter au repo, dit « je veux
  contribuer un hook/skill/config », ou demande de scaffolder une ressource.
  NE PAS UTILISER pour modifier une ressource existante, ni hors du repo its-not-skynet.
---

# new-resource — contributeur assisté

Transforme la description d'une ressource en une arborescence conforme, prête pour
`doctor.sh`. C'est l'outillage du « mode contributeur assisté » décrit dans `CLAUDE.md`.

## Règles non négociables (CLAUDE.md)

- **Statut `draft` obligatoire** tant que la ressource n'a pas été testée en conditions
  réelles. Ne jamais écrire `beta`/`stable` à la création.
- **Zéro réseau non maîtrisé** à l'exécution, déterminisme privilégié (shell pur pour les
  hooks). Refuser une ressource hors scope (deps npm non auditées, plugins marketplace).
- **Pas de commit avant validation humaine.** Le skill prépare et valide ; il ne committe pas.

## Protocole

### 1. Identifier type et pseudo
- **Type** : `hooks` | `skills` | `configs` | `subagents` | `architecture`.
  Au moindre doute, demander. Indices : « avant chaque commande » → hook ; « slash command /
  agent réutilisable » → skill ; « settings.json / .mcp.json / Modelfile » → config.
- **Pseudo** : demander si non fourni. C'est le dossier `<type>/<pseudo>/<nom>`.
- **Nom** : `snake_case` pour hooks/subagents, `kebab-case` pour skills/configs/architecture.

### 2. Scaffolder
```bash
bash scripts/new.sh <type> <pseudo> <nom>
```
Crée le dossier, un `META.md` pré-rempli (statut `draft` en dur) et le stub à la bonne
convention. Le script **refuse d'écraser** un dossier existant — si c'est une modification,
ce n'est pas le bon skill.

### 3. Remplir le `META.md`
Compléter les sections (laisser le statut à `draft`) :
- **Source** : `Auteur`, `Statut : **draft**`. Champs optionnels reconnus par
  `build-index`/`find` : `Tags`, `Dépendances`, `Testé le`.
- **Contexte d'usage** : ce que fait la ressource, dans quel workflow elle s'intègre.
- **Installation** : bloc `settings.json` pour un hook ; chemin de copie pour skill/config.
- **Environnement testé** : outil (Claude Code, Codex CLI, Ollama…), OS, versions.

### 4. Écrire le fichier de définition
À partir de la description de l'utilisateur :
- **hook** → `<nom>.sh` exécutable, shell pur, `exit 0`/`exit 2` selon la sémantique
  (voir `hooks/README.md` pour les événements et exit codes).
- **skill** → `SKILL.md` avec frontmatter `name` + `description` (la `description` doit dire
  *quand* le skill se déclenche ET quand ne pas l'utiliser — c'est le déclencheur).
- **config** → fichier(s) de config commentés.
- **subagent** → `<nom>.md` avec frontmatter `name`/`description`/`tools`.

### 5. Mettre à jour le `README.md` parent
Ajouter une ligne dans le tableau du `README.md` du dossier de type (`skills/README.md`,
`hooks/README.md`…), sous la section du pseudo (créer la section si nouveau contributeur).

### 6. Valider
```bash
bash scripts/doctor.sh <type>/<pseudo>/<nom>
```
Enchaîne lint + catalogue + audit. Le `CATALOG.md`/`index.json` se régénèrent via
`doctor.sh --fix` ou `bash scripts/build-index.sh`. Doit sortir en vert.

### 7. Rendre la main
Annoncer ce qui a été créé et **rappeler que le statut reste `draft`** : à l'utilisateur de
tester en conditions réelles avant de passer à `beta`/`stable` et d'ouvrir la PR. Ne pas
committer sans validation humaine.

## Checklist de sortie
- [ ] `scripts/new.sh` a scaffoldé sans écraser
- [ ] `META.md` complet, statut `draft`
- [ ] Fichier de définition écrit et cohérent avec le scope (zéro réseau non maîtrisé)
- [ ] `README.md` parent à jour
- [ ] `doctor.sh` vert (catalogue régénéré)
- [ ] Statut `draft` rappelé à l'utilisateur, aucun commit effectué
