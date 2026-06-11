---@class LowbeamGroupsModule
---@field get fun(colors: LowbeamPalette, opts: LowbeamOptions): LowbeamHighlightGroups

---@type LowbeamGroupsModule
local M = {}

---@param opts LowbeamHighlight
---@param configured? LowbeamHighlight
---@return LowbeamHighlight
local function style(opts, configured)
  return vim.tbl_extend("force", configured or {}, opts or {})
end

---@param groups LowbeamHighlightGroups
---@param custom? table<string, LowbeamHighlightOverride>
---@param c LowbeamPalette
---@param opts LowbeamOptions
local function merge_highlights(groups, custom, c, opts)
  if type(custom) ~= "table" then
    return
  end

  for group, spec in pairs(custom) do
    if type(spec) == "function" then
      spec = spec(c, opts, groups)
    end

    if spec == false then
      groups[group] = nil
    elseif type(spec) == "table" then
      groups[group] = vim.tbl_extend("force", groups[group] or {}, spec)
    end
  end
end

---@param c LowbeamPalette
---@param opts LowbeamOptions
---@return LowbeamHighlightGroups
function M.get(c, opts)
  local transparent_bg = opts.transparent and c.none or c.bg
  local transparent_float = opts.transparent and c.none or c.bg_float
  local inactive_bg = opts.dim_inactive and c.bg_alt or transparent_bg

  local comments = opts.styles.comments or {}
  local keywords = opts.styles.keywords or {}
  local funcs = opts.styles.functions or {}
  local types = opts.styles.types or {}
  local strings = opts.styles.strings or {}

  ---@type LowbeamHighlightGroups
  local groups = {
    -- Editor ---------------------------------------------------------------
    Normal = { fg = c.fg, bg = transparent_bg },
    NormalNC = { fg = c.fg_muted, bg = inactive_bg },
    NormalFloat = { fg = c.fg, bg = transparent_float },
    FloatBorder = { fg = c.border, bg = transparent_float },
    FloatTitle = { fg = c.keyword, bg = transparent_float },
    ColorColumn = { bg = c.bg_alt },
    Cursor = { fg = c.bg, bg = c.fg },
    CursorColumn = { bg = c.bg_alt },
    CursorLine = { bg = c.bg_alt },
    CursorLineNr = { fg = c.fg, bg = c.bg_alt, bold = true },
    LineNr = { fg = c.fg_faint },
    SignColumn = { fg = c.fg_faint, bg = transparent_bg },
    FoldColumn = { fg = c.fg_faint, bg = transparent_bg },
    Folded = { fg = c.fg_muted, bg = c.bg_alt },
    Conceal = { fg = c.fg_faint },
    Directory = { fg = c.func },
    EndOfBuffer = { fg = c.bg_soft },
    ErrorMsg = { fg = c.red, bold = true },
    WarningMsg = { fg = c.amber, bold = true },
    MoreMsg = { fg = c.green },
    ModeMsg = { fg = c.fg_muted },
    MsgArea = { fg = c.fg, bg = transparent_bg },
    Question = { fg = c.func },
    NonText = { fg = c.fg_faint },
    SpecialKey = { fg = c.fg_faint },
    Whitespace = { fg = c.border },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border },
    StatusLine = { fg = c.fg, bg = c.bg_alt },
    StatusLineNC = { fg = c.fg_subtle, bg = c.bg_soft },
    TabLine = { fg = c.fg_muted, bg = c.bg_alt },
    TabLineFill = { fg = c.fg_muted, bg = c.bg_soft },
    TabLineSel = { fg = c.fg, bg = transparent_bg, bold = true },
    Title = { fg = c.keyword, bold = true },
    Visual = { bg = c.bg_visual },
    VisualNOS = { bg = c.bg_visual },
    Search = { fg = c.fg, bg = c.bg_search },
    IncSearch = { fg = c.bg, bg = c.constant },
    CurSearch = { fg = c.bg, bg = c.constant },
    Substitute = { fg = c.bg, bg = c.constant },
    MatchParen = { fg = c.fg, bg = c.bg_search, bold = true },
    Pmenu = { fg = c.fg, bg = c.bg_float },
    PmenuSel = { fg = c.fg, bg = c.bg_visual },
    PmenuSbar = { bg = c.bg_soft },
    PmenuThumb = { bg = c.shadow },
    WildMenu = { fg = c.fg, bg = c.bg_visual },
    QuickFixLine = { bg = c.bg_alt, bold = true },
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.blue, undercurl = true },
    SpellLocal = { sp = c.green, undercurl = true },
    SpellRare = { sp = c.amber, undercurl = true },

    -- Core syntax ----------------------------------------------------------
    Comment = style({ fg = c.comment }, comments),
    Constant = { fg = c.constant },
    String = style({ fg = c.string }, strings),
    Character = { fg = c.string },
    Number = { fg = c.constant },
    Boolean = { fg = c.constant },
    Float = { fg = c.constant },
    Identifier = { fg = c.fg },
    Function = style({ fg = c.func }, funcs),
    Statement = style({ fg = c.keyword }, keywords),
    Conditional = style({ fg = c.keyword }, keywords),
    Repeat = style({ fg = c.keyword }, keywords),
    Label = style({ fg = c.keyword }, keywords),
    Operator = { fg = c.fg_muted },
    Keyword = style({ fg = c.keyword }, keywords),
    Exception = style({ fg = c.keyword }, keywords),
    PreProc = { fg = c.keyword },
    Include = { fg = c.keyword },
    Define = { fg = c.keyword },
    Macro = { fg = c.keyword },
    PreCondit = { fg = c.keyword },
    Type = style({ fg = c.type }, types),
    StorageClass = { fg = c.keyword },
    Structure = style({ fg = c.type }, types),
    Typedef = style({ fg = c.type }, types),
    Special = { fg = c.constant },
    SpecialChar = { fg = c.constant },
    Tag = { fg = c.func },
    Delimiter = { fg = c.fg_muted },
    SpecialComment = { fg = c.comment, italic = true },
    Debug = { fg = c.red },
    Underlined = { underline = true },
    Ignore = { fg = c.fg_faint },
    Error = { fg = c.red },
    Todo = { fg = c.keyword, bg = c.bg_search, bold = true },

    -- Diffs ----------------------------------------------------------------
    DiffAdd = { bg = c.diff_add },
    DiffChange = { bg = c.diff_change },
    DiffDelete = { fg = c.red, bg = c.diff_delete },
    DiffText = { bg = c.diff_text },
    Added = { fg = c.green },
    Changed = { fg = c.amber },
    Removed = { fg = c.red },

    -- Diagnostics ----------------------------------------------------------
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.amber },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.green },
    DiagnosticOk = { fg = c.green },
    DiagnosticVirtualTextError = { fg = c.red, bg = c.diff_delete },
    DiagnosticVirtualTextWarn = { fg = c.amber, bg = c.diff_change },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = c.bg_alt },
    DiagnosticVirtualTextHint = { fg = c.green, bg = c.diff_add },
    DiagnosticUnderlineError = { sp = c.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.amber, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.green, undercurl = true },
    DiagnosticFloatingError = { fg = c.red },
    DiagnosticFloatingWarn = { fg = c.amber },
    DiagnosticFloatingInfo = { fg = c.blue },
    DiagnosticFloatingHint = { fg = c.green },
    DiagnosticSignError = { fg = c.red, bg = transparent_bg },
    DiagnosticSignWarn = { fg = c.amber, bg = transparent_bg },
    DiagnosticSignInfo = { fg = c.blue, bg = transparent_bg },
    DiagnosticSignHint = { fg = c.green, bg = transparent_bg },

    -- LSP ------------------------------------------------------------------
    LspReferenceText = { bg = c.bg_alt },
    LspReferenceRead = { bg = c.bg_alt },
    LspReferenceWrite = { bg = c.bg_alt },
    LspSignatureActiveParameter = { fg = c.constant, bold = true },
    LspCodeLens = { fg = c.fg_faint },
    LspCodeLensSeparator = { fg = c.border },
    LspInlayHint = { fg = c.fg_faint, bg = c.bg_alt },

    -- Tree-sitter ----------------------------------------------------------
    ["@comment"] = style({ fg = c.comment }, comments),
    ["@comment.documentation"] = style({ fg = c.comment }, comments),
    ["@constant"] = { fg = c.constant },
    ["@constant.builtin"] = { fg = c.constant },
    ["@constant.macro"] = { fg = c.constant },
    ["@string"] = style({ fg = c.string }, strings),
    ["@string.documentation"] = style({ fg = c.string }, strings),
    ["@string.escape"] = { fg = c.constant },
    ["@string.regexp"] = { fg = c.constant },
    ["@string.special"] = { fg = c.constant },
    ["@character"] = { fg = c.string },
    ["@character.special"] = { fg = c.constant },
    ["@number"] = { fg = c.constant },
    ["@boolean"] = { fg = c.constant },
    ["@float"] = { fg = c.constant },
    ["@function"] = style({ fg = c.func }, funcs),
    ["@function.builtin"] = style({ fg = c.func }, funcs),
    ["@function.call"] = style({ fg = c.func }, funcs),
    ["@function.macro"] = style({ fg = c.func }, funcs),
    ["@method"] = style({ fg = c.func }, funcs),
    ["@method.call"] = style({ fg = c.func }, funcs),
    ["@constructor"] = style({ fg = c.type }, types),
    ["@parameter"] = { fg = c.fg },
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.keyword },
    ["@property"] = { fg = c.fg },
    ["@field"] = { fg = c.fg },
    ["@keyword"] = style({ fg = c.keyword }, keywords),
    ["@keyword.function"] = style({ fg = c.keyword }, keywords),
    ["@keyword.operator"] = style({ fg = c.keyword }, keywords),
    ["@keyword.return"] = style({ fg = c.keyword }, keywords),
    ["@keyword.conditional"] = style({ fg = c.keyword }, keywords),
    ["@keyword.repeat"] = style({ fg = c.keyword }, keywords),
    ["@keyword.exception"] = style({ fg = c.keyword }, keywords),
    ["@conditional"] = style({ fg = c.keyword }, keywords),
    ["@repeat"] = style({ fg = c.keyword }, keywords),
    ["@label"] = style({ fg = c.keyword }, keywords),
    ["@operator"] = { fg = c.fg_muted },
    ["@punctuation"] = { fg = c.fg_muted },
    ["@punctuation.delimiter"] = { fg = c.fg_muted },
    ["@punctuation.bracket"] = { fg = c.fg_muted },
    ["@punctuation.special"] = { fg = c.constant },
    ["@type"] = style({ fg = c.type }, types),
    ["@type.builtin"] = style({ fg = c.type }, types),
    ["@type.definition"] = style({ fg = c.type }, types),
    ["@type.qualifier"] = style({ fg = c.keyword }, keywords),
    ["@storageclass"] = style({ fg = c.keyword }, keywords),
    ["@attribute"] = { fg = c.constant },
    ["@tag"] = { fg = c.keyword },
    ["@tag.attribute"] = { fg = c.type },
    ["@tag.delimiter"] = { fg = c.fg_muted },
    ["@text"] = { fg = c.fg },
    ["@text.strong"] = { bold = true },
    ["@text.emphasis"] = { italic = true },
    ["@text.underline"] = { underline = true },
    ["@text.strike"] = { strikethrough = true },
    ["@text.title"] = { fg = c.keyword, bold = true },
    ["@text.literal"] = { fg = c.string },
    ["@text.uri"] = { fg = c.func, underline = true },
    ["@markup.heading"] = { fg = c.keyword, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.link"] = { fg = c.func, underline = true },
    ["@markup.raw"] = { fg = c.string },

    -- LSP semantic tokens --------------------------------------------------
    ["@lsp.type.class"] = style({ fg = c.type }, types),
    ["@lsp.type.decorator"] = { fg = c.constant },
    ["@lsp.type.enum"] = style({ fg = c.type }, types),
    ["@lsp.type.enumMember"] = { fg = c.constant },
    ["@lsp.type.function"] = style({ fg = c.func }, funcs),
    ["@lsp.type.interface"] = style({ fg = c.type }, types),
    ["@lsp.type.macro"] = { fg = c.keyword },
    ["@lsp.type.method"] = style({ fg = c.func }, funcs),
    ["@lsp.type.namespace"] = style({ fg = c.type }, types),
    ["@lsp.type.parameter"] = { fg = c.fg },
    ["@lsp.type.property"] = { fg = c.fg },
    ["@lsp.type.struct"] = style({ fg = c.type }, types),
    ["@lsp.type.type"] = style({ fg = c.type }, types),
    ["@lsp.type.typeParameter"] = style({ fg = c.type }, types),
    ["@lsp.type.variable"] = { fg = c.fg },
    ["@lsp.typemod.variable.readonly"] = { fg = c.constant },
    ["@lsp.typemod.property.readonly"] = { fg = c.constant },
    ["@lsp.mod.defaultLibrary"] = { fg = c.keyword },

    -- Git signs ------------------------------------------------------------
    GitSignsAdd = { fg = c.green, bg = transparent_bg },
    GitSignsChange = { fg = c.amber, bg = transparent_bg },
    GitSignsDelete = { fg = c.red, bg = transparent_bg },
    GitSignsAddNr = { fg = c.green, bg = transparent_bg },
    GitSignsChangeNr = { fg = c.amber, bg = transparent_bg },
    GitSignsDeleteNr = { fg = c.red, bg = transparent_bg },

    -- Completion -----------------------------------------------------------
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.fg_faint, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.func, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.func },
    CmpItemKind = { fg = c.type },
    CmpItemMenu = { fg = c.fg_faint },
    CmpItemKindText = { fg = c.fg },
    CmpItemKindMethod = { fg = c.func },
    CmpItemKindFunction = { fg = c.func },
    CmpItemKindConstructor = { fg = c.type },
    CmpItemKindField = { fg = c.fg },
    CmpItemKindVariable = { fg = c.fg },
    CmpItemKindClass = { fg = c.type },
    CmpItemKindInterface = { fg = c.type },
    CmpItemKindModule = { fg = c.type },
    CmpItemKindProperty = { fg = c.fg },
    CmpItemKindUnit = { fg = c.constant },
    CmpItemKindValue = { fg = c.constant },
    CmpItemKindEnum = { fg = c.type },
    CmpItemKindKeyword = { fg = c.keyword },
    CmpItemKindSnippet = { fg = c.string },
    CmpItemKindColor = { fg = c.constant },
    CmpItemKindFile = { fg = c.fg },
    CmpItemKindReference = { fg = c.constant },
    CmpItemKindFolder = { fg = c.func },
    CmpItemKindEnumMember = { fg = c.constant },
    CmpItemKindConstant = { fg = c.constant },
    CmpItemKindStruct = { fg = c.type },
    CmpItemKindEvent = { fg = c.constant },
    CmpItemKindOperator = { fg = c.fg_muted },
    CmpItemKindTypeParameter = { fg = c.type },

    -- Telescope ------------------------------------------------------------
    TelescopeNormal = { fg = c.fg, bg = transparent_float },
    TelescopeBorder = { fg = c.border, bg = transparent_float },
    TelescopePromptNormal = { fg = c.fg, bg = c.bg_alt },
    TelescopePromptBorder = { fg = c.border, bg = c.bg_alt },
    TelescopePromptTitle = { fg = c.bg, bg = c.keyword },
    TelescopePreviewTitle = { fg = c.bg, bg = c.type },
    TelescopeResultsTitle = { fg = c.bg, bg = c.func },
    TelescopeSelection = { bg = c.bg_visual },
    TelescopeMatching = { fg = c.constant, bold = true },

    -- File trees -----------------------------------------------------------
    NvimTreeNormal = { fg = c.fg, bg = transparent_bg },
    NvimTreeNormalNC = { fg = c.fg_muted, bg = inactive_bg },
    NvimTreeRootFolder = { fg = c.keyword, bold = true },
    NvimTreeFolderName = { fg = c.func },
    NvimTreeOpenedFolderName = { fg = c.func, bold = true },
    NvimTreeEmptyFolderName = { fg = c.fg_faint },
    NvimTreeGitDirty = { fg = c.amber },
    NvimTreeGitNew = { fg = c.green },
    NvimTreeGitDeleted = { fg = c.red },
    NvimTreeSpecialFile = { fg = c.constant },
    NeoTreeNormal = { fg = c.fg, bg = transparent_bg },
    NeoTreeNormalNC = { fg = c.fg_muted, bg = inactive_bg },
    NeoTreeDirectoryName = { fg = c.func },
    NeoTreeDirectoryIcon = { fg = c.func },
    NeoTreeRootName = { fg = c.keyword, bold = true },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.amber },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitUntracked = { fg = c.green },

    -- Which-key / Lazy / Snacks -------------------------------------------
    WhichKey = { fg = c.keyword },
    WhichKeyGroup = { fg = c.func },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeparator = { fg = c.fg_faint },
    WhichKeyFloat = { bg = transparent_float },
    LazyNormal = { fg = c.fg, bg = transparent_float },
    LazyButton = { fg = c.fg, bg = c.bg_alt },
    LazyButtonActive = { fg = c.fg, bg = c.bg_visual },
    LazyH1 = { fg = c.bg, bg = c.keyword, bold = true },
    LazyH2 = { fg = c.keyword, bold = true },
    SnacksPicker = { fg = c.fg, bg = transparent_float },
    SnacksPickerBorder = { fg = c.border, bg = transparent_float },
    SnacksPickerMatch = { fg = c.constant, bold = true },
    SnacksPickerSelected = { bg = c.bg_visual },
  }

  ---@param patterns string[]
  local function remove_matching(patterns)
    for group, _ in pairs(vim.deepcopy(groups)) do
      for _, pattern in ipairs(patterns) do
        if group:match(pattern) then
          groups[group] = nil
          break
        end
      end
    end
  end

  if opts.semantic_tokens == false then
    remove_matching({ "^@lsp" })
  end

  local integrations = opts.integrations or {}

  if integrations.treesitter == false then
    remove_matching({ "^@[^l]", "^@l[^s]", "^@ls[^p]" })
  end

  if integrations.lsp == false then
    remove_matching({ "^Lsp", "^@lsp" })
  end

  if integrations.telescope == false then
    remove_matching({ "^Telescope" })
  end

  if integrations.nvim_tree == false then
    remove_matching({ "^NvimTree" })
  end

  if integrations.neo_tree == false then
    remove_matching({ "^NeoTree" })
  end

  if integrations.gitsigns == false then
    remove_matching({ "^GitSigns" })
  end

  if integrations.cmp == false then
    remove_matching({ "^Cmp" })
  end

  if integrations.which_key == false then
    remove_matching({ "^WhichKey" })
  end

  if integrations.lazy == false then
    remove_matching({ "^Lazy" })
  end

  if integrations.snacks == false then
    remove_matching({ "^Snacks" })
  end

  if type(opts.on_highlights) == "function" then
    local next_groups = opts.on_highlights(groups, c, opts)

    if type(next_groups) == "table" then
      groups = next_groups
    end
  end

  merge_highlights(groups, opts.highlights, c, opts)

  return groups
end

return M