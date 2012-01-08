" Vim syntax file
" Language:         ConTeXt typesetting engine
" Maintainer:       Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Latest Revision:  2012-01-03

" Initialize Syntaxfile: {{{1
" ======================

if exists("b:current_syntax")
  finish
endif

scriptencoding utf-8

let s:cpo_save = &cpo
set cpo&vim

setlocal fdm=syntax
setlocal isk-=_

" Syntax Definitions:
" ===================

"FIXME
syn cluster contextDocumentGroup contains=contextComment

" Commands: {{{1
" ---------

" We just match \...alphabetic... Sometimes @ and ! are used inside commands, but this is only supported inside \unprotect'ed environments.
syn match   contextCommand    display '\\\a\+'

syn match   contextBlock      display '\\\%(start\|stop\)\a*'

syn match   contextCondition  display '\\doif\a*' 

"syn match   contextDefine     display '\\[egx]\%(def\|let\)'
syn match   contextDefine     display '\\\%(define\|set\|get\)\a*'
syn match   contextDefine     display '\\\%(start\|stop\)texdefinition\>'
syn match   contextSetup      display '\\\%(setup\|use\|enable\|disable\|show\)\a*'

"FIXME contextInclude --> contextInput omdat dat in TeX zo heet?
syn match   contextInclude    display '^\s*\\\%(component\|product\|project\|environment\|input\)\>.*$'

" Sections: {{{1
" ---------

"FIXME: contextInclude --> contextStructure duidelijker?
"FIXME: transparant maken en appart highlighten?
"FIXME: alleen gebruiken voor sync?
syn region  contextDocument   matchgroup=contextInclude start='^\\starttext$'                end='^\\stoptext$'        contains=TOP
syn region  contextDocument   matchgroup=contextInclude start='^\\startcomponent\>.*$'       end='^\\stopcomponent$'   contains=TOP
syn region  contextDocument   matchgroup=contextInclude start='^\\startproduct\>.*$'         end='^\\stopproduct$'     contains=TOP
syn region  contextDocument   matchgroup=contextInclude start='^\\startproject\>.*$'         end='^\\stopproject$'     contains=TOP
syn region  contextDocument   matchgroup=contextInclude start='^\\startenvironment\>.*$'     end='^\\stopenvironment$' contains=TOP

syn region  contextPart       matchgroup=contextHead    start='\\startpart\>'                end='\\stoppart\>'                                                                                                                fold containedin=contextDocument                contains=TOP
syn region  contextPart       matchgroup=contextHead    start='\\part\>'                     end='\ze\\\%(part\|\stop\%(text\|component\|product\|project\|environment\)\>\)'                                                  fold containedin=contextDocument                contains=TOP

syn region  contextChapter    matchgroup=contextHead    start='\\startchapter\>'             end='\\stopchapter\>'                                                                                                             fold containedin=contextDocument,contextPart    contains=TOP
syn region  contextChapter    matchgroup=contextHead    start='\\starttitle\>'               end='\\stoptitle\>'                                                                                                               fold containedin=contextDocument,contextPart    contains=TOP
syn region  contextChapter    matchgroup=contextHead    start='\\\%(chapter\|title\)\>'      end='\ze\\\%(chapter\|title\|part\|\stop\%(text\|component\|product\|project\|environment\)\>\)'                                  fold containedin=contextDocument,contextPart    contains=TOP

syn region  contextSection    matchgroup=contextHead    start='\\startsection\>'             end='\\stopsection\>'                                                                                                             fold containedin=contextDocument,contextChapter contains=TOP
syn region  contextSection    matchgroup=contextHead    start='\\startsubject\>'             end='\\stopsubject\>'                                                                                                             fold containedin=contextDocument,contextChapter contains=TOP
syn region  contextSection    matchgroup=contextHead    start='\\\%(section\|subject\)\>'    end='\ze\\\%(section\|subject\|chapter\|title\|part\|\stop\%(text\|component\|product\|project\|environment\)\>\)'                fold containedin=contextDocument,contextChapter contains=TOP

