local config = require("lowbeam.config")
local palette = require("lowbeam.palette")
local groups = require("lowbeam.groups")

---@class LowbeamLoadOptions : LowbeamUserConfig
---@field name? string

---@class LowbeamModule
---@field setup fun(opts?: LowbeamUserConfig)
---@field extend fun(opts?: LowbeamUserConfig)
---@field palette fun(style?: LowbeamStyleName|string): LowbeamPalette
---@field highlights fun(style?: LowbeamStyleName|string): LowbeamHighlightGroups
---@field load fun(opts?: LowbeamLoadOptions|LowbeamStyleName|string)

---@type LowbeamModule
local M = {}

---@param opts? LowbeamLoadOptions|LowbeamStyleName|string
---@return LowbeamLoadOptions
local function normalize_load_opts(opts)
  if type(opts) == "string" then
    return {
      style = opts,
      name = "lowbeam-" .. opts,
    }
  end

  if type(opts) == "table" then
    return opts
  end

  return {}
end

---@param opts? LowbeamUserConfig
function M.setup(opts)
  config.setup(opts)
end

---@param opts? LowbeamUserConfig
function M.extend(opts)
  config.extend(opts)
end

---@param style? LowbeamStyleName|string
---@return LowbeamPalette
function M.palette(style)
  local options = config.get({ style = style or config.options.style })
  return palette.get(options.style, options)
end

---@param style? LowbeamStyleName|string
---@return LowbeamHighlightGroups
function M.highlights(style)
  local options = config.get({ style = style or config.options.style })
  local colors = palette.get(options.style, options)

  return groups.get(colors, options)
end

---@param opts? LowbeamLoadOptions|LowbeamStyleName|string
function M.load(opts)
  local raw_load_opts = normalize_load_opts(opts)
  local load_opts = vim.deepcopy(raw_load_opts)
  local colorscheme_name = load_opts.name
  local requested_style = load_opts.style

  load_opts.name = nil

  local options = config.get(load_opts)
  local colors, normalized_style = palette.get(options.style, options)

  if not colorscheme_name then
    if requested_style then
      colorscheme_name = requested_style == "dark" and "lowbeam-dark" or "lowbeam-" .. normalized_style
    else
      colorscheme_name = "lowbeam"
    end
  end

  vim.cmd("highlight clear")

  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.background = colors.background
  vim.g.colors_name = colorscheme_name

  local highlight_groups = groups.get(colors, options)

  for group, spec in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end
end

return M