---@alias LowbeamStyleName "day"|"dusk"|"night"|"dark"
---@alias LowbeamResolvedStyleName "day"|"dusk"|"night"
---@alias LowbeamBackground "light"|"dark"

---@class LowbeamHighlight
---@field fg? string
---@field bg? string
---@field sp? string
---@field bold? boolean
---@field standout? boolean
---@field underline? boolean
---@field undercurl? boolean
---@field underdouble? boolean
---@field underdotted? boolean
---@field underdashed? boolean
---@field strikethrough? boolean
---@field italic? boolean
---@field reverse? boolean
---@field nocombine? boolean
---@field link? string
---@field default? boolean
---@field blend? integer
---@field ctermfg? string|integer
---@field ctermbg? string|integer
---@field cterm? table|string

---@alias LowbeamHighlightGroups table<string, LowbeamHighlight>

---@class LowbeamPalette
---@field background LowbeamBackground
---@field none string
---@field bg string
---@field bg_alt string
---@field bg_soft string
---@field bg_float string
---@field bg_visual string
---@field bg_search string
---@field fg string
---@field fg_muted string
---@field fg_subtle string
---@field fg_faint string
---@field comment string
---@field border string
---@field shadow string
---@field keyword string
---@field func string
---@field type string
---@field string string
---@field constant string
---@field red string
---@field amber string
---@field blue string
---@field green string
---@field diff_add string
---@field diff_change string
---@field diff_delete string
---@field diff_text string

---@alias LowbeamPaletteOverride table<string, string>
---@alias LowbeamHighlightOverride false|LowbeamHighlight|fun(colors: LowbeamPalette, opts: LowbeamOptions, groups: LowbeamHighlightGroups): LowbeamHighlight|false|nil
---@alias LowbeamPaletteHook fun(colors: LowbeamPalette, style: LowbeamResolvedStyleName, opts: LowbeamOptions): LowbeamPalette|nil
---@alias LowbeamHighlightsHook fun(groups: LowbeamHighlightGroups, colors: LowbeamPalette, opts: LowbeamOptions): LowbeamHighlightGroups|nil

---@class LowbeamStyleOptions
---@field comments LowbeamHighlight
---@field keywords LowbeamHighlight
---@field functions LowbeamHighlight
---@field types LowbeamHighlight
---@field strings LowbeamHighlight

---@class LowbeamStyleOptionsInput
---@field comments? LowbeamHighlight
---@field keywords? LowbeamHighlight
---@field functions? LowbeamHighlight
---@field types? LowbeamHighlight
---@field strings? LowbeamHighlight

---@class LowbeamPaletteOverrides
---@field all LowbeamPaletteOverride
---@field day LowbeamPaletteOverride
---@field dusk LowbeamPaletteOverride
---@field night LowbeamPaletteOverride
---@field dark LowbeamPaletteOverride

---@class LowbeamPaletteOverridesInput
---@field all? LowbeamPaletteOverride
---@field day? LowbeamPaletteOverride
---@field dusk? LowbeamPaletteOverride
---@field night? LowbeamPaletteOverride
---@field dark? LowbeamPaletteOverride

---@class LowbeamIntegrationOptions
---@field treesitter boolean
---@field lsp boolean
---@field telescope boolean
---@field nvim_tree boolean
---@field neo_tree boolean
---@field gitsigns boolean
---@field cmp boolean
---@field which_key boolean
---@field lazy boolean
---@field snacks boolean

---@class LowbeamIntegrationOptionsInput
---@field treesitter? boolean
---@field lsp? boolean
---@field telescope? boolean
---@field nvim_tree? boolean
---@field neo_tree? boolean
---@field gitsigns? boolean
---@field cmp? boolean
---@field which_key? boolean
---@field lazy? boolean
---@field snacks? boolean

