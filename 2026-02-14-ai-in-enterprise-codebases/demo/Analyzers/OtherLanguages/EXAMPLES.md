# AST-Based Rules in Other Languages

The same approach we use with Roslyn for C# applies to pretty much every other language - we just need to use the appropriate AST tools for that language.

## JavaScript/TypeScript - Biome (GritQL Plugins) / ESLint (Custom Rules)

Biome now supports custom rules using **GritQL** - a pattern matching language for code.

**detect-date-now.grit:**
```grit
`Date.now()` as $call where {
    register_diagnostic(
        span = $fn,
        message = "Use injected clock service instead of Date.now()",
        severity = "error"
    )
}
```

**biome.json:**
```json
{
  "plugins": ["./detect-date-now.grit"],
  "linter": {
    "rules": {
      "suspicious": {
        "noExplicitAny": "error"  // Built-in rules still work
      }
    }
  }
}
```

**For more complex patterns:**
```grit
`$fn($args)` where {
    $fn <: `Object.assign`,
    register_diagnostic(
        span = $fn,
        message = "Prefer object spread instead of Object.assign()",
        severity = "warn"
    )
}
```

## Tree-sitter (Any Language)

For languages without built-in AST tools, tree-sitter provides a universal parser:

```python
import tree_sitter_python as tspython
from tree_sitter import Language, Parser

parser = Parser(Language(tspython.language()))
tree = parser.parse(bytes(source_code, "utf8"))

# Query for specific patterns
query = Language(tspython.language()).query("""
  (call
    function: (attribute
      object: (identifier) @obj
      attribute: (identifier) @method))
  (#eq? @obj "datetime")
  (#eq? @method "now")
""")
```

## Key Takeaway

**The concept is portable:** Define rules based on syntax patterns, run them at build time, give the AI immediate feedback. The specific tool changes per language, but the approach remains the same.