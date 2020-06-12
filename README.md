# vim-plist

![Screenshot of vim-plist in action](http://i.imgur.com/ezBKTK7.png)

This vim bundle adds complete support for [property lists](plist) (*plist*)
files.

The plugin uses the underlying **plutil** (or **plistutil**) tool for
manipulating property lists. It supports reading and writing in *binary*,
*xml* and *json* formats.

## Requirements

- Vim 7.4 or later
- plutil (bundled with macOS) or [plistutil](libplist)

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

- Change the display format used when editing property lists:

    ```vim
    let g:plist_display_format = 'xml'
    ```

    Available options for this command; *json* or *xml*. This does not only
    control the display format of binary property lists, but also for *json*
    and *xml* files. If the option is set to *json*, property lists in *xml*
    format will be displayed as *json* as well (but the format used when saving
    will be preserved).


- Change the plist format used when saving property lists:

    ```vim
    let g:plist_save_format = ''
    ```

    By default, property lists are saved in the same format as they had when
    opened. If you want to override this and always save property lists in a
    specific format, you can use *json*, *xml* or *binary* format.

## Notes

If you want syntax checking I highly recommend [Syntastic][syntastic] since it
has integrated support for property lists.

In case you use the `sudo tee` trick for writing to root owned files when using
Vim, it will **not** work with plist files. This is because the *tee* trick
uses the underlying Vim *write* function which bypasses the plugins
`BufWriteCmd` and `FileWriteCmd` hooks.

This does not add *plist* as a new filetype, but merely conversion
functionality between the different representable formats.

## Todo

- Add saving format options while editing (e.g. `:PlistSaveAs json`)

- Change display format while editing (e.g. `:PlistFormat xml`)

## License

MIT: [License][license]

[neobundle]: https://github.com/Shougo/neobundle.vim
[vundle]: https://github.com/gmarik/vundle
[pathogen]: https://github.com/tpope/vim-pathogen
[vim-plug]: https://github.com/junegunn/vim-plug
[vim-json]: https://github.com/elzr/vim-json
[syntastic]: https://github.com/scrooloose/syntastic
[license]: https://github.com/darfink/vim-plist/blob/master/LICENSE
[libplist]: https://github.com/libimobiledevice/libplist
[plist]: http://en.wikipedia.org/wiki/Property_list
