using Microsoft.EntityFrameworkCore;
using DotnetLibrary.Billing.Data;
using DotnetLibrary.Billing.Models;

namespace DotnetLibrary.Billing.Repositories;

public interface IInvoiceRepository
{
    Task<Invoice?> GetByIdAsync(int id);
    Task<Invoice?> GetByOrderIdAsync(int orderId);
    Task<IEnumerable<Invoice>> GetOverdueInvoicesAsync();
    Task SaveAsync(Invoice invoice);
}

public class SqlInvoiceRepository : IInvoiceRepository
{
    private readonly BillingDbContext _context;

    public SqlInvoiceRepository(BillingDbContext context)
    {
        _context = context;
    }

    public async Task<Invoice?> GetByIdAsync(int id)
    {
        return await _context.Invoices.FindAsync(id);
    }

    public async Task<Invoice?> GetByOrderIdAsync(int orderId)
    {
        return await _context.Invoices
            .FirstOrDefaultAsync(i => i.OrderId == orderId);
    }

    public async Task<IEnumerable<Invoice>> GetOverdueInvoicesAsync()
    {
        return await _context.Invoices
            .Where(i => i.Status == InvoiceStatus.Overdue)
            .ToListAsync();
    }

    public async Task SaveAsync(Invoice invoice)
    {
        if (invoice.Id == 0)
        {
            _context.Invoices.Add(invoice);
        }
        else
        {
            _context.Invoices.Update(invoice);
        }
        
        await _context.SaveChangesAsync();
    }
}