syn region  contextSubsection matchgroup=contextHead    start='\\startsubsection\>'          end='\\stopsubsection\>'                                                                                                          fold containedin=contextDocument,contextSection contains=TOP
syn region  contextSubsection matchgroup=contextHead    start='\\startsubsubject\>'          end='\\stopsubsubject\>'                                                                                                          fold containedin=contextDocument,contextSection contains=TOP
syn region  contextSubsection matchgroup=contextHead    start='\\sub\%(section\|subject\)\>' end='\ze\\\%(\%(sub\)\?\%(section\|subject\)\|chapter\|title\|part\|\stop\%(text\|component\|product\|project\|environment\)\>\)' fold containedin=contextDocument,contextSection contains=TOP

" We don't fold anthing lower than sub(section|subject), just highlight it.
"FIXME: --> contextSubsubsection geeft geen clash met folds?
syn match   contextHead       display '\\\%(sub\)\+subsection\>' containedin=contextSubsection
syn match   contextHead       display '\\\%(sub\)\+subsubject\>' containedin=contextSubsection

" Fonts And Styles: {{{1
" -----------------

syn match   contextFont       display '\\\%(rm\|ss\|tt\|hw\|cg\|mf\)\>'

syn match   contextStyle      display '\\\%(em\|tf\|b[fsi]\|s[cl]\|it\|os\)\%(xx\|[xabcd]\)\?\>'
syn match   contextStyle      display '\\\%(vi\{1,3}\|ix\|xi\{0,2}\)\>'

syn match   contextCapital    display '\\\%(cap\|Cap\|CAP\|Caps\|nocap\)\>'
syn match   contextCapital    display '\\\%(Word\|WORD\|Words\|WORDS\)\>'
"FIXME: what is this?
"syn match   contextCapital    display '\\\%(character\|Character\)s\?\>'

" Specials: {{{1
" ---------

syn match   contextDelimiter  display '\\\@![][{}]'

syn match   contextDimension  display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\%(p[tc]\|in\|bp\|cc]\|[cm]m\|dd\|sp\|e[mx]\)\>'
syn match   contextNumber     display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\>' contained

syn match   contextEscaped    display '\\[%#~&$^_\{} \n]'
"syn match   contextEscaped    display '\\[`'"]'

syn match   contextSpecial    display '\\\%(par\|crlf\)\>'
syn match   contextSpecial    display '\\\@!\%(~\|&\|\^\|_\|-\{2,3}\)'

"FIXME
syn match   contextParameter  display '\\\@!#\d\+'

"TODO errors: #, ^, _
"TODO hyphens?: ||

"FIXME
syn region  contextArgument   display matchgroup=contextDelimiter keepend start='\[' end='\]' contains=contextLabel,contextCommand,contextDimension,contextNumber

syn match   contextLabel      display '\a\+:[0-9a-zA-Z: ]\+' contained

" Comments: {{{1
" ---------

syn keyword contextTodo       TODO FIXME NOTE XXX

syn match   contextComment    display '\\\@!%.*$'    contains=contextTodo
syn match   contextComment    display '^%[CDM]\s.*$' contains=TOP,contextComment contains=@Spell

syn region  contextHiding     matchgroup=contextBlock keepend start='\\starthiding\>' end='\\stophiding\>'

" Math: {{{1
" -----

"FIXME
syn cluster contextMathGroup  contains=contextComment,contextCommand,contextBlock,contextDelimiter,contextEscaped,contextSpecial,contextFont,contextStyle


syn region  contextMath       display matchgroup=contextDelimiter keepend start='\$'                       end='\$'                 contains=contextMathText,@contextMathGroup
syn region  contextMath       display matchgroup=contextCommand   keepend start='\\math\%(ematics\)\?{'    end='}'                  contains=contextMathText,@contextMathGroup

syn region  contextMath               matchgroup=contextDelimiter keepend start='\$\$'                     end='\$\$'               contains=contextMathText,@contextMathGroup
syn region  contextMath               matchgroup=contextBlock     keepend start='\\start\z(\a*\)formula\>' end='\\stop\z1formula\>' contains=contextMathText,@contextMathGroup

syn region  contextMathText   display matchgroup=contextCommand   keepend start='\\\%(inter\)\?text{'      end='}'        contained contains=contextMath,@contextMathGroup

" Math Concealment: {{{1
" ~~~~~~~~~~~~~~~~~
"
" Many symbols by Björn Winckler, additions by Tim Steenvoorden.

