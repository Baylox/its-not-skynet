# PHP

## Pattern

```php
<?php

interface IOrderService
{
    public function createOrder(CreateOrderRequest $request): Order;
    public function findById(string $id): ?Order;
}

class OrderService implements IOrderService
{
    public function createOrder(CreateOrderRequest $request): Order { /* ... */ }
    public function findById(string $id): ?Order { /* ... */ }
}
```

## Pourquoi `IOrderService` plutôt que `OrderServiceInterface`

La convention PSR / Symfony / Laravel est le suffixe `Interface` (`OrderServiceInterface`).
Ce skill impose le préfixe `I` pour la cohérence cross-langage. Si le projet suit
strictement les standards PSR ou utilise des packages tiers avec le suffixe `Interface`,
il peut être pertinent de s'aligner sur la convention locale.

## Laravel DI

```php
// AppServiceProvider.php
public function register(): void
{
    $this->app->bind(IOrderService::class, OrderService::class);
}

// Consumer
class OrderController extends Controller
{
    public function __construct(
        private readonly IOrderService $orderService
    ) {}
}
```

## Symfony DI

```yaml
# services.yaml
services:
    App\Domain\Order\IOrderService:
        alias: App\Infrastructure\OrderService
```

Symfony auto-wire les interfaces vers leur implémentation par défaut quand il n'y a qu'une
seule classe qui les implémente. L'alias explicite n'est nécessaire qu'en cas d'ambiguïté.
