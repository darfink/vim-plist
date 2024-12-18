" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

if exists('g:loaded_plist') || &cp || !executable('plutil')
  finish
endif

let g:loaded_plist = '0.1'

augroup plist
  " Remove all plist autocommands
  autocmd!

  " Output operations
  autocmd BufWriteCmd ++nested *.plist call plist#BufWriteCmd()
  autocmd FileWriteCmd ++nested *.plist call plist#FileWriteCmd()

  " Input operations
  autocmd BufReadCmd *.plist call plist#BufReadCmd()
  autocmd FileReadCmd *.plist call plist#FileReadCmd()

  " TODO: Add support for extensionless plists
augroup END

if !exists('g:plist_display_format')
  " Specifies the display format for all plists
  let g:plist_display_format = 'xml'
end

if !exists('g:plist_save_format')
  " Saves in the same format as the plist was originally opened as by default.
  " Available options are: xml, json & binary
  let g:plist_save_format = ''
end
