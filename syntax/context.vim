" Vim syntax file
" Language:         ConTeXt typesetting engine
" Maintainer:       Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Latest Revision:  2012-01-03

" Initialize Syntaxfile: {{{1
" ======================

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Syntax Definitions:
" ===================

" Commands: {{{1
" =========

"TODO syn cluster contextCommandGroup

syn match   contextCommand    display '\\[a-zA-Z@!:]\+'

syn match   contextBlock      display '\\\%(start\|stop\|place\)\a*'

"TODO folds
syn match   contextSection    display '\\\%(start\|stop\)\?part\>'
syn match   contextSection    display '\\\%(start\|stop\)\?chapter\>'
syn match   contextSection    display '\\\%(start\|stop\)\?\%(sub\)*section\>'
syn match   contextSection    display '\\\%(start\|stop\)\?title\>'
syn match   contextSection    display '\\\%(start\|stop\)\?\%(sub\)*subject\>'

"syn match   contextDefine     display '\\\%([egx]def\|let\)'
syn match   contextDefine     display '\\\%(define\|set\|get\)\a*'
syn match   contextDefine     display '\\\%(start\|stop\)texdefinition\>'
syn match   contextSetup      display '\\\%(setup\|use\|enable\|disable\)\a*'
syn match   contextMode       display '\\\a*mode\>'

syn match   contextProject    display '^\s*\\\%(start\|stop\)\?\%(component\|product\|project\|environment\)\>.*$'
syn match   contextProject    display '^\s*\\\%(start\|stop\)text\>\s*$'

" Comments: {{{1
" ---------

syn keyword contextTodo       TODO FIXME NOTE XXX

syn match   contextComment    display contains=contextTodo
                              \ '\\\@!%.*$'
syn match   contextComment    display contains=TOP,contextComment contains=@Spell
                              \ '^%[CDM]\s.*$'

syn region  contextHiding     matchgroup=contextBlock keepend
                              \ start='\\starthiding\>' end='\\stophiding\>'

" Specials: {{{1
" ---------

syn match   contextDelimiter  display '[][{}]'

syn match   contextDimension  display '[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\%(p[tc]\|in\|bp\|c[mc]\|mm\|dd\|sp\|e[mx]\)\>'

syn match   contextEscaped    display '\\[\{}%$#&^_ \n]'
"syn match   contextEscaped    display '\\[`'"]'

syn match   contextSpecial    display '\\\%(par\|crlf\)\>'
syn match   contextSpecial    display '\%(&\|^\|_\|-\{2,3}\)'

"FIXME
syn match   contextParameter  display '#\d\+'

"TODO errors: #, ^, _
"TODO hyphens?: ||

"FIXME
syn region  contextArgument   display matchgroup=contextDelimiter keepend
                              \ contains=contextLabel,contextCommand,contextDimension
                              \ start='\[' end='\]'
syn match   contextLabel      display contained '\a\+:[0-9a-zA-Z: ]\+'

" Fonts: {{{1
" ------

syn match   contextFont       display '\\\%(rm\|ss\|tt\|hw\|cg\|mf\)\>'

syn match   contextStyle      display '\\\%(em\|tf\|b[fsi]\|s[cl]\|it\|os\)\%(xx\|[xabcd]\)\?\>'
syn match   contextStyle      display '\\\%(vi\{1,3}\|ix\|xi\{0,2}\)\>'

syn match   contextCapital    display '\\\%(CAP\|Cap\|cap\|Caps\|kap\|nocap\)\>'
syn match   contextCapital    display '\\\%(Word\|WORD\|Words\|WORDS\)\>'

" Math: {{{1
" -----

"FIXME
syn cluster contextMathGroup  contains=contextComment,contextCommand,contextBlock,contextDelimiter,contextEscaped,contextSpecial,contextFont,contextStyle


syn region  contextMath       display matchgroup=contextDelimiter keepend
                              \ contains=contextMathText,@contextMathGroup
                              \ start='\$' end='\$'
