# Screenshot guide

Use this when taking clean screenshots for the README or release notes.


## Current README screenshots

The screenshots committed in `extras/screenshots` are real Neovim captures.
`lowbeam-dark.png` intentionally mirrors `lowbeam-night.png` because `lowbeam-dark`
is an alias entry point for the night palette.

## Clean the editor UI

Run this before capturing a preview buffer:

```vim
:lua vim.diagnostic.enable(false); vim.o.number = false; vim.o.relativenumber = false; vim.o.signcolumn = "no"; vim.o.cursorline = false
```

This hides diagnostics, line numbers, the sign column, and the cursor line so the
screenshot shows the palette rather than editor noise.

If you prefer to keep diagnostics technically enabled but hide their UI, use:

```vim
:lua vim.diagnostic.config({ virtual_text = false, virtual_lines = false, signs = false, underline = false })
```

## Restore diagnostics

```vim
:lua vim.diagnostic.enable(true); vim.diagnostic.config({ virtual_text = true, signs = true, underline = true })
```

## Capture each variant

```vim
:edit extras/preview-sample.ts
:colorscheme lowbeam-day
:colorscheme lowbeam-dusk
:colorscheme lowbeam-night
:colorscheme lowbeam-dark
```

## Suggested terminal setup

- Use a monospace font at the size you normally code with.
- Disable terminal transparency for the capture.
- Keep the same font and window size for every variant.
- Capture the same file and scroll position for each image.
