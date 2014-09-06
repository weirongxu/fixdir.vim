"=============================================================================
" FILE: fixdir.vim
" AUTHOR:  WeiRong Xu <weirongxu.raidou@gmail.com>
" License: MIT license
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim


function! s:dir_complete(path) "{{{
  let path = escape(expand(a:path), '?={}[]')
  let paths = sort(filter(split(glob(path.'*'), '\n'), 'isdirectory(v:val)') )
  return map(map(paths, 'v:val == path ? path."/" : v:val'), 'escape(v:val, ''\ '')')
endfunction "}}}

function! fixdir#complete(ArgLead, CmdLine, CursorPos) "{{{
  if a:ArgLead =~ '^[\~/]'
    return s:dir_complete(a:ArgLead)
  else
    return s:dir_complete(expand("%:p:h").'/'.a:ArgLead)
endfunction "}}}


let s:fixdir_start = 0

function! fixdir#fix(...) "{{{
  let curr_path = expand("%:p:h")
  if a:0 > 1
    let fix_dir_path = s:get_absolute_path(curr_path, a:1)
  else
    let fix_dir_path = curr_path
  endif
  call s:bind_autocmd(fix_dir_path)
endfunction "}}}

function! s:bind_autocmd(fix_dir_path) "{{{
  if !s:fixdir_start
    exec "cd" a:fix_dir_path
    augroup fixdir
      au!
      exec "au BufNew,BufAdd,BufCreate,BufFilePost cd" a:fix_dir_path
    augroup END
    let s:fixdir_start = 1
  endif
endfunction "}}}

function! fixdir#clean() "{{{
  augroup fixdir
    au!
  augroup END
  let s:fixdir_start = 0
endfunction "}}}

function! s:get_absolute_path(curr_path, arg) "{{{
  if a:arg =~ '^[/\~]'
    return a:arg
  else
    if a:arg =~ '^\.\/'
      return a:curr_path.a:arg[1:]
    else
      return a:curr_path.'/'.a:arg
    endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker
