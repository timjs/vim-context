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

"FIXME Good cluster structure
syn cluster contextDocumentGroup contains=contextComment
" Comments: {{{1
" ---------

syn keyword contextTodo       TODO FIXME NOTE XXX contained

syn region  contextComment    display oneline start='\\\@!%'    end='$' contains=contextTodo
syn region  contextComment    display oneline start='^%[CDM]\s' end='$' contains=TOP,contextComment
"FIXME or:
"syn region  contextComment    display oneline transparent matchgroup=contextComment start='^%[CDM]\s' end='$'

syn region  contextHiding     matchgroup=contextBlock keepend start='\\starthiding\>' end='\\stophiding\>'

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
syn match   contextHead       display '\\\%(start\|stop\)\?\%(sub\)*%\(section\|subject\)\>'

" And these define the document structure.
"FIXME Misschien toch gewoon match...
syn region  contextStructure  display oneline start='^\s*\\\%(start\|stop\)\?\%(component\|product\|project\|environment\)\>' end='$'
syn region  contextStructure  display oneline start='^\s*\\input\>'                                                           end='$'
syn match   contextStructure  display               '^\s*\\\%(start\|stop\)text$'

" Definitions And Setups: {{{1
" -----------------------

"syn match   contextDefine     display '\\[egx]\%(def\|let\)'
syn match   contextDefine     display '\\\%(re\)\?define\>'
syn match   contextDefine     display '\\\%(define\|\%(re\)\?set\|get\|let\)\a\+'
syn match   contextDefine     display '\\\%(start\|stop\)texdefinition\>'

syn match   contextSetup      display '\\\%(setup\|use\|enable\|disable\|prevent\|show\)\a\+'
syn match   contextSetup      display '\\\%(start\|stop\)\?setups\>'

" Section Folding: {{{1
" ----------------

if has('folding')
  " We don't fold documentsections but only use them as containers for sections.
  syn region  contextDocument   transparent      start='\\starttext\>'                end='\\stoptext\>'
  syn region  contextDocument   transparent      start='\\startcomponent\>'           end='\\stopcomponent\>'
  syn region  contextDocument   transparent      start='\\startproduct\>'             end='\\stopproduct\>'
  syn region  contextDocument   transparent      start='\\startproject\>'             end='\\stopproject\>'
  syn region  contextDocument   transparent      start='\\startenvironment\>'         end='\\stopenvironment\>'

  " Fold everything upto subsections.
  syn region  contextPart       transparent fold start='\\startpart\>'                end='\\stoppart\>'                                                                                                               contained containedin=contextDocument
  syn region  contextPart       transparent fold start='\\part\>'                     end='\ze\\\%(part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                                                  contained containedin=contextDocument

  syn region  contextChapter    transparent fold start='\\startchapter\>'             end='\\stopchapter\>'                                                                                                            contained containedin=contextDocument,contextPart
  syn region  contextChapter    transparent fold start='\\starttitle\>'               end='\\stoptitle\>'                                                                                                              contained containedin=contextDocument,contextPart
  syn region  contextChapter    transparent fold start='\\\%(chapter\|title\)\>'      end='\ze\\\%(chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                                  contained containedin=contextDocument,contextPart

  syn region  contextSection    transparent fold start='\\startsection\>'             end='\\stopsection\>'                                                                                                            contained containedin=contextDocument,contextChapter
  syn region  contextSection    transparent fold start='\\startsubject\>'             end='\\stopsubject\>'                                                                                                            contained containedin=contextDocument,contextChapter
  syn region  contextSection    transparent fold start='\\\%(section\|subject\)\>'    end='\ze\\\%(section\|subject\|chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>'                contained containedin=contextDocument,contextChapter

  syn region  contextSubsection transparent fold start='\\startsubsection\>'          end='\\stopsubsection\>'                                                                                                         contained containedin=contextDocument,contextSection
  syn region  contextSubsection transparent fold start='\\startsubsubject\>'          end='\\stopsubsubject\>'                                                                                                         contained containedin=contextDocument,contextSection
  syn region  contextSubsection transparent fold start='\\sub\%(section\|subject\)\>' end='\ze\\\%(\%(sub\)\?\%(section\|subject\)\|chapter\|title\|part\|stop\%(text\|component\|product\|project\|environment\)\)\>' contained containedin=contextDocument,contextSection
