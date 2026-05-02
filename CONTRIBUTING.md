# Contribuer à its-not-skynet

its-not-skynet ne fonctionne que si tout le monde apporte quelque chose.
Tu n'as pas besoin d'être expert — une config qui t'a fait gagner du temps,
un prompt qui marche vraiment, ça suffit.

## Devenir contributeur

Tout le monde peut soumettre une PR. Il n'y a pas de whitelist formelle —
la crédibilité repose sur la transparence de la déclaration.

## Déclaration obligatoire

Chaque ressource soumise doit préciser l'une des deux :

- **Créé par moi** : tu es l'auteur original de la ressource
- **Validé par moi** : tu l'as testée en conditions réelles et tu en assumes la pertinence

Les deux sont acceptés. L'absence de déclaration est un motif de rejet.

## Format attendu pour une PR

**Description de la ressource**
- Que fait-elle concrètement ?
- Dans quel workflow s'intègre-t-elle ?

**Contexte d'usage**
- Quel problème résout-elle ?
- Quelles alternatives as-tu considérées ?

**Environnement de test**
- OS, shell, version de l'outil concerné (best effort)

## Ce qui sera refusé

- Ressources copiées sans test personnel
- Scripts avec effets de bord non documentés
- Tout ce qui nécessite un accès réseau non maîtrisé à l'exécution
- Dépendances non auditées
