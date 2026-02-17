using DotnetLibrary.Orders.Models;
using DotnetLibrary.Orders.Repositories;
using DotnetLibrary.Shared;

namespace DotnetLibrary.Orders.Services;

/// <summary>
/// Service for managing orders - follows proper patterns.
/// </summary>
public class OrderService
{
    private readonly IOrderRepository _repository;
    private readonly IDateTimeProvider _dateTimeProvider;
    private readonly ILogger<OrderService> _logger;

    public OrderService(
        IOrderRepository repository,
        IDateTimeProvider dateTimeProvider,
        ILogger<OrderService> logger)
    {
        _repository = repository;
        _dateTimeProvider = dateTimeProvider;
        _logger = logger;
    }

    public async Task<OrdersResponse> GetTodaysOrdersAsync()
    {
        var today = _dateTimeProvider.Now.Date;

        var orders = await _repository.GetRecentOrdersAsync(today);
        
        return new OrdersResponse
        {
            GeneratedAt = _dateTimeProvider.UtcNow,
            Orders = orders.ToList(),
            Success = true
        };
    }
}
