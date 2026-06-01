---
name: interface-architecture
description: >
  Applique le principe d'inversion de dépendance lors de la génération de code orienté objet
  en Java, TypeScript, C#, PHP ou Rust. Toute classe importante (publique, exportée, ou
  représentant un concept métier) doit être adossée à une abstraction : interface pour
  Java/TypeScript/C#/PHP, trait pour Rust. Convention de nommage : préfixer le nom de la
  classe par `I` (ex. `ProductService` → `IProductService`). À UTILISER quand l'utilisateur
  demande de créer ou scaffolder du code contenant des classes ou structs dans ces langages,
  notamment des services, repositories, controllers, handlers, factories, ou domain models.
  NE PAS UTILISER pour : fonctions utilitaires simples, scripts one-shot, snippets de
  démonstration, DTOs/value objects sans comportement, ou langages autres que ceux listés.
---
``
# Interface-Driven Architecture

Toute classe importante doit dépendre d'une abstraction, pas d'une concrétion. C'est le
**D** de SOLID. Une interface (ou trait en Rust) permet de tester, mocker et substituer
les implémentations sans toucher aux consommateurs.

## Quand créer une abstraction

Créer une interface/trait si **au moins un** critère est rempli :

- La classe est `public` (Java/C#), `export` (TS), `pub` (Rust) ou non-`abstract` (PHP)
- Elle représente un concept métier : service, repository, handler, controller, factory,
  use case, strategy, gateway
- Elle est destinée à être injectée comme dépendance

**Ignorer** pour : DTOs, value objects, records de configuration, helpers privés,
exceptions, classes de test (mocks/fakes/stubs).

En cas de doute, créer l'interface. C'est trivial à ajouter au début, coûteux à rétro-fitter.

## Convention de nommage

**Préfixer le nom de la classe par `I`** pour obtenir le nom de l'interface.

| Classe              | Interface              |
|---------------------|------------------------|
| `ProductService`    | `IProductService`      |
| `OrderRepository`   | `IOrderRepository`     |
| `PaymentHandler`    | `IPaymentHandler`      |
| `UserFactory`       | `IUserFactory`         |

Cette convention s'applique à **tous les langages supportés**, y compris Java, TypeScript
et PHP où elle s'écarte des conventions communautaires habituelles. Le préfixe `I` est
choisi pour la cohérence cross-langage. En Rust, on utilise un trait au nom non préfixé
(les traits ne portent pas de préfixe par convention idiomatique).

## Workflow de génération

1. **Définir l'abstraction d'abord**, l'implémentation ensuite. Cela force à concevoir
   le contrat avant les détails.
2. Après génération, **scanner chaque classe créée**. Pour chaque classe répondant aux
   critères, vérifier qu'elle implémente une interface/trait.
3. Si une classe importante n'a pas d'abstraction, **signaler en fin de réponse** :

```
⚠️ Architecture review:
- `MyClass` est un service public sans interface.
  → Suggéré : `IMyClass` avec les méthodes : doX(), doY()
```

Le but est de fournir un signal actionnable, pas de bloquer ou de réécrire.

## Exemples par langage

Pour les patterns concrets et la registration DI de chaque langage, consulter le fichier
de référence approprié :

- Java : `references/java.md`
- TypeScript : `references/typescript.md`
- C# : `references/csharp.md`
- PHP : `references/php.md`
- Rust : `references/rust.md`

## Cas particulier

Si l'utilisateur demande explicitement de ne pas créer d'interface pour une classe
spécifique, respecter cette demande sans signaler. Ce skill est un guardrail, pas un
blocant : l'objectif est de faire de l'architecture orientée interfaces le **comportement
par défaut**, pas une obligation absolue.
