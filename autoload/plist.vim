" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

" Defines the mapping between the vim-plist options and plutil arguments
let s:mapping = { 'json': 'json', 'binary': 'binary1', 'xml': 'xml1' }

function! plist#Read(bufread)
  " Get the filename of the current argument
  let filename = expand('<afile>')

  " If the file does not exist, there is nothing to convert
  if !filereadable(filename)
    " We simply leave the buffer handling to Vim
    silent execute ':doautocmd BufNewFile ' . fnameescape(filename)
    return
  endif

  " Convert the file's content directly, and read it into the current buffer
  execute 'silent read !plutil -convert ' . s:mapping[g:plist_display_format] .
        \ ' -r ' . shellescape(filename, 1) . ' -o -'

  if (v:shell_error)
    echohl WarningMsg
    let blackhole = input('Plist could not be converted! (Press ENTER)')
    echohl None

    " Only wipeout the buffer if we were creating one to start with.
    " FileReadCmd just reads the content into the existing buffer
    if a:bufread
      silent bwipeout!
    endif

    return
  endif

  " We need to know in which format we should save the file
  call plist#DetectFormat(filename)

  " Tell the user about any information we've parsed
  call plist#DisplayInfo(filename, b:plist_original_format)
endfunction

function! plist#Write()
  " Cache the argument filename destination
  let filename = resolve(expand('<afile>'))

  " If the user has not specified his preferred format when saving, we use the
  " same format as the filed had originally. Otherwise the user option takes
  " precedence.
  let save_format = !len(g:plist_save_format) ? b:plist_original_format : g:plist_save_format

  " Use plutil even when the current format is the same as the target format,
  " since it will give the user additional error checking (he will be notified
  " if there is any error upon saving).
  execute "silent '[,']write !plutil -convert " . s:mapping[save_format] .
        \ ' - -o ' . shellescape(filename)

  if (v:shell_error)
    echohl WarningMsg
    let blackhole = input('Plist could not be saved! (Press ENTER)')
    echohl None

    return
  else
    " Give the user visual feedback about the write
    call plist#DisplayInfo(filename, save_format)

    " This indicates a successful write
    setlocal nomodified
  endif
endfunction

function! plist#ReadPost()
  " This needs to be validated...
  let levels = &undolevels
  set undolevels=-1
  silent 1delete
  let &undolevels = levels

  " Update the file content type
  call plist#SetFiletype()
endfunction

function! plist#SetFiletype()
  if g:plist_display_format == 'json'
    " There is no specific support for json bundled with Vim, so we let the
    " user decide the filetype (by default we assume 'JavaScript').
    execute 'set filetype=' . g:plist_json_filetype
  else
    " We hardcode this to xml, since it maps one-to-one
    set filetype=xml
  endif
endfunction

function! plist#DetectFormat(filename)
  let content = readfile(a:filename, 1, 2)

  if content[0] =~ "^bplist"
    let b:plist_original_format = 'binary'
  elseif content[1] =~ '^<!DOCTYPE plist'
    let b:plist_original_format = 'xml'
  else
    let b:plist_original_format = 'json'
  endif
endfunction

function! plist#DisplayInfo(filename, format)
  " Notify the user about the filename, size and plist format
  redraw!
  echo '"' . a:filename . '", ' . getfsize(a:filename) . 'B [' . a:format . ']'
endfunction
