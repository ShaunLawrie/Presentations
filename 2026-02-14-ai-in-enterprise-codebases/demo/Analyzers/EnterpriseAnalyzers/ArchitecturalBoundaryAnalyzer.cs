using System.Collections.Immutable;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.Diagnostics;

namespace EnterpriseAnalyzers;

/// <summary>
/// Analyzer that enforces architectural boundaries between domains.
/// Services in one domain should not directly instantiate repositories from another domain.
/// This ensures proper separation of concerns and prevents tight coupling between bounded contexts.
/// </summary>
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class ArchitecturalBoundaryAnalyzer : DiagnosticAnalyzer
{
    public const string DiagnosticId = "ENT003";

    private static readonly LocalizableString Title = "Cross-domain boundary violation";
    private static readonly LocalizableString MessageFormat = 
        "'{0}' domain should not directly access '{1}' from '{2}' domain. Use events or service calls into the related domain instead.";
    private static readonly LocalizableString Description = 
        "Direct access across domain boundaries creates tight coupling. Each domain should be loosely coupled.";
    private const string Category = "Architecture";

    private static readonly DiagnosticDescriptor Rule = new(
        DiagnosticId,
        Title,
        MessageFormat,
        Category,
        DiagnosticSeverity.Error, // This is an error, not a warning - architecture matters!
        isEnabledByDefault: true,
        description: Description);

    public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => ImmutableArray.Create(Rule);

    public override void Initialize(AnalysisContext context)
    {
        context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
        context.EnableConcurrentExecution();

        context.RegisterSyntaxNodeAction(AnalyzeObjectCreation, SyntaxKind.ObjectCreationExpression);
        context.RegisterSyntaxNodeAction(AnalyzeConstructorParameter, SyntaxKind.Parameter);
    }

    private static void AnalyzeObjectCreation(SyntaxNodeAnalysisContext context)
    {
        var objectCreation = (ObjectCreationExpressionSyntax)context.Node;
        
        // Get the containing type's namespace
        var containingNamespace = GetContainingNamespace(objectCreation);
        if (containingNamespace == null)
            return;

        // Extract domain from namespace (e.g., "DotnetLibrary.Billing.Services" -> "Billing")
        var containingDomain = ExtractDomain(containingNamespace);
        if (containingDomain == null)
            return;

        // Get the type being instantiated
        var symbolInfo = context.SemanticModel.GetSymbolInfo(objectCreation.Type);
        if (symbolInfo.Symbol is not INamedTypeSymbol typeSymbol)
            return;

        var targetNamespace = typeSymbol.ContainingNamespace?.ToDisplayString();
        if (targetNamespace == null)
            return;

        var targetDomain = ExtractDomain(targetNamespace);
        if (targetDomain == null)
            return;

        // Check if we're crossing domain boundaries with Repository instantiation
        if (containingDomain != targetDomain && IsRepositoryType(typeSymbol.Name))
        {
            var diagnostic = Diagnostic.Create(
                Rule, 
                objectCreation.GetLocation(), 
                containingDomain,
                typeSymbol.Name,
                targetDomain);
            
            context.ReportDiagnostic(diagnostic);
        }
    }

    private static void AnalyzeConstructorParameter(SyntaxNodeAnalysisContext context)
    {
        var parameter = (ParameterSyntax)context.Node;
        
        // Only check parameters in constructors
        if (parameter.Parent?.Parent is not ConstructorDeclarationSyntax)
            return;

        // Get the containing type's namespace
        var containingNamespace = GetContainingNamespace(parameter);
        if (containingNamespace == null)
            return;

        // Extract domain from namespace
        var containingDomain = ExtractDomain(containingNamespace);
        if (containingDomain == null)
            return;

        // Get the parameter type
        var parameterSymbol = context.SemanticModel.GetDeclaredSymbol(parameter);
        if (parameterSymbol?.Type is not INamedTypeSymbol typeSymbol)
            return;

        var targetNamespace = typeSymbol.ContainingNamespace?.ToDisplayString();
        if (targetNamespace == null)
            return;

        var targetDomain = ExtractDomain(targetNamespace);
        if (targetDomain == null)
            return;

        // Check if we're crossing domain boundaries with Repository dependencies
        if (containingDomain != targetDomain && IsRepositoryType(typeSymbol.Name))
        {
            var diagnostic = Diagnostic.Create(
                Rule, 
                parameter.GetLocation(), 
                containingDomain,
                typeSymbol.Name,
                targetDomain);
            
            context.ReportDiagnostic(diagnostic);
        }
    }

    private static bool IsRepositoryType(string typeName)
    {
        return typeName.EndsWith("Repository") || typeName.Contains("Repository<");
    }

    /// <summary>
    /// Extracts domain name from namespace.
    /// E.g., "DotnetLibrary.Orders.Services" -> "Orders"
    ///       "DotnetLibrary.Billing.Repositories" -> "Billing"
    /// </summary>
    private static string ExtractDomain(string namespaceName)
    {
        // Look for pattern: <RootNamespace>.<Domain>.*
        var parts = namespaceName.Split('.');
        
        // Need at least 2 parts: RootNamespace.Domain
        if (parts.Length < 2)
            return null;

        // Skip if in Shared namespace - those are cross-cutting concerns
        if (parts.Contains("Shared"))
            return null;

        // Return the second part as the domain (e.g., Orders, Billing, Shipping)
        return parts[1];
    }

#nullable enable
    private static string? GetContainingNamespace(SyntaxNode node)
    {
        var namespaceDeclaration = node.Ancestors()
            .OfType<BaseNamespaceDeclarationSyntax>()
            .FirstOrDefault();
        
        return namespaceDeclaration?.Name.ToString();
    }
}
