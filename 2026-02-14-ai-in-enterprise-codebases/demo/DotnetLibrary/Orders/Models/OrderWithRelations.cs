namespace DotnetLibrary.Orders.Models;

public class OrderWithRelations
{
    public int Id { get; set; }
    public string CustomerName { get; set; } = string.Empty;
    public decimal Total { get; set; }
    public OrderStatus Status { get; set; }
    public DateTime CreatedAt { get; set; }
    
    // Navigation properties that would trigger joins
    public Customer Customer { get; set; } = new Customer();
    public Address ShippingAddress { get; set; } = new Address();
    public Address BillingAddress { get; set; } = new Address();
    public PaymentMethod PaymentMethod { get; set; } = new PaymentMethod();
    public List<OrderItem> OrderItems { get; set; } = new();
}