endif

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

" Specials: {{{1
" ---------

syn match   contextEscaped    display '\\[%#~&$^_\{} \n]'
"syn match   contextEscaped    display '\\[`'"]'

syn match   contextSpecial    display '\\\%(par\|crlf\)\>'
syn match   contextSpecial    display '\\\@!\%(\~\|&\|\^\|_\|-\{2,3}\)'

syn match   contextParameter  display '\\\@!#\d\+'

"TODO Errors for #, ^, _
"TODO Hyphens || (?)

"TODO Matching delimiters
"FIXME Spell in Groups and Arguments
syn region  contextGroup      display matchgroup=contextDelimiter keepend start='{'  end='}'  contains=TOP
syn region  contextArgument   display matchgroup=contextDelimiter keepend start='\[' end='\]' contains=TOP,@Spell
" Not needed with above definitions
"syn match   contextDelimiter  display '\\\@![][{}]'
"syn region  contextArgument   display transparent keepend start='\[' end='\]'
"syn region  contextArgument   display transparent keepend start='\[' end='\]' contains=contextLabel,contextNumber
"syn region  contextArgument   display transparent matchgroup=contextDelimiter keepend start='\[' end='\]' contains=contextLabel,contextNumber
"syn region  contextArgument   display matchgroup=contextDelimiter transparent keepend start='\[' end='\]'

syn match   contextDimension  display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\%(p[tc]\|in\|bp\|cc]\|[cm]m\|dd\|sp\|e[mx]\)\>'
syn match   contextNumber     display '\<[+-]\?\%(\d\+\%(\.\d\+\)\?\|\.\d\+\)\>' contained containedin=contextArgument
syn match   contextLabel      display '\a\+:[0-9a-zA-Z_\-: ]\+'                  contained containedin=contextArgument

