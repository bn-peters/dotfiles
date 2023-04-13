Dotfiles designed to be installed with `stow`. 
`stow` is a tool that creates symlinks to the files in the `stow`ed directory in the parent folder.

- To initialize or to add symlinks for new files:
    ```
    stow --no-folding nvim
    ```
- If some files already exist, they can be `adopt`ed into stow's tree:
    ```
    stow --adopt nvim
    ```
- To add a new file to an existing `stow` package, do one of the following:
    1. *move* the new file into its position in the `stow`ed package, and run `stow --no-folding package`
    2. *touch* the new file in its position in the `stow`ed package, and run `stow --adopt package`

