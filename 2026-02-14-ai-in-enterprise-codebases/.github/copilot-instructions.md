# Writing Code

Always ensure that warnings and errors are clean after making changes, you should use `dotnet build` to check for issues.

# Error Handling

For error handling attempt to use the following pattern:

```csharp
try {
    // Code that may throw an exception
} catch (Exception ex) {
    // Log the exception and rethrow or handle as appropriate
    // This is just an example, in a real application you'd have proper logging and error handling
    Console.WriteLine($"Error fetching order summary: {ex.Message}");
    throw;
}
```