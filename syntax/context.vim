" Vim syntax file
" Language:         ConTeXt typesetting engine
" Maintainer:       Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Latest Revision:  2012-01-13

" Initialize Syntaxfile: {{{1
" ======================

if exists('b:current_syntax')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

scriptencoding utf-8

setlocal isk-=_

syn spell toplevel

" Syntax Definitions:
" ===================

" Commands: {{{1
" ---------

" We just match \...alphabetic... Sometimes @ and ! are used inside commands, but this is only supported inside \unprotect'ed environments.
syn match   contextCommand    display '\\\a\+'

" Some commands are special statements...
syn match   contextBlock      display '\\\%(start\|stop\)\a*'

syn match   contextCondition  display '\\doif\a*' 
syn match   contextCondition  display '\\\%(start\|stop\)\%(not\)\?\%(all\)\?mode\>'

syn match   contextLoop       display '\\do\%(\%(stepwise\)\?recurse\|loop\)\>'
syn match   contextLoop       display '\\\%(recurselevel\|exitloop\)\>'

" ...or section heads.
syn match   contextHead       display '\\\%(start\|stop\)\?part\>'
syn match   contextHead       display '\\\%(start\|stop\)\?\%(chapter\|title\)\>'
syn match   contextHead       display '\\\%(start\|stop\)\?\%(sub\)*\%(section\|subject\)\>'

" The mistake I make most often.
syn match   contextStructureError     display '\\\%(start\)\?\%(component\|product\|project\|environment\)\>'
syn match   contextStructureError     display '\\input\>'

" And these define the document structure.
syn match   contextStructure  display '^\s*\\\%(start\)\?\%(component\|product\|project\|environment\)\s\+\S\+$'
syn match   contextStructure  display '^\s*\\stop\%(component\|product\|project\|environment\)$'
syn match   contextStructure  display '^\s*\\input\s\+\S\+$'
syn match   contextStructure  display '^\s*\\\%(start\|stop\)text$'

" Definitions And Setups: {{{1
" -----------------------

"syn match   contextDefine     display '\\[egx]\%(def\|let\)'
syn match   contextDefine     display '\\\%(re\)\?define\>'
syn match   contextDefine     display '\\\%(define\|\%(re\)\?set\|get\|let\)\a\+'
syn match   contextDefine     display '\\\%(start\|stop\)texdefinition\>'

syn match   contextSetup      display '\\\%(setup\|use\|enable\|disable\|prevent\|show\)\a\+'
syn match   contextSetup      display '\\\%(start\|stop\)\?setups\>'

" Groups And Arguments: {{{1
" -------------------

" The purpose of this code is only to highlight matching braces and parenthesis. Just as the folds defined below they are transparent.
"FIXME conceal inside group and gather
syn region  contextGroup      transparent matchgroup=contextDelimiter start='{'  end='}'
syn region  contextGather     transparent matchgroup=contextDelimiter start='('  end=')'

" To get rid of nasty spell errors for options, we don't allow spell check inside argument brackets. Here we can't use transparent
syn region  contextArgument               matchgroup=contextDelimiter start='\[' end='\]' contains=TOP,@Spell,contextScriptError

" Ending delimiters that are not matched by groups, gathers and arguments above (which have priority because the opening starts earlier), are matched as errors.
syn match   contextMismatch   display '[]})]'

" As a bonus, we can highlight some constants inside argument brackets.
syn match   contextLabel      display '\a\+:[0-9a-zA-Z_\-: ]\+'                                                               contained containedin=contextArgument
syn match   contextNumber     display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\>'                                              contained containedin=contextArgument
syn match   contextDimension  display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\%(p[tc]\|in\|bp\|cc]\|[cm]m\|dd\|sp\|e[mx]\)\>' contained containedin=contextArgument

syn keyword contextConstant   yes no on off start stop contained containedin=contextArgument

