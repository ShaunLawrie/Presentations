# What is an AST?

Present very short background on Abstract Syntax Trees (AST) using a PowerShell in Windows Terminal.

1. Write a hello world function with an branching condition.
   ```pwsh
   function Write-Hello($name) {
     if ($name -eq "shaun") {
       Write-Host "Hi $name"
     } else {
       Write-Host "Hello $name"
     }
   }
   ```
2. Use `Get-Command` to get the command info object.
3. Use `Format-SpectreAst` to show the AST.

The AST represents the structure of the code, and we can analyze it to find patterns. We used to require an understanding of programming language design and compiler theory to do this, but now we have tools that make it much more accessible.

# What is an Analyzer?

A metaprogramming tool that parses code into an AST and looks for specific patterns to enforce coding standards, architectural principles, or best practices. It can be used to guide AI agents in generating better code and reducing the need for manual review and refactoring.

We're going to use an example of a .NET codebase, but the same concepts apply across languages and ecosystems.

1. Show how the analyzers parse the code into an AST and look for specific patterns and we don't need to fully understand the AST to implement them.
   ```prompt
   Create an analyzer rule that enforces that direct usage of DateTime.Now or DateTime.UtcNow should be replaced with an injected IDateTimeProvider for better testability.
   ```
2. Show how the analyzers help guide agent output towards better code that requires less manual review and refactoring.
   ```prompt
   Add error handling for GetRecentOrdersAsync in the repository, it sometimes fails for some reason.
   ```
3. Show how the rules aren't just about "is this code correct?" but "is this code following our architectural principles?" This helps a huge amount with scaling greenfield AI development and not just patching legacy code.

# Extras

1. Show that this also works for legacy .NET Framework codebases going back to .NET 4.6 which is a decade old now, and that the same concepts apply across languages and ecosystems.
2. Show that this approach applies to pretty much any language:
   - Python's Flake8 and AST module.
     ```pwsh
     cd ./demo/Analyzers/OtherLanguages/python
     flake8 app.py
     ```
   - Biome with GritQL 🤮 for TypeScript.
     ```pwsh
     cd ./demo/DotnetWeb/ClientApp
     npm run lint
     ```
