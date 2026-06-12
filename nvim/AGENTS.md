# Neovim Config Agent Notes

This file is a maintenance guide for agents editing this Neovim config.
It is not a changelog and not a prose copy of the Lua config.

The Lua files are the source of truth. Use this document to understand where to look, which docs to check, how the config is launched, and how to verify changes.

## Ground Rules

- Prefer LazyVim extras and plugin-native configuration over custom Lua.
- Read docs or installed plugin source before changing LazyVim, LSP, formatting, linting, Snacks, or persistence behavior.
- Keep changes small, local, and boring.
- Do not duplicate exact settings here unless the reason behind them matters.
- Do not add private names, private project names, or absolute machine-specific paths. This repo may be public.

## Repo Map

- `lazyvim.json`: enabled LazyVim extras.
- `init.lua`: Neovim entrypoint.
- `lua/config/options.lua`: editor options and LazyVim globals.
- `lua/config/autocmds.lua`: local editor lifecycle hooks.
- `lua/config/keymaps.lua`: local keymaps.
- `lua/plugins/*.lua`: plugin specs and plugin overrides.

When adding behavior, first look for the nearest existing LazyVim/plugin pattern in these files.

## Config Location

Neovim should load this directory through the standard config path:

```sh
$HOME/.config/nvim
```

That path is expected to be a symlink to the repo's `nvim/` directory.

Useful checks:

```sh
readlink "$HOME/.config/nvim"
nvim --headless some-file '+lua print(vim.uv.fs_realpath(vim.fn.stdpath("config")))' '+qa!'
```

## Docs To Check First

- LazyVim docs: https://www.lazyvim.org/
- LazyVim formatting: https://www.lazyvim.org/plugins/formatting
- LazyVim recipes: https://www.lazyvim.org/configuration/recipes
- LazyVim persistence: https://www.lazyvim.org/plugins/util#persistencenvim
- nvim-lspconfig ESLint: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#eslint
- persistence.nvim: https://github.com/folke/persistence.nvim
- snacks.nvim: https://github.com/folke/snacks.nvim
- conform.nvim: https://github.com/stevearc/conform.nvim

Installed plugin source is often the fastest truth when docs are vague:

```sh
~/.local/share/nvim/lazy
```

## Launch Shapes

Test the same launch shape that the behavior depends on.

```sh
nvim
nvim .
nvim some-directory
nvim path/to/file.ts
```

Important distinction:

- `nvim` has no explicit target.
- `nvim .` is a directory launch and is the common project-entry workflow.
- `nvim some-file.ts` is an explicit file launch and should not be hijacked by startup/session logic.

Do not rely only on headless Neovim for startup UI behavior. Dashboard, explorer, focus, and session restore issues need a real TUI check.

## Formatting And Linting

Start from LazyVim extras, Conform, Mason, and LSP state before adding hooks.

Useful commands inside Neovim:

```vim
:LspInfo
:ConformInfo
:Mason
:Lazy
:checkhealth
```

For JS/TS projects:

- Check `.js`, `.jsx`, `.ts`, and `.tsx`.
- Prettier should normally be project-config-aware, not forced globally.
- ESLint can be attached as an LSP client without being an active formatter.
- If ESLint fixes are needed and formatter-based integration is not active, use the documented `LspEslintFixAll` command path rather than inventing a custom fixer.

## Autosave

Desired behavior is ordinary editor autosave: save on focus loss or when leaving insert mode.

Reasonable hooks:

- `FocusLost`
- `InsertLeave`

Avoid `TextChanged`; it is too noisy and can cause excessive format/lint attempts.

If a save hook formats or fixes first, make sure the final write does not recursively trigger the same save flow. `noautocmd update` can be appropriate after the intended format/fix step has already run.

## Session Restore

LazyVim includes `folke/persistence.nvim`. Prefer its API and documented behavior.

Think in terms of launch intent:

- no args: restore the last useful session
- directory arg: restore that directory's session
- file arg: open that file directly

Startup ordering matters. Snacks dashboard/explorer and persistence can race visually. Verification should prove the final focused editor window, not only that a restore function was called.

## When Custom Hooks Are Worth It

Custom Lua hooks are acceptable when they adapt a documented plugin capability to a user workflow LazyVim does not cover directly.

Good reasons:

- wire a documented plugin command into save flow
- adapt session restore to `nvim .`
- preserve a concrete workflow after the normal LazyVim path has been checked

Bad reasons:

- reimplement a LazyVim extra
- duplicate plugin defaults
- hide one local behavior behind a broad abstraction
- solve a missing dependency/config problem with more Lua

## Verification Playbooks

Use the smallest check that proves the behavior.

Formatting/autosave:

- use a disposable temp project
- include local ESLint/Prettier config when the behavior depends on it
- test `.js`, `.jsx`, `.ts`, and `.tsx`
- verify the file contents changed after save, not only that commands exist

Session restore:

- use a disposable temp directory
- create a real persistence session
- launch with a real TUI using the same command shape, especially `nvim .`
- write the final buffer/window state to a temp marker file from inside Neovim
- clean up the disposable session afterwards

General health:

```sh
nvim --headless '+checkhealth' '+qa!'
nvim --headless '+Lazy! sync' '+qa!'
```

Avoid killing running Neovim processes unless explicitly asked. If swap warnings appear, inspect the process list and explain the situation.
