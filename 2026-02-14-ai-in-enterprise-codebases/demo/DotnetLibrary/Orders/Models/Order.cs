namespace DotnetLibrary.Orders.Models;

public record Order(
    int Id, 
    string CustomerName, 
    DateTime CreatedAt, 
    decimal Total,
    OrderStatus Status);

public enum OrderStatus
{
    Pending,
    Confirmed,
    Shipped,
    Delivered,
    Cancelled
}
