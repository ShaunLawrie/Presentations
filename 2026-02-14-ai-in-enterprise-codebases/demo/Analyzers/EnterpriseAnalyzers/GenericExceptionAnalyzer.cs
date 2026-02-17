using System.Collections.Immutable;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.Diagnostics;

namespace EnterpriseAnalyzers;

/// <summary>
/// Analyzer that detects catching generic Exception types.
/// Specific exception types should be caught instead.
/// </summary>
[DiagnosticAnalyzer(LanguageNames.CSharp)]
public class GenericExceptionAnalyzer : DiagnosticAnalyzer
{
    public const string DiagnosticId = "ENT002";

    private static readonly LocalizableString Title = "Avoid catching generic Exception";
    private static readonly LocalizableString MessageFormat = 
        "Catch specific exception types instead of '{0}'";
    private static readonly LocalizableString Description = 
        "Catching generic Exception can hide bugs and make debugging difficult. Catch specific exceptions.";
    private const string Category = "Reliability";

    private static readonly DiagnosticDescriptor Rule = new(
        DiagnosticId,
        Title,
        MessageFormat,
        Category,
        DiagnosticSeverity.Error,
        isEnabledByDefault: true,
        description: Description);

    public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => ImmutableArray.Create(Rule);

    public override void Initialize(AnalysisContext context)
    {
        context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
        context.EnableConcurrentExecution();

        context.RegisterSyntaxNodeAction(AnalyzeCatchClause, SyntaxKind.CatchClause);
    }

    private static void AnalyzeCatchClause(SyntaxNodeAnalysisContext context)
    {
        var catchClause = (CatchClauseSyntax)context.Node;

        // Check if catching generic Exception or no type specified (bare catch)
        if (catchClause.Declaration?.Type is IdentifierNameSyntax typeName &&
            typeName.Identifier.Text == "Exception")
        {
            var diagnostic = Diagnostic.Create(
                Rule, 
                catchClause.Declaration.Type.GetLocation(), 
                typeName.Identifier.Text);
            
            context.ReportDiagnostic(diagnostic);
        }
    }
}
