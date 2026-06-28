---
name: pre-pr-check
description: >
  Vérifie qu'une contribution its-not-skynet est prête pour une PR, en enrobant
  `scripts/doctor.sh` (lint des ressources + catalogue à jour + audit sécurité des hooks).
  Le skill exécute les contrôles, traduit les sorties en verdict actionnable, régénère le
  `CATALOG.md`/`index.json` s'ils sont désynchronisés, et vérifie les règles que la CI
  applique (statut ≥ beta pour une PR, format conventional commits si demandé).
  À UTILISER avant d'ouvrir une PR sur le repo, quand l'utilisateur demande « est-ce prêt
  pour une PR ? », « lance le doctor », « vérifie ma ressource » ou « pré-check PR ».
  NE PAS UTILISER pour créer une ressource (→ new-resource) ni hors du repo its-not-skynet.
---

# pre-pr-check — bilan pré-PR

Boucle de vérification avant PR. Rejoue ce que fait la CI
(`.github/workflows/validate.yml` : `test.sh`, `validate.sh`, `build-index.sh --check`,
`audit-hooks.sh --strict`) et rend un verdict net : **prêt** ou **pas prêt**, avec la liste
des corrections.

## Procédure

### 1. Lancer le doctor
Cibler la (les) ressource(s) concernée(s) si connues, sinon tout le repo :
```bash
bash scripts/doctor.sh [<type>/<pseudo>/<nom> ...]
```
`doctor.sh` enchaîne 3 étapes : **lint** (bloquant), **catalogue** (bloquant),
**audit sécurité** (consultatif). Exit 0 = prêt, exit 1 = au moins un contrôle bloquant KO.

### 2. Interpréter et corriger
- **Lint KO** (`validate.sh`) : `META.md` manquant/incomplet (sections `Source`,
  `Contexte d'usage`, `Environnement testé`), champ `Auteur` vide, statut absent/invalide,
  nommage de dossier non conforme, fichier de définition manquant. → Corriger le `META.md`
  ou la structure, relancer.
- **Catalogue désynchronisé** (`build-index.sh --check`) : régénérer avec
  `bash scripts/doctor.sh --fix` (ou `bash scripts/build-index.sh`), puis **committer**
  `CATALOG.md` et `index.json`. La CI échoue si on oublie.
- **Audit sécurité** (`audit-hooks.sh`) : consultatif dans le doctor. Inspecter chaque
  alerte (réseau, `curl|sh`, `eval`, `rm -rf`). Faux positif assumé → ajouter `# audit:allow`
  en fin de ligne dans le hook, avec une justification. La CI tourne en `--strict`, donc une
  alerte non traitée **bloque** la PR : ne pas l'ignorer.

### 3. Vérifier les règles de PR (au-delà du doctor)
- **Statut ≥ beta** : une ressource en `draft` n'est pas mergeable. Confirmer auprès de
  l'utilisateur qu'elle a bien été **testée en conditions réelles** avant de promouvoir le
  statut. Ne pas passer en `beta`/`stable` à sa place sans confirmation explicite.
- **`README.md` parent à jour** : la ressource apparaît dans le tableau du dossier de type.
- **Commits** : si le repo impose le format conventional commits (cf. historique), le
  rappeler. Vérifier l'absence de `Co-Authored-By` (le hook `no_coauthor` le bloque).

### 4. Verdict
- **Tout vert + statut ≥ beta testé** → annoncer « prêt pour la PR » et lister ce qui a été
  vérifié.
- **Sinon** → lister précisément les points ✗ restants et l'action pour chacun. Ne pas
  déclarer « prêt » si un contrôle bloquant échoue.

## Notes
- Ne jamais désactiver un contrôle pour faire passer le doctor. Corriger la cause.
- Le skill **n'ouvre pas la PR** et ne committe pas sans demande explicite — il vérifie.
- Rejouer `bash scripts/test.sh` si l'outillage lui-même (`scripts/`) a été modifié.
