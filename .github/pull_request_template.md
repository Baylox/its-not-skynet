<!-- Merci pour ta contribution à its-not-skynet ! Remplis les sections ci-dessous. -->

## Ressource(s)

<!-- Liste les ressources ajoutées/modifiées : <type>/<pseudo>/<nom> -->

-

## Ce que ça fait

<!-- Résumé en une à deux phrases : que fait la ressource, dans quel workflow. -->

## Statut déclaré

<!-- Coche le statut. Une PR démarre au minimum en beta. -->

- [ ] `stable` — testé en conditions réelles, en usage régulier
- [ ] `beta` — testé, mais usage limité ou edge cases non couverts
- [ ] `draft` — généré/écrit, pas encore testé (ne devrait pas être mergé tel quel)

## Règle fondamentale

- [ ] J'ai **créé** ou **testé personnellement** cette ressource — rien d'importé sans validation.
- [ ] Aucun accès **réseau non maîtrisé** à l'exécution (ou il est déclaré dans `META.md`).
- [ ] Toute dépendance **LLM** d'un hook est marquée dans son `META.md`.

## Checklist pré-merge

- [ ] `bash scripts/doctor.sh <type>/<pseudo>/<nom>` sort en vert (lint + catalogue + audit).
- [ ] `CATALOG.md` et `index.json` régénérés (`bash scripts/build-index.sh`) et commités.
- [ ] Le `META.md` contient les sections **Source**, **Contexte d'usage**, **Environnement testé**.