syn region  contextMath       display matchgroup=contextCommand keepend
                              \ contains=contextMathText,@contextMathGroup
                              \ start='\\math\%(ematics\)\?{' end='}'

syn region  contextMath       matchgroup=contextDelimiter keepend
                              \ contains=contextMathText,@contextMathGroup
                              \ start='\$\$' end='\$\$'
syn region  contextMath       matchgroup=contextBlock keepend
                              \ contains=contextMathText,@contextMathGroup
                              \ start='\\start\z(\a*\)formula\>' end='\\stop\z1formula\>'

syn region  contextMathText   display matchgroup=contextCommand keepend
                              \ contained contains=contextMath,@contextMathGroup
                              \ start='\\\%(inter\)\?text{' end='}'

" Concealment: {{{1
" ~~~~~~~~~~~~
"
" (many symbols by Björn Winckler)

if has('conceal') && &enc == 'utf-8'

  let s:contextMathList=[
    \ ['angle'		, '∠'],
    \ ['approx'		, '≈'],
    \ ['ast'		, '∗'],
    \ ['asymp'		, '≍'],
    \ ['backepsilon'	, '∍'],
    \ ['backsimeq'	, '≃'],
    \ ['barwedge'	, '⊼'],
    \ ['because'	, '∵'],
    \ ['between'	, '≬'],
    \ ['bigcap'		, '∩'],
    \ ['bigcup'		, '∪'],
    \ ['bigodot'	, '⊙'],
    \ ['bigoplus'	, '⊕'],
    \ ['bigotimes'	, '⊗'],
    \ ['bigsqcup'	, '⊔'],
    \ ['bigtriangledown', '∇'],
    \ ['bigvee'		, '⋁'],
    \ ['bigwedge'	, '⋀'],
    \ ['blacksquare'	, '∎'],
    \ ['bot'		, '⊥'],
    \ ['boxdot'		, '⊡'],
    \ ['boxminus'	, '⊟'],
    \ ['boxplus'	, '⊞'],
    \ ['boxtimes'	, '⊠'],
    \ ['bumpeq'		, '≏'],
    \ ['Bumpeq'		, '≎'],
    \ ['cap'		, '∩'],
    \ ['Cap'		, '⋒'],
    \ ['cdot'		, '·'],
    \ ['cdots'		, '⋯'],
    \ ['circ'		, '∘'],
    \ ['circeq'		, '≗'],
    \ ['circlearrowleft', '↺'],
    \ ['circlearrowright', '↻'],
    \ ['circledast'	, '⊛'],
    \ ['circledcirc'	, '⊚'],
    \ ['complement'	, '∁'],
    \ ['cong'		, '≅'],
    \ ['coprod'		, '∐'],
    \ ['cup'		, '∪'],
    \ ['Cup'		, '⋓'],
    \ ['curlyeqprec'	, '⋞'],
    \ ['curlyeqsucc'	, '⋟'],
    \ ['curlyvee'	, '⋎'],
    \ ['curlywedge'	, '⋏'],
    \ ['dashv'		, '⊣'],
    \ ['diamond'	, '⋄'],
    \ ['div'		, '÷'],
    \ ['doteq'		, '≐'],
    \ ['doteqdot'	, '≑'],
    \ ['dotplus'	, '∔'],
    \ ['dotsb'		, '⋯'],
    \ ['dotsc'		, '…'],
    \ ['dots'		, '…'],
    \ ['dotsi'		, '⋯'],
    \ ['dotso'		, '…'],
    \ ['doublebarwedge'	, '⩞'],
    \ ['downarrow'	, '↓'],
    \ ['Downarrow'	, '⇓'],
    \ ['emptyset'	, '∅'],
    \ ['eqcirc'		, '≖'],
    \ ['eqsim'		, '≂'],
    \ ['eqslantgtr'	, '⪖'],
    \ ['eqslantless'	, '⪕'],
    \ ['equiv'		, '≡'],
    \ ['exists'		, '∃'],
    \ ['fallingdotseq'	, '≒'],
    \ ['forall'		, '∀'],
    \ ['ge'		, '≥'],
    \ ['geq'		, '≥'],
    \ ['geqq'		, '≧'],
    \ ['gets'		, '←'],
    \ ['gg'             , '≫'],
    \ ['gneqq'		, '≩'],
    \ ['gtrdot'		, '⋗'],
    \ ['gtreqless'	, '⋛'],
    \ ['gtrless'	, '≷'],
    \ ['gtrsim'		, '≳'],
    \ ['hookleftarrow'	, '↩'],
    \ ['hookrightarrow'	, '↪'],
    \ ['iiint'		, '∭'],
    \ ['iint'		, '∬'],
    \ ['Im'		, 'ℑ'],
    \ ['in'		, '∈'],
    \ ['infty'		, '∞'],
    \ ['int'		, '∫'],
    \ ['lceil'		, '⌈'],
    \ ['ldots'		, '…'],
    \ ['le'		, '≤'],
    \ ['leftarrow'	, '⟵'],
    \ ['Leftarrow'	, '⟸'],
    \ ['leftarrowtail'	, '↢'],
    \ ['left('		, '('],
    \ ['left\['		, '['],
    \ ['left\\{'	, '{'],
    \ ['Leftrightarrow'	, '⇔'],
    \ ['leftrightsquigarrow', '↭'],
    \ ['leftthreetimes'	, '⋋'],
    \ ['leq'		, '≤'],
    \ ['leqq'		, '≦'],
    \ ['lessdot'	, '⋖'],
    \ ['lesseqgtr'	, '⋚'],
    \ ['lesssim'	, '≲'],
    \ ['lfloor'		, '⌊'],
    \ ['ll'             , '≪'],
    \ ['lneqq'		, '≨'],
    \ ['ltimes'		, '⋉'],
    \ ['mapsto'		, '↦'],
    \ ['measuredangle'	, '∡'],
    \ ['mid'		, '∣'],
    \ ['mp'		, '∓'],
    \ ['nabla'		, '∇'],
    \ ['ncong'		, '≇'],
    \ ['nearrow'	, '↗'],
    \ ['ne'		, '≠'],
    \ ['neg'		, '¬'],
    \ ['neq'		, '≠'],
    \ ['nexists'	, '∄'],
    \ ['ngeq'		, '≱'],
    \ ['ngeqq'		, '≱'],
    \ ['ngtr'		, '≯'],
    \ ['ni'		, '∋'],
    \ ['nleftarrow'	, '↚'],
    \ ['nLeftarrow'	, '⇍'],
    \ ['nLeftrightarrow', '⇎'],
    \ ['nleq'		, '≰'],
    \ ['nleqq'		, '≰'],
    \ ['nless'		, '≮'],
    \ ['nmid'		, '∤'],
    \ ['notin'		, '∉'],
    \ ['nprec'		, '⊀'],
    \ ['nrightarrow'	, '↛'],
    \ ['nRightarrow'	, '⇏'],
    \ ['nsim'		, '≁'],
    \ ['nsucc'		, '⊁'],
    \ ['ntriangleleft'	, '⋪'],
    \ ['ntrianglelefteq', '⋬'],
    \ ['ntriangleright'	, '⋫'],
    \ ['ntrianglerighteq', '⋭'],
    \ ['nvdash'		, '⊬'],
    \ ['nvDash'		, '⊭'],
    \ ['nVdash'		, '⊮'],
    \ ['nwarrow'	, '↖'],
    \ ['odot'		, '⊙'],
    \ ['oint'		, '∮'],
    \ ['ominus'		, '⊖'],
    \ ['oplus'		, '⊕'],
    \ ['oslash'		, '⊘'],
    \ ['otimes'		, '⊗'],
    \ ['owns'		, '∋'],
    \ ['partial'	, '∂'],
    \ ['perp'		, '⊥'],
    \ ['pitchfork'	, '⋔'],
    \ ['pm'		, '±'],
    \ ['precapprox'	, '⪷'],
    \ ['prec'		, '≺'],
    \ ['preccurlyeq'	, '≼'],
    \ ['preceq'		, '⪯'],
    \ ['precnapprox'	, '⪹'],
    \ ['precneqq'	, '⪵'],
    \ ['precsim'	, '≾'],
    \ ['prod'		, '∏'],
    \ ['propto'		, '∝'],
    \ ['rceil'		, '⌉'],
    \ ['Re'		, 'ℜ'],
    \ ['rfloor'		, '⌋'],
    \ ['rightarrow'	, '⟶'],
    \ ['Rightarrow'	, '⟹'],
    \ ['rightarrowtail'	, '↣'],
    \ ['right)'		, ')'],
    \ ['right]'		, ']'],
    \ ['right\\}'	, '}'],
    \ ['rightsquigarrow', '↝'],
    \ ['rightthreetimes', '⋌'],
    \ ['risingdotseq'	, '≓'],
    \ ['rtimes'		, '⋊'],
    \ ['searrow'	, '↘'],
    \ ['setminus'	, '∖'],
    \ ['sim'		, '∼'],
    \ ['sphericalangle'	, '∢'],
    \ ['sqcap'		, '⊓'],
    \ ['sqcup'		, '⊔'],
    \ ['sqsubset'	, '⊏'],
    \ ['sqsubseteq'	, '⊑'],
    \ ['sqsupset'	, '⊐'],
    \ ['sqsupseteq'	, '⊒'],
    \ ['subset'		, '⊂'],
    \ ['Subset'		, '⋐'],
    \ ['subseteq'	, '⊆'],
    \ ['subseteqq'	, '⫅'],
    \ ['subsetneq'	, '⊊'],
    \ ['subsetneqq'	, '⫋'],
    \ ['succapprox'	, '⪸'],
    \ ['succ'		, '≻'],
    \ ['succcurlyeq'	, '≽'],
    \ ['succeq'		, '⪰'],
    \ ['succnapprox'	, '⪺'],
    \ ['succneqq'	, '⪶'],
    \ ['succsim'	, '≿'],
    \ ['sum'		, '∑'],
    \ ['Supset'		, '⋑'],
    \ ['supseteq'	, '⊇'],
    \ ['supseteqq'	, '⫆'],
    \ ['supsetneq'	, '⊋'],
    \ ['supsetneqq'	, '⫌'],
    \ ['surd'		, '√'],
    \ ['swarrow'	, '↙'],
    \ ['therefore'	, '∴'],
    \ ['times'		, '×'],
    \ ['to'		, '→'],
    \ ['top'		, '⊤'],
    \ ['triangleleft'	, '⊲'],
    \ ['trianglelefteq'	, '⊴'],
    \ ['triangleq'	, '≜'],
    \ ['triangleright'	, '⊳'],
    \ ['trianglerighteq', '⊵'],
    \ ['twoheadleftarrow', '↞'],
    \ ['twoheadrightarrow', '↠'],
    \ ['uparrow'	, '↑'],
    \ ['Uparrow'	, '⇑'],
    \ ['updownarrow'	, '↕'],
    \ ['Updownarrow'	, '⇕'],
    \ ['varnothing'	, '∅'],
    \ ['vartriangle'	, '∆'],
    \ ['vdash'		, '⊢'],
    \ ['vDash'		, '⊨'],
    \ ['Vdash'		, '⊩'],
    \ ['vdots'		, '⋮'],
    \ ['veebar'		, '⊻'],
    \ ['vee'		, '∨'],
    \ ['Vvdash'		, '⊪'],
    \ ['wedge'		, '∧'],
    \ ['wr'		, '≀']]
  for symbol in s:contextMathList
    exe "syn match contextMathSymbol '\\\\".symbol[0]."\\>' contained conceal cchar=".symbol[1]
  endfor

  """ Greek
  let s:contextGreekList=[
    \ ['alpha'		,'α'],
    \ ['beta'		,'β'],
    \ ['gamma'		,'γ'],
    \ ['delta'		,'δ'],
    \ ['epsilon'	,'ϵ'],
    \ ['varepsilon'	,'ε'],
    \ ['zeta'		,'ζ'],
    \ ['eta'		,'η'],
    \ ['theta'		,'θ'],
    \ ['vartheta'	,'ϑ'],
    \ ['kappa'		,'κ'],
    \ ['lambda'		,'λ'],
    \ ['mu'		,'μ'],
    \ ['nu'		,'ν'],
    \ ['xi'		,'ξ'],
    \ ['pi'		,'π'],
    \ ['varpi'		,'ϖ'],
    \ ['rho'		,'ρ'],
    \ ['varrho'		,'ϱ'],
    \ ['sigma'		,'σ'],
    \ ['varsigma'	,'ς'],
    \ ['tau'		,'τ'],
    \ ['upsilon'	,'υ'],
    \ ['phi'		,'φ'],
    \ ['varphi'		,'ϕ'],
    \ ['chi'		,'χ'],
    \ ['psi'		,'ψ'],
    \ ['omega'		,'ω'],
    \ ['Gamma'		,'Γ'],
    \ ['Delta'		,'Δ'],
    \ ['Theta'		,'Θ'],
    \ ['Lambda'		,'Λ'],
    \ ['Xi'		,'Χ'],
    \ ['Pi'		,'Π'],
    \ ['Sigma'		,'Σ'],
    \ ['Upsilon'	,'Υ'],
    \ ['Phi'		,'Φ'],
    \ ['Psi'		,'Ψ'],
    \ ['Omega'		,'Ω']]
  for symbol in s:contextGreekList
    exe "syn match contextMathGreek '\\\\".symbol[0]."\\>' contained conceal cchar=".symbol[1]
  endfor

  """ Superscripts/Subscripts
  " texMathMatcher ???
  syn region contextSuperscript matchgroup=contextDelimiter
             \ contained concealends
             \ contains=contextSuperscripts,contextSuperscript,contextSubscript,contextCommand
             \ start='\^{' end='}'
  syn region contextSubscript   matchgroup=contextDelimiter
             \ contained concealends
             \ contains=contextSubscripts,contextSuperscript,contextSubscript,contextCommand
             \ start='_{' end='}'

  let s:contextSubscriptList=[
    \ ['0','₀'],
    \ ['1','₁'],
    \ ['2','₂'],
    \ ['3','₃'],
    \ ['4','₄'],
    \ ['5','₅'],
    \ ['6','₆'],
    \ ['7','₇'],
    \ ['8','₈'],
    \ ['9','₉'],
    \ ['a','ₐ'],
    \ ['e','ₑ'],
    \ ['i','ᵢ'],
    \ ['o','ₒ'],
    \ ['u','ᵤ'],
    \ ['+','₊'],
    \ ['-','₋'],
    \ ['/','ˏ'],
    \ ['(','₍'],
    \ [')','₎'],
    \ ['\.','‸'],
    \ ['r','ᵣ'],
    \ ['v','ᵥ'],
    \ ['x','ₓ'],
    \ ['\\beta\>' ,'ᵦ'],
    \ ['\\delta\>','ᵨ'],
    \ ['\\phi\>'  ,'ᵩ'],
    \ ['\\gamma\>','ᵧ'],
    \ ['\\chi\>'  ,'ᵪ']]

  let s:contextSuperscriptList=[
    \ ['0','⁰'],
    \ ['1','¹'],
    \ ['2','²'],
    \ ['3','³'],
    \ ['4','⁴'],
    \ ['5','⁵'],
    \ ['6','⁶'],
    \ ['7','⁷'],
    \ ['8','⁸'],
    \ ['9','⁹'],
    \ ['a','ᵃ'],
    \ ['b','ᵇ'],
    \ ['c','ᶜ'],
    \ ['d','ᵈ'],
    \ ['e','ᵉ'],
    \ ['f','ᶠ'],
    \ ['g','ᵍ'],
    \ ['h','ʰ'],
    \ ['i','ⁱ'],
    \ ['j','ʲ'],
    \ ['k','ᵏ'],
    \ ['l','ˡ'],
    \ ['m','ᵐ'],
    \ ['n','ⁿ'],
    \ ['o','ᵒ'],
    \ ['p','ᵖ'],
    \ ['r','ʳ'],
    \ ['s','ˢ'],
    \ ['t','ᵗ'],
    \ ['u','ᵘ'],
    \ ['v','ᵛ'],
    \ ['w','ʷ'],
    \ ['x','ˣ'],
    \ ['y','ʸ'],
    \ ['z','ᶻ'],
    \ ['A','ᴬ'],
    \ ['B','ᴮ'],
    \ ['D','ᴰ'],
    \ ['E','ᴱ'],
    \ ['G','ᴳ'],
    \ ['H','ᴴ'],
    \ ['I','ᴵ'],
    \ ['J','ᴶ'],
    \ ['K','ᴷ'],
    \ ['L','ᴸ'],
    \ ['M','ᴹ'],
    \ ['N','ᴺ'],
    \ ['O','ᴼ'],
    \ ['P','ᴾ'],
    \ ['R','ᴿ'],
    \ ['T','ᵀ'],
    \ ['U','ᵁ'],
    \ ['W','ᵂ'],
    \ ['+','⁺'],
    \ ['-','⁻'],
    \ ['<','˂'],
    \ ['>','˃'],
    \ ['/','ˊ'],
    \ ['(','⁽'],
    \ [']','⁾'],
    \ ['\.','˙'],
    \ ['=','˭']]

  for symbol in s:contextSubscriptList
    exe "syn match contextSubscript    '_".symbol[0]."' contained conceal cchar=".symbol[1]
    exe "syn match contextSubscripts    '".symbol[0]."' contained conceal cchar=".symbol[1]." nextgroup=contextSubscripts"
  endfor

  for symbol in s:contextSuperscriptList
    exe "syn match contextSuperscript '\^".symbol[0]."' contained conceal cchar=".symbol[1]
    exe "syn match contextSuperscipts   '".symbol[0]."' contained conceal cchar=".symbol[1]." nextgroup=contextSuperscipts"
  endfor

  syn cluster contextMathGroup add=contextSuperscipt,contextSubscript,contextMathSymbol,contextMathGreek

