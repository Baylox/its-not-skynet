# Contribuer à its-not-skynet

its-not-skynet ne fonctionne que si chacun apporte quelque chose.
Nul besoin d'être expert — une config qui fait gagner du temps,
un prompt qui fonctionne vraiment, c'est suffisant.

## Devenir contributeur

Toute personne peut soumettre une PR. Il n'y a pas de whitelist formelle —
la crédibilité repose sur la transparence de la déclaration.

## Statut obligatoire

Chaque ressource soumise doit déclarer l'un des trois statuts :

- **stable** : testé en conditions réelles, en usage régulier
- **beta** : testé, mais usage limité ou edge cases non couverts
- **draft** : généré ou écrit, pas encore testé en conditions réelles

L'absence de statut est un motif de rejet. Toute ressource soumise via PR commence au minimum en **beta**.

## Où placer votre ressource

| Type | Dossier | Détails |
|------|---------|---------|
| Hook | `hooks/<votre-pseudo>/nom_du_hook/` | → [hooks/README.md](hooks/README.md) |
| Skill | `skills/<votre-pseudo>/nom-du-skill/` | → [skills/README.md](skills/README.md) |
| Config | `configs/<votre-pseudo>/nom-de-la-config/` | → [configs/README.md](configs/README.md) |
| Subagent | `subagents/<votre-pseudo>/nom_du_subagent/` | → [subagents/README.md](subagents/README.md) |

## Template META.md

Chaque ressource doit inclure un `META.md`. Copiez-collez ce template et supprimez les sections inutiles :

```markdown
# Meta — nom-de-la-ressource

## Source
- Auteur : Votre nom / alias
- Repo : https://... (si applicable)
- Statut : **stable** / **beta** / **draft**

## Contexte d'usage
Ce que fait la ressource concrètement, dans quel workflow elle s'intègre.

## Installation

### Pour un hook — Ajouter dans settings.json :
\`\`\`json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/hook.sh" }]
      }
    ]
  }
}
\`\`\`

### Pour un skill — Copier dans le projet cible :
\`\`\`
.claude/skills/nom-du-skill.md
\`\`\`

### Pour une config — Copier vers :
\`\`\`
~/.claude/settings.json  # ou le chemin indiqué
\`\`\`

## Environnement testé
- Outil : Claude Code (ou autre)
```

## Ce qui sera refusé

- Ressources copiées sans test personnel
- Scripts avec effets de bord non documentés
- Tout ce qui nécessite un accès réseau non maîtrisé à l'exécution
- Dépendances non auditées
- META.md absent ou incomplet
