namespace DotnetLibrary.Orders.Models;

public class Product 
{ 
    public int Id { get; set; }
    public string Name { get; set; } = string.Empty;
    public Category Category { get; set; } = new Category();
}
