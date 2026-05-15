# Copilot Instructions

## Repository Overview

Public personal configs repo: editor configs (Neovim), shell configs (zsh, PowerShell), terminal emulators (wezterm, alacritty), keyboard customization (AHK, karabiner), and machine setup scripts.

## Architecture

### Config Syncing
- `pwsh/sync.ps1` (Windows) / `sh/sync.sh` (Unix) — creates symlinks from this repo to system config locations
- Profiles are symlinked, not copied — edits to repo files take effect immediately
- The repo is expected to live at `~/configs`

### PowerShell Modules (`pwsh/`)
| File | Purpose |
|------|---------|
| `profile.ps1` | Main pwsh 7+ profile, sources all modules |
| `winps_profile.ps1` | Windows PowerShell 5.x profile (minimal) |
| `git.ps1` | Git workflow shortcuts (gcb, gps, syncm, hardreset, pruneBranches) |
| `utilities.ps1` | General utilities (vpn, pkill, guid, runInPwsh, bios, nextWin) |
| `fileUtil.ps1` | File/archive operations |
| `alias.ps1` | Cross-platform aliases (j, vi, touch, pbcopy) |
| `chrome.ps1` | ChromeDriver version detection and download |
| `ssh_awake.ps1` | Prevent sleep during active SSH connections |

### Shell Config (`zshrc`)
Contains the zsh equivalents of the PowerShell git/utility functions for macOS/Linux.

### Neovim Config (`nvim/`)
- `init.lua` sources `~/.vimrc` for base vim settings, then loads Lua config
- `lua/configs/init.lua` loads theme immediately, then defers all other plugins via `vim.defer_fn`
- Each plugin config lives in its own file under `lua/configs/`
- Plugin management via lazy.nvim (`lazy-lock.json` pins versions)
- Platform-aware: handles WSL clipboard (`win32yank`), Windows shell settings, and macOS/Linux differences

### Hook for Private Extensions
The profile includes: `if (Test-Path ~/work/work_profile.ps1) { . ~/work/work_profile.ps1 }`
This allows a private repo to inject work-specific scripts without modifying public configs.

## Conventions

- **Function naming**: Short lowercase for frequent commands (`gcb`, `gps`, `vpn`). PascalCase for less common utilities (`Update-SelectionIndex`).
- **PowerShell targets**: pwsh 7+ unless explicitly noted for Windows PowerShell 5.x.
- **Error suppression**: `-ErrorAction SilentlyContinue` or `2>&1 | Out-Null` for expected failures.
- **Alias conflicts**: Remove before redefining (`remove-alias gcb -ErrorAction SilentlyContinue`).
- **Cross-platform**: Use `$IsWindows`/`$IsLinux`/`$IsMacOS` for platform-specific behavior.
- **Admin elevation**: Use `runInPwsh $command $wait $asAdmin` helper.
- **Splatting**: Prefer `@params` for commands with many parameters.
- **No build/test system**: Test by dot-sourcing and invoking functions manually.
