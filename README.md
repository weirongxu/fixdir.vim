FixDir.vim
====

FixDir is plug-in be used for to fix directory.

Installation
----

* Vundle
```vim
Plugin 'weirongxu/fixdir.vim'
```

* Neobundle
```vim
NeoBundleLazy 'weirongxu/fixdir.vim', {
    \ 'commands' : [{ 'name': 'FixDir',
    \                 'complete': 'customlist,fixdir#complete'}
    \ ]}
```

Usage
----

Start fix directory. If `path` is omitted, FixDir use current directory.
```vim
:FixDir [path]
```

Stop fix directory.
```vim
:FixDirStop
```

Function
----

fixdir#started
