# Meta — laravel_reviewer

## Source
- Auteur : 404notfood
- Repo : https://github.com/Baylox/its-not-skynet
- Statut : **stable**

## Contexte d'usage
Subagent de revue de code PHP / Laravel ciblé **Laravel 12 et 13**. À déléguer avant un merge ou sur une PR : il relit (ne réécrit pas) et signale les failles de sécurité (mass assignment, injection SQL, validation manquante, données exposées, secrets en dur), les problèmes de performance (N+1, pagination) et les écarts de convention propres à ces versions (skeleton slim / `bootstrap/app.php` en L12, attributs PHP / `Queue::route()` en L13). Chaque remarque est classée par sévérité et pointe fichier + ligne avec un correctif.

Pendant « agent » du skill `laravel-php-review` : même logique de revue, mais utilisable en délégation de tâche plutôt qu'en skill chargé dans le contexte.

## Installation

### Pour un subagent — Copier dans le projet cible :
```
.claude/agents/laravel_reviewer.md
```

(copier le contenu de `laravel_reviewer.md` sous ce nom ; le frontmatter `tools` limite l'agent à Read/Grep/Glob/Bash, donc lecture seule + commandes git de diff)

## Environnement testé
- Outil : Claude Code
- Stack : Laravel 12 (PHP 8.2+) et Laravel 13 (PHP 8.3+), environnement Laragon (Windows)