---@class LowbeamOptions
---@field style LowbeamStyleName
---@field transparent boolean
---@field styles LowbeamStyleOptions
---@field semantic_tokens boolean
---@field dim_inactive boolean
---@field palettes LowbeamPaletteOverrides
---@field highlights table<string, LowbeamHighlightOverride>
---@field on_palette? LowbeamPaletteHook
---@field on_highlights? LowbeamHighlightsHook
---@field integrations LowbeamIntegrationOptions

---@class LowbeamUserConfig
---@field style? LowbeamStyleName
---@field transparent? boolean
---@field styles? LowbeamStyleOptionsInput
---@field semantic_tokens? boolean
---@field dim_inactive? boolean
---@field palettes? LowbeamPaletteOverridesInput
---@field highlights? table<string, LowbeamHighlightOverride>
---@field on_palette? LowbeamPaletteHook
---@field on_highlights? LowbeamHighlightsHook
---@field integrations? LowbeamIntegrationOptionsInput

---@class LowbeamConfigModule
---@field defaults LowbeamOptions
---@field options LowbeamOptions
---@field merge fun(dst: table, src?: table): table
---@field setup fun(opts?: LowbeamUserConfig)
---@field extend fun(opts?: LowbeamUserConfig)
---@field get fun(overrides?: LowbeamUserConfig): LowbeamOptions

---@type LowbeamConfigModule
local M = {}

---@type LowbeamOptions
M.defaults = {
  -- Default style used by :colorscheme lowbeam.
  -- Variant entry points are also available:
  -- :colorscheme lowbeam-day
  -- :colorscheme lowbeam-dusk
  -- :colorscheme lowbeam-night
  -- :colorscheme lowbeam-dark
  style = "day",

  transparent = false,

  -- Keep the theme calm by default. Users who rely on font style as a parsing
  -- aid can enable these without changing the palette.
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    types = {},
    strings = {},
  },

  -- Semantic token highlights can make TypeScript feel noisy in some setups.
  -- Keep them on, but map them back into the same restrained five hue roles.
  semantic_tokens = true,

  -- Inactive windows stay readable, just quieter.
  dim_inactive = false,

  -- Palette extension points. `all` applies to every style, and style-specific
  -- keys apply after `all`.
  palettes = {
    all = {},
    day = {},
    dusk = {},
    night = {},
    dark = {},
  },

  -- Direct highlight overrides. Values may be a highlight spec table, a function
  -- returning a spec table, or false to remove a group.
  highlights = {},

  -- Callback hooks for public extension without forking the theme.
  -- on_palette(colors, style, opts) may mutate and/or return a colors table.
  -- on_highlights(groups, colors, opts) may mutate and/or return a groups table.
  on_palette = nil,
  on_highlights = nil,

  -- Leave integrations on by default; unknown groups are ignored by Neovim.
  integrations = {
    treesitter = true,
    lsp = true,
    telescope = true,
    nvim_tree = true,
    neo_tree = true,
    gitsigns = true,
    cmp = true,
    which_key = true,
    lazy = true,
    snacks = true,
  },
}

M.options = vim.deepcopy(M.defaults)

---@generic T: table
---@param dst T
---@param src? table
---@return T
function M.merge(dst, src)
  if type(src) ~= "table" then
    return dst
  end

  for key, value in pairs(src) do
    if type(value) == "table" and type(dst[key]) == "table" then
      M.merge(dst[key], value)
    else
      dst[key] = value
    end
  end

  return dst
end

---@param opts? LowbeamUserConfig
function M.setup(opts)
  M.options = M.merge(vim.deepcopy(M.defaults), opts or {})
end

---@param opts? LowbeamUserConfig
function M.extend(opts)
  M.options = M.merge(vim.deepcopy(M.options), opts or {})
end

---@param overrides? LowbeamUserConfig
---@return LowbeamOptions
function M.get(overrides)
  return M.merge(vim.deepcopy(M.options), overrides or {})
end

return M