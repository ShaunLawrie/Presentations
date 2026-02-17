using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Models;

/// <summary>
/// ✅ GOOD EXAMPLE: Single model in correct namespace
/// This follows the convention:
/// - In a Models namespace
/// - One class per file
/// - File name matches class name
/// </summary>
public class OrderDetailModel
{
    public int OrderId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal Total { get; set; }
    public OrderStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<OrderItemModel> Items { get; set; } = new();
}
