namespace DotnetLibrary.Orders.Models;

public class Customer 
{ 
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public Address Address { get; set; } = new Address();
}
