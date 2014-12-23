# vim-plist

This vim bundle adds complete support for [property lists](http://en.wikipedia.org/wiki/Property_list) (*plist*) files on OS X.

The plugin uses the underlying **plutil** tool for reading and writing property
lists. It supports reading and writing binary, xml and json files.

## Requirements

- Vim with `BufWriteCmd` support
- plutil (bundled with OS X)

## Installation

Use your favorite plugin manager.

- [NeoBundle][neobundle]

    ```vim
    NeoBundle 'darfink/vim-plist'
    ```

- [Vundle][vundle]

    ```vim
    Bundle 'darfink/vim-plist'
    ```

- [Pathogen][pathogen]

    ```sh
    git clone git://github.com/darfink/vim-plist.git ~/.vim/bundle/vim-plist
    ```

- [vim-plug][vim-plug]

    ```vim
    Plug 'darfink/vim-plist'
    ```

## Usage

None! Just go ahead and edit plist files. Although there are some customization
options availabe.

* Change the plist format used when saving. By default it preserves the format
  the file had when opened (e.g json is saved as json and xml as xml).
  Available options are: *binary*, *json* and *xml*.

    ```vim
    let g:plist_save_as = ''
    ```

* Set the display format for binary property lists (*json* or *xml*).

    ```vim
    let g:plist_display_format_binary = 'xml'
    ```

* Set an overriding display format that is always used for property lists (e.g
  when you open a xml plist it can be display as json or the other way around).
  This option overrides the `g:plist_display_format_binary` option. Json or xml
  is available.

    ```vim
    let g:plist_display_format_all = ''
    ```

## Notes

If you want syntax checking I highly recommend [Syntastic][syntastic] since it
has support for property lists.

In case you use the `sudo tee` trick for writing to root owned files when using
Vim, it will **not** work with plist files. This is because the *tee* trick
uses the underlying Vim *write* function which bypasses the plugins
`BufWriteCmd` hook.

## Todo

* Integrate syntax support (for some reason `setlocal syntax=javascript/xml` does not work)

* Add saving format options while editing (e.g. `:PlistSaveAs json`)

* Change display format while editing (e.g. `:PlistFormat xml`)

## License

MIT: [License][license]

[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/gmarik/vundle
[pathogen]: https://github.com/tpope/vim-pathogen
[vim-plug]: https://github.com/junegunn/vim-plug
[syntastic]: https://github.com/scrooloose/syntastic
[license]: https://github.com/darfink/vim-plist/blob/master/LICENSE
