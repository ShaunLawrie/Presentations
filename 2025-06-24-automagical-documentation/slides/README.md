# Automagical Documentation

## Slides Overview

The numbers are not the slide numbers, they are like section markers.
These need to be split into multiple slides, but this is the overall structure of the content.

1. Intro - What does automagical documentation look like?
   - Demonstration of the PwshSpectreConsole documentation.
   - Demonstration of the Comment Based Help Example's that generate the interactive documentation.
2. How it works in PwshSpectreConsole
   - At a high level, the process of generating documentation.
   - Explain how there is a script that parses all of the public functions in the module and generates the documentation from the comment based help.
   - The output is markdown files.
   - The markdown files are formatted to be compatible with Astro Starlight by adding the necessary frontmatter and formatting and converting them to MDX, a markdown format that supports React components.
   - For each Example in the comment based help, it parses the example data, sets up mocks, executes the code, emulates the console input and records the output. Caveat: This recording is a function of Spectre.Console which means this only works for this module.
   - The output is then saved in asciinema format.
   - The asciinema files are then referenced in the markdown files.
   - The whole thing runs headless in a GitHub Action workflow.
3. Benefits of this approach
   - The documentation is always in sync with the code.
   - The documentation is interactive and can be run in a terminal.
   - The documentation is easy to read and understand.
   - The documentation is generated automatically, so there is no need to manually update it.
   - The documentation is quick to read and can often highlight bugs in the code when the examples don't work as expected.
4. How can we generalise this for other PowerShell modules.
   - Discuss how we will work through the process of generalising this for other PowerShell modules.
   - Requirements for this to work, each component of the process should be a plugin type.
     - The module must have comment based help and the example format needs to be clearly defined. This will be the input format that the recorder will use.
     - The recorder component needs to be defined e.g. asciinema, mp4, etc. Explain how the recording needs to capture either the input and output of the terminal or just capture a visual recording of the terminal.
     - The web component needs to have two stages, parsing the comment based help into markdown will be specific to the web output type:
       - Generate the initial website code.
       - Parse help and generate the markdown/mdx from the comment based help and be flexible and able to be modified in a pipeline, an issue with the current implementation is that it is regex replacing in the output markdown which is brittle and yucky. This step will need to substitute in the example recordings where the example is referenced in the markdown.
       - The publishing component needs to be defined, e.g. GitHub Pages, Cloudflare Pages, etc. This will be the final step in the pipeline that publishes the generated documentation.
