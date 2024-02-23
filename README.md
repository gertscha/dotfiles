# Configuration Management
This is how I manage my configuration files.

Using GNU Stow is a simple way to manage all files in a single repository
while simultaneously having fine control over the installations.

See `man stow` for a full explanation of GNU Stow.

## Using Stow
Install the stow with the package manager of your system.

Folders represent packages (except for scripts).

Stow creates symlinks in the target directory based on
the structure inside the package.
By default this happens in the parent directory.
```
stow [package] # create symlinks
stow -D [package] # remove created symlinks
```
Cloning this repo into the home directory and then running
the stow commands inside the dotfiles folder generates the
symlinks in the correct locations.

## Windows
On Windows I use `mklink` to manually create the symbolic link for Neovim.
```
mklink /j "C:\Users\#username\AppData\Local\nvim" "D:\#path_to_repository\neovim\.config\nvim"
```
This creates a [Junction](https://learn.microsoft.com/en-us/windows/win32/fileio/hard-links-and-junctions#junctions)
which can go to other volumes.

