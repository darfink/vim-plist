" Language:    Plist
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
  autocmd BufWriteCmd,FileWriteCmd *.plist call plist#Write()

  " Input operations
  autocmd BufReadCmd *.plist call plist#Read(1) | call plist#ReadPost()
  autocmd FileReadCmd *.plist call plist#Read(0) | call plist#SetFiletype()

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

if !exists('g:plist_json_filetype')
  " Controls the filetype used for json plists (JavaScript is what Vim uses by
  " default for these filetypes).
  let g:plist_json_filetype = 'javascript'
end
