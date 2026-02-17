namespace DotnetLibrary.Shared;

/// <summary>
/// Abstraction for DateTime operations to enable testability.
/// </summary>
public interface IDateTimeProvider
{
    DateTime Now { get; }
    DateTime UtcNow { get; }
}

/// <summary>
/// Production implementation that uses the system clock.
/// This is the ONE place where DateTime.Now/UtcNow is allowed.
/// </summary>
public class SystemDateTimeProvider : IDateTimeProvider
{
#pragma warning disable ENT001 // This is the legitimate implementation
    public DateTime Now => DateTime.Now;
    public DateTime UtcNow => DateTime.UtcNow;
#pragma warning restore ENT001
}
