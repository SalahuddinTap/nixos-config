-- Vanta Black colorscheme for Neovim
-- Exact colors from HyDE Vanta Black theme (theme.dcol)
-- Pure grayscale: #000000 → #E5E5E5

local M = {}

M.palette = {
  -- Base grayscale (from theme.dcol)
  black      = "#000000",  -- dcol_pry1
  gray900    = "#0D0D0D",  -- dcol_1xa1
  gray800    = "#1A1A1A",  -- dcol_pry2
  gray700    = "#2E2E2E",  -- dcol_pry3
  gray600    = "#474747",  -- dcol_pry4
  gray500    = "#5E5E5E",  -- dcol_1xa5
  gray400    = "#7A7A7A",  -- dcol_1xa6
  gray300    = "#999999",  -- dcol_1xa7
  gray200    = "#B2B2B2",  -- dcol_1xa8
  gray100    = "#E5E5E5",  -- dcol_txt1 / dcol_1xa9
  white      = "#FFFFFF",  -- not in dcol but used in kitty.theme

  -- Semantic aliases
  bg         = "#000000",
  bg_alt     = "#0D0D0D",
  bg_hover   = "#1A1A1A",
  bg_active  = "#2E2E2E",
  fg         = "#E5E5E5",
  fg_dim     = "#999999",
  fg_muted   = "#7A7A7A",
  border     = "#474747",
  border_focus = "#E5E5E5",
  selection  = "#E5E5E5",
  selection_fg = "#000000",
  cursor     = "#FFFFFF",
}

