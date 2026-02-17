# Python Enterprise Code Analyzer

This demonstrates using **flake8** with a custom plugin to enforce enterprise coding standards in Python, similar to our C# Roslyn analyzers.
An extensive explanation of flake8 plugin development is available on [YouTube](https://www.youtube.com/watch?v=ot5Z4KQPBL8) and in the [official documentation](https://flake8.pycqa.org/en/latest/plugin-development/index.html).

## What It Does

Our custom flake8 plugin checks for:

- **ENT401**: Hardcoded connection strings
- **ENT402**: Direct use of `datetime.now()` (should use dependency injection)

## Setup

### 0. Setup a Python Virtual Environment

```bash
# Switch to this directory first
pipenv install
```

### 1. Install flake8

```bash
pip install flake8
```

### 2. Install the custom plugins in this directory

```bash
pip install -e .
```

This installs the plugin in development mode, making it available to flake8.

### 3. Run the analyzer

```bash
flake8 app.py
```

## Expected Output

```
app.py:14:9: ENT401 hardcoded connection string detected: 'hardcoded_database.db'
app.py:19:22: ENT402 use injected clock instead of datetime.now(): use dependency injection for time
app.py:76:20: ENT402 use injected clock instead of datetime.now(): use dependency injection for time
```

## How It Works

The plugin uses Python's built-in `ast` (Abstract Syntax Tree) module to:

1. Parse the Python source code into an AST
2. Walk the tree looking for specific patterns
3. Report violations with line numbers and error codes

This is **exactly the same concept** as Roslyn analyzers for C#:
- Parse code into a syntax tree
- Pattern match on tree nodes
- Report diagnostics
