---
name: mcp-audit
description: >
  Audite la sécurité d'une configuration MCP (`.mcp.json`, `mcpServers` dans
  `settings.json`, ou bloc équivalent) avant de l'ajouter à un projet. Inspecte chaque
  serveur : commande de lancement, arguments, transport (stdio vs URL distante), variables
  d'environnement / secrets, et provenance du paquet. Classe les findings par sévérité et
  pointe la cause + le correctif, dans l'esprit déterministe de `scripts/audit-hooks.sh` et
  de la règle « zéro réseau non maîtrisé » du repo. Le skill relit, il ne modifie pas.
  À UTILISER quand l'utilisateur veut vérifier/auditer un `.mcp.json`, ajouter un serveur
  MCP en confiance, ou demande « ce serveur MCP est-il sûr ? ».
  NE PAS UTILISER pour développer un serveur MCP (→ skill mcp-builder).
---

# mcp-audit — revue sécurité d'une config MCP

Audit statique et déterministe d'une configuration MCP. Objectif : décider si un serveur
peut entrer dans un projet sans introduire de réseau non maîtrisé, d'exécution distante
opaque ou de fuite de secrets. **Aucune exécution du serveur**, aucune installation : on lit
la config et la provenance.

## Entrée
Un `.mcp.json`, un bloc `mcpServers` dans `settings.json`, ou la commande de lancement d'un
serveur. Demander le fichier si absent.

## Points de contrôle (par serveur)

### 1. Transport et réseau — sévérité haute
- **`stdio` local** (`command` + `args`) : à privilégier, périmètre maîtrisé.
- **`url` / serveur distant** (SSE, HTTP) : signaler. Le runtime dépend d'un réseau non
  maîtrisé → contraire à la doctrine du repo. Exiger une justification et un domaine connu.
- `command` qui lance un fetch réseau au démarrage (`npx <paquet-distant>` non épinglé,
  `uvx`, `curl … | sh`) : **rouge**. Le code exécuté n'est pas auditable avant exécution.

### 2. Provenance du paquet — sévérité haute
- `npx -y <paquet>` / `uvx <paquet>` **sans version épinglée** : récupère le dernier
  publié → supply-chain non maîtrisée. Recommander une version exacte et un paquet audité,
  ou un chemin local.
- Binaire/chemin local (`node ./server.js`, `./bin/server`) : vérifier qu'il est dans le
  repo et lisible. Préférable.
- Éditeur inconnu / typosquatting possible : signaler le nom exact à vérifier.

### 3. Secrets et variables d'environnement — sévérité haute
- Clé API / token **en clair** dans `env` : **rouge**. Doit passer par une variable
  d'environnement de l'hôte, jamais committée.
- `.mcp.json` committé contenant des secrets : rappeler de le retirer de l'index et de
  faire tourner le secret (rotation).

### 4. Surface d'exécution — sévérité moyenne
- `args` passant des chemins larges (`/`, `$HOME`, racine projet) à un serveur filesystem :
  périmètre trop large → restreindre au dossier nécessaire.
- Serveur avec accès shell / exécution arbitraire (`run`, `exec`, eval) : signaler la
  capacité et qui peut la déclencher.
- Flags désactivant des protections (`--no-sandbox`, `--dangerously-*`, TLS off) : **rouge**.

### 5. Cohérence config — sévérité basse
- JSON valide, pas de serveur dupliqué, noms explicites.
- Champs inconnus / typos (`comand`, `agrs`) qui casseraient le chargement.

## Méthode
1. Parser la config (`jq` si dispo, sinon lecture directe). Lister les serveurs.
2. Pour chaque serveur, dérouler les 5 points de contrôle.
3. Produire un tableau **Sévérité | Serveur | Constat | Correctif**.
4. Conclure : **OK / OK sous conditions / à ne pas intégrer**, avec le raisonnement.

## Sortie attendue
- Verdict global aligné sur la doctrine du repo (zéro réseau non maîtrisé, deps auditées).
- Findings classés `haute` / `moyenne` / `basse`, chacun avec un correctif concret.
- Le skill **ne modifie pas** la config : il relit et recommande.