"TODO Maybe highlight more constants, probably do it this way.
"syn match   contextConstant   display '\<\%(yes\|no\|on\|off\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(fit\|broad\|fixed\|local\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(depth\|hanging\|high\|lohi\|low\|top\|middle\|bottom\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(serif\|regular\|roman\|sans\|support\|sansserif\|mono\|type\|teletype\|handwritten\|calligraphic\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(normal\|bold\|slanted\|boldslanted\|type\|cap\|small\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(small\|medium\|big\|nowhite\|back\|white\|disable\|force\|reset\|line\|halfline\|fixed\|flexible\|none\|samepage\)=\@!\>' contained containedin=contextArgument
"syn match   contextConstant   display '\<\%(left\|right\|here\|top\|bottom\|inleft\|inright\|inmargin\|margin\|leftmargin\|rightmargin\|leftedge\|rightedge\|innermargin\|outermargin\|inneredge\|outeredge\|inner\|outer\|line\|high\|low\|fit\|page\|leftpage\|rightpage\|opposite\|always\|auto\|force\|tall\|reset\|line\|height\|depth\)=\@!\>' contained containedin=contextArgument

" Specials: {{{1
" ---------

syn match   contextEscaped    display '\\[%#~&$^_\{} \n]'
"syn match   contextEscaped    display '\\[`'"]'

syn match   contextSpecial    display '\\\%(par\|crlf\)\>'
syn match   contextSpecial    display '\\\@!\%(\~\|&\|\^\|_\|-\{2,3}\)'
"syn match   contextSpecial    display '|[<>/]\?|'

" These are not allowed outside math mode, see math section.
syn match   contextScriptError        display '[_^]'

syn match   contextParameterError     display '#'
syn match   contextParameter  display '\\\@!#\d\+'

" Fonts And Styles: {{{1
" -----------------

syn match   contextFont       display '\\\%(rm\|ss\|tt\|hw\|cg\|mf\)\>'

syn match   contextFont       display '\\\%(em\|tf\|b[fsi]\|s[cl]\|it\|os\)\%(xx\|[xabcd]\)\?\>'
syn match   contextFont       display '\\\%(vi\{1,3}\|ix\|xi\{0,2}\)\>'

syn match   contextStyle      display '\\\%(cap\|Cap\|CAP\|Caps\|nocap\)\>'
syn match   contextStyle      display '\\\%(Word\|WORD\|Words\|WORDS\)\>'
syn match   contextStyle      display '\\\%(underbar\|over\%(bar\|strike\)\)s\?'
"FIXME What is this?
"syn match   contextStyle      display '\\\%(character\|Character\)s\?\>'

syn region  contextTypeFace    display matchgroup=contextDelimiter start='{\\tf\s'     end='}' contains=TOP
syn region  contextItalic      display matchgroup=contextDelimiter start='{\\it\s'     end='}' contains=TOP
syn region  contextSlanted     display matchgroup=contextDelimiter start='{\\sl\s'     end='}' contains=TOP
syn region  contextBold        display matchgroup=contextDelimiter start='{\\bf\s'     end='}' contains=TOP
syn region  contextBoldItalic  display matchgroup=contextDelimiter start='{\\bi\s'     end='}' contains=TOP
syn region  contextBoldItalic  display matchgroup=contextDelimiter start='{\\bf\\it\s' end='}' contains=TOP
syn region  contextBoldItalic  display matchgroup=contextDelimiter start='{\\it\\bf\s' end='}' contains=TOP
syn region  contextBoldSlanted display matchgroup=contextDelimiter start='{\\bs\s'     end='}' contains=TOP
syn region  contextBoldSlanted display matchgroup=contextDelimiter start='{\\bf\\sl\s' end='}' contains=TOP
syn region  contextBoldSlanted display matchgroup=contextDelimiter start='{\\sl\\bf\s' end='}' contains=TOP

syn region  contextOuterEmph   display matchgroup=contextDelimiter start='{\\em\s'            end='}'                 contains=TOP,contextOuterEmph
syn region  contextOuterEmph   display matchgroup=contextDelimiter start='\\emph{'            end='}'                 contains=TOP,contextOuterEmph
syn region  contextOuterEmph           matchgroup=contextBlock     start='\\startemphasize\>' end='\\stopemphasize\>' contains=TOP,contextOuterEmph

