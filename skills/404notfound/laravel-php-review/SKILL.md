---
name: laravel-php-review
description: "Utiliser ce skill pour relire du code PHP/Laravel (Laravel 12 et 13) : revue d'un diff, d'une PR, d'un contrôleur, d'un model Eloquent, d'une migration, d'une route ou d'un job avant merge. Déclencher quand l'utilisateur demande une revue de code, un audit de sécurité, ou de vérifier les conventions/perfs sur du Laravel (requêtes N+1, mass assignment, validation, injections, exposition de données). Ne PAS déclencher pour du frontend pur, du code non-PHP, ou la simple génération de code sans intention de revue."
---

# Laravel / PHP — Revue de code (Laravel 12 & 13)

Revue ciblée d'un diff ou d'un fichier PHP/Laravel. Objectif : repérer les bugs réels, les failles de sécurité et les écarts de convention — pas réécrire le code.

## Cibles : Laravel 12 & 13

Adapter les remarques à la version du projet (vérifier `composer.json` → `laravel/framework`).

- **Laravel 12** : PHP 8.2+ minimum. Skeleton « slim » : pas de `app/Http/Kernel.php`, pas de `app/Console/Kernel.php`, pas de `AuthServiceProvider`/`RouteServiceProvider`. La config middleware, exceptions et routing vit dans `bootstrap/app.php`. Pas de `routes/api.php` par défaut (ajouté via `install:api`). Ne PAS signaler l'absence de ces fichiers comme un manque.
- **Laravel 13** : PHP 8.3+ minimum. Les attributs PHP 8 sont une alternative officielle aux propriétés de classe pour configurer les composants (non bloquant, rétrocompatible). `Queue::route()` centralise le mapping job → queue/connection dans un service provider. AI SDK first-party (provider-agnostique). Support JSON:API natif (resource classes dédiées).

Signaux d'incohérence à relever : config middleware/exceptions placée dans d'anciens `Kernel.php` réintroduits à la main, ou usage de structures pré-Laravel 11 dans un projet 12/13.

## Méthode

1. Lire le diff (ou les fichiers indiqués). Si rien n'est précisé, prendre les changements non commités.
2. Classer chaque remarque par sévérité : **Bloquant** / **À corriger** / **Suggestion**.
3. Pointer le fichier et la ligne. Donner le correctif, pas juste le problème.
4. Ne rien inventer : si un comportement dépend de code non visible, le signaler comme hypothèse à vérifier.

## Sécurité (priorité)

- **Mass assignment** : `$fillable`/`$guarded` définis sur les models ? `Model::create($request->all())` sans garde = bloquant.
- **Injection SQL** : `DB::raw`, `whereRaw`, `orderByRaw` avec variable non bindée → utiliser des bindings (`?` / `:param`).
- **Validation** : toute entrée utilisateur passe par `$request->validate()` / Form Request avant usage.
- **Données exposées** : pas de mot de passe / token / clé dans une réponse JSON ou un `$visible`. Vérifier `$hidden` sur les models sensibles.
- **Autorisation** : action sensible protégée par Policy / Gate / middleware, pas seulement par l'UI.
- **Secrets** : aucune clé/credential en dur — doit venir de `config()`. `env()` interdit hors des fichiers `config/*` (le cache de config en prod renvoie `null` pour tout `env()` appelé ailleurs).
- **AI SDK (L13)** : clés des providers (OpenAI/Anthropic) dans `config/` + `.env`, jamais en dur ; vérifier que les entrées utilisateur envoyées au prompt sont maîtrisées (pas d'injection de prompt depuis une donnée non filtrée).
- **Upload de fichiers** : type et taille validés, stockage hors webroot, nom de fichier non basé sur l'entrée brute.

## Performance

- **N+1** : boucle sur une relation sans `with()` / eager loading → signaler. Suspecter dès qu'un `foreach` accède à `$model->relation`.
- **`get()` puis filtrage PHP** au lieu d'un `where()` SQL.
- **Absence de pagination** sur des listes potentiellement grandes (`all()` / `get()` sans `paginate()`).
- **Requêtes dans les vues Blade** (déclencheur silencieux de N+1).

## Conventions Laravel / PHP

- Logique métier hors des contrôleurs (Service, Action, ou model) ; contrôleur mince.
- Nommage : models au singulier, tables au pluriel, méthodes en `camelCase`, classes en `StudlyCase`.
- `declare(strict_types=1)` et typage des signatures quand le projet le fait déjà — rester cohérent avec l'existant (PHP 8.2+ en L12, 8.3+ en L13 : property hooks, types impossibles, etc. sont disponibles selon la version).
- Migrations réversibles : `down()` cohérent avec `up()`.
- Pas de `dd()`, `dump()`, `var_dump()`, `Log::debug()` oubliés dans le diff.
- **Config dans `bootstrap/app.php` (L12/13)** : middleware, alias, exceptions et routing s'enregistrent ici via `->withMiddleware()`, `->withExceptions()`, `->withRouting()`. Signaler du code qui contourne ce flux.
- **Routing des jobs (L13)** : préférer `Queue::route()` centralisé plutôt que des `onQueue()`/`onConnection()` dispersés quand le projet a adopté ce pattern.
- **Attributs PHP (L13)** : usage cohérent — ne pas mélanger configuration par attributs et par propriétés sur un même composant sans raison.

## Format de sortie

```
## Revue — <fichier ou PR>

### Bloquant
- [chemin/fichier.php:42] <problème> → <correctif>

### À corriger
- ...

### Suggestion
- ...

### OK
- <points positifs notés, pour ne pas signaler à tort ce qui est déjà correct>
```

Si aucun problème : le dire explicitement plutôt que d'inventer des remarques.
