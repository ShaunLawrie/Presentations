using Microsoft.EntityFrameworkCore;
using DotnetLibrary.Orders.Data;
using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Repositories;

/// <summary>
/// ⚠️ BAD EXAMPLE: Query with excessive joins ⚠️
/// This demonstrates poor EF Core query design that the analyzer will catch.
/// 
/// Note: This uses a hypothetical extended DbContext to demonstrate the pattern.
/// In reality, the Order entity would have these navigation properties defined.
/// 
/// The model classes used here are now properly organized in the Models namespace.
/// </summary>
public class BadOrderRepositoryWithJoins
{
    private readonly ExtendedOrdersDbContext _context;

    public BadOrderRepositoryWithJoins(ExtendedOrdersDbContext context)
    {
        _context = context;
    }

    /// <summary>
    /// ENT005: This query has way too many includes, causing performance issues.
    /// Each Include adds a JOIN to the SQL query.
    /// </summary>
    public async Task<OrderWithRelations?> GetOrderWithEverything(int id)
    {
        // ENT005: Excessive joins - 5 includes!
        // This will generate a massive SQL query with multiple JOINs
        return await _context.OrdersWithRelations
            .Include(o => o.Customer)
            .Include(o => o.ShippingAddress)
            .Include(o => o.BillingAddress)
            .Include(o => o.PaymentMethod)
            .Include(o => o.OrderItems)
            .FirstOrDefaultAsync(o => o.Id == id);
    }

    /// <summary>
    /// ENT005: Nested ThenInclude calls also count.
    /// </summary>
    public async Task<IEnumerable<OrderWithRelations>> GetOrdersWithDeepIncludes()
    {
        // ENT005: Even with ThenInclude, this is still too many joins
        return await _context.OrdersWithRelations
            .Include(o => o.Customer)
                .ThenInclude(c => c.Address)
            .Include(o => o.OrderItems)
                .ThenInclude(oi => oi.Product)
                    .ThenInclude(p => p.Category)
            .Include(o => o.ShippingAddress)
            .ToListAsync();
    }
}

/// <summary>
/// ✅ GOOD EXAMPLE: Refactored to avoid excessive joins
/// </summary>
public class GoodOrderRepositoryOptimized
{
    private readonly OrdersDbContext _context;

    public GoodOrderRepositoryOptimized(OrdersDbContext context)
    {
        _context = context;
    }

    /// <summary>
    /// Uses projection to only select the data we need.
    /// No excessive joins, better performance.
    /// </summary>
    public async Task<OrderSummary?> GetOrderSummary(int id)
    {
        try
        {
            return await _context.Orders
                .Where(o => o.Id == id)
                .Select(o => new OrderSummary
                {
                    OrderId = o.Id,
                    CustomerName = o.CustomerName,
                    Total = o.Total,
                    Status = o.Status,
                    CreatedAt = o.CreatedAt
                })
                .FirstOrDefaultAsync();
        }
        catch (InvalidOperationException ex)
        {
            // Log the exception and rethrow or handle as appropriate
            // This is just an example, in a real application you'd have proper logging and error handling
            Console.WriteLine($"Error fetching order summary: {ex.Message}");
            throw;
        }
        catch (DbUpdateException ex)
        {
            // Log the exception and rethrow or handle as appropriate
            // This is just an example, in a real application you'd have proper logging and error handling
            Console.WriteLine($"Error fetching order summary: {ex.Message}");
            throw;
        }
    }

    /// <summary>
    /// If you need related data, load it in separate queries.
    /// This gives you more control and better performance.
    /// </summary>
    public async Task<Order?> GetOrderById(int id)
    {
        // Simple query, no joins - let the application layer orchestrate
        return await _context.Orders.FindAsync(id);
    }
}
