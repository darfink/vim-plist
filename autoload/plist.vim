" Maintainer:  Elliott Linder <elliott.darfink@gmail.com>
" URL:         http://github.com/darfink/vim-plist
" License:     MIT

" Defines the mapping between the vim-plist options and plutil arguments
let s:mapping = { 'json': 'json', 'binary': 'binary1', 'xml': 'xml1' }
let s:mapping_util = { 'binary': 'bin', 'xml': 'xml' }
let s:has_plist = executable('plutil')
let s:has_plistutil = executable('plistutil')

function! s:warn(message) abort
  echohl WarningMsg
  unsilent echomsg a:message
  call inputsave() | call input('(Press ENTER)') | call inputrestore()
  echohl None
endfunction

function! plist#BufReadCmd() abort
  if s:ReadCmd(1)
    call plist#BufReadPost()
    doautocmd BufReadPost
    return 1
  endif
  return 0
endfunction
function! plist#FileReadCmd() abort
  if s:ReadCmd(0)
    call plist#FileReadPost()
    execute 'doautocmd FileReadPost ' .. fnameescape(expand('<afile>'))
    return 1
  endif
  return 0
endfunction
function! s:ReadCmd(buf_read) abort
  " Get the filename of the current argument
  let plist_filename = expand('<afile>')

  " If the file does not exist, there is nothing to convert
  if !filereadable(plist_filename)
    execute 'doautocmd BufNewFile ' .. fnameescape(plist_filename)
    return 0
  endif

  if !s:has_plist && !s:has_plistutil
    echoerr 'plutil is not found in $PATH'
    silent execute 'read ' . fnameescape(plist_filename)
    return 0
  endif

  " Determine which format should be used when saving
  let b:plist_original_format = plist#DetectFormat(plist_filename)

  " Convert the file's content and read it into the current buffer
  if s:has_plist
    execute 'silent read !plutil -convert ' . s:mapping[g:plist_display_format]
      \ . ' -r ' . shellescape(plist_filename, 1) . ' -o -'
  else
    if g:plist_display_format == 'json'
      call s:warn('Plistutil does not support json display format')
    endif

    execute 'silent read !plistutil -f xml -i ' . shellescape(plist_filename, 1) . ' -o -'
  endif

  let b:read_error = v:shell_error != 0

  if (v:shell_error)
    call s:warn('Plist could not be converted!')

    " Only wipeout the buffer if one was being created to start with.
    " FileReadCmd just reads the content into the existing buffer
    if a:buf_read
      let plist_bufnr = bufnr()
      silent execute 'buffer! #'
      silent execute 'bwipeout! ' . plist_bufnr
    endif

    return 0
  endif

  " Tell the user about any information parsed
  call plist#DisplayInfo(plist_filename, b:plist_original_format)

  return 1
endfunction

function! plist#BufWriteCmd() abort
  return s:WriteCmd()
endfunction
function! plist#FileWriteCmd() abort
  return s:WriteCmd()
endfunction
function! s:WriteCmd() abort
  " Cache the argument filename destination
  let filename = resolve(expand('<afile>'))

  " If the user has not specified his preferred format when saving, use the
  " same format as the file had originally. Otherwise the user option takes
  " precedence.
  let save_format = !len(g:plist_save_format) ? b:plist_original_format : g:plist_save_format

  if s:has_plist
    " Use plutil even when the current format is the same as the target
    " format, since it will give the user additional error checking (they will
    " be notified if there is any error upon saving).
    execute "silent '[,']write !plutil -convert " . s:mapping[save_format] .
          \ ' - -o ' . shellescape(filename, 1)
  else
    if b:plist_original_format == 'json'
      call s:warn('Plistutil cannot process json, saving buffer contents directly')
    else
      execute "silent '[,']write !plistutil -f " . s:mapping_util[save_format] .
            \ ' -i - -o ' . shellescape(filename, 1)
    endif
  endif

  if (v:shell_error)
    call s:warn('Plist could not be saved!')
    return 0
  else
    " Give the user visual feedback about the write
    call plist#DisplayInfo(filename, save_format)

    " This indicates a successful write
    setlocal nomodified
  endif

  return 1
endfunction

function! plist#BufReadPost() abort
  " This needs to be validated...
  let levels = &undolevels
  set undolevels=-1
  silent 1delete
  let &undolevels = levels

  " Update the file content type
  call plist#SetFiletype()
endfunction

function! plist#FileReadPost() abort
  " Update the file content type
  call plist#SetFiletype()
endfunction

function! plist#SetFiletype() abort
  if g:plist_display_format == 'json' && s:has_plist || b:plist_original_format == 'json' && !s:has_plist
    let filetype = len(getcompletion('json', 'filetype')) ? 'json' : 'javascript'
  else
    let filetype = 'xml'
  endif
  if &filetype !=# filetype
    execute 'set filetype=' . filetype
  endif
endfunction

function! plist#DetectFormat(filename) abort
  let content = readfile(a:filename, 1, 2)

  if len(content) > 0 && content[0] =~ "^bplist"
    return 'binary'
  elseif len(content) > 1 && content[1] =~ '^<!DOCTYPE plist'
    return 'xml'
  else
    return 'json'
  endif
endfunction

function! plist#DisplayInfo(filename, format) abort
  " Notify the user about the filename, size and plist format
  redraw!
  echo '"' . a:filename . '", ' . getfsize(a:filename) . 'B [' . a:format . ']'
endfunction
