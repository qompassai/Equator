# Qompass Diver for Neovim

**Qompass Diver** was inspired by the great folks who made [NvChad](https://github.com/NvChad/NvChad). The intent of Diver is to build on the original configuration framework to provide an even more powerful, customizable, and user-friendly experience that bridges the skills gap left by education and industry. Qompass Diver enhances the flexibility of the original project while focusing on AI, cloud integrations, education, and developer productivity.

## Features

Qompass Diver builds upon the solid foundation of NvChad, offering the following enhancements:

### AI Integration
- **Hugging Face Transformers**: Provides support for machine learning workflows with integration into Hugging Face transformers.
- **CUDA Support**: Tools and integrations for CUDA-based AI development, helping you leverage your GPU for machine learning tasks.
- **Ollama integration**: A plugin that provides AI-assisted code generation capabilities, integrating seamlessly with Neovim for improved productivity.
- **Open-Source Cursor via Avante**: Enhances AI-driven workflows, offering advanced completions and intelligent suggestions within Neovim.

### Cloud Development
- **Remote Editing**: Allows seamless editing of files over SSH and remote machines using plugins like distant.lua, sshfs.lua, and more.
- **GPG & SSH Management**: Manage GPG and SSH keys effortlessly within Neovim for secure remote development environments.

### Educational Tools
- **nvim-be-good**: Helps users practice and improve their Neovim proficiency with gamified learning tools.
- **Twilight**: A focus mode plugin that dims inactive portions of code to keep you concentrated on your current task.

### Developer Productivity
- **Jupyter Integration**: Enables running Jupyter notebooks inside Neovim, streamlining data science and development workflows.
- **Markdown to PDF Conversion**: Quickly convert Markdown documents into PDF files without leaving Neovim.
- **Completions and LSP**: Enhanced autocompletion and language server configurations with completion.lua and nvim-lsp.lua, supporting multiple languages and tools.
- **Debugging Tools**: Integrated debugging support using the Debug Adapter Protocol (DAP) and additional utilities.

### Enhanced UI and UX
- **Telescope Themes**: Easily toggle between themes via telescope integrated with transparent backgrounds
- **Lualine Integration**: Enhanced status line management with lualine.lua for better customization and UI experience.
- **Gitsigns**: Visual indicators for Git changes in the gutter for quick code reviews and version control management.

### Developer Tools
- **Rust Development**: Rust-specific configurations with rustaceanvim.lua to make Rust development seamless.
- **Treesitter**: Robust syntax highlighting and code parsing powered by treesitter.lua, improving the Neovim editing experience.
- **Telescope Fuzzy Finder**: Quick file and buffer navigation with telescope.lua, providing a fast way to access your project.

## Getting Started

### Install Dependencies before you start your dive

To set up Qompass Diver, you will first need to install the necessary dependencies using the provided `mac/arch/ubuntu/windowsdive.sh` script to simpllify getting your system ready to dive.

- MacOS users can get the necessary core packages via `macosdive.sh` after cloning Diver locally
```
chmod +x macosdive.sh
./macosdive.sh
```
- Arch users can get the necessary core packages via `archdive.sh` after cloning Diver locally
```
chmod +x archdive.sh
./archdive.sh
```
- Ubuntu users can get the necessary core packages via `ubuntudive.sh` after cloning Diver locally
```
chmod +x ubuntudive.sh
./ubuntudive.sh
```
- Windows users can get the necessary core packages via `windowsdive.sh` after cloning Diver locally
```
chmod +x windowsdive.sh
./windowsdive.sh
```

### Clone the Repository
After installing the dependencies, you can clone the Qompass Diver repository and set up Neovim:

```bash
# Clone the repository to your Neovim configuration folder
git clone https://github.com/qompassai/Diver ~/.config/nvim
```
- `gh repo clone qompassai/Diver` if you're a ` real one` as the Zoomers say.

Once the repository is cloned, start Neovim and Qompass Diver will be ready for you to use.

### Final Steps
Launch Diver by starting Neovim:
```bash
nvim
```
Qompass Diver will automatically set up and load the required plugins for a streamlined coding experience whether you're new or a seasoned pro.

And unlike other folks in the AI space, we will `NEVER` collect data on your use.

## Dual-License Notice
This repository and all applications within it are dual-licensed under the terms of the [Qompass Commercial Distribution Agreement (CDA)](LICENSE) and the [GNU Affero General Public License v3.0 (AGPL-3.0)](LICENSE-AGPL).

## What a Dual-License means

### Protection for Vulnerable Populations

The dual licensing aims to address the cybersecurity gap that disproportionately affects underserved populations. As highlighted by recent cyberattacks[^1], low-income residents, seniors, and foreign language speakers face higher-than-average risks of being victims of cyber attacks. By offering both open-source and commercial licensing options, we encourage the development of cybersecurity solutions that can reach these vulnerable groups while also enabling sustainable development and support.

### Preventing Malicious Use

The AGPL-3.0 license ensures that any modifications to the software remain open source, preventing bad actors from creating closed-source variants that could be used for exploitation. This is especially crucial given the rising threats to vulnerable communities, including children in educational settings. The attack on Minneapolis Public Schools, which resulted in the leak of 300,000 files and a $1 million ransom demand, highlights the importance of transparency and security[^6]).

