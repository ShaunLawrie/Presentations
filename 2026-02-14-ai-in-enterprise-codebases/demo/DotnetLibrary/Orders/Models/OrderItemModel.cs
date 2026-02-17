namespace DotnetLibrary.Orders.Models;

/// <summary>
/// ✅ GOOD EXAMPLE: Single model in its own file
/// </summary>
public class OrderItemModel
{
    public int ItemId { get; set; }
    public string ProductName { get; set; } = string.Empty;
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal Total => Quantity * UnitPrice;
}
