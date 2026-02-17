namespace DotnetLibrary.Billing.Models;

public record Invoice(
    int Id,
    int OrderId,
    decimal Amount,
    DateTime IssuedDate,
    DateTime? PaidDate,
    InvoiceStatus Status);

public enum InvoiceStatus
{
    Draft,
    Issued,
    Paid,
    Overdue,
    Cancelled
}
