" Language:    Plist
" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

" Defines the mapping between the vim-plist options and plutil arguments
let s:mapping = { 'json': 'json', 'binary': 'binary1', 'xml': 'xml1' }

function! plist#ConvertBuffer(type)
  " We need to use binary format otherwise new lines and miscellaneous
  " whitespace will cause the conversion to fail.
  setlocal binary

  " Converts the current buffer's content to the specified type. There are no
  " issues with converting a type to its own (e.g. json → json).
  execute "silent '[,']!plutil -convert " . s:mapping[a:type] . " -r - -o -"

  " After the conversion we can continue to treat the file as text
  setlocal nobinary

  if v:shell_error != 0
    redraw!
    echohl WarningMsg | echo '***warning*** (plist#ConvertBuffer) unable to read plist file' | echohl None
  endif
endfunction

function! plist#Read()
  " Identify the plist content format
  if getline("'[") =~ "^bplist"
    let l:display_format = g:plist_display_format_binary
    let b:plist_original_format = 'binary'
  elseif getline(2) =~ '<!DOCTYPE plist'
    let b:plist_original_format = 'xml'
    let l:display_format = 'xml'
  else
    " Assume the file is json if it isn't xml or binary
    let b:plist_original_format = 'json'
    let l:display_format = 'json'
  endif

  if len(g:plist_display_format_all)
    " We can only display plists in either xml or json format
    if g:plist_display_format_all != 'xml' && g:plist_display_format_all != 'json'
      redraw!
      echohl WarningMsg | echo '***warning*** (plist#Read) g:plist_display_format_all had an invalid value, defaulting to xml' | echohl None

      let g:plist_display_format_all = 'xml'
    endif

    " If the user has specified a 'format all' option, that means that every
    " type should be displayed as specified. That includes displaying json
    " plist files as xml or the other way around.
    let l:display_format = g:plist_display_format_all
  endif

  " Even when the source and display format is (for example) xml, we convert
  " the buffer's content. This ensures that the content has a valid plist
  " format, and that the output is normalized.
  call plist#ConvertBuffer(l:display_format)

  " TODO: Set the syntax to use (xml or JavaScript)
endfunction

function! plist#Write()
  " If the user has not specified their preferred format when saving, we use
  " the same format that the filed had originally. Otherwise the user option
  " takes precedence.
  let l:save_as = !len(g:plist_save_as) ? b:plist_original_format : g:plist_save_as

  " Use plutil even when the current format is the same as the target format,
  " since it will give the user additional error checking (he will be notified
  " if there is any error upon saving).
  execute "silent write !plutil -convert " . s:mapping[l:save_as] . " - -o %"

  redraw!
  if v:shell_error != 0
    echohl Error | echo '***error*** (plist#Write) unable to write plist file' | echohl None
  else
    " Notify the user about the filename, size and plist format (from → to)
    echo '"' . expand('%') . '", ' . getfsize(expand('%')) . 'B [' . b:plist_original_format . '] → [' . l:save_as . ']'
  endif

  setlocal nomod
endfunction
