" Vim syntax file
" Language:         LaTeX typesetting engine
" Maintainer:       Tim Steenvoorden <steenvoo@science.ru.nl>
" Latest Revision:  2012-05-29
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

" Quotes: {{{1
" -------

syn match   contextDelimiter  display '\(``\|\'\'\)'

" Mathematics: {{{1
" ------------

syn region  contextMath       display matchgroup=contextDelimiter start='\\ensuremath{'                                            end='}'          contains=TOP,@Spell,contextScriptError

" No, I won't define "eqnarray" here, it is obsolete...
syn region  contextMath               matchgroup=contextBlock     start='\\begin{\z(\(equation\|align\|gather\|multiline\)\*\?\)}' end='\\end{\z1}' contains=TOP,@Spell,contextScriptError

" Typing And Coding: {{{1
" ------------------

syn region  contextTyping     display matchgroup=contextDelimiter start='\\verb\z(\A\)'                    end='\z1'

syn region  contextTyping             matchgroup=contextBlock   start='\\begin{\z(verbatim\|lstlisting\)}' end='\\end{\z1}' contains=contextComment

" Finalize Syntaxfile: {{{1
" ====================

let b:current_syntax = 'latex'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: nowrap fdm=marker spell spl=en