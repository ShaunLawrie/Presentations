namespace DotnetLibrary.Billing.Models;

public class InvoiceResult
{
    public bool Success { get; init; }
    public Invoice? Invoice { get; init; }
    public string? ErrorMessage { get; init; }
}
