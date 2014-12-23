# vim-plist

![Screenshot of vim-plist in action](http://i.imgur.com/ezBKTK7.png)

This vim bundle adds complete support for [property lists](http://en.wikipedia.org/wiki/Property_list) (*plist*) files on OS X.

The plugin uses the underlying **plutil** tool for manipulating property lists.
It supports reading and writing in *binary*, *xml* and *json* formats.

## Requirements

- Vim 7.2 or later
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

- Change the filetype used for property lists in *json* format:

    ```vim
    let g:plist_json_filetype = 'javascript'
    ```

    Vim does not have inherent support for *json* files (it reverts to
    *JavaScript* syntax). If you do want a specific filetype for *json* property
    lists, when using a json plugin (such as [vim-json][vim-json]), you can
    specify *json* as the filetype instead.

## Notes

If you want syntax checking I highly recommend [Syntastic][syntastic] since it
has integrated support for property lists.

In case you use the `sudo tee` trick for writing to root owned files when using
Vim, it will **not** work with plist files. This is because the *tee* trick
uses the underlying Vim *write* function which bypasses the plugins
`BufWriteCmd` and `FileWriteCmd` hooks.

This does not add *plist* as a new filetype, but merely conversion
functionality between the different representible formats.

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
