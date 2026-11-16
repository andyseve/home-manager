# Home Manager configuration

This flake exposes complete Home Manager configurations, reusable modules, and focused runnable environments.

## Full profile

```sh
home-manager switch --flake .#<hostname>
```

## Reusable modules

The root flake exports `homeModules.default`, `homeModules.zsh`, `homeModules.nvim`, `homeModules.kitty`, and `homeModules.vscode` for use from other Home Manager, NixOS, or nix-darwin flakes.

## Temporary environments

Run the configured shell or editor without activating the full profile:

```sh
nix run .#zsh
nix run .#nvim -- <files>
```

When this repository exists at `~/.config/home-manager`, the runnable apps and Home Manager activation use its config files so edits are live. Remote flake consumers fall back to the immutable store-backed copies.
