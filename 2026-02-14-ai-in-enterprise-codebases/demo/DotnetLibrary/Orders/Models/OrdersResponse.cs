using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Models;

public class OrdersResponse
{
    public DateTime GeneratedAt { get; init; }
    public List<Order> Orders { get; init; } = [];
    public bool Success { get; init; }
}
