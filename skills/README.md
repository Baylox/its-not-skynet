# skills/

Skills Claude Code réutilisables (slash commands, agents spécialisés).

→ Retour au [CLAUDE.md](../CLAUDE.md)

## Structure

```
skills/
├── anthropics/        # Skills officiels Anthropic
└── <pseudo>/          # Skills personnels/communautaires
    └── nom-du-skill/
        ├── SKILL.md
        └── META.md
```

## Skills disponibles

### anthropics/

> **Licence :** ces skills sont l'œuvre d'Anthropic, **non couverts par la licence MIT** du repo. Ils restent régis par leurs propres termes (`LICENSE.txt` Apache-2.0 dans chaque dossier). Voir la section *Third-party content* du [LICENSE](../LICENSE).

| Skill | Description |
|-------|-------------|
| [algorithmic-art](anthropics/algorithmic-art/META.md) | Art génératif via p5.js |
| [brand-guidelines](anthropics/brand-guidelines/META.md) | Respect de charte graphique |
| [canvas-design](anthropics/canvas-design/META.md) | Design sur canvas |
| [claude-api](anthropics/claude-api/META.md) | Intégration API Claude |
| [frontend-design](anthropics/frontend-design/META.md) | Design frontend |
| [internal-comms](anthropics/internal-comms/META.md) | Communications internes |
| [mcp-builder](anthropics/mcp-builder/META.md) | Construction de serveurs MCP |
| [skill-creator](anthropics/skill-creator/META.md) | Création de skills |
| [slack-gif-creator](anthropics/slack-gif-creator/META.md) | Création de GIFs Slack |
| [theme-factory](anthropics/theme-factory/META.md) | Génération de thèmes |
| [webapp-testing](anthropics/webapp-testing/META.md) | Tests d'applications web |
| [web-artifacts-builder](anthropics/web-artifacts-builder/META.md) | Construction d'artefacts web |

### IGSparkew/

| Skill | Description |
|-------|-------------|
| [interface-architecture](IGSparkew/interface-architecture/META.md) | Inversion de dépendance OOP : interfaces/traits systématiques (Java, TS, C#, PHP, Rust) |

### 404notfood/

| Skill | Description |
|-------|-------------|
| [laravel-php-review](404notfood/laravel-php-review/META.md) | Revue de code PHP/Laravel (sécurité, perfs N+1, conventions) |
| [seo-laravel](404notfood/seo-laravel/META.md) | SEO on-page Laravel/Blade : audit + implémentation (zéro réseau) |

## Comment utiliser un skill

Copier le `SKILL.md` dans le projet cible :

```
.claude/skills/nom-du-skill.md
```
