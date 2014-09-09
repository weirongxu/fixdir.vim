"=============================================================================
" FILE: fixdir.vim
" AUTHOR:  WeiRong Xu <weirongxu.raidou@gmail.com>
" License: MIT license
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim

if exists('g:fixdir_loaded') | finish | endif
let g:fixdir_loaded = 1


command! -nargs=? -complete=customlist,fixdir#complete FixDir call fixdir#fix(<f-args>)
command! -nargs=0 FixDirStop call fixdir#stop()


let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker
