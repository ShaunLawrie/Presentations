# React + TypeScript Frontend with Enterprise Code Quality

This frontend enforces the same enterprise standards as the C# backend, using **Biome** linter and custom **GritQL** rules.

## Enterprise Code Quality

### Custom GritQL Rules

Located in `.grit/`:

- **ENT501** (`detect-date-now.grit`): Detects `Date.now()` and `new Date()` - requires injected clock service
- **ENT502** (`detect-hardcoded-urls.grit`): Detects hardcoded API URLs - requires configuration
- **ENT503** (`detect-unhandled-promises.grit`): Detects fetch calls without error handling

### Standard Biome Rules

Configured in `biome.json`:

- `noExplicitAny`: Prevent `any` types in TypeScript
- `noConsoleLog`: Warn on console.log statements
- `useConst`: Enforce const over let when not reassigned
- `noVar`: Disallow var keyword

## Setup

```bash
cd ClientApp
npm install
```

## Linting

```bash
# Check for violations
npm run lint

# Auto-fix issues
npm run lint:fix
```

### Example Output

Running lint on bad examples shows:

```
src/examples/BadPatterns.tsx:9:57: ENT501: Use injected clock service
src/examples/BadPatterns.tsx:25:11: ENT502: Hardcoded API URL
src/examples/BadPatterns.tsx:28:9: noConsoleLog: Don't use console.log
src/examples/BadPatterns.tsx:23:22: noExplicitAny: Don't use 'any' type
```

## Development

Run the Vite dev server:

```bash
npm run dev
```

This will start the development server at `http://localhost:5173` with hot module replacement.

## Build

Build for production:

```bash
npm run build
```

This runs TypeScript compiler + Vite bundler, outputs to `../wwwroot/dist`.

## Integration with ASP.NET Core

The built assets are served by the ASP.NET Core application from `wwwroot/dist`.

The backend API is available at `/api/orders`.

## Comparison: Backend vs Frontend

| Aspect | C# (Roslyn) | TypeScript (Biome) |
|--------|-------------|---------------------|
| **Time Check** | ENT001: DateTime.Now | ENT501: Date.now() |
| **Config** | ENT004: Connection strings | ENT502: Hardcoded URLs |
| **Error Handling** | ENT002: Generic Exception | ENT503: Unhandled promises |
| **Tool** | Roslyn Analyzer | Biome + GritQL |
| **Run Time** | Compile-time | Lint-time |

Both enforce the same principles: **No magic values, proper error handling, dependency injection.**