if has('conceal') && &enc == 'utf-8'

  " We will define the unbraced variants seperatly for each symbol in the function ContextConcealScript.
  syn region contextSuperscript matchgroup=contextDelimiter start='\^{' end='}' concealends contained containedin=contextMath contains=contextSuperscript,contextSubscript,contextSuperscripts,contextCommand
  syn region contextSubscript   matchgroup=contextDelimiter start='_{'  end='}' concealends contained containedin=contextMath contains=contextSuperscript,contextSubscript,contextSubscripts,contextCommand

  "syn cluster contextMathGroup add=contextSuperscipt,contextSubscript,contextMathSymbol

  fun! s:ContextConcealSymbol(pattern, replacement)
    exe 'syn match contextMathSymbol "'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:replacement
  endfun

  fun! s:ContextConcealScript(pattern, superscript, subscript)
    exe 'syn match contextSuperscript "\^'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:superscript
    exe 'syn match contextSubscript    "_'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:subscript
    exe 'syn match contextSuperscripts  "'.a:pattern.'" contained                         conceal cchar='.a:superscript.' nextgroup=contextSuperscripts'
    exe 'syn match contextSubscripts    "'.a:pattern.'" contained                         conceal cchar='.a:subscript.'   nextgroup=contextSubscripts'
  endfun

  " Math Symbols: {{{2
  let s:contextMathSymbols=[
    \ ['angle'              , '∠'],
    \ ['approx'             , '≈'],
    \ ['ast'                , '∗'],
    \ ['asymp'              , '≍'],
    \ ['backepsilon'        , '∍'],
    \ ['backsimeq'          , '≃'],
    \ ['barwedge'           , '⊼'],
    \ ['because'            , '∵'],
    \ ['between'            , '≬'],
    \ ['bigcap'             , '∩'],
    \ ['bigcup'             , '∪'],
    \ ['bigodot'            , '⊙'],
    \ ['bigoplus'           , '⊕'],
    \ ['bigotimes'          , '⊗'],
    \ ['bigsqcup'           , '⊔'],
    \ ['bigtriangledown'    , '∇'],
    \ ['bigvee'             , '⋁'],
    \ ['bigwedge'           , '⋀'],
    \ ['blacksquare'        , '∎'],
    \ ['bot'                , '⊥'],
    \ ['boxdot'             , '⊡'],
    \ ['boxminus'           , '⊟'],
    \ ['boxplus'            , '⊞'],
    \ ['boxtimes'           , '⊠'],
    \ ['bumpeq'             , '≏'],
    \ ['Bumpeq'             , '≎'],
    \ ['cap'                , '∩'],
    \ ['Cap'                , '⋒'],
    \ ['cdot'               , '·'],
    \ ['cdots'              , '⋯'],
    \ ['circ'               , '∘'],
    \ ['circeq'             , '≗'],
    \ ['circlearrowleft'    , '↺'],
    \ ['circlearrowright'   , '↻'],
    \ ['circledast'         , '⊛'],
    \ ['circledcirc'        , '⊚'],
    \ ['complement'         , '∁'],
    \ ['cong'               , '≅'],
    \ ['coprod'             , '∐'],
    \ ['cup'                , '∪'],
    \ ['Cup'                , '⋓'],
    \ ['curlyeqprec'        , '⋞'],
    \ ['curlyeqsucc'        , '⋟'],
    \ ['curlyvee'           , '⋎'],
    \ ['curlywedge'         , '⋏'],
    \ ['dashv'              , '⊣'],
    \ ['diamond'            , '⋄'],
    \ ['div'                , '÷'],
    \ ['doteq'              , '≐'],
    \ ['doteqdot'           , '≑'],
    \ ['dotplus'            , '∔'],
    \ ['dotsb'              , '⋯'],
    \ ['dotsc'              , '…'],
    \ ['dots'               , '…'],
    \ ['dotsi'              , '⋯'],
    \ ['dotso'              , '…'],
    \ ['doublebarwedge'     , '⩞'],
    \ ['downarrow'          , '↓'],
    \ ['Downarrow'          , '⇓'],
    \ ['emptyset'           , '∅'],
    \ ['eqcirc'             , '≖'],
    \ ['eqsim'              , '≂'],
    \ ['eqslantgtr'         , '⪖'],
    \ ['eqslantless'        , '⪕'],
    \ ['equiv'              , '≡'],
    \ ['exists'             , '∃'],
    \ ['fallingdotseq'      , '≒'],
    \ ['forall'             , '∀'],
    \ ['ge'                 , '≥'],
    \ ['geq'                , '≥'],
    \ ['geqq'               , '≧'],
    \ ['gets'               , '←'],
    \ ['gg'                 , '≫'],
    \ ['gneqq'              , '≩'],
    \ ['gtrdot'             , '⋗'],
    \ ['gtreqless'          , '⋛'],
    \ ['gtrless'            , '≷'],
    \ ['gtrsim'             , '≳'],
    \ ['hookleftarrow'      , '↩'],
    \ ['hookrightarrow'     , '↪'],
    \ ['iiint'              , '∭'],
    \ ['iint'               , '∬'],
    \ ['Im'                 , 'ℑ'],
    \ ['in'                 , '∈'],
    \ ['infty'              , '∞'],
    \ ['int'                , '∫'],
    \ ['lceil'              , '⌈'],
    \ ['ldots'              , '…'],
    \ ['le'                 , '≤'],
    \ ['leftarrow'          , '⟵'],
    \ ['Leftarrow'          , '⟸'],
    \ ['leftarrowtail'      , '↢'],
    \ ['left('              , '('],
    \ ['left\['             , '['],
    \ ['left\\{'            , '{'],
    \ ['Leftrightarrow'     , '⇔'],
    \ ['leftrightsquigarrow', '↭'],
    \ ['leftthreetimes'     , '⋋'],
    \ ['leq'                , '≤'],
    \ ['leqq'               , '≦'],
    \ ['lessdot'            , '⋖'],
    \ ['lesseqgtr'          , '⋚'],
    \ ['lesssim'            , '≲'],
    \ ['lfloor'             , '⌊'],
    \ ['ll'                 , '≪'],
    \ ['lneqq'              , '≨'],
    \ ['ltimes'             , '⋉'],
    \ ['mapsto'             , '↦'],
    \ ['measuredangle'      , '∡'],
    \ ['mid'                , '∣'],
    \ ['mp'                 , '∓'],
    \ ['nabla'              , '∇'],
    \ ['ncong'              , '≇'],
    \ ['nearrow'            , '↗'],
    \ ['ne'                 , '≠'],
    \ ['neg'                , '¬'],
    \ ['neq'                , '≠'],
    \ ['nexists'            , '∄'],
    \ ['ngeq'               , '≱'],
    \ ['ngeqq'              , '≱'],
    \ ['ngtr'               , '≯'],
    \ ['ni'                 , '∋'],
    \ ['nleftarrow'         , '↚'],
    \ ['nLeftarrow'         , '⇍'],
    \ ['nLeftrightarrow'    , '⇎'],
    \ ['nleq'               , '≰'],
    \ ['nleqq'              , '≰'],
    \ ['nless'              , '≮'],
    \ ['nmid'               , '∤'],
    \ ['notin'              , '∉'],
    \ ['nprec'              , '⊀'],
    \ ['nrightarrow'        , '↛'],
    \ ['nRightarrow'        , '⇏'],
    \ ['nsim'               , '≁'],
    \ ['nsucc'              , '⊁'],
    \ ['ntriangleleft'      , '⋪'],
    \ ['ntrianglelefteq'    , '⋬'],
    \ ['ntriangleright'     , '⋫'],
    \ ['ntrianglerighteq'   , '⋭'],
    \ ['nvdash'             , '⊬'],
    \ ['nvDash'             , '⊭'],
    \ ['nVdash'             , '⊮'],
    \ ['nwarrow'            , '↖'],
    \ ['odot'               , '⊙'],
    \ ['oint'               , '∮'],
    \ ['ominus'             , '⊖'],
    \ ['oplus'              , '⊕'],
    \ ['oslash'             , '⊘'],
    \ ['otimes'             , '⊗'],
    \ ['owns'               , '∋'],
    \ ['partial'            , '∂'],
    \ ['perp'               , '⊥'],
    \ ['pitchfork'          , '⋔'],
    \ ['pm'                 , '±'],
    \ ['precapprox'         , '⪷'],
    \ ['prec'               , '≺'],
    \ ['preccurlyeq'        , '≼'],
    \ ['preceq'             , '⪯'],
    \ ['precnapprox'        , '⪹'],
    \ ['precneqq'           , '⪵'],
    \ ['precsim'            , '≾'],
    \ ['prod'               , '∏'],
    \ ['propto'             , '∝'],
    \ ['rceil'              , '⌉'],
    \ ['Re'                 , 'ℜ'],
    \ ['rfloor'             , '⌋'],
    \ ['rightarrow'         , '⟶'],
    \ ['Rightarrow'         , '⟹'],
    \ ['rightarrowtail'     , '↣'],
    \ ['right)'             , ')'],
    \ ['right]'             , ']'],
    \ ['right\\}'           , '}'],
    \ ['rightsquigarrow'    , '↝'],
    \ ['rightthreetimes'    , '⋌'],
    \ ['risingdotseq'       , '≓'],
    \ ['rtimes'             , '⋊'],
    \ ['searrow'            , '↘'],
    \ ['setminus'           , '∖'],
    \ ['sim'                , '∼'],
    \ ['sphericalangle'     , '∢'],
    \ ['sqcap'              , '⊓'],
    \ ['sqcup'              , '⊔'],
    \ ['sqsubset'           , '⊏'],
    \ ['sqsubseteq'         , '⊑'],
    \ ['sqsupset'           , '⊐'],
    \ ['sqsupseteq'         , '⊒'],
    \ ['subset'             , '⊂'],
    \ ['Subset'             , '⋐'],
    \ ['subseteq'           , '⊆'],
    \ ['subseteqq'          , '⫅'],
    \ ['subsetneq'          , '⊊'],
    \ ['subsetneqq'         , '⫋'],
    \ ['succapprox'         , '⪸'],
    \ ['succ'               , '≻'],
    \ ['succcurlyeq'        , '≽'],
    \ ['succeq'             , '⪰'],
    \ ['succnapprox'        , '⪺'],
    \ ['succneqq'           , '⪶'],
    \ ['succsim'            , '≿'],
    \ ['sum'                , '∑'],
    \ ['Supset'             , '⋑'],
    \ ['supseteq'           , '⊇'],
    \ ['supseteqq'          , '⫆'],
    \ ['supsetneq'          , '⊋'],
    \ ['supsetneqq'         , '⫌'],
    \ ['surd'               , '√'],
    \ ['swarrow'            , '↙'],
    \ ['therefore'          , '∴'],
    \ ['times'              , '×'],
    \ ['to'                 , '→'],
    \ ['top'                , '⊤'],
    \ ['triangleleft'       , '⊲'],
    \ ['trianglelefteq'     , '⊴'],
    \ ['triangleq'          , '≜'],
    \ ['triangleright'      , '⊳'],
    \ ['trianglerighteq'    , '⊵'],
    \ ['twoheadleftarrow'   , '↞'],
    \ ['twoheadrightarrow'  , '↠'],
    \ ['uparrow'            , '↑'],
    \ ['Uparrow'            , '⇑'],
    \ ['updownarrow'        , '↕'],
    \ ['Updownarrow'        , '⇕'],
    \ ['varnothing'         , '∅'],
    \ ['vartriangle'        , '∆'],
    \ ['vdash'              , '⊢'],
    \ ['vDash'              , '⊨'],
    \ ['Vdash'              , '⊩'],
    \ ['vdots'              , '⋮'],
    \ ['veebar'             , '⊻'],
    \ ['vee'                , '∨'],
    \ ['Vvdash'             , '⊪'],
    \ ['wedge'              , '∧'],
    \ ['wr'                 , '≀']]

  for symbol in s:contextMathSymbols
    call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
  endfor

  " Greek Symbols: {{{2
  let s:contextGreekSymbols=[
    \ ['alpha'     , 'α', ' ', ' '],
    \ ['beta'      , 'β', ' ', 'ᵦ'],
    \ ['gamma'     , 'γ', ' ', 'ᵧ'],
    \ ['delta'     , 'δ', ' ', ' '],
    \ ['epsilon'   , 'ϵ', ' ', ' '],
    \ ['varepsilon', 'ε', ' ', ' '],
    \ ['zeta'      , 'ζ', ' ', ' '],
    \ ['eta'       , 'η', ' ', ' '],
    \ ['theta'     , 'θ', ' ', ' '],
    \ ['vartheta'  , 'ϑ', ' ', ' '],
    \ ['kappa'     , 'κ', ' ', ' '],
    \ ['lambda'    , 'λ', ' ', ' '],
    \ ['mu'        , 'μ', ' ', ' '],
    \ ['nu'        , 'ν', ' ', ' '],
    \ ['xi'        , 'ξ', ' ', ' '],
    \ ['pi'        , 'π', ' ', ' '],
    \ ['varpi'     , 'ϖ', ' ', ' '],
    \ ['rho'       , 'ρ', ' ', ' '],
    \ ['varrho'    , 'ϱ', ' ', 'ᵨ'],
    \ ['sigma'     , 'σ', ' ', ' '],
    \ ['varsigma'  , 'ς', ' ', ' '],
    \ ['tau'       , 'τ', ' ', ' '],
    \ ['upsilon'   , 'υ', ' ', ' '],
    \ ['phi'       , 'ϕ', ' ', ' '],
    \ ['varphi'    , 'φ', ' ', 'ᵩ'],
    \ ['chi'       , 'χ', ' ', 'ᵪ'],
    \ ['psi'       , 'ψ', ' ', ' '],
    \ ['omega'     , 'ω', ' ', ' '],
    \ ['Gamma'     , 'Γ', ' ', ' '],
    \ ['Delta'     , 'Δ', ' ', ' '],
    \ ['Theta'     , 'Θ', ' ', ' '],
    \ ['Lambda'    , 'Λ', ' ', ' '],
    \ ['Xi'        , 'Χ', ' ', ' '],
    \ ['Pi'        , 'Π', ' ', ' '],
    \ ['Sigma'     , 'Σ', ' ', ' '],
    \ ['Upsilon'   , 'Υ', ' ', ' '],
    \ ['Phi'       , 'Φ', ' ', ' '],
    \ ['Psi'       , 'Ψ', ' ', ' '],
    \ ['Omega'     , 'Ω', ' ', ' ']]

  for symbol in s:contextGreekSymbols
    call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
    call s:ContextConcealScript('\\'.symbol[0].'\>', symbol[2], symbol[3])
  endfor

  " Printable Symbols: {{{2
  let s:contextPrintableSymbols=[
    \ ['0' , '⁰', '₀'],
    \ ['1' , '¹', '₁'],
    \ ['2' , '²', '₂'],
    \ ['3' , '³', '₃'],
    \ ['4' , '⁴', '₄'],
    \ ['5' , '⁵', '₅'],
    \ ['6' , '⁶', '₆'],
    \ ['7' , '⁷', '₇'],
    \ ['8' , '⁸', '₈'],
    \ ['9' , '⁹', '₉'],
    \ ['a' , 'ᵃ', 'ₐ'],
    \ ['b' , 'ᵇ', ' '],
    \ ['c' , 'ᶜ', ' '],
    \ ['d' , 'ᵈ', ' '],
    \ ['e' , 'ᵉ', 'ₑ'],
    \ ['f' , 'ᶠ', ' '],
    \ ['g' , 'ᵍ', ' '],
    \ ['h' , 'ʰ', ' '],
    \ ['i' , 'ⁱ', 'ᵢ'],
    \ ['j' , 'ʲ', ' '],
    \ ['k' , 'ᵏ', ' '],
    \ ['l' , 'ˡ', ' '],
    \ ['m' , 'ᵐ', ' '],
    \ ['n' , 'ⁿ', ' '],
    \ ['o' , 'ᵒ', 'ₒ'],
    \ ['p' , 'ᵖ', ' '],
    \ ['q' , ' ', ' '],
    \ ['r' , 'ʳ', ' '],
    \ ['s' , 'ˢ', ' '],
    \ ['t' , 'ᵗ', ' '],
    \ ['u' , 'ᵘ', 'ᵤ'],
    \ ['v' , 'ᵛ', ' '],
    \ ['w' , 'ʷ', ' '],
    \ ['x' , 'ˣ', ' '],
    \ ['y' , 'ʸ', ' '],
    \ ['z' , 'ᶻ', ' '],
    \ ['A' , 'ᴬ', ' '],
    \ ['B' , 'ᴮ', ' '],
    \ ['C' , ' ', ' '],
    \ ['D' , 'ᴰ', ' '],
    \ ['E' , 'ᴱ', ' '],
    \ ['F' , ' ', ' '],
    \ ['G' , 'ᴳ', ' '],
    \ ['H' , 'ᴴ', ' '],
    \ ['I' , 'ᴵ', ' '],
    \ ['J' , 'ᴶ', ' '],
    \ ['K' , 'ᴷ', ' '],
    \ ['L' , 'ᴸ', ' '],
    \ ['M' , 'ᴹ', ' '],
    \ ['N' , 'ᴺ', ' '],
    \ ['O' , 'ᴼ', ' '],
    \ ['P' , 'ᴾ', ' '],
    \ ['Q' , ' ', ' '],
    \ ['R' , 'ᴿ', 'ᵣ'],
    \ ['S' , ' ', ' '],
    \ ['T' , 'ᵀ', ' '],
    \ ['U' , 'ᵁ', ' '],
    \ ['V' , ' ', 'ᵥ'],
    \ ['W' , 'ᵂ', ' '],
    \ ['X' , ' ', 'ₓ'],
    \ ['Y' , ' ', ' '],
    \ ['Z' , ' ', ' ']]

  let s:contextSubscriptList=[
    \ ['+'        , '₊'],
    \ ['-'        , '₋'],
    \ ['/'        , 'ˏ'],
    \ ['('        , '₍'],
    \ [')'        , '₎'],
    \ ['\.'       , '‸']]

  let s:contextSuperscriptList=[
    \ ['+' , '⁺'],
    \ ['-' , '⁻'],
    \ ['/' , 'ˊ'],
    \ ['(' , '⁽'],
    \ [')' , '⁾'],
    \ ['<' , '˂'],
    \ ['>' , '˃'],
    \ ['\.', '˙'],
    \ ['=' , '˭']]

  for symbol in s:contextPrintableSymbols
    call s:ContextConcealScript(symbol[0], symbol[1], symbol[2])
  endfor

