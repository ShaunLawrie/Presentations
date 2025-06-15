# Web Component Stages

## Slide Details

**Title:** Web Generator Plugin: Two-Stage Processing  
**Subtitle:** From help data to website-ready content

### Content
- Two-stage web generation process:
  
  **Stage 1: Site Scaffolding**
  - Generate initial website structure
  - Set up navigation and theming
  - Create homepage and index pages
  - Configure build system

  **Stage 2: Content Generation**
  - Parse help data into web format
  - Substitute recorded examples into content
  - Apply formatting and styling
  - Generate cross-references and links
  
- Flexible pipeline for different web frameworks
- Avoid brittle regex replacements in favor of structured processing

### Imagery
- Two-stage pipeline diagram
- Web framework logos (Astro, Hugo, Docusaurus, etc.)
- Before/after showing structured vs. final content
- Configuration options for different web generators

### Talking Notes
- The web generation needs to be broken into two clear stages
- Stage 1 creates the website foundation and structure
- Stage 2 populates it with the actual documentation content
- This separation allows for different web frameworks
- The current implementation has brittle regex replacements
- A plugin approach would use structured data transformation instead
- Different web generators would have different Stage 1 implementations
- Stage 2 could be more standardized across frameworks
- This allows supporting multiple popular documentation frameworks
- Teams can choose their preferred web technology stack


