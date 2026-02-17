// using System.Collections.Immutable;
// using System.IO;
// using System.Linq;
// using Microsoft.CodeAnalysis;
// using Microsoft.CodeAnalysis.CSharp;
// using Microsoft.CodeAnalysis.CSharp.Syntax;
// using Microsoft.CodeAnalysis.Diagnostics;

// namespace EnterpriseAnalyzers;

// /// <summary>
// /// Analyzer that enforces model organization rules:
// /// 1. Models must be in a namespace containing "Models"
// /// 2. Only one class per model file
// /// </summary>
// [DiagnosticAnalyzer(LanguageNames.CSharp)]
// public class ModelOrganizationAnalyzer : DiagnosticAnalyzer
// {
//     public const string ModelNamespaceDiagnosticId = "ENT006";
//     public const string OneClassPerFileDiagnosticId = "ENT007";

//     private static readonly LocalizableString NamespaceTitle = "Model not in Models namespace";
//     private static readonly LocalizableString NamespaceMessageFormat = 
//         "Model class '{0}' should be in a namespace containing 'Models' (currently in '{1}')";
//     private static readonly LocalizableString NamespaceDescription = 
//         "Model classes should be organized in namespaces ending with or containing 'Models' for clarity and consistency.";

//     private static readonly LocalizableString OneClassTitle = "Multiple classes in model file";
//     private static readonly LocalizableString OneClassMessageFormat = 
//         "Model file '{0}' contains {1} classes. Model files should contain only one class.";
//     private static readonly LocalizableString OneClassDescription = 
//         "Each model class should be in its own file for better maintainability and easier navigation.";

//     private const string Category = "Design";

//     private static readonly DiagnosticDescriptor NamespaceRule = new(
//         ModelNamespaceDiagnosticId,
//         NamespaceTitle,
//         NamespaceMessageFormat,
//         Category,
//         DiagnosticSeverity.Warning,
//         isEnabledByDefault: true,
//         description: NamespaceDescription);

//     private static readonly DiagnosticDescriptor OneClassRule = new(
//         OneClassPerFileDiagnosticId,
//         OneClassTitle,
//         OneClassMessageFormat,
//         Category,
//         DiagnosticSeverity.Warning,
//         isEnabledByDefault: true,
//         description: OneClassDescription);

//     public override ImmutableArray<DiagnosticDescriptor> SupportedDiagnostics => 
//         ImmutableArray.Create(NamespaceRule, OneClassRule);

//     public override void Initialize(AnalysisContext context)
//     {
//         context.ConfigureGeneratedCodeAnalysis(GeneratedCodeAnalysisFlags.None);
//         context.EnableConcurrentExecution();

//         // Check namespace for model classes
//         context.RegisterSyntaxNodeAction(AnalyzeClassDeclaration, SyntaxKind.ClassDeclaration);
        
//         // Check one class per file
//         context.RegisterSyntaxTreeAction(AnalyzeSyntaxTree);
//     }

//     private static void AnalyzeClassDeclaration(SyntaxNodeAnalysisContext context)
//     {
//         var classDeclaration = (ClassDeclarationSyntax)context.Node;
        
//         // Skip if not a model class (heuristic: ends with "Model", is a record, or has only properties)
//         if (!IsModelClass(classDeclaration, context.SemanticModel))
//             return;

//         // Get the namespace
//         var namespaceDeclaration = classDeclaration.Ancestors()
//             .OfType<BaseNamespaceDeclarationSyntax>()
//             .FirstOrDefault();

//         if (namespaceDeclaration == null)
//             return;

//         var namespaceName = namespaceDeclaration.Name.ToString();
        
//         // Check if namespace contains "Models"
//         if (!namespaceName.Contains("Models"))
//         {
//             var diagnostic = Diagnostic.Create(
//                 NamespaceRule,
//                 classDeclaration.Identifier.GetLocation(),
//                 classDeclaration.Identifier.Text,
//                 namespaceName);
            
//             context.ReportDiagnostic(diagnostic);
//         }
//     }

//     private static void AnalyzeSyntaxTree(SyntaxTreeAnalysisContext context)
//     {
//         var root = context.Tree.GetRoot(context.CancellationToken);
        
//         // Get all class declarations in this file
//         var classDeclarations = root.DescendantNodes()
//             .OfType<ClassDeclarationSyntax>()
//             .Where(c => !c.Modifiers.Any(m => m.IsKind(SyntaxKind.PartialKeyword))) // Ignore partial classes
//             .ToList();

//         if (classDeclarations.Count <= 1)
//             return;

//         // Check if this is in a Models namespace/folder
//         var fileName = Path.GetFileName(context.Tree.FilePath);
        
//         // If we have multiple classes and at least one looks like a model
//         var hasModelClass = classDeclarations.Any(c => 
//             IsModelClass(c, null));

//         if (hasModelClass && classDeclarations.Count > 1)
//         {
//             // Report on the first class in the file
//             var firstClass = classDeclarations[0];
//             var diagnostic = Diagnostic.Create(
//                 OneClassRule,
//                 firstClass.Identifier.GetLocation(),
//                 fileName,
//                 classDeclarations.Count);
            
//             context.ReportDiagnostic(diagnostic);
//         }
//     }

//     /// <summary>
//     /// Heuristic to determine if a class is a model/data class.
//     /// </summary>
// #nullable enable
//     private static bool IsModelClass(ClassDeclarationSyntax classDeclaration, SemanticModel? semanticModel)
// #nullable disable
//     {
//         // Check if class inherits from DbContext - if so, it's NOT a model
//         var baseList = classDeclaration.BaseList;
//         if (baseList != null)
//         {
//             var baseTypes = baseList.Types.Select(t => t.Type.ToString());
//             if (baseTypes.Any(t => t.Contains("DbContext")))
//             {
//                 return false;
//             }
//         }

//         // Check class name patterns
//         var className = classDeclaration.Identifier.Text;
//         if (className.EndsWith("Model") || 
//             className.EndsWith("Dto") || 
//             className.EndsWith("Entity") ||
//             className.EndsWith("Data"))
//         {
//             return true;
//         }

//         // Check if it's a record (records are typically data classes)
//         if (classDeclaration.Modifiers.Any(m => m.IsKind(SyntaxKind.RecordKeyword)))
//         {
//             return true;
//         }

//         // Check if class is in a Models namespace
//         var namespaceDeclaration = classDeclaration.Ancestors()
//             .OfType<BaseNamespaceDeclarationSyntax>()
//             .FirstOrDefault();

//         if (namespaceDeclaration != null)
//         {
//             var namespaceName = namespaceDeclaration.Name.ToString();
//             if (namespaceName.Contains("Models") || 
//                 namespaceName.Contains("Entities"))
//             {
//                 return true;
//             }
//         }

//         // Check if class has only properties (data class pattern)
//         var members = classDeclaration.Members;
//         var properties = members.OfType<PropertyDeclarationSyntax>().Count();
//         var methods = members.OfType<MethodDeclarationSyntax>()
//             .Where(m => !m.Modifiers.Any(mod => mod.IsKind(SyntaxKind.OverrideKeyword))) // Ignore overrides
//             .Count();
//         var constructors = members.OfType<ConstructorDeclarationSyntax>().Count();

//         // If it has properties and no/few methods (excluding constructors), it's likely a model
//         if (properties > 0 && methods == 0)
//         {
//             return true;
//         }

//         return false;
//     }
// }
