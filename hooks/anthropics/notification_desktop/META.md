# Meta — notification_desktop

## Source
- Auteur : Anthropic (officiel)
- Statut : **stable**
- Référence : https://docs.anthropic.com/fr/docs/claude-code/hooks

## Contexte d'usage
Envoie une notification desktop quand Claude Code a besoin d'attention (en attente d'input, tâche longue terminée, etc.).
Détecte automatiquement l'OS : macOS (`osascript`), Linux (`notify-send`), Windows (`powershell.exe`).

## Événement
- `Notification` — pas de matcher

## Configuration settings.json
```json
{
  "hooks": {
    "Notification": [
      {
        "matcher": "",
        "hooks": [{ "type": "command", "command": "bash /chemin/vers/notification_desktop.sh" }]
      }
    ]
  }
}
```

## Prérequis
- macOS : `osascript` (natif)
- Linux : `notify-send` (`libnotify`)
- Windows : `powershell.exe` (natif)

## Environnement testé
- Outil : Claude Code
