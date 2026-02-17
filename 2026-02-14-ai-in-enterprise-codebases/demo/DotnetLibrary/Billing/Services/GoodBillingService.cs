using DotnetLibrary.Billing.Models;
using DotnetLibrary.Billing.Repositories;
using DotnetLibrary.Shared;

namespace DotnetLibrary.Billing.Services;

/// <summary>
/// ✅ GOOD EXAMPLE: Respects domain boundaries
/// Uses dependency injection and doesn't reach across domains directly.
/// If we need order data, we'd use an application service or event/message.
/// </summary>
public class GoodBillingService
{
    private readonly IInvoiceRepository _invoiceRepository;
    private readonly IDateTimeProvider _dateTimeProvider;
    private readonly ILogger<GoodBillingService> _logger;

    public GoodBillingService(
        IInvoiceRepository invoiceRepository,
        IDateTimeProvider dateTimeProvider,
        ILogger<GoodBillingService> logger)
    {
        _invoiceRepository = invoiceRepository;
        _dateTimeProvider = dateTimeProvider;
        _logger = logger;
    }

    /// <summary>
    /// Creates an invoice based on order data passed in.
    /// The calling layer (application service) is responsible for fetching order data.
    /// </summary>
    public async Task<InvoiceResult> CreateInvoiceAsync(int orderId, decimal amount)
    {
        try
        {
            var invoice = new Invoice(
                Id: 0,
                OrderId: orderId,
                Amount: amount,
                IssuedDate: _dateTimeProvider.UtcNow,
                PaidDate: null,
                Status: InvoiceStatus.Draft
            );

            await _invoiceRepository.SaveAsync(invoice);
            
            _logger.LogInfo($"Created invoice for order {orderId}");
            
            return new InvoiceResult { Success = true, Invoice = invoice };
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Failed to create invoice for order {OrderId}", orderId);
            throw;
        }
    }

    public async Task<IEnumerable<Invoice>> GetOverdueInvoicesAsync()
    {
        try
        {
            return await _invoiceRepository.GetOverdueInvoicesAsync();
        }
        catch (TimeoutException ex)
        {
            _logger.LogError(ex, "Database timeout while fetching overdue invoices");
            throw;
        }
    }
}
