" Language:    Plist
" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

if exists('b:did_ftplugin')
  finish
endif

let b:did_ftplugin = 1

augroup plist
  autocmd BufWriteCmd <buffer> call plist#Write()
  autocmd BufNewFile,BufRead <buffer> call plist#Read()
augroup END

if !exists('g:plist_save_as')
  " Save in the same format as the plist was originally opened in by default.
  " Available options are: xml, json & binary
	let g:plist_save_as = ''
end

if !exists('g:plist_display_format_binary')
  " The displayed format for binary plist files (json or xml)
  let g:plist_display_format_binary = 'xml'
end

if !exists('g:plist_display_format_all')
  " Override for displaying all plist sources in a specific format
  let g:plist_display_format_all = ''
end

" Filetype plugins are loaded during BufReadPost
call plist#Read()
