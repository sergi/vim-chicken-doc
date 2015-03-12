## vim-chicken-doc

vim-chicken-doc is a vim plugin that integrates the documentation system of
chicken scheme in vim.

### Installation

vim-chicken-doc is an ftplugin and has to be installed in your ftplugin
directory. Installing it with vundle or pathogen will work too. Installing
it in the plugin directory won't work

In order for this plugin to work, you need to install the `chicken-doc` egg,
along with a tarball with the latest documentation:

```
sudo chicken-install chicken-doc
echo "(use chicken-doc)" | tee -a "$HOME/.csirc"
cd `csi -p "(chicken-home)"`
curl http://3e8.org/pub/chicken-doc/chicken-doc-repo.tgz | tar zx
```

Please note that depending on the platform you are, you might need to be root
for the above commands to work.

Also note that you need a line like the following in your .vimrc file:
`filetype plugin on`

### Usage

Typing `<leader> cw` when the cursor is on a particular keyword will query
chicken-doc for that keyword and present it in a small vertical buffer by
default.

### TODO

- Better documentation
- Disambiguation for similar command sin different contexts

### Other

This plugin is inspired by the [vim-pydoc
plugin](https://github.com/fs111/pydoc.vim).
