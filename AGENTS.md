# Repository Guidelines

## Project Structure & Module Organization
- `flake.nix` / `flake.lock`: Entry point for Home Manager configs; follows nixos-config inputs. Use `homeConfigurations` attr.
- `modules/`: Home Manager modules. `modules/default.nix` sets user/home basics. `modules/vscode/` holds VS Code module. `modules/zsh/` contains Zsh subflake plus dotfiles (`.zshrc`, `.zshenv`, `p10k.zsh`) wired via out-of-store symlinks for live edits.
- `treefmt.nix`: Formatter configuration (deadnix + nixfmt).
- Keep new program-specific modules under `modules/<name>/` and wire them in via the main `modules/default.nix` list using `inputs.nixos-config.utils.listModules`.

## Build, Test, and Development Commands
- `nix fmt`: Format Nix files via treefmt (uses nixfmt + deadnix).
- `nix flake check`: Evaluate flake outputs and run flake checks.
- `home-manager switch --flake .#<hostname>`: Apply config to the active user. Replace `<hostname>` with one from `hostnames` in `flake.nix`.
- `nix develop`: Enter dev shell (if defined in nixos-config inputs) to get consistent tooling.

## Coding Style & Naming Conventions
- Nix: Use nixfmt defaults; prefer concise attr sets and explicit `inherit` use. Keep modules small and composable.
- File layout: One module per file; name files after the program (`modules/git/git.nix`, etc.).
- Symlinks: For live dotfile edits, use `config.lib.file.mkOutOfStoreSymlink` and point to files in the repo (see `modules/zsh/flake.nix`).

## Testing Guidelines
- Primary checks are declarative: `nix flake check` and `home-manager switch --flake ... --dry-run` before applying.
- Add module-specific sanity assertions (e.g., `assertions = [ { assertion = ...; message = "..."; } ];`) when introducing risky options.

## Commit & Pull Request Guidelines
- No strict convention enforced; prefer short, imperative subjects (`Add zsh plugins`, `Wire VS Code module`). Include scope when helpful.
- In PRs: describe the intent, list modules touched, and note any manual steps (e.g., `home-manager switch` required) or symlinked dotfiles added. Screenshots/logs only if the change is user-visible (e.g., prompt theme).

## Security & Configuration Tips
- Avoid embedding secrets in Nix; reference external files via `mkOutOfStoreSymlink` or use age/sops if integrating later.
- When adding plugins or extensions, prefer packaged versions from nixpkgs to reduce supply-chain risk; fall back to fetched sources only when necessary.***
