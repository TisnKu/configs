# Copilot Instructions

## Repository Overview

Public personal configs repo: editor configs (Neovim), shell configs (zsh, PowerShell), terminal emulators (wezterm, alacritty), keyboard customization (AHK, karabiner), and machine setup scripts.

## Architecture

### Config Syncing
- `sync.ps1` (Windows) / `sync.sh` (Unix) — creates symlinks from this repo to system config locations and sets up PowerShell profiles
- Profiles are symlinked, not copied — edits to the repo files take effect immediately

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

### Hook for Private Extensions
The profile includes: `if (Test-Path ~/work/work_profile.ps1) { . ~/work/work_profile.ps1 }`
This allows a private repo to inject work-specific scripts without modifying public configs.

## Conventions

- **Function naming**: Short lowercase for frequent commands (`gcb`, `gps`, `vpn`). PascalCase for less common utilities (`Update-SelectionIndex`).
- **Error suppression**: `-ErrorAction SilentlyContinue` or `2>&1 | Out-Null` for expected failures.
- **Alias conflicts**: Remove before redefining (`remove-alias gcb -ErrorAction SilentlyContinue`).
- **Cross-platform**: Use `$IsWindows`/`$IsLinux`/`$IsMacOS` for platform-specific behavior.
- **Admin elevation**: Use `runInPwsh $command $wait $asAdmin` helper.
- **No build/test system**: Test by dot-sourcing and invoking functions manually.
