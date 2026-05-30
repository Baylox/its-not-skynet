# Meta — pre_tool_use_block_secrets

## Source
- Auteur : 404notfood
- Repo : https://github.com/Baylox/its-not-skynet
- Statut : **Créé par moi**

## Contexte d'usage
Empêche deux erreurs classiques de sécurité avant qu'elles n'arrivent au dépôt :
1. **Écriture de secrets en dur** (Edit/Write) : scanne le contenu inséré pour des patterns de clés/tokens connus (AWS, OpenAI, Anthropic, GitHub, Slack, clés privées PEM, paires `password=...`/`api_key=...`).
2. **Commit d'un `.env`** (Bash) : bloque `git add` / `git commit` portant sur un fichier `.env` ou variante.

Déterministe, pur shell, **aucun accès réseau**. Volontairement conservateur sur les patterns pour limiter les faux positifs.

## Événement
- `PreToolUse` — matcher : `Edit|Write|Bash`
- Exit 2 = blocage avec message dans stderr

## Installation

### Ajouter dans settings.json :
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Edit|Write|Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/hooks/404notfood/pre_tool_use_block_secrets/pre_tool_use_block_secrets.sh\""
          }
        ]
      }
    ]
  }
}
```

`$CLAUDE_PROJECT_DIR` est exposée nativement par Claude Code — aucun `.env` requis.

## Prérequis
- `jq` disponible dans le PATH

## Environnement testé
- Outil : Claude Code
- Shell : Git Bash (Windows / Laragon) et bash Linux
