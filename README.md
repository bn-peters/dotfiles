Dotfiles designed to be installed with `stow`. 

`stow` is a tool that creates symlinks, by default in the parent directory.

To initialize:
```
cd ~
git clone ...
cd dotfiles

stow i3
stow nvim
...
```

To force `stow` to overwrite files:
```
stow --adopt i3
```
