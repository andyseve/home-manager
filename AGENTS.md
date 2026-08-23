# Repository Guidelines

## Project Purpose
- This repository is a Home Manager configuration, but it is also a collection of portable user-environment modules.
- The main flake should define complete `homeConfigurations` for known hosts.
- The root flake should expose named `homeModules` for persistent imports and named `packages`/`apps` for temporary use.
- Preserve the ability to run one focused environment, especially zsh or nvim, on a remote machine without activating the full personal profile.
- Long term, this Home Manager configuration may be integrated into a NixOS/nix-darwin flake, but user-level configuration should remain implemented as Home Manager modules.

## Project Structure & Module Organization
- `flake.nix` / `flake.lock`: Single flake entry point. It exposes full `homeConfigurations`, importable `homeModules`, and temporary `packages`/`apps`.
- `modules/default.nix`: Full user profile entry point. It sets user/home basics and imports the normal module set.
- `modules/<name>/`: Program-specific Home Manager modules and their related dotfiles or config trees.
- `modules/zsh/`: Zsh Home Manager module and zsh config files.
- `modules/nvim/`: Neovim module and Lua config.
- `modules/kitty/`: Kitty terminal module and config.
- `treefmt.nix`: Formatter configuration using deadnix and nixfmt.
- Keep new program-specific modules under `modules/<name>/` and wire them into the full profile through `modules/default.nix`.

## Portable Output Design
- Keep one root flake rather than creating a flake and lockfile under every program directory.
- Export persistent configurations as named modules such as `homeModules.zsh` and `homeModules.nvim`. These are intended to be imported by another Home Manager, NixOS, or nix-darwin flake.
- Export temporary tools as named packages and apps such as `packages.<system>.zsh` and `apps.<system>.zsh`.
- `nix run github:andyseve/home-manager#zsh` should enter a configured zsh without activating Home Manager or changing the user's profile.
- `nix run github:andyseve/home-manager#nvim -- <files>` should launch Neovim with this repository's config.
- `nix shell github:andyseve/home-manager#zsh --command zsh` is the package-oriented alternative when a temporary PATH environment is desired.
- Do not add a module-local flake merely to make a module importable. Add one only when the directory genuinely needs independent inputs, versioning, or release lifecycle.
- A focused Home Manager module should not assume `modules/default.nix` is imported. Declare its own packages, files, options, and session variables.
- A runnable app should include its runtime dependencies and keep mutable cache/history/plugin state outside the immutable store config.

## Home Manager vs System Flakes
- Use NixOS/nix-darwin for machine-level concerns: system packages, valid login shells, services, platform defaults, and host-specific OS configuration.
- Use Home Manager for user-level concerns: shell config, editor config, terminal config, dotfiles, aliases, prompts, user packages, and files under `$HOME`.
- If Home Manager is integrated into a NixOS/nix-darwin flake later, keep these modules as Home Manager modules rather than moving personal configuration into the system layer.
- Prefer one coordinated lockfile eventually, but preserve the ability to run focused Home Manager modules independently.

## Live Dotfile Editing & Symlink Policy
- Some modules need fast local editing of dotfiles, especially zsh and nvim.
- The intended behavior is:
  - If a local checkout exists on the machine, link the active config path to that checkout so edits are live immediately.
  - If the module is fetched remotely, such as with `git+ssh`, and no local checkout exists, fall back to normal store-backed Home Manager symlinks.
- Runnable apps should follow the same source-selection rule: use the known checkout when valid, otherwise run from the flake's store-backed config.
- Do not depend on detecting whether the flake was fetched by SSH inside pure Nix evaluation. Prefer activation-time checks for a known local checkout path.
- For mutable config directories, keep both sources available:
  - `storeSource = ./config` for the immutable Nix store copy.
  - `localSource = "${config.home.homeDirectory}/.config/home-manager/modules/<name>/config"` for fast local edits when present.
- Activation logic should choose `localSource` only when it exists and looks valid, otherwise use `storeSource`.
- Keep generated runtime files out of the repository. For zsh, ignore cache/history/session files such as `.zcompdump*`, `zsh_history`, `.zcalc_history`, and `.zsh_sessions/`.

## Build, Test, and Development Commands
- `nix fmt`: Format Nix files via treefmt.
- `nix flake check`: Evaluate flake outputs and run flake checks.
- `home-manager switch --flake .#<hostname>`: Apply the full config to the active user. Replace `<hostname>` with an entry from `hostnames` in `flake.nix`.
- `home-manager switch --flake .#<hostname> --dry-run`: Validate a full Home Manager activation without applying it.
- `nix run .#zsh`: Enter zsh with the portable config.
- `nix run .#nvim -- <files>`: Run Neovim with the portable config.
- `nix develop`: Enter the dev shell when available from inherited inputs.

## Coding Style & Naming Conventions
- Nix: Use nixfmt defaults; prefer concise attr sets and explicit `inherit` use.
- Keep modules small, composable, and focused on one program or workflow.
- Name files after the program or concern they configure, for example `modules/git/git.nix`.
- Prefer packaged versions from nixpkgs for plugins and extensions. Use fetched sources only when necessary.
- Add succinct comments only when they clarify non-obvious module behavior, especially activation-time symlink logic.

## Neovim
- Mapping sources: core mappings live in `modules/nvim/config/lua/core/keymaps.lua`; feature-specific mappings live in `modules/nvim/config/lua/setup/*.lua`.
- Keymap registration: use `utils.load_mappings(...)` from `modules/nvim/config/lua/core/utils.lua` so descriptions and prefixes are collected.
- Hinting system: `mini.clue` consumes mapping metadata via `utils.get_mapping_clues()` in `modules/nvim/config/lua/config/mini/clue.lua`.
- When adding new keybinds, prefer `setup/*.lua` plus `utils.load_mappings` to keep clue hints accurate.
- Mini transition: mini.nvim is the default for UI and QoL utilities; prefer mini modules for these categories and avoid non-mini alternatives unless there is a clear gap.
- Mini toggles live in `modules/nvim/config/lua/core/user.lua`, specs in `modules/nvim/config/lua/plugins/init.lua`, and module config in `modules/nvim/config/lua/config/mini/`.

## Testing Guidelines
- Primary checks are declarative: `nix flake check` and `home-manager switch --flake ... --dry-run`.
- Add module-specific sanity assertions when introducing risky options.
- For symlink or activation changes, verify both paths when practical:
  - local checkout present, config links to the checkout;
  - no local checkout, config links to the store source.
- For focused modules, test that they evaluate without importing the full personal profile.
- For runnable outputs, test `nix run .#<name>` or a non-interactive equivalent and confirm the local/store source selection.

## Commit & Pull Request Guidelines
- No strict commit convention is enforced. Prefer short, imperative subjects such as `Add zsh fallback link` or `Wire kitty module`.
- In PRs, describe the intent, list modules touched, and note manual steps such as `home-manager switch`.
- Include screenshots or logs only for user-visible changes such as prompt, terminal, or editor UI changes.

## Security & Configuration Tips
- Avoid embedding secrets in Nix.
- Reference external secret files only through explicit paths or a future age/sops integration.
- Be careful with remote-machine workflows: standalone modules should be convenient, but they should not silently copy credentials or private local state.
