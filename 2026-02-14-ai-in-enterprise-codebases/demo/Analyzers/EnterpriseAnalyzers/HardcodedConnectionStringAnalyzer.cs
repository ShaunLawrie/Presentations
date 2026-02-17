// using System.Collections.Immutable;
// using System.Text.RegularExpressions;
// using Microsoft.CodeAnalysis;
// using Microsoft.CodeAnalysis.CSharp;
// using Microsoft.CodeAnalysis.CSharp.Syntax;
// using Microsoft.CodeAnalysis.Diagnostics;

// namespace EnterpriseAnalyzers;

// /// <summary>
// /// Analyzer that detects hardcoded connection strings in code.
// /// Connection strings should come from configuration, not be embedded in code.
// /// </summary>
// [DiagnosticAnalyzer(LanguageNames.CSharp)]
// public class HardcodedConnectionStringAnalyzer : DiagnosticAnalyzer
// {
//     public const string DiagnosticId = "ENT004";

//     private static readonly LocalizableString Title = "Hardcoded connection string detected";
//     private static readonly LocalizableString MessageFormat = 
//         "Connection strings should not be hardcoded. Use IConfiguration or environment variables.";
//     private static readonly LocalizableString Description = 
//         "Hardcoded connection strings are a security risk and make deployment difficult.";
//     private const string Category = "Security";

//     private static readonly DiagnosticDescriptor Rule = new(
//         DiagnosticId,
//         Title,
//         MessageFormat,
//         Category,
//         DiagnosticSeverity.Error,
//         isEnabledByDefault: true,
//         description: Description);

//     // Pattern to detect connection string-like values
//     private static readonly Regex ConnectionStringPattern = new(
//         @"(Server|Data Source|Initial Catalog|Database|User Id|Password|Integrated Security|Trusted_Connection)=",
//         RegexOptions.IgnoreCase | RegexOptions.Compiled);

//     public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => ImmutableArray.Create(Rule);

//     public override void Initialize(AnalysisContext context)
//     {
//         context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
//         context.EnableConcurrentExecution();

//         context.RegisterSyntaxNodeAction(AnalyzeStringLiteral, SyntaxKind.StringLiteralExpression);
//     }

//     private static void AnalyzeStringLiteral(SyntaxNodeAnalysisContext context)
//     {
//         var literalExpression = (LiteralExpressionSyntax)context.Node;
//         var value = literalExpression.Token.ValueText;

//         if (ConnectionStringPattern.IsMatch(value))
//         {
//             var diagnostic = Diagnostic.Create(Rule, literalExpression.GetLocation());
//             context.ReportDiagnostic(diagnostic);
//         }
//     }
// }
