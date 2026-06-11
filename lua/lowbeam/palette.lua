local config = require("lowbeam.config")

---@class LowbeamPaletteModule
---@field styles table<LowbeamResolvedStyleName, LowbeamPalette>
---@field aliases table<string, LowbeamResolvedStyleName>
---@field normalize_style fun(style?: LowbeamStyleName|string): LowbeamResolvedStyleName
---@field get fun(style?: LowbeamStyleName|string, opts?: LowbeamOptions): LowbeamPalette, LowbeamResolvedStyleName

---@type LowbeamPaletteModule
local M = {}

--- Lowbeam is deliberately restrained.
---
--- The syntax palette has five semantic hues:
--- - keyword
--- - function
--- - type
--- - string
--- - constant
---
--- The colors are not pastel. They are saturated enough to distinguish semantic
--- roles at small font sizes, while staying limited to a few intentional hues.
--- The light canvas is dim off-white rather than brown/sepia. The dark analog
--- keeps the same hue relationships on a low-glare charcoal surface.
---
--- Everything else should lean neutral unless it communicates editor state,
--- diagnostics, search, or diffs.
---@type table<LowbeamResolvedStyleName, LowbeamPalette>
M.styles = {
  day = {
    background = "light",
    none = "NONE",

    bg = "#DADCD6",
    bg_alt = "#CDD0C9",
    bg_soft = "#C1C5BE",
    bg_float = "#E1E3DD",
    bg_visual = "#B6BFC4",
    bg_search = "#BCAE71",

    fg = "#101311",
    fg_muted = "#333A34",
    fg_subtle = "#454D45",
    fg_faint = "#656F65",
    comment = "#747D73",

    border = "#98A195",
    shadow = "#879286",

    keyword = "#5A2CC7",
    func = "#005F84",
    type = "#00672C",
    string = "#735F00",
    constant = "#A83200",

    red = "#A01822",
    amber = "#6A5300",
    blue = "#005F84",
    green = "#00672C",

    diff_add = "#AFB98F",
    diff_change = "#B9AA76",
    diff_delete = "#BE9C90",
    diff_text = "#A58D44",
  },

  dusk = {
    background = "light",
    none = "NONE",

    bg = "#CBCDC6",
    bg_alt = "#BEC2BA",
    bg_soft = "#B2B8AF",
    bg_float = "#D3D5CE",
    bg_visual = "#AAB4BA",
    bg_search = "#AA9C61",

    fg = "#0D100E",
    fg_muted = "#303730",
    fg_subtle = "#404840",
    fg_faint = "#5F695E",
    comment = "#687268",

    border = "#8B9689",
    shadow = "#7D897A",

    keyword = "#4B20B2",
    func = "#005878",
    type = "#005F27",
    string = "#665100",
    constant = "#982D00",

    red = "#94151F",
    amber = "#5E4900",
    blue = "#005878",
    green = "#005F27",

    diff_add = "#9DAA7C",
    diff_change = "#AA9A66",
    diff_delete = "#AD8B80",
    diff_text = "#927D3A",
  },

  night = {
    background = "dark",
    none = "NONE",

    bg = "#181A18",
    bg_alt = "#20231F",
    bg_soft = "#2A2E28",
    bg_float = "#1F221F",
    bg_visual = "#333A38",
    bg_search = "#594E27",

    fg = "#E9EDE4",
    fg_muted = "#C4CCC0",
    fg_subtle = "#AAB4A7",
    fg_faint = "#899486",
    comment = "#7F8A7C",

    border = "#4A5549",
    shadow = "#0C0E0C",

    keyword = "#C09CFF",
    func = "#43D2FF",
    type = "#5FD875",
    string = "#E7C547",
    constant = "#FF945A",

    red = "#FF7A7A",
    amber = "#F2C85B",
    blue = "#43D2FF",
    green = "#5FD875",

    diff_add = "#243421",
    diff_change = "#39311D",
    diff_delete = "#3A2420",
    diff_text = "#544624",
  },
}

---@type table<string, LowbeamResolvedStyleName>
M.aliases = {
  dark = "night",
}

---@param style? LowbeamStyleName|string
---@return LowbeamResolvedStyleName
function M.normalize_style(style)
  local raw_style = style or "day"
  local normalized_style = M.aliases[raw_style] or raw_style

  if M.styles[normalized_style] == nil then
    return "day"
  end

  return normalized_style
end

---@param style? LowbeamStyleName|string
---@param opts? LowbeamOptions
---@return LowbeamPalette colors
---@return LowbeamResolvedStyleName normalized_style
function M.get(style, opts)
  opts = opts or {}

  local normalized_style = M.normalize_style(style)
  local colors = vim.deepcopy(M.styles[normalized_style])
  local palettes = opts.palettes or {}

  config.merge(colors, palettes.all or {})
  config.merge(colors, palettes[normalized_style] or {})

  if style ~= nil and style ~= normalized_style then
    config.merge(colors, palettes[style] or {})
  end

  if type(opts.on_palette) == "function" then
    local next_colors = opts.on_palette(colors, normalized_style, opts)

    if type(next_colors) == "table" then
      colors = next_colors
    end
  end

  return colors, normalized_style
end

return M