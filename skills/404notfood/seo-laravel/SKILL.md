---
name: seo-laravel
description: "Utiliser ce skill pour faire le SEO technique on-page d'un projet Laravel (Blade) : auditer ET implémenter correctement les balises title/meta, Open Graph, données structurées JSON-LD, canonical, hreflang, robots.txt et sitemap.xml. Déclencher quand l'utilisateur veut optimiser le SEO d'un site Laravel, ajouter des meta tags par page, générer un sitemap, corriger des problèmes d'indexation on-page, ou mettre en place des bonnes pratiques SEO dans des templates Blade. Travaille uniquement sur les fichiers locaux du projet, sans requête réseau ni crawl. Ne PAS déclencher pour la recherche de mots-clés, l'analyse de backlinks ou la vérification d'indexation Google (hors scope, nécessite le réseau)."
---

# SEO Laravel / Blade (on-page, local)

Skill pour **auditer et implémenter** le SEO technique on-page d'un projet Laravel. Travaille uniquement sur les fichiers du dépôt (templates Blade, contrôleurs, routes, `robots.txt`, `sitemap.xml`, config). **Aucune requête réseau, aucun crawl.**

Hors scope (nécessite le réseau, donc non couvert) : recherche de mots-clés, backlinks, audit d'indexation Google, mesure réelle de vitesse. Le mentionner si l'utilisateur le demande, sans le faire.

## Démarche

1. Repérer le layout Blade principal (`resources/views/layouts/*.blade.php`), les vues, les routes (`routes/web.php`) et les fichiers SEO racine.
2. Décider : **audit** (relever les manques, classés Bloquant/À corriger/Suggestion + fichier:ligne) ou **implémentation** (proposer/écrire le code Blade et serveur).
3. Ne jamais inventer une donnée : ce qui dépend du rendu runtime ou d'un package non présent est signalé comme hypothèse.

## 1. Balises de tête par page (pattern Blade)

Centraliser les meta dans le layout avec des sections surchargées par vue.

```blade
{{-- layouts/app.blade.php (dans <head>) --}}
<title>@yield('title', config('app.name'))</title>
<meta name="description" content="@yield('meta_description', 'Description par défaut du site.')">
<link rel="canonical" href="{{ url()->current() }}">

{{-- Open Graph --}}
<meta property="og:title" content="@yield('og_title', View::yieldContent('title'))">
<meta property="og:description" content="@yield('og_description', View::yieldContent('meta_description'))">
<meta property="og:image" content="@yield('og_image', asset('images/og-default.jpg'))">
<meta property="og:url" content="{{ url()->current() }}">
<meta property="og:type" content="website">
<meta name="twitter:card" content="summary_large_image">

@stack('head')
```

```blade
{{-- une vue : articles/show.blade.php --}}
@section('title', $article->title.' — '.config('app.name'))
@section('meta_description', Str::limit(strip_tags($article->excerpt), 155))
@section('og_image', $article->cover_url)
```

À vérifier : `<title>` unique ~50–60 car., description ~120–160 car., `<html lang="{{ app()->getLocale() }}">`, un seul `<h1>` par page, hiérarchie Hn cohérente.

## 2. Données structurées (JSON-LD)

Injecter via `@push('head')`. Types utiles : `Article`, `Product`, `BreadcrumbList`, `FAQPage`, `Organization`.

```blade
@push('head')
<script type="application/ld+json">
{!! json_encode([
    '@context' => 'https://schema.org',
    '@type'    => 'Article',
    'headline' => $article->title,
    'datePublished' => $article->created_at->toIso8601String(),
    'author'   => ['@type' => 'Person', 'name' => $article->author->name],
], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) !!}
</script>
@endpush
```

Vérifier : JSON valide, type cohérent avec la page, pas de données absentes hardcodées.

## 3. robots.txt & sitemap

- **`robots.txt`** (dossier `public/`) : ne pas bloquer le site par erreur (`Disallow: /`), référencer le sitemap :
  ```
  User-agent: *
  Allow: /
  Sitemap: https://exemple.com/sitemap.xml
  ```
- **Sitemap** : générer via une route plutôt qu'un fichier figé, pour rester à jour.
  ```php
  // routes/web.php
  Route::get('/sitemap.xml', function () {
      $urls = Article::published()->get(['slug', 'updated_at']);
      return response()
          ->view('sitemap', ['urls' => $urls])
          ->header('Content-Type', 'application/xml');
  });
  ```
  Cohérence : une page en `noindex` ne doit pas figurer au sitemap.
- Si le projet utilise un package SEO (ex. `spatie/laravel-sitemap`, `artesaos/seotools`), s'appuyer dessus plutôt que réinventer — vérifier sa présence dans `composer.json` avant de le supposer.

## 4. Internationalisation (hreflang)

Sur un site multilingue, déclarer les variantes dans le `<head>` :
```blade
@foreach(config('app.locales', []) as $loc)
  <link rel="alternate" hreflang="{{ $loc }}" href="{{ route(Route::currentRouteName(), ['locale' => $loc]) }}">
@endforeach
<link rel="alternate" hreflang="x-default" href="{{ url('/') }}">
```

## 5. Performance (impacte le SEO)

- Images : `loading="lazy"`, `width`/`height` explicites, `alt` descriptif ; servir du WebP/AVIF si possible.
- Éviter les requêtes N+1 dans les vues (déléguer au skill/subagent `laravel_reviewer` au besoin).
- Activer le cache de routes/config/vue en prod (`route:cache`, `config:cache`, `view:cache`).
- Pas de CSS/JS bloquant inutile dans le `<head>`.

## Format de sortie (mode audit)

```
## SEO Laravel — <projet ou page>

### Bloquant
- [resources/views/...:ligne] <problème> → <correctif>

### À corriger
- ...

### Suggestion
- ...

### OK
- <points déjà conformes>
```

En mode implémentation : proposer le code Blade/serveur, expliquer où le placer, et ne modifier les fichiers que si l'utilisateur le demande.
