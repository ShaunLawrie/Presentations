using Microsoft.EntityFrameworkCore;
using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Data;

/// <summary>
/// Hypothetical extended context with navigation properties for demonstration purposes.
/// </summary>
public class ExtendedOrdersDbContext : OrdersDbContext
{
    public ExtendedOrdersDbContext(DbContextOptions<OrdersDbContext> options) : base(options) { }
    
    public DbSet<OrderWithRelations> OrdersWithRelations => Set<OrderWithRelations>();
}