syn region  contextInnerEmph   display matchgroup=contextDelimiter start='{\\em\s'            end='}'                 contains=TOP,contextInnerEmph contained containedin=contextOuterEmph,context.*\(Italic\|Slanted\)
syn region  contextInnerEmph   display matchgroup=contextDelimiter start='\\emph{'            end='}'                 contains=TOP,contextInnerEmph contained containedin=contextOuterEmph,context.*\(Italic\|Slanted\)
syn region  contextInnerEmph           matchgroup=contextBlock     start='\\startemphasize\>' end='\\stopemphasize\>' contains=TOP,contextInnerEmph contained containedin=contextOuterEmph,context.*\(Italic\|Slanted\)

" Mathematics: {{{1
" ------------

syn region  contextMath       display matchgroup=contextDelimiter start='\$'                       end='\$'                 contains=TOP,@Spell,contextScriptError
syn region  contextMath       display matchgroup=contextDelimiter start='\\math\%(ematics\)\?{'    end='}'                  contains=TOP,@Spell,contextScriptError

syn region  contextMath               matchgroup=contextDelimiter start='\$\$'                     end='\$\$'               contains=TOP,@Spell,contextScriptError
syn region  contextMath               matchgroup=contextBlock     start='\\start\z(\a*\)formula\>' end='\\stop\z1formula\>' contains=TOP,@Spell,contextScriptError

syn region  contextMathText   display matchgroup=contextDelimiter start='\\\%(inter\)\?text{'      end='}'                  contains=TOP contained containedin=contextMath

" Math Concealment: {{{1
" ~~~~~~~~~~~~~~~~~
"
" Many symbols by Björn Winckler, additions by Tim Steenvoorden.

