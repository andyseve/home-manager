# Home Manager Config

## Neovim
- Core mappings live in `modules/nvim/config/lua/core/keymaps.lua`.
- Feature-specific mappings live in `modules/nvim/config/lua/setup/*.lua`.
- Use `utils.load_mappings(...)` from `modules/nvim/config/lua/core/utils.lua` so `mini.clue` hints stay in sync.
- `mini.clue` is configured in `modules/nvim/config/lua/config/mini/clue.lua` and pulls clues from `utils.get_mapping_clues()`.