endif

" Typing: {{{1
" -------

"FIXME
syn cluster contextTypingGroup contains=contextComment

syn region  contextTyping     display matchgroup=contextCommand keepend start='\\type\z(\A\)'                 end='\z1'
syn region  contextTyping     display matchgroup=contextCommand keepend start='\\\%(type\?\|tex\|arg\|mat\){' end='}'

syn region  contextTyping             matchgroup=contextBlock   keepend start='\\start\z(\a*\)typing\>'       end='\\stop\z1typing\>' contains=contextComment

" Emphasize: {{{1
" ----------

"FIXME: contains
syn region  contextEmphasize  display matchgroup=contextCommand keepend start='\\emph{'            end='}'
syn region  contextEmphasize          matchgroup=contextBlock   keepend start='\\startemphasize\>' end='\\stopemphasize\>' contains=contextCommand,contextBlock

" Highlight Definitions: {{{1
" ======================

" Comments:
hi def link contextTodo       Todo
hi def link contextComment    Comment
hi def link contextHiding     contextComment

" Constants:
hi def link contextDimension  Constant
hi def link contextNumber     contextDimension

" Regions:
hi def link contextMath       String
hi def link contextTyping     String
hi def link contextMathText   Normal
hi          contextEmphasize  gui=italic

" Commands:
hi def link contextCommand    Function
hi def link contextBlock      Statement
hi def link contextHead       Keyword
hi def link contextCondition  Conditional

" Definitions:
hi def link contextDefine     Define
hi def link contextSetup      contextDefine
hi def link contextMode       contextDefine
hi def link contextInclude    Include

" Types:
hi def link contextFont       Type
hi def link contextStyle      Type
hi def link contextCapital    contextStyle

" Specials:
hi def link contextDelimiter  Delimiter
hi def link contextParameter  Identifier
hi def link contextSpecial    Special
hi def link contextEscaped    contextSpecial
hi def link contextLabel      Tag

" Conceal:
hi!    link Conceal           SpecialChar

" Finalize Syntaxfile: {{{1
" ====================

let b:current_syntax = "context"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8 nowrap fdm=marker
