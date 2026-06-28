# Meta — mcp-audit

## Source
- Auteur : Baylox
- Statut : **draft**
- Tags : sécurité, MCP, audit
- Dépendances : `jq` optionnel (lecture directe sinon)

## Contexte d'usage
Revue sécurité statique d'une configuration MCP (`.mcp.json`, bloc `mcpServers` d'un
`settings.json`, ou commande de lancement) avant de l'intégrer à un projet. Le skill
inspecte chaque serveur — transport (stdio vs distant), provenance du paquet, secrets dans
`env`, surface d'exécution, cohérence — puis classe les findings par sévérité avec un
correctif. Aligné sur la règle « zéro réseau non maîtrisé » du repo et l'esprit déterministe
de `scripts/audit-hooks.sh`. N'exécute ni n'installe rien : il relit et recommande.

## Installation
Copier le dossier du skill dans le projet cible :
```
.claude/skills/mcp-audit/SKILL.md
```

## Environnement testé
- Outil : Claude Code
- À tester en conditions réelles (sur un `.mcp.json` concret) avant passage en `beta`.
