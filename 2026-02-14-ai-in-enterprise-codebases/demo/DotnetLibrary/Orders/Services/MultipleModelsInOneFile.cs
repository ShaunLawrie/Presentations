using DotnetLibrary.Orders.Models;

namespace DotnetLibrary.Orders.Services;

/// <summary>
/// ⚠️ BAD EXAMPLE: Multiple model classes in one file ⚠️
/// ENT007: This file contains multiple model classes.
/// Each model should be in its own file.
/// </summary>

// ENT006: These are model classes but not in a Models namespace
// ENT007: Multiple classes in one file
public class OrderResponse
{
    public int OrderId { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal Total { get; set; }
    public OrderStatus Status { get; set; }
}

public class OrderRequest
{
    public string CustomerName { get; set; } = string.Empty;
    public decimal Total { get; set; }
}

public class OrderListResponse
{
    public List<OrderResponse> Orders { get; set; } = new();
    public int TotalCount { get; set; }
}
