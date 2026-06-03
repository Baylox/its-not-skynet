# C\#

## Pattern

```csharp
public interface IOrderService
{
    Order CreateOrder(CreateOrderRequest request);
    Order? FindById(Guid id);
}

public class OrderService : IOrderService
{
    public Order CreateOrder(CreateOrderRequest request) { /* ... */ }
    public Order? FindById(Guid id) { /* ... */ }
}
```

Le préfixe `I` correspond ici à la convention .NET officielle, donc aucune adaptation
nécessaire par rapport à l'écosystème.

## Placement

- Interface aux côtés de l'implémentation pour les services internes.
- Dans un projet ou namespace `Contracts` / `Abstractions` quand l'interface est
  consommée à travers plusieurs assemblies.

## .NET DI Container

```csharp
// Program.cs
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddSingleton<IConfigService, ConfigService>();
builder.Services.AddTransient<IEmailSender, EmailSender>();

// Consumer
public class OrderController : ControllerBase
{
    private readonly IOrderService _orderService;

    public OrderController(IOrderService orderService)
    {
        _orderService = orderService;
    }
}
```

Choisir le bon scope : `Scoped` (par requête HTTP) pour les services applicatifs,
`Singleton` pour la configuration et les caches, `Transient` pour les services sans état.
