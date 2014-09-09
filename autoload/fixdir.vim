"=============================================================================
" FILE: fixdir.vim
" AUTHOR:  WeiRong Xu <weirongxu.raidou@gmail.com>
" License: MIT license
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim


function! s:dir_complete(path) "{{{
  let path = escape(expand(a:path, 1), '?={}[]')
  let paths = sort(filter(split(glob(path.'*', 1), '\n'), 'isdirectory(v:val)') )
  return map(map(paths, 'v:val == path ? path."/" : v:val'), 'escape(v:val, ''\ '')')
endfunction "}}}

function! fixdir#complete(ArgLead, CmdLine, CursorPos) "{{{
  return s:dir_complete(s:get_absolute_path(a:ArgLead))
endfunction "}}}


let s:fixdir_start = 0

function! fixdir#fix(...) "{{{
  call s:bind_autocmd(call('s:get_absolute_path', a:000))
endfunction "}}}

function! s:bind_autocmd(fix_dir_path) "{{{
  if s:fixdir_start | call fixdir#stop() | endif

  exec "cd" a:fix_dir_path
  augroup fixdir
    au!
    exec "au BufEnter * cd" a:fix_dir_path
  augroup END
  let s:fixdir_start = 1
endfunction "}}}

function! fixdir#stop() "{{{
  augroup fixdir
    au!
  augroup END
  let s:fixdir_start = 0
endfunction "}}}

function! s:get_absolute_path(...) "{{{
  let curr_path = expand("%:p:h")
  if a:0 == 0 || empty(a:1)
    return curr_path
  endif
  if a:1 =~ '^[/\~]'
    return a:1
  elseif a:1 =~ '^\.\/'
    return curr_path.a:1[1:]
  else
    return curr_path.'/'.a:1
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker
