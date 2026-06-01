#!/bin/bash
# Réinjecte des rappels de contexte après une compaction de conversation.
# Événement : SessionStart — matcher: "compact"
# Source : https://docs.anthropic.com/fr/docs/claude-code/hooks
# Personnaliser le message ci-dessous selon le projet.

echo "Rappels projet : utiliser Bun (pas npm). Lancer les tests avant commit. Vérifier le sprint en cours."
