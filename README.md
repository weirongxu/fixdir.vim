FixDir.vim
====

FixDir is plug-in be used for to fix directory.

Installation
----

* Vundle
```viml
Plugin 'weirongxu/fixdir.vim'
```

* Neobundle
```viml
NeoBundleLazy 'weirongxu/fixdir.vim', {
    \ 'commands' : [{ 'name': 'FixDir',
    \                 'complete': 'customlist,fixdir#complete'}
    \ ]}
```

Usage
----

Start fix directory. If `path` is omitted, FixDir use current directory.
```viml
:FixDir [path]
```

Stop fix directory.
```viml
:FixDirStop
```

