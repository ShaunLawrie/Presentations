# Writing Code

Always ensure that warnings and errors are clean after making changes, you should use `dotnet build --property:NoWarn=NU1900%3BENT001%3BENT003` to check for issues, this ignores a couple of errors I don't want polluting my demo.

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