if has('conceal') && &enc == 'utf-8'

  " Let user determine which classes of concealment will be supported:
  "   m = math symbols
  "   f = fractions
  "   s = spaces
  "   d = delimiters
  "   g = Greek
  "   l = Latin superscripts/subscripts
  "   n = numeric superscripts/subscripts
  "   a = accents
  " By default we conceal everything.
  if !exists('g:context_conceal')
   let s:context_conceal = 'mfsdglna'
  else
   let s:context_conceal = g:context_conceal
  endif

  " We will define the unbraced variants separately for each symbol in the function ContextConcealScript.
  syn region contextSuperscript start='\^{' end='}' concealends contained containedin=contextMath contains=contextSuperscript,contextSubscript,contextSuperscripts,contextCommand
  syn region contextSubscript   start='_{'  end='}' concealends contained containedin=contextMath contains=contextSuperscript,contextSubscript,contextSubscripts,contextCommand

  fun! s:ContextConcealSymbol(pattern, replacement)
    exe 'syn match contextMathSymbol "'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:replacement
  endfun

  fun! s:ContextRegisterAccent(name, accent)
    exe 'syn match   contextMathAccent'.a:name.' "}" contained conceal cchar='.a:accent
    exe 'hi def link contextMathAccent'.a:name.' contextMathAccent'
  endfun
  
  fun! s:ContextConcealAccent(name, pattern, replacement)
    exe 'syn match contextMathSymbol "\\'.a:name.'{'.a:pattern.'" nextgroup=contextMathAccent'.a:name.' contained containedin=contextMath conceal cchar='.a:replacement
  endfun

  fun! s:ContextConcealScript(pattern, superscript, subscript)
    " Scripts are only concealed if there is a suitable character in the Unicode tables.
    if a:superscript != ' '
      exe 'syn match contextSuperscript "\^'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:superscript
      exe 'syn match contextSuperscripts  "'.a:pattern.'" contained                         conceal cchar='.a:superscript.' nextgroup=contextSuperscripts'
    endif
    if a:subscript != ' '
      exe 'syn match contextSubscript    "_'.a:pattern.'" contained containedin=contextMath conceal cchar='.a:subscript
      exe 'syn match contextSubscripts    "'.a:pattern.'" contained                         conceal cchar='.a:subscript.'   nextgroup=contextSubscripts'
    endif
  endfun

  " Math Symbols: {{{2
  let s:contextMathSymbols = [
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
    \ ['implies'            , '⇒'],
    \ ['in'                 , '∈'],
    \ ['infty'              , '∞'],
    \ ['int'                , '∫'],
    \ ['lceil'              , '⌈'],
    \ ['ldots'              , '…'],
    \ ['le'                 , '≤'],
    \ ['leftarrow'          , '⟵'],
    \ ['Leftarrow'          , '⟸'],
    \ ['leftarrowtail'      , '↢'],
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
    \ ['rightarrow'         , '→'],
    \ ['Rightarrow'         , '⇒'],
    \ ['rightarrowtail'     , '↣'],
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

  if s:context_conceal =~ 'm'
    for symbol in s:contextMathSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
    endfor
  endif
  
  " Fractions: {{{2
  let s:contextFractionSymbols = [
    \ ['half'          , 'frac12' , '½'],
    \ ['third'         , 'frac13' , '⅓'],
    \ ['thwothirds'    , 'frac23' , '⅔'],
    \ ['quarter'       , 'frac14' , '¼'],
    \ ['threequarters' , 'frac34' , '¾'],
    \ ['fifth'         , 'frac15' , '⅕'],
    \ ['twofifths'     , 'frac25' , '⅖'],
    \ ['threefifths'   , 'frac35' , '⅗'],
    \ ['fourfifths'    , 'frac45' , '⅘'],
    \ ['sixth'         , 'frac16' , '⅙'],
    \ ['fifesixths'    , 'frac56' , '⅚'],
    \ ['eighth'        , 'frac18' , '⅛'],
    \ ['threeeighths'  , 'frac38' , '⅜'],
    \ ['fifeeighths'   , 'frac58' , '⅝'],
    \ ['seveneighths'  , 'frac78' , '⅞']]

  if s:context_conceal =~ 'f'
    for symbol in s:contextFractionSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[2])
      call s:ContextConcealSymbol('\\'.symbol[1],      symbol[2])
    endfor
  endif

  " Spaces: {{{2
  if s:context_conceal =~ 's'
    call s:ContextConcealSymbol('\\[;:,!]', '␣')
    call s:ContextConcealSymbol('\\\%(q\)\?quad', '␣')
  endif

  " Delimiters: {{{2
  let s:contextDelimiterSymbols = [
    \ ['.'        , '¦'],
    \ ['('        , '('],
    \ [')'        , ')'],
    \ ['\\{'      , '{'],
    \ ['\\}'      , '}'],
    \ ['\['       , '['],
    \ ['\]'       , ']'],
    \ ['<'        , '⟨'],
    \ ['>'        , '⟩'],
    \ ['|'        , '|'],
    \ ['\\|'      , '‖'],
    \ ['/'        , '/']]
  let s:contextDelimiterCommands = [
    \ ['lgroup'      , '('],
    \ ['rgroup'      , ')'],
    \ ['lbrace'      , '{'],
    \ ['rbrace'      , '}'],
    \ ['langle'      , '⟨'],
    \ ['rangle'      , '⟩'],
    \ ['vert'        , '|'],
    \ ['lvert'       , '|'],
    \ ['rvert'       , '|'],
    \ ['Vert'        , '‖'],
    \ ['lVert'       , '‖'],
    \ ['rVert'       , '‖'],
    \ ['backslash'   , '\'],
    \ ['lfloor'      , '⌊'],
    \ ['rfloor'      , '⌋'],
    \ ['lceil'       , '⌈'],
    \ ['rceil'       , '⌉'],
    \ ['uparrow'     , '↑'],
    \ ['Uparrow'     , '⇑'],
    \ ['downarrow'   , '↓'],
    \ ['Downarrow'   , '⇓'],
    \ ['updownarrow' , '↕'],
    \ ['Updownarrow' , '⇕'],
    \ ['llcorner'    , '⌞'],
    \ ['lrcorner'    , '⌟'],
    \ ['ulcorner'    , '⌜'],
    \ ['urconrner'   , '⌝'],
    \ ['lmoustache'  , '⎠'],
    \ ['rmoustache'  , '⎝']]

  if s:context_conceal =~ 'd'
    for symbol in s:contextDelimiterSymbols
      call s:ContextConcealSymbol('\\left'.symbol[0],  symbol[1])
      call s:ContextConcealSymbol('\\right'.symbol[0], symbol[1])
    endfor
    for symbol in s:contextDelimiterCommands
      call s:ContextConcealSymbol('\\left\\'.symbol[0].'\>',  symbol[1])
      call s:ContextConcealSymbol('\\right\\'.symbol[0].'\>', symbol[1])
    endfor
  endif

  " Greek: {{{2
  let s:contextGreekSymbols = [
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

  if s:context_conceal =~ 'g'
    for symbol in s:contextGreekSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
      "call s:ContextConcealScript('\\'.symbol[0].'\>', symbol[2], symbol[3])
    endfor
  endif

  " Latin Scripts: {{{2
  let s:contextLatinSymbols = [
    \ ['a' , 'ᵃ' , 'ₐ'],
    \ ['b' , 'ᵇ' , ' '],
    \ ['c' , 'ᶜ' , ' '],
    \ ['d' , 'ᵈ' , ' '],
    \ ['e' , 'ᵉ' , 'ₑ'],
    \ ['f' , 'ᶠ' , ' '],
    \ ['g' , 'ᵍ' , ' '],
    \ ['h' , 'ʰ' , ' '],
    \ ['i' , 'ⁱ' , 'ᵢ'],
    \ ['j' , 'ʲ' , ' '],
    \ ['k' , 'ᵏ' , ' '],
    \ ['l' , 'ˡ' , ' '],
    \ ['m' , 'ᵐ' , ' '],
    \ ['n' , 'ⁿ' , ' '],
    \ ['o' , 'ᵒ' , 'ₒ'],
    \ ['p' , 'ᵖ' , ' '],
    \ ['q' , ' ' , ' '],
    \ ['r' , 'ʳ' , ' '],
    \ ['s' , 'ˢ' , ' '],
    \ ['t' , 'ᵗ' , ' '],
    \ ['u' , 'ᵘ' , 'ᵤ'],
    \ ['v' , 'ᵛ' , ' '],
    \ ['w' , 'ʷ' , ' '],
    \ ['x' , 'ˣ' , ' '],
    \ ['y' , 'ʸ' , ' '],
    \ ['z' , 'ᶻ' , ' '],
    \ ['A' , 'ᴬ' , ' '],
    \ ['B' , 'ᴮ' , ' '],
    \ ['C' , ' ' , ' '],
    \ ['D' , 'ᴰ' , ' '],
    \ ['E' , 'ᴱ' , ' '],
    \ ['F' , ' ' , ' '],
    \ ['G' , 'ᴳ' , ' '],
    \ ['H' , 'ᴴ' , ' '],
    \ ['I' , 'ᴵ' , ' '],
    \ ['J' , 'ᴶ' , ' '],
    \ ['K' , 'ᴷ' , ' '],
    \ ['L' , 'ᴸ' , ' '],
    \ ['M' , 'ᴹ' , ' '],
    \ ['N' , 'ᴺ' , ' '],
    \ ['O' , 'ᴼ' , ' '],
    \ ['P' , 'ᴾ' , ' '],
    \ ['Q' , ' ' , ' '],
    \ ['R' , 'ᴿ' , 'ᵣ'],
    \ ['S' , ' ' , ' '],
    \ ['T' , 'ᵀ' , ' '],
    \ ['U' , 'ᵁ' , ' '],
    \ ['V' , ' ' , 'ᵥ'],
    \ ['W' , 'ᵂ' , ' '],
    \ ['X' , ' ' , 'ₓ'],
    \ ['Y' , ' ' , ' '],
    \ ['Z' , ' ' , ' ']]

  if s:context_conceal =~ 'l'
    for symbol in s:contextLatinSymbols
      call s:ContextConcealScript(symbol[0], symbol[1], symbol[2])
    endfor
  endif

  " Numeric Scripts: {{{2
  let s:contextNumericSymbols = [
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
    \ ['=' , '˭', '₌'],
    \ ['+' , '⁺', '₊'],
    \ ['-' , '⁻', '₋'],
    \ ['/' , 'ˊ', 'ˏ'],
    \ ['(' , '⁽', '₍'],
    \ [')' , '⁾', '₎'],
    \ ['<' , '˂', '˱'],
    \ ['>' , '˃', '˲'],
    \ ['\.', '˙', '‸']]

  if s:context_conceal =~ 'n'
    for symbol in s:contextNumericSymbols
      call s:ContextConcealScript(symbol[0], symbol[1], symbol[2])
    endfor
  endif

endif

  " Accents: {{{2
  let s:contextAccentSymbols = [
    \ ['acute'    , '´', '́'],
    \ ['bar'      , '¯', '̄'],
    \ ['breve'    , '˘', '̆'],
    \ ['check'    , 'ˇ', '̌'],
    \ ['ddot'     , '¨', '̈'],
    \ ['dot'      , '˙', '̇'],
    \ ['grave'    , '`', '̀'],
    \ ['hat'      , 'ˆ', '̂'],
    \ ['widehat'  , 'ˆ', '᷍'],
    \ ['tilde'    , '˜', '̃'],
    \ ['widetilde', '˜', '͠'],
    \ ['vec'      , '→', '⃗']]
  " Unicode names:
  "   bar   -> macron
  "   check -> caron
  "   ddot  -> diaeresis
  "   hat   -> circumflex

  " This is a bit hacked code, but it works...
  if s:context_conceal =~ 'a'
    for symbol in s:contextAccentSymbols
      call s:ContextRegisterAccent(symbol[0], symbol[2])
      for letter in s:contextGreekSymbols
        call s:ContextConcealAccent(symbol[0], '\\'.letter[0], letter[1])
      endfor
      for letter in s:contextLatinSymbols
        call s:ContextConcealAccent(symbol[0], letter[0], letter[0])
      endfor
      " Old solution just replaced the command:
      "call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
    endfor
  endif

" Types And Codes: {{{1
" ----------------

syn region  contextTyping     display matchgroup=contextDelimiter start='\\type\z(\A\)'                 end='\z1'
syn region  contextTyping     display matchgroup=contextDelimiter start='\\\%(type\?\|tex\|arg\|mat\){' end='}'               contains=contextGroup

"FIXME arguments after \starttyping
syn region  contextTyping             matchgroup=contextBlock   start='\\start\z(\a*\)typing\>'       end='\\stop\z1typing\>' contains=contextComment

"TODO MetaPost, Lua etc.

" Comments: {{{1
" ---------

syn keyword contextTodo       TODO FIXME NOTE XXX contained

" The match group is there to prevent spell checking of the %D %M and %C themselves.
syn region  contextComment    display oneline                           start='\\\@!%'    end='$' contains=contextTodo
syn region  contextComment    display oneline matchgroup=contextComment start='^%[CDM]\s' end='$' contains=TOP,contextComment

syn region  contextHiding     matchgroup=contextBlock start='\\starthiding\>' end='\\stophiding\>'

" Folding: {{{1
" --------

if exists('g:context_no_fold')
 let s:context_fold = 0
else
 let s:context_fold = 1
endif

"FIXME Folding of heads inside comments.
if has('folding') && s:context_fold == 1
  " All highlighting is done elsewhere. Here we just match the boundaries of a fold and use transparent.
  setlocal fdm=syntax

  " We don't fold document structure but only use them as containers for sections.
  " The keepend is necessary to get the first match. This isn't a problem, because there can't be a \chapter inside a \chapter etcetera.
  syn region  contextDocument   transparent keepend      start='\\starttext\>'                end='\\stoptext\>'
  syn region  contextDocument   transparent keepend      start='\\startcomponent\>'           end='\\stopcomponent\>'
  syn region  contextDocument   transparent keepend      start='\\startproduct\>'             end='\\stopproduct\>'
  syn region  contextDocument   transparent keepend      start='\\startproject\>'             end='\\stopproject\>'
  syn region  contextDocument   transparent keepend      start='\\startenvironment\>'         end='\\stopenvironment\>'

  syn region  contextHiding     transparent keepend fold start='\\starthiding\>'              end='\\stophiding\>'                                                                                                             contained containedin=contextDocument

  " Fold everything up to subsections.
  syn region  contextPart       transparent keepend fold start='\\startpart\>'                end='\\stoppart\>'                                                                                                               contained containedin=contextDocument
  syn region  contextPart       transparent keepend fold start='\\part\>'                     end='\ze\\\%(part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                                                  contained containedin=contextDocument

  syn region  contextChapter    transparent keepend fold start='\\startchapter\>'             end='\\stopchapter\>'                                                                                                            contained containedin=contextDocument,contextPart
  syn region  contextChapter    transparent keepend fold start='\\starttitle\>'               end='\\stoptitle\>'                                                                                                              contained containedin=contextDocument,contextPart
  syn region  contextChapter    transparent keepend fold start='\\\%(chapter\|title\)\>'      end='\ze\\\%(chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                                  contained containedin=contextDocument,contextPart

  syn region  contextSection    transparent keepend fold start='\\startsection\>'             end='\\stopsection\>'                                                                                                            contained containedin=contextDocument,contextChapter
  syn region  contextSection    transparent keepend fold start='\\startsubject\>'             end='\\stopsubject\>'                                                                                                            contained containedin=contextDocument,contextChapter
  syn region  contextSection    transparent keepend fold start='\\\%(section\|subject\)\>'    end='\ze\\\%(section\|subject\|chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                contained containedin=contextDocument,contextChapter

  syn region  contextSubsection transparent keepend fold start='\\startsubsection\>'          end='\\stopsubsection\>'                                                                                                         contained containedin=contextDocument,contextSection
  syn region  contextSubsection transparent keepend fold start='\\startsubsubject\>'          end='\\stopsubsubject\>'                                                                                                         contained containedin=contextDocument,contextSection
  syn region  contextSubsection transparent keepend fold start='\\sub\%(section\|subject\)\>' end='\ze\\\%(\%(sub\)\?\%(section\|subject\)\|chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>' contained containedin=contextDocument,contextSection
endif

" Syncing: {{{1
" ========

" Syncing against comments is simply the best way to go.
syn sync    ccomment          contextComment

" Highlight Definitions: {{{1
" ======================

" Commands:
hi def link contextCommand        Function

hi def link contextBlock          Statement
hi def link contextCondition      Conditional
hi def link contextLoop           Repeat
hi def link contextHead           Keyword

hi def link contextStructure      Include
hi def link contextStructureError Error

" Definitions And Setups:
hi def link contextDefine         Define
hi def link contextSetup          contextDefine

" Groups And Arguments:
hi def link contextDelimiter      Delimiter
hi def link contextMismatch       Error

hi def link contextNumber         Number
hi def link contextDimension      contextNumber
hi def link contextLabel          Tag
hi def link contextConstant       Constant

" Fonts And Styles:
hi def link contextFont           Type
hi def link contextStyle          contextFont

hi def      contextTypeFace       gui=NONE
hi def      contextItalic         gui=italic
hi def link contextSlanted        contextItalic
hi def      contextBold           gui=bold
hi def      contextBoldItalic     gui=bold,italic
hi def link contextBoldSlanted    contextBoldItalic

hi def      contextOuterEmph      gui=italic
hi def      contextInnerEmph      gui=NONE

" Specials:
hi def link contextEscaped        contextSpecial
hi def link contextSpecial        Special
hi def link contextScriptError    Error
hi def link contextParameter      Identifier
hi def link contextParameterError Error

" Math:
hi def link contextMath           String
hi def link contextMathText       Normal
hi def link contextMathSymbol     SpecialChar
hi def link contextMathAccent     contextMathSymbol
hi def link contextSuperscript    contextMathSymbol
hi def link contextSubscript      contextMathSymbol
hi!    link Conceal               contextMathSymbol

" Typing:
hi def link contextTyping         String

" Comments:
hi def link contextTodo           Todo
hi def link contextComment        Comment
hi def link contextHiding         contextComment

" Finalize Syntaxfile: {{{1
" ====================

let b:current_syntax = 'context'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap fdm=marker spell spl=en
