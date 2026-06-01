# Rust

## Pattern : trait au lieu d'interface

En Rust, l'équivalent d'une interface est un **trait**. Les traits ne portent pas de
préfixe `I` par convention idiomatique : on garde le nom du concept directement.

```rust
pub trait OrderService {
    fn create_order(&self, request: CreateOrderRequest) -> Result<Order, OrderError>;
    fn find_by_id(&self, id: &OrderId) -> Result<Option<Order>, OrderError>;
}

pub struct OrderServiceImpl {
    repo: Box<dyn OrderRepository>,
}

impl OrderService for OrderServiceImpl {
    fn create_order(&self, request: CreateOrderRequest) -> Result<Order, OrderError> {
        /* ... */
    }

    fn find_by_id(&self, id: &OrderId) -> Result<Option<Order>, OrderError> {
        /* ... */
    }
}
```

## Choix : `dyn Trait` ou génériques

**Génériques (`impl Trait` / `<T: Trait>`)** : dispatch statique, zéro coût runtime,
monomorphisation. À privilégier par défaut.

```rust
pub struct OrderController<S: OrderService> {
    service: S,
}
```

**Trait objects (`Box<dyn Trait>` ou `&dyn Trait`)** : dispatch dynamique via vtable.
À utiliser quand on a besoin d'une collection hétérogène ou que le type concret n'est
pas connu à la compilation.

```rust
pub struct OrderController {
    service: Box<dyn OrderService>,
}
```

## Placement

Convention courante : placer les traits dans un module `domain::ports` (pattern hexagonal)
ou `traits.rs` à côté des structs qui les implémentent.

## Object safety

Pour utiliser `dyn Trait`, le trait doit être **object-safe** : pas de méthodes
génériques, pas de retour `Self`, etc. Si ces contraintes sont bloquantes, utiliser
les génériques.
