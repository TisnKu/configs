# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Repository Overview

This is a personal dotfiles and configuration repository containing cross-platform development environment configurations for Windows, macOS, and Linux systems. The primary focus is on terminal-based development tools and text editors.

## Common Commands

### Setup and Synchronization
```bash
# On Linux/macOS - Initial setup
./sync.sh

# On Windows - Initial setup (PowerShell)
.\sync.ps1

# Setup Manjaro-specific configurations
./manjaro_setup.sh

# Setup Ubuntu-specific configurations  
./ubuntu.sh
```

### Neovim Development
```bash
# Start Neovim with configuration
nvim

# Check Neovim startup time
nvim --startuptime startup.log

# Update plugins (within Neovim)
:Lazy update

# Check plugin health
:checkhealth

# Format code using LSP
:lua vim.lsp.buf.format()

# Run tests (within Neovim)
:TestFile       # Current file
:TestNearest    # Nearest test
:TestSuite      # Full test suite
```

### Git Operations (from zshrc functions)
```bash
# Checkout branch by partial name match
gcob <partial_branch_name>

# Push and set upstream
gps

# Get current branch name
currentbranch

# Hard reset to origin
hardreset

# Sync with master branch
syncm

# Commit without editing message
gcne

# Prune deleted remote branches
pruneBranches

# Shallow fetch to reduce repo size
shallowfetch
```

## Architecture and Structure

### Configuration Sync System
The repository uses a symlink-based synchronization system to deploy configurations:
- `sync.sh` (Linux/macOS): Creates symlinks from repo to standard config locations
- `sync.ps1` (Windows): PowerShell equivalent for Windows environments
- Configurations are version-controlled while actual config files are symlinked

### Neovim Configuration Structure
**Entry Point**: `nvim/init.lua` - Loads base vimrc and initializes Lua configuration system

**Key Components**:
- **Base Config**: `nvim/vimrc` - Core Vim settings and keybindings (leader key: `,`)
- **Plugin Management**: Uses lazy.nvim for plugin management with deferred loading
- **Modular Configs**: `nvim/lua/configs/` contains specialized configuration modules
- **Utils**: `nvim/lua/utils.lua` provides cross-platform utilities and helper functions

**Plugin Categories**:
- **Themes**: Multiple colorschemes with random theme support
- **LSP/Completion**: Full LSP setup with nvim-cmp, Mason for language servers
- **AI Integration**: GitHub Copilot, CopilotChat, Avante, and CodeCompanion
- **Navigation**: Telescope, Oil file explorer, various text objects
- **Development**: Git integration, testing, refactoring tools
- **Terminal**: Floaterm integration

### Cross-Platform Compatibility
**Platform Detection**: `utils.lua` detects Windows, Linux, macOS, and WSL environments

**Conditional Configurations**:
- Shell setup: PowerShell on Windows, zsh/bash on Unix systems  
- Clipboard handling: win32yank for WSL, system clipboard for others
- Path handling: Adapts to Windows vs Unix path conventions

### Terminal and Shell Configuration
**WezTerm**: Lua-configured terminal with theme cycling and launcher integration
**Zsh Functions**: Extensive collection of development utilities including:
- VPN proxy management
- Git workflow helpers  
- Remote desktop connections
- Build and development shortcuts

**Tmux**: Minimal configuration with mouse support and zsh integration

### Development Environment Setup Scripts
**System-Specific Setup**:
- `manjaro_setup.sh`: Arch Linux setup with AUR packages
- `ubuntu.sh`: Ubuntu/Debian setup with PPA repositories
- Includes SSH key generation, package installation, and tool configuration

## Key Features and Patterns

### Multi-Modal Editor Setup
- Supports both traditional Vim workflows and modern LSP-based development
- IdeaVim configuration for JetBrains IDEs (`nvim/ideavimrc`)
- Consistent keybindings across Vim, Neovim, and IDE plugins

### AI-Assisted Development
- Multiple AI providers configured (Copilot, Claude via Avante)
- Code completion, chat, and refactoring integrations
- Context-aware suggestions with codebase understanding

### Git-Centric Workflow  
- Extensive git aliases and functions for branch management
- Diffview and gitsigns for visual git operations
- Automated sync utilities in `utils.lua`

### Cross-Language Support
- LSP configurations for multiple languages
- Language-specific tooling (Rust tools, TypeScript tools, C# Roslyn)
- Universal text objects and navigation patterns

## Development Notes

When modifying configurations:
- Test changes across all supported platforms
- Consider deferred loading for performance (`vim.defer_fn`)
- Use the platform detection utilities for conditional logic
- Plugin configurations are split into separate files under `nvim/lua/configs/`
- Custom utilities should be added to `utils.lua` and accessed via `_G.utils`

The system is designed for rapid development environment bootstrap across different machines and operating systems while maintaining consistent workflows and keybindings.
