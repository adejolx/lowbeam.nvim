# Forking Lowbeam

Lowbeam is public source, but it is not run as an open contribution project.

Pull requests are not accepted. If you want to change the palette, add plugin
support, or take the theme in a different direction, please fork the project and
maintain your version independently.

## Why

Lowbeam has a narrow design target:

- dim off-white light variants
- a dark analog with the same semantic role model
- non-pastel syntax colors
- a small number of syntax hues
- comments that recede below normal code
- diagnostics and diffs kept separate from normal syntax

Accepting palette changes through pull requests would make the theme drift toward
the same problem it is trying to avoid: too many competing preferences and too
many token colors.

## What is still supported

Users can still customize Lowbeam locally through the public extension API:

- `palettes`
- `highlights`
- `on_palette`
- `on_highlights`
- `integrations`

That means you can tune your local setup without needing the upstream theme to
change.

## Recommended path for changes

1. Fork the repository.
2. Rename the theme if your fork changes the visual identity substantially.
3. Keep the MIT license notice.
4. Document your own palette goals clearly.
