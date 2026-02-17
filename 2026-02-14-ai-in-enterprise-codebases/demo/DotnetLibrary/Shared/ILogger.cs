namespace DotnetLibrary.Shared;

/// <summary>
/// Minimal logger interface for demo purposes.
/// In real applications, use Microsoft.Extensions.Logging.
/// </summary>
public interface ILogger<T>
{
    void LogInfo(string message);
    void LogWarning(Exception ex, string message, params object[] args);
    void LogError(Exception ex, string message, params object[] args);
}