### Addressing Cybersecurity in Critical Sectors

The commercial license option allows for tailored solutions in critical sectors such as healthcare, which has seen significant impacts from cyberattacks. For example, the recent Change Healthcare attack[^2] affected millions of Americans and caused widespread disruption for hospitals and by estimates 1/3 Americans private health data.

### Supporting Cybersecurity Awareness

The dual licensing model supports initiatives like the Cybersecurity and Infrastructure Security Agency (CISA) efforts to improve cybersecurity awareness[^3] in "target rich" sectors, including K-12 education. By allowing both open-source and commercial use, we aim to facilitate the development of tools that support these critical awareness and protection efforts.

### Bridging the Digital Divide

The unfortunate reality is that a number of individuals and organizations have gone into a hype frenzy over adding "AI" into every facet of our daily lives[^4]. These folks identify themselves with their talk of "10X returns" and building Artificial General Intelligence aka "AGI" but only after they get your money. Our dual licensing approach aims to acknkowledge this deeply concerning predatory paradigm witih clear eyes while still bringing the best parts of the open-source community with our services and solutions.

### Recent Cybersecurity Attacks

Recent attacks underscore the importance of robust cybersecurity measures:

- The Change Healthcare cyberattack in February 2024 is just one of a number of growing attacks in Healtchare[^2] affecting millions of Americans.
- The White House and Congress jointly designated October as Cybersecurity Awareness Month[^5]. This designation comes with over 100 actions that align the Federal government and public/private sector partners are taking to help every man, woman, and child to safely navigate the age of AI.
### Conclusion

By offering both open-source and commercial licensing options, we strive to create a balance that promotes innovation and accessibility while also providing the necessary resources and flexibility to address the complex cybersecurity challenges faced by vulnerable populations and critical infrastructure sectors.

[^1]: [International Counter Ransomware Initiative 2024 Joint Statement](https://www.whitehouse.gov/briefing-room/statements-releases/2024/10/02/international-counter-ransomware-initiative-2024-joint-statement/)
[^2]: [The Top 10 Health Data Breaches of the First Half of 2024](https://www.chiefhealthcareexecutive.com/view/the-top-10-health-data-breaches-of-the-first-half-of-2024)
[^3]: [CISA's K-12 Cybersecurity Initiatives](https://www.cisa.gov/K12Cybersecurity)
[^4]: [Federal Trade Commission Operation AI Comply: continuing the crackdown on overpromises and AI-related lies](https://www.ftc.gov/business-guidance/blog/2024/09/operation-ai-comply-continuing-crackdown-overpromises-ai-related-lies)
[^5]: [A Proclamation on Cybersecurity Awareness Month, 2024 ](https://www.whitehouse.gov/briefing-room/presidential-actions/2024/09/30/a-proclamation-on-cybersecurity-awareness-month-2024/)
[^6]: [Minneapolis school district says data breach affected more than 100,000 people](https://therecord.media/minneapolis-schools-say-data-breach-affected-100000/)
