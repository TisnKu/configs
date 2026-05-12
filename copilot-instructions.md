# Global Copilot Instructions

These instructions apply to all repositories via ~/.copilot/copilot-instructions.md.

## PowerShell Conventions

- Target PowerShell 7+ (`pwsh`) unless explicitly noted for Windows PowerShell 5.x
- Use `$ErrorActionPreference = 'Stop'` in scripts that should fail fast
- Suppress expected errors with `-ErrorAction SilentlyContinue` or `2>&1 | Out-Null`
- Prefer splatting (`@params`) for commands with many parameters
- Use `[CmdletBinding()]` and `param()` blocks for reusable functions

## Git Workflow

- Default branch names to check: `main`, `master`, `develop` (in that priority order)
- Push with upstream tracking: `git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)`
- Use `git fetch origin "branch:branch"` to update local tracking branches without checkout

## Environment

- Windows-first development environment
- Package managers: scoop (CLI tools), winget (GUI apps), npm/yarn (JS)
- Node version management via `nvs`
- Editor: Neovim (`nvim`) aliased as `vi`
- Fuzzy finding: `fzf` for interactive selection, `zlocation` for directory jumping (`j`/`z`)

## Code Style

- Keep shell functions short and composable
- Use `Write-Host` for user-facing output, `Write-Output` for pipeline output
- Prefer early returns over deep nesting
