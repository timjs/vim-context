" Vim compiler file
" Compiler:     ConTeXt
" Maintainer:   Tim Steenvoorden <tim.steenvoorden@gmail.com>
" Last Change:  2015 Jan 02

" Initialize Compiler File: {{{1
" =========================

if exists('b:current_compiler')
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

" Setups: {{{1
" =======

let &l:makeprg = 'context --batchmode %'

let &l:errorformat  = '%Etex error       > error on line %l in file %f: ! %m'
let &l:errorformat .= ',%-G%.%#'

" Finalize Compiler File: {{{1
" =======================

let b:current_compiler = 'context'

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=2 sw=2 fdm=marker

