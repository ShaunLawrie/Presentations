// using System.Collections.Immutable;
// using System.Linq;
// using Microsoft.CodeAnalysis;
// using Microsoft.CodeAnalysis.CSharp;
// using Microsoft.CodeAnalysis.CSharp.Syntax;
// using Microsoft.CodeAnalysis.Diagnostics;

// namespace EnterpriseAnalyzers;

// /// <summary>
// /// Analyzer that detects excessive joins in Entity Framework queries.
// /// Too many joins can cause performance issues and indicate poor data access design.
// /// </summary>
// [DiagnosticAnalyzer(LanguageNames.CSharp)]
// public class ExcessiveJoinsAnalyzer : DiagnosticAnalyzer
// {
//     public const string DiagnosticId = "ENT005";
//     private const int MaxJoinsThreshold = 3;

//     private static readonly LocalizableString Title = "Excessive joins in query";
//     private static readonly LocalizableString MessageFormat = 
//         "Query contains {0} joins/includes. Consider refactoring to reduce complexity (max recommended: {1}).";
//     private static readonly LocalizableString Description = 
//         "Queries with too many joins can cause performance issues. Consider using projection, separate queries, or optimizing your data model.";
//     private const string Category = "Performance";

//     private static readonly DiagnosticDescriptor Rule = new(
//         DiagnosticId,
//         Title,
//         MessageFormat,
//         Category,
//         DiagnosticSeverity.Warning,
//         isEnabledByDefault: true,
//         description: Description);

//     public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => ImmutableArray.Create(Rule);

//     public override void Initialize(AnalysisContext context)
//     {
//         context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
//         context.EnableConcurrentExecution();

//         // Register for invocation expressions (method calls)
//         context.RegisterSyntaxNodeAction(AnalyzeInvocation, SyntaxKind.InvocationExpression);
//     }

//     private static void AnalyzeInvocation(SyntaxNodeAnalysisContext context)
//     {
//         var invocation = (InvocationExpressionSyntax)context.Node;
        
//         // Count joins and includes in the query chain
//         var joinCount = CountJoinsInChain(invocation);
        
//         if (joinCount > MaxJoinsThreshold)
//         {
//             var diagnostic = Diagnostic.Create(
//                 Rule,
//                 invocation.GetLocation(),
//                 joinCount,
//                 MaxJoinsThreshold);
            
//             context.ReportDiagnostic(diagnostic);
//         }
//     }

//     /// <summary>
//     /// Counts the number of Join, Include, and ThenInclude calls in a query chain.
//     /// </summary>
//     private static int CountJoinsInChain(InvocationExpressionSyntax invocation)
//     {
//         int count = 0;
//         var current = invocation;

//         while (current != null)
//         {
//             // Check if this is a Join, Include, or ThenInclude call
//             if (current.Expression is MemberAccessExpressionSyntax memberAccess)
//             {
//                 var methodName = memberAccess.Name.Identifier.Text;
                
//                 if (methodName == "Join" || 
//                     methodName == "Include" || 
//                     methodName == "ThenInclude" ||
//                     methodName == "GroupJoin")
//                 {
//                     count++;
//                 }

//                 // Move to the next invocation in the chain
//                 if (memberAccess.Expression is InvocationExpressionSyntax nextInvocation)
//                 {
//                     current = nextInvocation;
//                 }
//                 else
//                 {
//                     break;
//                 }
//             }
//             else
//             {
//                 break;
//             }
//         }

//         return count;
//     }
// }
