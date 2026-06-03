# Java

## Pattern

```java
public interface IOrderService {
    Order createOrder(CreateOrderRequest request);
    Optional<Order> findById(OrderId id);
}

public class OrderService implements IOrderService {
    @Override
    public Order createOrder(CreateOrderRequest request) { /* ... */ }

    @Override
    public Optional<Order> findById(OrderId id) { /* ... */ }
}
```

## Placement

- Interface dans le même package que l'implémentation par défaut.
- Si l'interface est consommée à travers plusieurs modules, la placer dans un package
  dédié `api` ou `spi` pour expliciter la frontière.

## Spring Boot DI

```java
@Service
public class OrderService implements IOrderService { /* ... */ }

@RestController
public class OrderController {
    private final IOrderService orderService;  // injecter via l'interface

    public OrderController(IOrderService orderService) {
        this.orderService = orderService;
    }
}
```

## Pourquoi `IOrderService` plutôt que `OrderService` (interface) + `OrderServiceImpl`

La convention communautaire Java est `OrderService` (interface) + `OrderServiceImpl` (impl).
Ce skill impose le préfixe `I` pour la **cohérence cross-langage** dans les codebases
polyglottes. À adapter si le projet a une convention différente déjà établie.