" Math: {{{1
" -----

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

  " Let user determine which classes of concealment will be supported:
  "   m = math symbols
  "   f = fractions
  "   d = delimiters
  "   a = accents/ligatures
  "   g = Greek
  "   n = number superscripts/subscripts
  "   s = alphabetic superscripts/subscripts
  " At default we don't conceal fractions, because the commands are not standard,
  " and alphabetic superscript/subscripts, because they are not complete.
  if !exists("g:context_conceal")
   let s:context_conceal='mdagn'
  else
   let s:context_conceal=g:context_conceal
  endif

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
  
  " Fraction Symbols: {{{2
  let s:contextFractionSymbols=[
    \ ['half'          , '½'],
    \ ['third'         , '⅓'],
    \ ['thwothirds'    , '⅔'],
    \ ['quarter'       , '¼'],
    \ ['threequarters' , '¾'],
    \ ['fifth'         , '⅕'],
    \ ['twofifths'     , '⅖'],
    \ ['threefifths'   , '⅗'],
    \ ['fourfifths'    , '⅘'],
    \ ['sixth'         , '⅙'],
    \ ['fifesixths'    , '⅚'],
    \ ['eighth'        , '⅛'],
    \ ['threeeighths'  , '⅜'],
    \ ['fifeeighths'   , '⅝'],
    \ ['seveneighths'  , '⅞']]

  if s:context_conceal =~ 'f'
    for symbol in s:contextFractionSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
    endfor
  endif

  " Delimiter Symbols: {{{2
  " FIXME: issue with (){}[]<>.|/
  let s:contextDelimiterSymbols=[
    \ ['\@!.'        , '.'],
    \ ['\@!('        , '('],
    \ ['\@!)'        , ')'],
    \ ['lgroup'      , '('],
    \ ['rgroup'      , ')'],
    \ ['{'           , '{'],
    \ ['}'           , '}'],
    \ ['lbrace'      , '{'],
    \ ['rbrace'      , '}'],
    \ ['\@!\['       , '['],
    \ ['\@!\]'       , ']'],
    \ ['\@!<'        , '⟨'],
    \ ['\@!>'        , '⟩'],
    \ ['langle'      , '⟨'],
    \ ['rangle'      , '⟩'],
    \ ['\@!|'        , '|'],
    \ ['vert'        , '|'],
    \ ['lvert'       , '|'],
    \ ['rvert'       , '|'],
    \ ['|'           , '‖'],
    \ ['Vert'        , '‖'],
    \ ['lVert'       , '‖'],
    \ ['rVert'       , '‖'],
    \ ['\@!/'        , '/'],
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
    \ ['rmoustache'  , ' '],
    \ ['lmoustache'  , ' ']]

  if s:context_conceal =~ 'd'
    for symbol in s:contextDelimiterSymbols
      call s:ContextConcealSymbol('\\left\\'.symbol[0].'\>', symbol[1])
      call s:ContextConcealSymbol('\\right\\'.symbol[0].'\>', symbol[1])
    endfor
  endif

  " Accent Symbols: {{{2
  let s:contextAccentSymbols=[
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

  if s:context_conceal =~ 'a'
    for symbol in s:contextAccentSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
      "FIXME Conceal differently:
      "  \zs after \\ doesn't work
      "  can only conceal to one char, so loop doesn't work, complex mach doesn't work
      "call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[2])
      "call s:ContextConcealSymbol('\\'.symbol[0].'\>{\z(\a\)}', '\z1'.symbol[2])
    endfor
  endif

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

  if s:context_conceal =~ 'g'
    for symbol in s:contextGreekSymbols
      call s:ContextConcealSymbol('\\'.symbol[0].'\>', symbol[1])
      if s:context_conceal =~ 's'
        call s:ContextConcealScript('\\'.symbol[0].'\>', symbol[2], symbol[3])
      endif
    endfor
  endif

  " Numeric Symbols: {{{2
  let s:contextNumericSymbols=[
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

  " Alphabetic Symbols: {{{2
  let s:contextAlphabeticSymbols=[
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

  if s:context_conceal =~ 's'
    for symbol in s:contextPrintableSymbols
      call s:ContextConcealScript(symbol[0], symbol[1], symbol[2])
    endfor
  endif

endif

" Typing: {{{1
" -------

syn cluster contextTypingGroup contains=contextComment

syn region  contextTyping     display matchgroup=contextCommand keepend start='\\type\z(\A\)'                 end='\z1'
syn region  contextTyping     display matchgroup=contextCommand keepend start='\\\%(type\?\|tex\|arg\|mat\){' end='}'

syn region  contextTyping             matchgroup=contextBlock   keepend start='\\start\z(\a*\)typing\>'       end='\\stop\z1typing\>' contains=contextComment

"TODO MetaPost, Lua etc.

" Emphasize: {{{1
" ----------

"FIXME highlight \emph and {} distinctly
syn region  contextEmphasize  display transparent keepend start='\\emph{'            end='}'
syn region  contextEmphasize          transparent keepend start='\\startemphasize\>' end='\\stopemphasize\>'
"syn region  contextEmphasize  display matchgroup=contextCommand keepend start='\\emph{'            end='}'
"syn region  contextEmphasize          matchgroup=contextBlock   keepend start='\\startemphasize\>' end='\\stopemphasize\>' contains=contextCommand,contextBlock
" contains=contextCommand,contextBlock

" Syncing: {{{1
" ========

syn sync    ccomment          contextComment

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
hi def link contextMathSymbol SpecialChar
hi          contextEmphasize  gui=italic

" Commands:
hi def link contextCommand    Function
hi def link contextBlock      Statement
hi def link contextCondition  Conditional
hi def link contextLoop       Repeat
hi def link contextHead       Keyword

hi def link contextStructure  Include

" Definitions And Setups:
hi def link contextDefine     Define
hi def link contextSetup      contextDefine

" Types:
hi def link contextFont       Type
hi def link contextStyle      contextFont

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
