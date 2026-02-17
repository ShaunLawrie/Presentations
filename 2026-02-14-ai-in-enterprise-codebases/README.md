# AI in Enterprise Codebases

This presentation is for AI Tinkerers Chicago, to talk about the struggles of using AI in enterprise codebases, and one technique to help enhance the reliability of AI-generated code.

The presentation is a 5 minute lightning talk so the majority of the introduction and other techniques detailed in the outline will be very quickly glossed over so the demo can start as soon as possible, but I wanted to include them in the outline to give some context to the problem and other techniques that can be used to help improve the quality of AI-generated code.

TODO:
2. Step through demo flow with timer.

# Outline

## Introduction

### Problem Statement

There are some key challenges when it comes to using AI in enterprise codebases, such as:

- The complexity of enterprise codebases, 10+ year old piles of code, if you're successful at vibing up a new application you'll be familiar with how you can reach a point of complexity where it becomes difficult to start adding more features cleanly.
- The need for reliability and maintainability. A shared understanding of what can and cannot be done in certain areas of the codebase is crucial when working with large teams.
- The limitations of LLM context which can be easily polluted with irrelevant and conflicting information when working with large codebases, and how that can lead to poor quality AI-generated code.
- Wasting time on low quality AI-generated code can be frustrating and time-consuming, especially when it can produce a lot of compiling code quickly that doesn't meet the required standards requring back-and-forth on a pull request review.

### Solutions

Tight feedback loops for the agent are required to improve the quality of the solutions you get back from the model, and to be able to guide it when it gets off track. Just like with human developers.

Shifting the context to be as close to the point in which its useful as possible, I call this "locality of context", similar to locality of behavior in software design, the idea is to keep the context as close to where it's required as possible to avoid context-rot. We want the model to be able to focus on solving the problem at hand and guiding it when it gets off track instead of trying to load too much information into instructions files or prompt engineering.

- Nested AGENTS.md instructions to ensure that relevant context is available to the model when it's generating code in different areas of the codebase.

- Obviously tests are super important and your instructions for the agent should include guidance on how to write and run them.

We're missing a middle ground here though, what we're going to get is code that compiles and passes tests, but it may not meet the required standards for maintainability, readability, or security. This is where AST-based rules can come in to help us enforce coding standards and best practices in AI-generated code. Standards are deterministic by nature

## Demo: AST-based Rules

This is where the demo will start, and I'll be showing how to implement AST-based rules for a C# codebase, and how it can help improve the quality of AI-generated code. I'll be covering:

- Basic AST-based rules for C# codebases to capture specific syntax issues you want to avoid in AI-generated code.
- How to use the Roslyn API to create and enforce these rules in your codebase.
- How to use these rules for more complex enterprise situations like enforcing architectural patterns, security best practices, or architectural boundaries.
- How to use Roslyn analyzers for older, .NET Framework codebases that may not be compatible with newer C# features.
- A quick example of the options available for other languages, such as Python's AST module, Biome for Javascript/Typescript, and how to use them to create similar rules for those languages.

## Outro

- AI in greenfield projects can be fun but a lot of us have to deal with legacy codebases, and AI can be a powerful tool to help us maintain and improve those codebases, but it comes with its own set of challenges.
- Using AST-based rules can help us enforce coding standards and best practices in AI-generated code, and improve the reliability and maintainability of our codebases giving us fewer things to worry about when using AI to generate code.
- Rulesets are portable, if you have generic rules you can use these across different projects and teams, and they can be a great way to share best practices and standards across an organization.
- I'm very interested in hearing about other people's experiences with using AI in enterprise organisations, and any techniques or tools they've found helpful for improving the quality of AI-generated code.
