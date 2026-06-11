# Contrast notes

The palette is intentionally **not pastel**. The current direction uses a dim
off-white light canvas, quiet comments, and brighter/saturated syntax hues so
semantic roles remain distinguishable at smaller font sizes.

The theme should not feel like a rainbow: the syntax palette is still limited to
five roles. The difference is that those five roles now have more chroma and
clearer hue separation.

Backgrounds:

- `day.bg`: `#DADCD6`
- `dusk.bg`: `#CBCDC6`
- `night.bg`: `#181A18`


## Variant entry points

The theme can be loaded directly by variant:

- `:colorscheme lowbeam-day`
- `:colorscheme lowbeam-dusk`
- `:colorscheme lowbeam-night`
- `:colorscheme lowbeam-dark`

These entry points select only the variant. They should preserve user extension
options from `setup()`, including palette and highlight overrides.

## Comment prominence

Comments intentionally sit below normal code and syntax contrast.

Approximate comment contrast:

- `day.comment` `#747D73` on `#DADCD6`: ~3.09:1
- `dusk.comment` `#687268` on `#CBCDC6`: ~3.12:1
- `night.comment` `#7F8A7C` on `#181A18`: ~4.86:1

This is deliberate: comments should be readable when you look at them, but they
should not compete with code structure while scanning.

## Day style

Approximate contrast ratios against `day.bg` (`#DADCD6`):

- fg `#101311`: ~13.52:1
- fg_muted `#333A34`: ~8.46:1
- fg_subtle `#454D45`: ~6.33:1
- fg_faint `#656F65`: ~3.78:1
- comment `#747D73`: ~3.09:1
- keyword `#5A2CC7`: ~5.80:1
- function `#005F84`: ~5.11:1
- type `#00672C`: ~5.10:1
- string `#735F00`: ~4.51:1
- constant `#A83200`: ~4.87:1
- diagnostic red `#A01822`: ~5.74:1
- diagnostic amber `#6A5300`: ~5.33:1
- diagnostic blue `#005F84`: ~5.11:1
- diagnostic green `#00672C`: ~5.10:1

## Dusk style

Approximate contrast ratios against `dusk.bg` (`#CBCDC6`):

- fg `#0D100E`: ~11.92:1
- fg_muted `#303730`: ~7.63:1
- fg_subtle `#404840`: ~5.90:1
- fg_faint `#5F695E`: ~3.57:1
- comment `#687268`: ~3.12:1
- keyword `#4B20B2`: ~6.09:1
- function `#005878`: ~4.91:1
- type `#005F27`: ~4.91:1
- string `#665100`: ~4.77:1
- constant `#982D00`: ~4.83:1
- diagnostic red `#94151F`: ~5.48:1
- diagnostic amber `#5E4900`: ~5.39:1
- diagnostic blue `#005878`: ~4.91:1
- diagnostic green `#005F27`: ~4.91:1

## Night style

Approximate contrast ratios against `night.bg` (`#181A18`):

- fg `#E9EDE4`: ~14.75:1
- fg_muted `#C4CCC0`: ~10.62:1
- fg_subtle `#AAB4A7`: ~8.16:1
- fg_faint `#899486`: ~5.54:1
- comment `#7F8A7C`: ~4.86:1
- keyword `#C09CFF`: ~7.87:1
- function `#43D2FF`: ~9.92:1
- type `#5FD875`: ~9.64:1
- string `#E7C547`: ~10.40:1
- constant `#FF945A`: ~8.03:1
- diagnostic red `#FF7A7A`: ~6.93:1
- diagnostic amber `#F2C85B`: ~10.99:1
- diagnostic blue `#43D2FF`: ~9.92:1
- diagnostic green `#5FD875`: ~9.64:1

`fg_faint` and `comment` are intentionally weaker than body text and should not
be reused for primary code tokens.
