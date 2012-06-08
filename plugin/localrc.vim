" Enable configuration file of each directory.
" Version: 0.2.0
" Author : thinca <thinca+vim@gmail.com>
" License: zlib License

if exists('g:loaded_localrc')
  finish
endif
let g:loaded_localrc = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:localrc_filename')
  let g:localrc_filename = '.local.vimrc'
endif

if !exists('g:localrc_filetype')
  let g:localrc_filetype = '/^\.local\..*\<%s\>.*\.vimrc$'
endif


augroup plugin-localrc
  autocmd!
  autocmd VimEnter * nested
  \                  if argc() == 0
  \                |   call localrc#load(g:localrc_filename)
  \                | endif
  " Depending on the circumstances, the FileType autocmd may execute before
  " BufReadPost (automatic filetype detection) or after BufReadPost (filetype
  " set manually or via modeline). Use a flag to ensure that global localrc is
  " always executed before the filetype-specific ones, so that they can override
  " global localrc settings.
  autocmd BufReadPre * unlet! b:localrc_done " Clear to support reload via :edit!.
  autocmd BufNewFile,BufReadPost * nested
  \   if !exists('b:localrc_done') | call localrc#load(g:localrc_filename) | let b:localrc_done = 1 | endif
  autocmd FileType * nested
  \   if !exists('b:localrc_done') | call localrc#load(g:localrc_filename) | let b:localrc_done = 1 | endif |
  \   call localrc#loadft(
  \     type(g:localrc_filetype) == type([]) ? copy(g:localrc_filetype)
  \                                          : [g:localrc_filetype],
  \     expand("<amatch>"))
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
