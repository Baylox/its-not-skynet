# skills/

Skills Claude Code réutilisables (slash commands, agents spécialisés).

→ Retour au [CLAUDE.md](../CLAUDE.md)

## Structure

```
skills/
├── anthropics/        # Skills officiels Anthropic
└── contributeur/      # Skills personnels/communautaires
    └── nom-du-skill/
        ├── SKILL.md
        └── META.md
```

## Skills disponibles

### [anthropics/](anthropics/README.md)

| Skill | Description |
|-------|-------------|
| [algorithmic-art](anthropics/algorithmic-art/META.md) | Art génératif via p5.js |
| [brand-guidelines](anthropics/brand-guidelines/META.md) | Respect de charte graphique |
| [canvas-design](anthropics/canvas-design/META.md) | Design sur canvas |
| [claude-api](anthropics/claude-api/META.md) | Intégration API Claude |
| [doc-coauthoring](anthropics/doc-coauthoring/META.md) | Co-rédaction de documents |
| [docx](anthropics/docx/META.md) | Génération de fichiers Word |
| [frontend-design](anthropics/frontend-design/META.md) | Design frontend |
| [internal-comms](anthropics/internal-comms/META.md) | Communications internes |
| [mcp-builder](anthropics/mcp-builder/META.md) | Construction de serveurs MCP |
| [pdf](anthropics/pdf/META.md) | Génération de PDF |
| [pptx](anthropics/pptx/META.md) | Génération de présentations PowerPoint |
| [skill-creator](anthropics/skill-creator/META.md) | Création de skills |
| [slack-gif-creator](anthropics/slack-gif-creator/META.md) | Création de GIFs Slack |
| [theme-factory](anthropics/theme-factory/META.md) | Génération de thèmes |
| [webapp-testing](anthropics/webapp-testing/META.md) | Tests d'applications web |
| [web-artifacts-builder](anthropics/web-artifacts-builder/META.md) | Construction d'artefacts web |
| [xlsx](anthropics/xlsx/META.md) | Génération de fichiers Excel |

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
