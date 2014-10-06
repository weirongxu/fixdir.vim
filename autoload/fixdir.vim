"=============================================================================
" FILE: fixdir.vim
" AUTHOR:  WeiRong Xu <weirongxu.raidou@gmail.com>
" License: MIT license
"=============================================================================
let s:save_cpo = &cpo
set cpo&vim


function! s:dir_complete(path) "{{{
  let path = escape(s:expand(a:path, 1), '?={}[]')
  let paths = sort(filter(split(s:glob(path.'*', 1), '\n'), 'isdirectory(v:val)') )
  return map(map(paths, 'v:val == path ? path."/" : v:val'), 'escape(s:trans_path(v:val), '' '')')
endfunction "}}}

function! fixdir#complete(ArgLead, CmdLine, CursorPos) "{{{
  return s:dir_complete(s:get_absolute_path(a:ArgLead))
endfunction "}}}


let s:fixdir_start = 0

function! fixdir#started() "{{{
  return s:fixdir_start
endfunction "}}}
function! fixdir#path() "{{{
  return s:fixdir_path
endfunction "}}}

function! fixdir#started() "{{{
  return s:fixdir_start
endfunction "}}}

function! fixdir#fix(...) "{{{
  call s:bind_autocmd(call('s:get_absolute_path', a:000))
endfunction "}}}

function! s:bind_autocmd(fixdir_path) "{{{
  if s:fixdir_start | call fixdir#stop() | endif

  exec "cd" a:fixdir_path
  augroup fixdir
    au!
    exec "au BufEnter * cd" a:fixdir_path
  augroup END
  let s:fixdir_path = a:fixdir_path
  let s:fixdir_start = 1
endfunction "}}}

function! fixdir#stop() "{{{
  augroup fixdir
    au!
  augroup END
  let s:fixdir_start = 0
endfunction "}}}

function! s:get_absolute_path(...) "{{{
  " let curr_path = s:expand("%:p:h")
  let curr_path = s:expand(getcwd())
  if a:0 == 0 || empty(a:1)
    return curr_path
  endif
  if a:1 =~ '^\([/\~]\|[a-zA-Z]:\)'
    return s:expand(a:1)
  elseif a:1 =~ '^\.\/'
    return curr_path.a:1[1:]
  else
    return curr_path.'/'.a:1
  endif
endfunction "}}}

if has('win32') || has('win64')
  function! s:expand(...) "{{{
    return s:trans_path(call('expand', a:000))
  endfunction "}}}
  function! s:glob(...) "{{{
    return s:trans_path(call('glob', a:000))
  endfunction "}}}
else
  function! s:glob(...) "{{{
    return call('glob', a:000)
  endfunction "}}}
  function! s:expand(...) "{{{
    return call('expand', a:000)
  endfunction "}}}
endif

function! s:trans_path(path) "{{{
  if type(a:path) == type([])
    return map(a:path, 's:trans_path(v:val)')
  else
    return substitute(a:path, '\\', '/', 'g')
  endif
endfunction "}}}


let &cpo = s:save_cpo
unlet s:save_cpo
" vim: fdm=marker
