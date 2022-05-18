" Dracula Theme: {{{
"
" https://github.com/zenorocha/dracula-theme
"
" Copyright 2016, All rights reserved
"
" Code licensed under the MIT license
" http://zenorocha.mit-license.org
"
" @author Trevor Heins <@heinst>
" @author Éverton Ribeiro <nuxlli@gmail.com>
" @author Derek Sifford <dereksifford@gmail.com>
" @author Zeno Rocha <hi@zenorocha.com>
scriptencoding utf8
" }}}

" Configuration: {{{

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'dracula'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:fg        = g:dracula#palette.fg

let s:bglighter = g:dracula#palette.bglighter
let s:bglight   = g:dracula#palette.bglight
let s:bg        = g:dracula#palette.bg
let s:bgdark    = g:dracula#palette.bgdark
let s:bgdarker  = g:dracula#palette.bgdarker

let s:comment   = g:dracula#palette.comment
let s:selection = g:dracula#palette.selection
let s:subtle    = g:dracula#palette.subtle

let s:cyan      = g:dracula#palette.cyan
let s:green     = g:dracula#palette.green
let s:orange    = g:dracula#palette.orange
let s:pink      = g:dracula#palette.pink
let s:purple    = g:dracula#palette.purple
let s:red       = g:dracula#palette.red
let s:yellow    = g:dracula#palette.yellow

let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:dracula#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:dracula#palette['color_' . s:i])
  endfor
endif

" }}}2
" User Configuration: {{{2

if !exists('g:dracula_bold')
  let g:dracula_bold = 1
endif

if !exists('g:dracula_italic')
  let g:dracula_italic = 1
endif

if !exists('g:dracula_underline')
  let g:dracula_underline = 1
endif

if !exists('g:dracula_undercurl')
  let g:dracula_undercurl = g:dracula_underline
endif

if !exists('g:dracula_full_special_attrs_support')
  let s:term = getenv("TERM")
  let g:dracula_full_special_attrs_support = has('gui_running')
        \ || s:term ==# "xterm-kitty"
        \ || s:term ==# "wezterm"
endif

if !exists('g:dracula_inverse')
  let g:dracula_inverse = 0
endif

if !exists('g:dracula_colorterm')
  let g:dracula_colorterm = 1
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:dracula_bold == 1 ? 'bold' : 0,
      \ 'italic': g:dracula_italic == 1 ? 'italic' : 0,
      \ 'underline': g:dracula_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:dracula_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:dracula_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])
  let l:fg = type(l:fg) == 3 ? l:fg : [ l:fg ]
  let l:bg = type(l:bg) == 3 ? l:bg : [ l:bg ]

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " If the UI does not have full support for special attributes (like underline and
  " undercurl) and the highlight does not explicitly set the foreground color,
  " make the foreground the same as the attribute color to ensure the user will
  " get some highlight if the attribute is not supported. The default behavior
  " is to assume that terminals do not have full support, but the user can set
  " the global variable `g:dracula_full_special_attrs_support` explicitly if the
  " default behavior is not desirable.
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  let l:special = type(l:special) == 3 ? l:special : [ l:special ]
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !g:dracula_full_special_attrs_support
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . (len(l:fg) >= 2 ? l:fg[1] : 'NONE'),
        \ 'guibg=' . l:bg[0], 'ctermbg=' . (len(l:bg) >= 2 ? l:bg[1] : 'NONE'),
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

"}}}2
" Dracula Highlight Groups: {{{2

call s:h('DraculaBgLight', s:none, s:bglight)
call s:h('DraculaBgLighter', s:none, s:bglighter)
call s:h('DraculaBgDark', s:none, s:bgdark)
call s:h('DraculaBgDarker', s:none, s:bgdarker)

call s:h('DraculaFg', s:fg)
call s:h('DraculaFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('DraculaFgBold', s:fg, s:none, [s:attrs.bold])

call s:h('DraculaComment', s:comment)
call s:h('DraculaCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('DraculaSelection', s:none, s:selection)

call s:h('DraculaSubtle', s:subtle)

call s:h('DraculaCyan', s:cyan)
call s:h('DraculaCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('DraculaGreen', s:green)
call s:h('DraculaGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('DraculaGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('DraculaGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('DraculaOrange', s:orange)
call s:h('DraculaOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('DraculaOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('DraculaOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('DraculaOrangeInverse', s:bg, s:orange)

call s:h('DraculaPink', s:pink)
call s:h('DraculaPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('DraculaPurple', s:purple)
call s:h('DraculaPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('DraculaPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('DraculaRed', s:red)
call s:h('DraculaRedInverse', s:fg, s:red)

call s:h('DraculaYellow', s:yellow)
call s:h('DraculaYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('DraculaError', s:red, s:none, [], s:red)

call s:h('DraculaErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('DraculaWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('DraculaInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('DraculaTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('DraculaSearch', s:bgdarker, s:purple, [s:attrs.inverse])
call s:h('DraculaBoundary', s:comment, s:bgdark)
call s:h('DraculaWinSeparator', '#74799c')
call s:h('DraculaLink', s:cyan, s:none, [s:attrs.underline])

call s:h('DraculaDiffChange', s:orange, s:none)
call s:h('DraculaDiffText', s:bg, s:orange)
call s:h('DraculaDiffDelete', s:red, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:dracula_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', '#6b7cb2', '#343746', [ s:attrs.bold ])
call s:h('StatusLineNC', '#6b7cb2', '#343746')
call s:h('StatusLineTerm', '#6b7cb2', '#343746', [ s:attrs.bold ])
call s:h('StatusLineTermNC', '#6b7cb2', '#343746')
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, '#3b3e50')
call s:h('Whitespace', '#4e5269')
call s:h('NonText', '#4e5269')
call s:h('Visual', s:none, '#313957')

hi! link ColorColumn  DraculaBgDark
hi! link CursorColumn CursorLine
hi! link CursorLineNr DraculaYellow
hi! link DiffAdd      DraculaGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   DraculaDiffChange
hi! link DiffDelete   DraculaDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     DraculaDiffText
hi! link Directory    DraculaPurpleBold
hi! link ErrorMsg     DraculaRed
hi! link FoldColumn   DraculaSubtle
hi! link Folded       DraculaBoundary
hi! link IncSearch    DraculaOrangeInverse
call s:h('LineNr', s:comment)
hi! link MoreMsg      DraculaFgBold
hi! link Pmenu        DraculaBgDark
hi! link PmenuSbar    DraculaBgDark
hi! link PmenuSel     DraculaSelection
hi! link PmenuThumb   DraculaSelection
hi! link Question     DraculaFgBold
hi! link Search       DraculaSearch
call s:h('SignColumn', s:comment)
call s:h('EndOfBuffer', ["bg", "bg"], ["bg", "bg"])
hi! link TabLine      DraculaBoundary
hi! link TabLineFill  DraculaBgDark
hi! link TabLineSel   DraculaPink
hi! link Title        DraculaGreenBold
hi! link VertSplit    DraculaWinSeparator
hi! link VisualNOS    Visual
hi! link WarningMsg   DraculaOrange

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey DraculaRed
  hi! link LspReferenceText DraculaSelection
  hi! link LspReferenceRead DraculaSelection
  hi! link LspReferenceWrite DraculaSelection
  " Link old 'LspDiagnosticsDefault*' hl groups
  " for backward compatibility with neovim v0.5.x
  hi! link LspDiagnosticsDefaultInformation DiagnosticInfo
  hi! link LspDiagnosticsDefaultHint DiagnosticHint
  hi! link LspDiagnosticsDefaultError DiagnosticError
  hi! link LspDiagnosticsDefaultWarning DiagnosticWarn
  hi! link LspDiagnosticsUnderlineError DiagnosticUnderlineError
  hi! link LspDiagnosticsUnderlineHint DiagnosticUnderlineHint
  hi! link LspDiagnosticsUnderlineInformation DiagnosticUnderlineInfo
  hi! link LspDiagnosticsUnderlineWarning DiagnosticUnderlineWarn

  hi! link DiagnosticInfo DraculaCyan
  hi! link DiagnosticHint DraculaCyan
  hi! link DiagnosticError DraculaError
  hi! link DiagnosticWarn DraculaOrange
  hi! link DiagnosticUnderlineError DraculaErrorLine
  hi! link DiagnosticUnderlineHint DraculaInfoLine
  hi! link DiagnosticUnderlineInfo DraculaInfoLine
  hi! link DiagnosticUnderlineWarn DraculaWarnLine

  hi! link WinSeparator DraculaWinSeparator
else
  hi! link SpecialKey DraculaPink
endif

hi! link Comment DraculaComment
hi! link Underlined DraculaFgUnderline
hi! link Todo DraculaTodo

hi! link Error DraculaError
hi! link SpellBad DraculaErrorLine
hi! link SpellLocal DraculaWarnLine
hi! link SpellCap DraculaInfoLine
hi! link SpellRare DraculaInfoLine

hi! link Constant DraculaPurple
hi! link String DraculaYellow
hi! link Character DraculaPink
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier DraculaFg
hi! link Function DraculaGreen

hi! link Statement DraculaPink
hi! link Conditional DraculaPink
hi! link Repeat DraculaPink
hi! link Label DraculaPink
hi! link Operator DraculaPink
hi! link Keyword DraculaPink
hi! link Exception DraculaPink

hi! link PreProc DraculaPink
hi! link Include DraculaPink
hi! link Define DraculaPink
hi! link Macro DraculaPink
hi! link PreCondit DraculaPink
hi! link StorageClass DraculaPink
hi! link Structure DraculaPink
hi! link Typedef DraculaPink

hi! link Type DraculaCyanItalic

hi! link Delimiter DraculaFg

hi! link Special DraculaPink
hi! link SpecialComment DraculaCyanItalic
hi! link Tag DraculaCyan
hi! link helpHyperTextJump DraculaLink
hi! link helpCommand DraculaPurple
hi! link helpExample DraculaGreen
hi! link helpBacktick Special

"}}}
" Plugins: {{{

" Fzf: {{{
if exists('g:loaded_fzf') && ! exists('g:fzf_colors')
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Search'],
    \ 'fg+':     ['fg', 'Normal'],
    \ 'bg+':     ['bg', 'Normal'],
    \ 'hl+':     ['fg', 'DraculaOrange'],
    \ 'info':    ['fg', 'DraculaPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'DraculaGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
"}}}
" ALE: {{{
if exists('g:ale_enabled')
  hi! link ALEError              DraculaErrorLine
  hi! link ALEWarning            DraculaWarnLine
  hi! link ALEInfo               DraculaInfoLine

  hi! link ALEErrorSign          DraculaRed
  hi! link ALEWarningSign        DraculaOrange
  hi! link ALEInfoSign           DraculaCyan

  hi! link ALEVirtualTextError   Comment
  hi! link ALEVirtualTextWarning Comment
endif
" }}}
" CtrlP: {{{
if exists('g:loaded_ctrlp')
  hi! link CtrlPMatch     IncSearch
  hi! link CtrlPBufferHid Normal
endif
" }}}
" GitGutter / gitsigns: {{{
if exists('g:loaded_gitgutter')
  hi! link GitGutterAdd    DiffAdd
  hi! link GitGutterChange DiffChange
  hi! link GitGutterDelete DiffDelete
endif
if has('nvim-0.5') && luaeval("pcall(require, 'gitsigns')")
  " https://github.com/lewis6991/gitsigns.nvim requires nvim > 0.5
  " has('nvim-0.5') checks >= 0.5, so this should be future-proof.
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange
  hi! link GitSignsDelete   DiffDelete
  hi! link GitSignsDeleteLn DiffDelete
  hi! link GitSignsDeleteNr DiffDelete
endif
" }}}
" Tree-sitter: {{{
" The nvim-treesitter library defines many global highlight groups that are
" linked to the regular vim syntax highlight groups. We only need to redefine
" those highlight groups when the defaults do not match the dracula
" specification.
" https://github.com/nvim-treesitter/nvim-treesitter/blob/master/plugin/nvim-treesitter.vim
" # Misc
hi! link TSPunctSpecial Special
" # Constants
hi! link TSConstMacro Macro
hi! link TSStringEscape Character
hi! link TSSymbol DraculaPurple
hi! link TSAnnotation DraculaYellow
hi! link TSAttribute DraculaGreenItalic
" # Functions
hi! link TSFuncBuiltin DraculaCyan
hi! link TSFuncMacro Function
hi! link TSParameter DraculaOrangeItalic
hi! link TSParameterReference DraculaOrange
hi! link TSField DraculaOrange
hi! link TSConstructor DraculaCyan
" # Keywords
hi! link TSLabel DraculaPurpleItalic
" # Variable
hi! link TSVariableBuiltin DraculaPurpleItalic
" # Text
hi! link TSStrong DraculaFgBold
hi! link TSEmphasis DraculaFg
hi! link TSUnderline Underlined
hi! link TSTitle DraculaYellow
hi! link TSLiteral DraculaYellow
hi! link TSURI DraculaYellow
" HTML and JSX tag attributes. By default, this group is linked to TSProperty,
" which in turn links to Identifer (white).
hi! link TSTagAttribute DraculaGreenItalic
" }}}
" nvim-cmp: {{{
" A completion engine plugin for neovim written in Lua.
" https://github.com/hrsh7th/nvim-cmp
hi! link CmpItemAbbrDeprecated DraculaError

hi! link CmpItemAbbrMatch DraculaCyan
hi! link CmpItemAbbrMatchFuzzy DraculaCyan

hi! link CmpItemKindText DraculaFg
hi! link CmpItemKindMethod Function
hi! link CmpItemKindFunction Function
hi! link CmpItemKindConstructor DraculaCyan
hi! link CmpItemKindField DraculaOrange
hi! link CmpItemKindVariable DraculaPurpleItalic
hi! link CmpItemKindClass DraculaCyan
hi! link CmpItemKindInterface DraculaCyan
hi! link CmpItemKindModule DraculaYellow
hi! link CmpItemKindProperty DraculaPink
hi! link CmpItemKindUnit DraculaFg
hi! link CmpItemKindValue DraculaYellow
hi! link CmpItemKindEnum DraculaPink
hi! link CmpItemKindKeyword DraculaPink
hi! link CmpItemKindSnippet DraculaFg
hi! link CmpItemKindColor DraculaYellow
hi! link CmpItemKindFile DraculaYellow
hi! link CmpItemKindReference DraculaOrange
hi! link CmpItemKindFolder DraculaYellow
hi! link CmpItemKindEnumMember DraculaPurple
hi! link CmpItemKindConstant DraculaPurple
hi! link CmpItemKindStruct DraculaPink
hi! link CmpItemKindEvent DraculaFg
hi! link CmpItemKindOperator DraculaPink
hi! link CmpItemKindTypeParameter DraculaCyan

hi! link CmpItemMenu Comment
" }}}
" telescope.nvim: {{{
hi! link TelescopeBorder DraculaPurple
hi! link TelescopePromptPrefix DraculaOrange
" }}}
" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
