# Repository Guidelines

## Project Purpose
- This repository is both a complete Home Manager configuration and a collection of portable user-environment modules.
- The root flake defines full `homeConfigurations`, reusable `homeModules`, and focused `packages`/`apps`.
- Preserve the ability to run zsh or Neovim on a remote machine without activating the full personal profile.
- Keep user-level configuration in Home Manager modules if this repository is later integrated into NixOS or nix-darwin.

## Project Structure & Module Organization
- `flake.nix` / `flake.lock`: Single flake entry point for complete profiles and portable outputs.
- `modules/default.nix`: Full user profile entry point and normal module imports.
- `modules/<name>/`: Program-specific Home Manager modules and related configuration trees.
- `modules/zsh/`: Zsh module and shell configuration.
- `modules/nvim/`: Neovim module and Lua configuration.
- `modules/kitty/`: Kitty terminal module and configuration.
- `treefmt.nix`: Formatter configuration using deadnix and nixfmt.
- Put new program-specific modules under `modules/<name>/` and import them from `modules/default.nix` when they belong in the full profile.

## Portable Output Design
- Keep one root flake rather than creating module-local flakes and lockfiles.
- Export persistent configurations as named modules such as `homeModules.zsh` and `homeModules.nvim`.
- Export temporary environments as named packages and apps such as `packages.<system>.zsh` and `apps.<system>.nvim`.
- Focused modules must declare their own packages, files, options, and session variables rather than assuming `modules/default.nix` is imported.
- Runnable apps must include their runtime dependencies and keep mutable cache, history, and plugin state outside immutable store-backed configuration.

## Live Dotfile Editing & Symlink Policy
- If a checkout exists at `~/.config/home-manager`, activation should link active configuration to it so edits are immediately visible.
- If no checkout exists, such as when importing the flake remotely, activation must fall back to the store-backed module configuration.
- Do not try to detect how the flake was fetched during pure evaluation. Select the source during activation by checking a known local checkout path.
- Keep both `storeSource = ./config` and a home-relative `localSource` available for mutable configuration directories.
- Keep runtime files out of the repository. This includes Zsh completion dumps, history, calculator history, and session directories.

## Build, Test, and Development Commands
- `nix fmt`: Format Nix files through treefmt.
- `nix flake check`: Evaluate flake outputs and checks.
- `home-manager switch --flake .#<hostname>`: Apply a complete profile.
- `home-manager switch --flake .#<hostname> --dry-run`: Validate activation without applying it.
- `nix run .#zsh`: Enter the portable configured shell.
- `nix run .#nvim -- <files>`: Run the portable Neovim configuration.
- `nix develop`: Enter the inherited development shell when available.

## Coding Style & Naming Conventions
- Use nixfmt defaults, concise attribute sets, and explicit `inherit` statements.
- Keep modules small, composable, and focused on one program or workflow.
- Name files after the program or concern they configure, such as `modules/git/git.nix`.
- Prefer packaged versions from nixpkgs for plugins and extensions.
- Add comments only when they clarify non-obvious behavior, especially activation-time source selection.

## Testing Guidelines
- Primary checks are `nix flake check` and a Home Manager dry run.
- Add module-specific assertions when introducing risky options.
- Evaluate focused modules without importing the full personal profile.
- Test runnable outputs with `nix run .#<name>` or a non-interactive equivalent.
- For source-selection changes, verify both a valid local checkout and the store-backed fallback when practical.

## Commit & Pull Request Guidelines
- Prefer short, imperative commit subjects such as `Expose portable flake outputs` or `Add zsh store fallback`.
- In pull requests, describe the intent, list affected modules, and note manual steps such as `home-manager switch`.
- Include screenshots or logs only for user-visible changes such as the prompt, terminal, or editor UI.

## Security & Configuration Tips
- Do not embed secrets in Nix or copy credentials into standalone modules.
- Reference external secret files through explicit paths or a future age/sops integration.
- Keep remote-machine workflows convenient without silently transferring private local state.
