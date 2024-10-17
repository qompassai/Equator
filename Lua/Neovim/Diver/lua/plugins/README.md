# Plugins Directory Overview

This document provides an overview of the directories in your Neovim configuration, explaining what is inside each directory and the purpose of the plugins contained within.

## Directory Structure

### `ai`
- **cuda.lua**: Integrates CUDA-specific AI capabilities, such as syntax highlighting or language support.
- **hf.lua**: Configures support for Hugging Face transformers, adding machine learning capabilities.
- **rose.lua**: Adds AI assistance features, potentially integrating with language models to provide in-editor suggestions.

### `cloud`
- **distant.lua**: Provides remote editing capabilities, allowing you to work on files from remote machines.
- **qpg.lua**: Manages GPG and SSH integration for remote environments.
- **remote.lua**: General plugin for handling remote file access and editing.
- **sshfs.lua**: Adds SSHFS support for mounting remote directories within Neovim.

### `core`
- **mason.lua**: Handles installation of LSP servers, DAPs, and other development dependencies.
- **plenary.lua**: Utility functions commonly used across several plugins, provided by the Plenary library.
- **whichkey.lua**: Displays available keybindings in a popup to make navigation easier.

### `data`
- **jupyter.lua**: Adds integration with Jupyter notebooks, enabling you to run Jupyter code cells directly in Neovim.
- **large.lua**: Configures Neovim to handle large files more efficiently.
- **md-pdf.lua**: Converts Markdown files to PDF from within Neovim.
- **notes.lua**: A plugin for managing and editing notes in Markdown or other formats.
- **oil.lua**: Provides an enhanced file explorer experience.
- **quarto.lua**: Adds support for Quarto documents, including rendering and editing capabilities.
- **toggle.lua**: Utility plugin for toggling various Neovim options or plugins.

### `edu`
- **nvim-be-good.lua**: Educational plugin designed to help users improve their proficiency with Neovim.
- **twilight.lua**: Focus mode plugin, dims inactive portions of the code to help you focus on the active section.

### `flow`
- **completion.lua**: Autocompletion configuration, enabling code suggestions and completions.
- **dap.lua**: Debug Adapter Protocol plugin setup for debugging support.
- **debugging.lua**: Additional debugging utilities to supplement DAP.
- **indent-blankline.lua**: Adds visual indentation guides to improve code readability.
- **lspsig.lua**: Provides signature help for functions and methods in LSP-enabled languages.
- **none-ls-external-sources.lua**: External sources configuration for none-ls, providing linting or formatting support.
- **none-ls.lua**: Sets up none-ls as a formatter and linter framework.
- **nvim-lsp.lua**: Core LSP configuration for language support and diagnostics.

### `lang`
- **rustaceanvim.lua**: Rust-specific configurations, including LSP setup and tools for Rust development.

### `nav`
- **conform.lua**: Code conformity tools to keep your code style consistent.
- **fugitive.lua**: Git integration, allowing version control commands from within Neovim.
- **tele.lua**: Sets up Telescope, a fuzzy finder for searching files, buffers, and more.
- **trees.lua**: Configures Treesitter for better syntax highlighting and code parsing.

### `ui`
- **color.lua**: Configuration for color schemes and highlights.
- **dive.lua**: A tool for better inspecting buffers or files in-depth.
- **gitsigns.lua**: Adds Git change indicators in the gutter, such as additions, modifications, and removals.
- **hover.lua**: Provides hover documentation on symbols under the cursor.
- **icons.lua**: Adds file type and other useful icons to the UI.
- **lualine.lua**: Sets up Lualine as the status line for Neovim.
- **themes.lua**: Configures Neovim themes, including setting default themes and switching between them.
- **transparent.lua**: Makes Neovim’s UI background transparent.
- **trouble.lua**: Adds a diagnostics list for LSP issues, warnings, and errors.

