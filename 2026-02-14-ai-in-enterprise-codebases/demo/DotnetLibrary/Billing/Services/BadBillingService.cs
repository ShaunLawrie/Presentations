using DotnetLibrary.Billing.Repositories;
using DotnetLibrary.Orders.Repositories;
using DotnetLibrary.Shared;

namespace DotnetLibrary.Billing.Services;

/// <summary>
/// ⚠️ BAD EXAMPLE: Violates domain boundaries ⚠️
/// This service is in the Billing domain but directly instantiates
/// a repository from the Orders domain.
/// </summary>
public class BadBillingService
{
    private readonly IInvoiceRepository _invoiceRepository;
    private readonly IOrderRepository _orderRepository; // Cross-domain dependency

    public BadBillingService(
        IInvoiceRepository invoiceRepository,
        IOrderRepository orderRepository, // Cross-domain dependency
        IDateTimeProvider dateTimeProvider,
        ILogger<GoodBillingService> logger)
    {
        _invoiceRepository = invoiceRepository;
        _orderRepository = orderRepository; // Cross-domain dependency
    }

    public async Task<object> CreateInvoiceForOrder(int orderId)
    {
        // Cross-domain access - bad architectural practice
        var order = await _orderRepository.GetByIdAsync(orderId);
        
        if (order == null)
            return new { Error = "Order not found" };

        // ENT001: Direct DateTime usage
        var invoice = new Billing.Models.Invoice(
            Id: 0,
            OrderId: orderId,
            Amount: order.Total,
            IssuedDate: DateTime.Now,
            PaidDate: null,
            Status: Billing.Models.InvoiceStatus.Draft
        );

        await _invoiceRepository.SaveAsync(invoice);
        
        return new { Success = true, Invoice = invoice };
    }
}
