" Language:    Plist
" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

function! s:DetectPlist()
  " We do not have any detection for JSON files without a plist extension
  if getline("'[") =~ "^bplist" || getline(2) =~ '<!DOCTYPE plist'
    set filetype=plist
  endif
endfunction

autocmd BufNewFile,BufRead * call s:DetectPlist()
autocmd BufNewFile,BufRead *.plist set filetype=plist