endif

" Typing: {{{1
" -------

syn region  contextTyping     display matchgroup=contextCommand keepend
                              \ start='\\type\z(\A\)' end='\z1'
syn region  contextTyping     display matchgroup=contextCommand keepend
                              \ start='\\\%(type\?\|tex\|mat\){' end='}'

syn region  contextTyping     matchgroup=contextBlock contains=contextComment keepend
                              \ start='\\start\z(\a*\)typing\>' end='\\stop\z1typing\>'

" Emphasize: {{{1
" ----------

syn region  contextEmphasize  display matchgroup=contextCommand keepend
                              \ start='\\emph{' end='}'
"FIXME
syn region  contextEmphasize  matchgroup=contextBlock contains=contextCommand,contextBlock keepend
                              \ start='\\startemphasize\>' end='\\stopemphasize\>'

" Highlight Definitions: {{{1
" ======================

" Comments:
hi def link contextTodo       Todo
hi def link contextComment    Comment
hi def link contextHiding     contextComment

" Constants:
hi def link contextDimension  Constant
hi def link contextMath       String
hi def link contextMathText   Normal
hi def link contextTyping     String

" Identifiers:
hi def link contextParameter  Identifier
hi def link contextCommand    Function

" Statements:
hi def link contextBlock      Statement
hi def link contextSection    Keyword

" Preprocessors:
hi def link contextDefine     Define
hi def link contextSetup      contextDefine
hi def link contextMode       contextDefine
hi def link contextProject    Include

" Types:
hi def link contextFont       Type
hi def link contextStyle      Type
hi def link contextCapital    contextStyle

" Specials:
hi def link contextDelimiter  Delimiter
hi def link contextSpecial    Special
hi def link contextEscaped    contextSpecial
hi def link contextLabel      Tag

" Conceal:
hi!    link Conceal           SpecialChar

" Markup:
hi          contextEmphasize  gui=italic

" Finalize Syntaxfile: {{{1
" ====================

let b:current_syntax = "context"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8 nowrap
