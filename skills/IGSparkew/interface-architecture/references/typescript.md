# TypeScript

## Pattern

```typescript
export interface IOrderService {
  createOrder(request: CreateOrderRequest): Promise<Order>;
  findById(id: string): Promise<Order | null>;
}

export class OrderService implements IOrderService {
  async createOrder(request: CreateOrderRequest): Promise<Order> { /* ... */ }
  async findById(id: string): Promise<Order | null> { /* ... */ }
}
```

## Exporter les deux

Toujours exporter à la fois l'interface et la classe. Les consommateurs doivent typer
leurs dépendances avec l'interface, pas la classe concrète.

```typescript
// Bon
constructor(private readonly orderService: IOrderService) {}

// À éviter
constructor(private readonly orderService: OrderService) {}
```

## NestJS DI

```typescript
@Injectable()
export class OrderService implements IOrderService { /* ... */ }

// Module
{
  providers: [
    { provide: 'IOrderService', useClass: OrderService },
  ],
  exports: ['IOrderService'],
}

// Consumer
constructor(@Inject('IOrderService') private readonly orderService: IOrderService) {}
```

## tsyringe / InversifyJS

Utiliser un token (string ou symbol) pour binder l'interface à l'implémentation, puisque
les interfaces TypeScript n'existent pas au runtime.
