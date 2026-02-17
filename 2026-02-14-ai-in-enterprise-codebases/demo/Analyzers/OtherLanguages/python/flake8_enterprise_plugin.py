"""
Custom flake8 plugin for enterprise Python code standards.
Detects patterns similar to our C# Roslyn analyzers.
"""
import ast
import re
from typing import Generator, Tuple


class EnterpriseChecker:
    """Flake8 plugin that enforces enterprise coding standards."""

    name = 'enterprise-checker'
    version = '1.0.0'

    # Error codes matching our C# analyzer style
    ENT401 = 'ENT401 hardcoded connection string detected'
    ENT402 = 'ENT402 use injected clock instead of datetime.now()'

    def __init__(self, tree: ast.AST) -> None:
        self.tree = tree

    def run(self) -> Generator[Tuple[int, int, str, type], None, None]:
        """Run all checks and yield violations."""
        for node in ast.walk(self.tree):
            # Check for hardcoded connection strings
            if isinstance(node, ast.Assign):
                yield from self._check_hardcoded_connection(node)

            # Check for datetime.now() usage
            if isinstance(node, ast.Call):
                yield from self._check_datetime_now(node)

    def _check_hardcoded_connection(
        self, node: ast.Assign
    ) -> Generator[Tuple[int, int, str, type], None, None]:
        """Detect hardcoded database connection strings."""
        for value in node.targets:
            if isinstance(value, ast.Attribute):
                attr_name = value.attr.lower()
                if any(keyword in attr_name for keyword in ['conn', 'connection', 'db']):
                    # Check if the value is a string literal or call with string arg
                    if isinstance(node.value, ast.Call):
                        if node.value.args and isinstance(node.value.args[0], ast.Constant):
                            if isinstance(node.value.args[0].value, str):
                                string_val = node.value.args[0].value
                                # Look for connection string patterns
                                patterns = [
                                    r'\.db$',
                                    r'\.sqlite$',
                                    r'Data Source=',
                                    r'Server=',
                                    r'mongodb://',
                                    r'postgresql://'
                                ]
                                if any(re.search(p, string_val, re.IGNORECASE) for p in patterns):
                                    yield (
                                        node.lineno,
                                        node.col_offset,
                                        f"{self.ENT401}: '{string_val}'",
                                        type(self)
                                    )

    def _check_datetime_now(
        self, node: ast.Call
    ) -> Generator[Tuple[int, int, str, type], None, None]:
        """Detect direct usage of datetime.now() or datetime.utcnow()."""
        if isinstance(node.func, ast.Attribute):
            # Check for datetime.datetime.now()
            if node.func.attr in ['now', 'utcnow']:
                if isinstance(node.func.value, ast.Attribute):
                    if (node.func.value.attr == 'datetime'
                            and isinstance(node.func.value.value, ast.Name)
                            and node.func.value.value.id == 'datetime'):
                        yield (
                            node.lineno,
                            node.col_offset,
                            f"{self.ENT402}: use dependency injection for time",
                            type(self)
                        )
                # Check for datetime.now() (when imported as from datetime import datetime)
                elif isinstance(node.func.value, ast.Name):
                    if node.func.value.id == 'datetime':
                        yield (
                            node.lineno,
                            node.col_offset,
                            f"{self.ENT402}: use dependency injection for time",
                            type(self)
                        )
