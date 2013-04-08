" Vim syntax file
" Language:         LaTeX typesetting engine
" Maintainer:       Tim Steenvoorden <steenvoo@science.ru.nl>
" Latest Revision:  2012-10-02
"
" This is *not* a standalone LaTeX specific syntax file!
" Syntax is based on ConTeXt with some additions,
" so it contains *a lot* of ConTeXt specific highlights.

" Initialize Syntaxfile: {{{1
" ======================

if exists('b:current_syntax')
  finish
endif

runtime! syntax/context.vim
unlet b:current_syntax

let s:cpo_save = &cpo
set cpo&vim

" Syntax Definitions:
" ===================

" Commands: {{{1
" ---------

syn match   contextBlock      display '\\\%(begin\|end\){\w\+}'

syn match   contextStructure  display '\\\%(begin\|end\){document}'
syn match   contextStructure  display '\\documentclass\>'
syn match   contextStructure  display '\\\%(titlehead\|subject\|title\|author\|date\|publishers\)\>'

" Definitions And Setups: {{{1
" -----------------------

syn match   contextDefine     display '\\\%(re\)\?new\%(command\|environment\)\>'

" Quotes: {{{1
" -------

syn match   contextDelimiter  display '\(``\|\'\'\)'

" Fonts And Styles: {{{1
" -----------------

syn match   contextFont       display '\\normalfont\>'
syn match   contextFont       display '\\\%(rm\|sf\|tt\)family\>'
syn match   contextFont       display '\\\%(md\|bf\)series\>'
syn match   contextFont       display '\\\%(up\|it\|sl\|sc\)shape\>'

syn match   contextStyle      display '\\\%(tiny\|scriptsize\|footnotesize\|small\|normalsize\|large\|Large\|LARGE\|huge\|Huge\)\>'
syn match   contextStyle      display '\\text\%(normal\|rm\|sf\|tt\|up\|it\|sl\|sc\|bf\|md\)'

" Mathematics: {{{1
" ------------

syn region  contextMath       display matchgroup=contextDelimiter start='\\ensuremath{'                                            end='}'          contains=TOP,@Spell,contextScriptError

" No, I won't define "eqnarray" here, it is obsolete...
syn region  contextMath               matchgroup=contextBlock     start='\\begin{\z(\(equation\|align\|gather\|multline\)\*\?\)}' end='\\end{\z1}' contains=TOP,@Spell,contextScriptError

" Typing And Coding: {{{1
" ------------------

syn region  contextTyping     display matchgroup=contextDelimiter start='\\verb\z(\A\)'                      end='\z1'

syn region  contextTyping             matchgroup=contextBlock     start='\\begin{\z(verbatim\|lstlisting\)}' end='\\end{\z1}' contains=contextComment

fun! s:LatexIncludeSyntax(name, startstop)
  exe 'syn include @'.a:name.'Top syntax/'.a:name.'.vim'
  unlet b:current_syntax
  exe 'syn region context'.a:name.'Code transparent matchgroup=contextBlock start="\\begin{\z('.a:startstop.'\)}" end="\\end{\z1}" contains=@'.a:name.'Top'
endfun

call s:LatexIncludeSyntax('haskell', 'HASKELL')

" Folding: {{{1
" --------

if exists('g:latex_no_fold')
 let s:latex_fold = 0
else
 let s:latex_fold = 1
endif


if has('folding') && s:latex_fold == 1
  syn region  contextDocument   transparent keepend start='\\begin{document}' end='\\end{document}'
endif

" Finalize Syntaxfile: {{{1
" ====================

let b:current_syntax = 'latex'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap fdm=marker spell spl=en
