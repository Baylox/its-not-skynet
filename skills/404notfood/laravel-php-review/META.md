# Meta — laravel-php-review

## Source
- Auteur : 404notfood
- Repo : https://github.com/Baylox/its-not-skynet
- Statut : **stable**

## Contexte d'usage
Skill de revue de code ciblé PHP / Laravel, adapté à **Laravel 12 et 13**. S'utilise avant un merge ou sur une PR pour repérer les failles de sécurité (mass assignment, injection SQL, validation manquante, données exposées, secrets en dur, clés AI SDK), les problèmes de performance (requêtes N+1, absence de pagination) et les écarts de convention propres à ces versions (skeleton slim et `bootstrap/app.php` en L12, attributs PHP / `Queue::route()` en L13). Le skill relit, il ne réécrit pas : chaque remarque est classée par sévérité et pointe fichier + ligne avec un correctif.

## Installation

### Pour un skill — Copier le dossier dans le projet cible :
```
.claude/skills/laravel-php-review/
```
(ou `bash scripts/install.sh skills/404notfood/laravel-php-review /chemin/du/projet`)

## Environnement testé
- Outil : Claude Code
- Stack : Laravel 12 (PHP 8.2+) et Laravel 13 (PHP 8.3+), environnement Laragon (Windows)