function M.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then vim.cmd("syntax reset") end
  vim.o.termguicolors = true
  vim.g.colors_name = "vanta-black"

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local p = M.palette

  -- Editor
  hi("Normal",        { fg = p.fg, bg = p.bg })
  hi("NormalNC",      { fg = p.fg_dim, bg = p.bg })
  hi("NormalFloat",   { fg = p.fg, bg = p.bg_alt })
  hi("FloatBorder",   { fg = p.border, bg = p.bg_alt })
  hi("FloatTitle",    { fg = p.fg, bg = p.bg_alt, bold = true })
  hi("CursorLine",    { bg = p.bg_alt })
  hi("CursorLineNr",  { fg = p.fg, bold = true })
  hi("LineNr",        { fg = p.gray500 })
  hi("CursorColumn",  { bg = p.bg_alt })
  hi("ColorColumn",   { bg = p.bg_alt })
  hi("SignColumn",    { fg = p.fg_dim, bg = p.bg })
  hi("Folded",        { fg = p.gray400, bg = p.bg_alt })
  hi("FoldColumn",    { fg = p.gray500, bg = p.bg })
  hi("VertSplit",     { fg = p.border, bg = p.bg })
  hi("WinSeparator",  { fg = p.border, bg = p.bg })
  hi("StatusLine",    { fg = p.fg, bg = p.bg_alt })
  hi("StatusLineNC",  { fg = p.gray400, bg = p.bg_alt })
  hi("TabLine",       { fg = p.gray400, bg = p.bg_alt })
  hi("TabLineFill",   { bg = p.bg_alt })
  hi("TabLineSel",    { fg = p.fg, bg = p.bg, bold = true })
  hi("Pmenu",         { fg = p.fg, bg = p.bg_alt })
  hi("PmenuSel",      { fg = p.selection_fg, bg = p.selection, bold = true })
  hi("PmenuSbar",     { bg = p.gray600 })
  hi("PmenuThumb",    { bg = p.gray400 })
  hi("WildMenu",      { fg = p.selection_fg, bg = p.selection })
  hi("Search",        { fg = p.selection_fg, bg = p.selection })
  hi("IncSearch",     { fg = p.selection_fg, bg = p.selection, bold = true })
  hi("CurSearch",     { fg = p.selection_fg, bg = p.selection, underline = true })
  hi("MatchParen",    { fg = p.fg, bg = p.gray600, bold = true })
  hi("Visual",        { bg = p.gray800 })
  hi("VisualNOS",     { bg = p.gray800 })
  hi("Whitespace",    { fg = p.gray700 })
  hi("NonText",       { fg = p.gray700 })
  hi("SpecialKey",    { fg = p.gray600 })
  hi("Conceal",       { fg = p.gray500 })

  -- Syntax
  hi("Comment",       { fg = p.gray500, italic = true })
  hi("Constant",      { fg = p.gray200 })
  hi("String",        { fg = p.gray300 })
  hi("Character",     { fg = p.gray300 })
  hi("Number",        { fg = p.gray300 })
  hi("Boolean",       { fg = p.gray200, bold = true })
  hi("Float",         { fg = p.gray300 })
  hi("Identifier",    { fg = p.fg })
  hi("Function",      { fg = p.gray200 })
  hi("Statement",     { fg = p.gray200, bold = true })
  hi("Conditional",   { fg = p.gray200, bold = true })
  hi("Repeat",        { fg = p.gray200, bold = true })
  hi("Label",         { fg = p.gray200 })
  hi("Operator",      { fg = p.gray400 })
  hi("Keyword",       { fg = p.gray200, bold = true })
  hi("Exception",     { fg = p.gray200, bold = true })
  hi("PreProc",       { fg = p.gray400 })
  hi("Include",       { fg = p.gray200 })
  hi("Define",        { fg = p.gray200 })
  hi("Macro",         { fg = p.gray400 })
  hi("PreCondit",     { fg = p.gray400 })
  hi("Type",          { fg = p.gray200 })
  hi("StorageClass",  { fg = p.gray200 })
  hi("Structure",     { fg = p.gray200 })
  hi("Typedef",       { fg = p.gray200 })
  hi("Special",       { fg = p.gray400 })
  hi("SpecialChar",   { fg = p.gray300 })
  hi("Tag",           { fg = p.gray200 })
  hi("Delimiter",     { fg = p.gray400 })
  hi("SpecialComment",{ fg = p.gray500, italic = true })
  hi("Debug",         { fg = p.gray200 })
  hi("Underlined",    { fg = p.gray300, underline = true })
  hi("Ignore",        { fg = p.gray600 })
  hi("Error",         { fg = p.fg, bg = p.black, bold = true })
  hi("Todo",          { fg = p.fg, bg = p.gray800, bold = true })

  -- Diff
  hi("DiffAdd",    { bg = "#0D1A0D" })  -- subtle green tint would be nice but staying grayscale
  hi("DiffChange", { bg = "#1A1A0D" })
  hi("DiffDelete", { bg = "#1A0D0D" })
  hi("DiffText",   { bg = "#2E2E0D" })

  -- Diagnostics
  hi("DiagnosticError",            { fg = p.gray200 })
  hi("DiagnosticWarn",             { fg = p.gray300 })
  hi("DiagnosticInfo",             { fg = p.gray400 })
  hi("DiagnosticHint",             { fg = p.gray500 })
  hi("DiagnosticUnderlineError",   { undercurl = true, sp = p.gray200 })
  hi("DiagnosticUnderlineWarn",    { undercurl = true, sp = p.gray300 })
  hi("DiagnosticUnderlineInfo",    { undercurl = true, sp = p.gray400 })
  hi("DiagnosticUnderlineHint",    { undercurl = true, sp = p.gray500 })

  -- LSP
  hi("LspReferenceText",  { bg = p.gray800 })
  hi("LspReferenceRead",  { bg = p.gray800 })
  hi("LspReferenceWrite", { bg = p.gray800 })
  hi("LspCodeLens",       { fg = p.gray500 })
  hi("LspCodeLensSeparator", { fg = p.gray600 })

  -- Treesitter
  hi("@variable",          { fg = p.fg })
  hi("@variable.builtin",  { fg = p.gray200 })
  hi("@constant",          { fg = p.gray200 })
  hi("@constant.builtin",  { fg = p.gray200 })
  hi("@module",            { fg = p.gray300 })
  hi("@label",             { fg = p.gray400 })
  hi("@string",            { fg = p.gray300 })
  hi("@character",         { fg = p.gray300 })
  hi("@number",            { fg = p.gray300 })
  hi("@boolean",           { fg = p.gray200, bold = true })
  hi("@type",              { fg = p.gray200 })
  hi("@attribute",         { fg = p.gray400 })
  hi("@property",          { fg = p.gray300 })
  hi("@function",          { fg = p.gray200 })
  hi("@function.builtin",  { fg = p.gray200 })
  hi("@function.macro",    { fg = p.gray400 })
  hi("@constructor",       { fg = p.gray200 })
  hi("@parameter",         { fg = p.fg })
  hi("@keyword",           { fg = p.gray200, bold = true })
  hi("@conditional",       { fg = p.gray200, bold = true })
  hi("@repeat",            { fg = p.gray200, bold = true })
  hi("@operator",          { fg = p.gray400 })
  hi("@comment",           { fg = p.gray500, italic = true })
  hi("@punctuation",       { fg = p.gray400 })
  hi("@tag",               { fg = p.gray200 })
  hi("@tag.attribute",     { fg = p.gray400 })

  -- Git
  hi("GitSignsAdd",    { fg = p.gray300 })
  hi("GitSignsChange", { fg = p.gray400 })
  hi("GitSignsDelete", { fg = p.gray400 })

  -- Telescope
  hi("TelescopeBorder",       { fg = p.border, bg = p.bg_alt })
  hi("TelescopePromptBorder", { fg = p.border_focus, bg = p.bg_alt })
  hi("TelescopeResultsBorder",{ fg = p.border, bg = p.bg_alt })
  hi("TelescopePreviewBorder",{ fg = p.border, bg = p.bg_alt })
  hi("TelescopeSelection",    { fg = p.fg, bg = p.bg_active, bold = true })
  hi("TelescopeMatching",     { fg = p.fg, bold = true })

  -- Which-key
  hi("WhichKey",        { fg = p.gray200 })
  hi("WhichKeyGroup",   { fg = p.gray300 })
  hi("WhichKeyDesc",    { fg = p.fg })
  hi("WhichKeySeperator",{ fg = p.gray500 })
  hi("WhichKeyFloat",   { bg = p.bg_alt })

  -- Lazy
  hi("LazyNormal",   { fg = p.fg, bg = p.bg })
  hi("LazyButton",   { fg = p.fg, bg = p.bg_alt })
  hi("LazyH1",       { fg = p.fg, bg = p.bg, bold = true })
  hi("LazyH2",       { fg = p.gray200, bold = true })

  -- Mason
  hi("MasonNormal", { fg = p.fg, bg = p.bg })

  -- Notify
  hi("NotifyBackground", { bg = p.bg })

  -- Noice
  hi("NoiceCmdlinePopupBorder", { fg = p.border_focus })

  -- Terminal colors
  vim.g.terminal_color_0  = p.black
  vim.g.terminal_color_8  = p.gray600
  vim.g.terminal_color_1  = p.gray200
  vim.g.terminal_color_9  = p.gray100
  vim.g.terminal_color_2  = p.gray300
  vim.g.terminal_color_10 = p.gray200
  vim.g.terminal_color_3  = p.gray400
  vim.g.terminal_color_11 = p.gray300
  vim.g.terminal_color_4  = p.gray300
  vim.g.terminal_color_12 = p.gray200
  vim.g.terminal_color_5  = p.gray300
  vim.g.terminal_color_13 = p.gray200
  vim.g.terminal_color_6  = p.gray300
  vim.g.terminal_color_14 = p.gray200
  vim.g.terminal_color_7  = p.gray100
  vim.g.terminal_color_15 = p.white
end

return M