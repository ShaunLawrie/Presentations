using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using DotnetLibrary.Billing.Data;
using DotnetLibrary.Billing.Repositories;
using DotnetLibrary.Billing.Services;
using DotnetLibrary.Orders.Data;
using DotnetLibrary.Orders.Repositories;
using DotnetLibrary.Orders.Services;
using DotnetLibrary.Shared;

namespace DotnetLibrary;

public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Adds the DotnetLibrary services with SQLite backing.
    /// </summary>
    /// <param name="services">The service collection</param>
    /// <param name="sqliteDbPath">Path to the SQLite database file</param>
    public static IServiceCollection AddDotnetLibrary(
        this IServiceCollection services, 
        string sqliteDbPath)
    {
        // Shared services
        services.AddSingleton<IDateTimeProvider, SystemDateTimeProvider>();
        services.AddSingleton(typeof(ILogger<>), typeof(ConsoleLogger<>));

        // Orders domain - separate SQLite file for domain isolation
        var ordersConnectionString = $"Data Source={sqliteDbPath}_orders.db";
        services.AddDbContext<OrdersDbContext>(options =>
            options.UseSqlite(ordersConnectionString));
        
        services.AddScoped<IOrderRepository, SqlOrderRepository>();
        services.AddScoped<OrderService>();

        // Billing domain - separate SQLite file for domain isolation
        var billingConnectionString = $"Data Source={sqliteDbPath}_billing.db";
        services.AddDbContext<BillingDbContext>(options =>
            options.UseSqlite(billingConnectionString));
        
        services.AddScoped<IInvoiceRepository, SqlInvoiceRepository>();
        services.AddScoped<GoodBillingService>();

        return services;
    }

    /// <summary>
    /// Adds the DotnetLibrary services with a real database connection.
    /// </summary>
    /// <param name="services">The service collection</param>
    /// <param name="connectionString">Connection string for the database</param>
    public static IServiceCollection AddRealDatabase(
        this IServiceCollection services,
        string connectionString)
    {
        throw new NotImplementedException("Real database configuration not yet implemented");
    }

    /// <summary>
    /// Initializes the databases and seeds sample data.
    /// </summary>
    public static async Task InitializeDotnetLibraryAsync(this IServiceProvider services)
    {
        using var scope = services.CreateScope();
        
        // Initialize Orders database
        var ordersContext = scope.ServiceProvider.GetRequiredService<OrdersDbContext>();
        await ordersContext.Database.EnsureCreatedAsync();
        
        if (!await ordersContext.Orders.AnyAsync())
        {
            await SeedOrdersAsync(ordersContext);
        }

        // Initialize Billing database
        var billingContext = scope.ServiceProvider.GetRequiredService<BillingDbContext>();
        await billingContext.Database.EnsureCreatedAsync();
        
        if (!await billingContext.Invoices.AnyAsync())
        {
            await SeedInvoicesAsync(billingContext);
        }
    }

    private static async Task SeedOrdersAsync(OrdersDbContext context)
    {
        var now = DateTime.UtcNow;
        var orders = new[]
        {
            new Orders.Models.Order(0, "Acme Corp", now.AddHours(-2), 1250.00m, Orders.Models.OrderStatus.Confirmed),
            new Orders.Models.Order(0, "TechStart Inc", now.AddHours(-1), 3400.50m, Orders.Models.OrderStatus.Shipped),
            new Orders.Models.Order(0, "Global Industries", now.AddMinutes(-30), 890.25m, Orders.Models.OrderStatus.Pending),
            new Orders.Models.Order(0, "Innovation Labs", now.AddHours(-5), 2100.00m, Orders.Models.OrderStatus.Delivered),
            new Orders.Models.Order(0, "Digital Solutions", now.AddMinutes(-15), 567.80m, Orders.Models.OrderStatus.Confirmed),
        };

        context.Orders.AddRange(orders);
        await context.SaveChangesAsync();
    }

    private static async Task SeedInvoicesAsync(BillingDbContext context)
    {
        var now = DateTime.UtcNow;
        var invoices = new[]
        {
            new Billing.Models.Invoice(0, 1, 1250.00m, now.AddHours(-2), null, Billing.Models.InvoiceStatus.Issued),
            new Billing.Models.Invoice(0, 2, 3400.50m, now.AddHours(-1), now, Billing.Models.InvoiceStatus.Paid),
            new Billing.Models.Invoice(0, 4, 2100.00m, now.AddHours(-5), now.AddHours(-3), Billing.Models.InvoiceStatus.Paid),
        };

        context.Invoices.AddRange(invoices);
        await context.SaveChangesAsync();
    }
}

/// <summary>
/// Simple console logger implementation for demo purposes.
/// </summary>
internal class ConsoleLogger<T> : ILogger<T>
{
    public void LogInfo(string message)
    {
        Console.WriteLine($"[INFO] [{typeof(T).Name}] {message}");
    }

    public void LogWarning(Exception ex, string message, params object[] args)
    {
        Console.WriteLine($"[WARN] [{typeof(T).Name}] {string.Format(message, args)}: {ex.Message}");
    }

    public void LogError(Exception ex, string message, params object[] args)
    {
        Console.WriteLine($"[ERROR] [{typeof(T).Name}] {string.Format(message, args)}: {ex.Message}");
    }
}
