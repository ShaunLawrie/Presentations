using Microsoft.EntityFrameworkCore;
using DotnetLibrary.Orders.Data;
using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Repositories;

public interface IOrderRepository
{
    Task<Order?> GetByIdAsync(int id);
    Task<IEnumerable<Order>> GetRecentOrdersAsync(DateTime since);
    Task SaveAsync(Order order);
}

public class SqlOrderRepository : IOrderRepository
{
    private readonly OrdersDbContext _context;

    public SqlOrderRepository(OrdersDbContext context)
    {
        _context = context;
    }

    public async Task<Order?> GetByIdAsync(int id)
    {
        return await _context.Orders.FindAsync(id);
    }

    public async Task<IEnumerable<Order>> GetRecentOrdersAsync(DateTime since)
    {
        return await _context.Orders
            .Where(o => o.CreatedAt >= since)
            .OrderByDescending(o => o.CreatedAt)
            .ToListAsync();
    }

    public async Task SaveAsync(Order order)
    {
        if (order.Id == 0)
        {
            _context.Orders.Add(order);
        }
        else
        {
            _context.Orders.Update(order);
        }
        
        await _context.SaveChangesAsync();
    }
}
