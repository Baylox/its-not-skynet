# subagents/

Définitions de subagents spécialisés pour Claude Code.

## Où les copier

Dans le projet cible :

```
.claude/agents/<nom_du_subagent>.md
```

## Convention

Fichiers en `snake_case`, préfixés par domaine — ex: `symfony_reviewer.md`, `git_commit_writer.md`.

## Structure

```
subagents/
└── <contributeur>/
    └── nom_du_subagent/
        ├── nom_du_subagent.md   # définition (frontmatter + system prompt)
        └── META.md
```

## Subagents disponibles

### 404notfood/

| Subagent | Description |
|----------|-------------|
| [laravel_reviewer](404notfood/laravel_reviewer/META.md) | Revue de code PHP/Laravel (L12/L13) : sécurité, perfs N+1, conventions |
