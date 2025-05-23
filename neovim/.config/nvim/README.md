# Installation
Add the content of this repo in the `nvim` config folder.
Use `:h $XDG_CONFIG_HOME` for more information or run `:echo stdpath('config')`
to get the location.

The config uses the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin
manager by folke. Setup should be automatic on first startup but a restart may
be required.

Be sure to run `:checkhealth` and fix any errors shown. The notifications are
handled by [snacks.nvim](https://github.com/folke/snacks.nvim), shown in the
top right, to view them again use `:Mes` or `:Messages` instead of the default
`:mes`/`:messages`.

To display some of the icons a nerd-font needs to be available and setup for the
terminal. Install one and set it up. On windows use Windows Terminal (get from
Windows Store if on Windows 10) and set the font there. Some of the icons
can be replaced by adjusting `lua/settings/icons.lua`, but many plugins
require a nerd-font.

## Try a configuration
Neovim looks for the environment variable `NVIM_APPNAME`, which can be used
to adjust the location of the configuration files. So you can use
`export NVIM_APPNAME=my-cool-config nvim` to set Neovim load the configuration
from `~/.config/my-cool-config/`. See `:h $NVIM_APPNAME`.

# Keybinds Reference
This is a reference to the keybinds (sample of the default bindings at the end).
"Which-Key" plugin is also installed.
But this is just a reference, if you do not know the basics, learn those first.

Also keep in mind that you can use commands directly for most plugins. And
manage plugins with `:Lazy`.

## Adjusted & Custom Global Keybinds
Adjusted keybinds have a alteration remark in braces i.e. key - effect (deviation
from default)
```
space => <leader>
// Normal Mode
<leader>p               Paste most recent yank
<leader>r               Redo
<leader>ya              Select entire buffer, going into visual mode
<C-d>                   Jump half page down (keep always keep cursor centered)
<C-u>                   Jump half page up (keep always keep cursor centered)
n                       Go to next search match (keeps the cursor centered)
N                       Go to previous search match (keeps the cursor centered)
J                       Append next line to current line (cursor doesn't move)
gJ                      Append next line to current line without space (cursor in place)
x                       Cut (goes into register 9 instead of 1)
// Visual Mode
>                       Increase indentation (remains in this mode i.e. repeatable)
<                       Reduce indentation (remains in this mode i.e. repeatable)
// Insert Mode
<C-s>                   Expand or step forward in snippet, if snippet available
                        otherwise do the default vim.lsp.buf.signature_help()
```

## Misc
```
// Normal Mode
  // Oil
  -                     Open Oil filemanager float, if already open, go up one level
  q                     Exit // changes must be saved manually
  // Undotree
  <leader>u             Open Undotree, use ? to toggle the help view
  q                     Exit
  // ToggleTerm (Terminal)
  <leader>ot            Toggle terminal overlay
  // Textwidth settings
  <leader>th            Toggle colorcolumn highlight on and off
  <leader>twl           Toggle text wrapping
  <leader>tw0           Set textwidth to zero (disable)
  <leader>tw1           Set textwidth to 80
  <leader>tw2           Set textwidth to 120
  // Visual toggles
  <leader>os            Open Splash Screen
  <leader>tc            Toggle color visualization
  <leader>ti            Toggle scope markers (indent lines)
  <leader>tsc           Toggle command line visibility
  // Quickfix list
  <M-n>                 Quickfix list next
  <M-p>                 Quickfix list previous
  <M-q>                 Close Quickfix list
  // Treesitter
  <cr>                  Visual select next incremental outer scope
// All Modes (except visual block)
  <A-j>                 Move line under cursor down
  <A-k>                 Move line under cursor up
```

## Search (fzf-lua)
```
// Normal Mode
<leader>sf              Search Files
<leader>sb              Search open Buffers
<leader>sr              Search Files in Git Repository
<leader>sh              Search Help
<leader>sw              Search Word under cursor
<leader>sg              Search with Grep
<leader>sj              Search jumplist
<leader>ss              Search builtin pickers
<leader>sm              Search manpages
<leader>sc              Search Files in Neovim config
<leader>sp              Search Files in Neovim plugins implementations
<leader>sM              Search marks
<leader>sl              Search LSP (everything releated to symbol under cursor)
<leader>sd              Search diagnostics messages in current document
<leader>sD              Search diagnostics messages in workspace
<leader><leader>        Resume previous search


// In a fzf lua search buffer
<F1>                    Show help
<A-m>                   Hide search (and resume with <leader><leader>)
<esc>                   Close search window
<C-s>                   Open file in split
<C-v>                   Open file in vertical split
<A-q>                   Add file to quickfix list
<F3>                    Toggle preview text wrap
<F4>                    Toggle preview
<A-i>                   Toggle ignored files
<A-h>                   Toggle hidden files
<A-f>                   Toggle follow (of symbolic links)
```

## LSP
Use `:LspInfo` to get a status on the language server\
Use `:Mason` to manage the language servers\
Most of these keybindings work on the symbol under the cursor and are only
available if the LSP server supports the functionality
```
// Normal Mode
gd                      Go to definition
gD                      Go to declaration
gI                      Go to implementation
gT                      Go to type definition
gr                      Search references
K                       LSP Hover
<leader>df              Format Buffer
<leader>dr              Rename all references to the symbol under the cursor
<leader>da              Use a code action
<leader>dw              Query workspace symbols
<leader>ds              Search document symbols
<leader>dS              Search workspace symbols
<leader>dco             Search outcoming calls
<leader>dci             Search incoming calls
```

Templates for the formatter config files can be created with `:FormatterSetup[...]`.

## Fugitive (Git)
```
<leader>g               Open fugitive window

// while inside the fugitive buffer
g?                      Show the help with all the keybinds
gq                      Close the fugitive buffer
s                       Stage (add) the file under the cursor
s                       Stage the hunk selected in visual mode
s                       Push the commit under the cursor
u                       Unstage (reset) the object under the cursor (files or hunks)
U                       Unstage everything
X                       Discard the change under the cursor.  This uses `checkout` or `clean`
                        under the hood. A command is echoed that shows how to undo the change
=                       Toggle an inline diff of the file under the cursor
o                       Open the file or |fugitive-obj| under cursor in a new split
gO                      Open the file or |fugitive-obj| under cursor in a new vertical split
[[                      Jump [count] sections backward
]]                      Jump [count] sections forward
cc                      Create a commit. use `:x` to finish it after setting a message
ca                      Amend the last commit and edit the message
ce                      Amend the last commit without editing the message
crc                     Revert the commit under the cursor
crn                     Revert the commit under the cursor in the index and work tree,
                        but do not actually commit the changes
coo                     Check out the commit under the cursor
c<Space>                Populate command line with ":Git commit "
cb<Space>               Populate command line with ":Git branch "
co<Space>               Populate command line with ":Git checkout "
cz<Space>               Populate command line with ":Git stash "
r<Space>                Populate command line with ":Git rebase "
.                       Start a |:| command line with the file under the cursor prepopulated
```

## Harpoon
```
<leader>a               Add current file to the swap list
<leader>h               Toggle quick menu showing the complete list
<leader>m               Go to file 1
<leader>n               Go to file 2
<leader>b               Go to file 3
<leader>v               Go to file 4
<A-h>                   Go to previous file in swap list
<A-l>                   Go to next file in swap list
```

## Completion - blink
```
<C-space>               Show completion menu
<C-e>                   Close completion menu
<Enter>                 Accept selected completion
<C-n> or <Tab>          Select next item in the completion list
<C-p>                   Select previous item the completion list
<C-k>                   Show signature popup
<C-Tab>                 Go forward in the snippet
<S-Tab>                 Go backwards in the snippet
<C-b>                   Scroll documentation up
<C-f>                   Scroll documentation down
```

## Markdown Preview
```
// inside Neovim
<leader>omb             Toggle Markdown preview in nvim (uses basic highlighting)
// external browser window
<leader>oms             Open Markdown in browser
<leader>omp             Pick Markdown file to open in browser
<leader>omc             Close Markdown preview in browser
```


## Default Keybinds
Selection of default vim keybinds
```
// Normal Mode
  [action]a[motion]     Perform action on one motion inclusive whitespace
  [action]i[motion]     Perform action on one motion exclusive whitespace
  // Editing
    u                   Undo
    <C-r>               Redo (<leader>r is also bound to this)
    r                   Replace character under cursor with what is typed next
    R                   Replace characters until ESC is pressed
    ==                  Align indent of current line
    =ap                 Align indent of current paragraph (ap => a paragraph)
    gcc                 Toggle comment for current line
    gc[motion]          Toggles comment the region covered by the motion
    <C-a>               Increment first number on or to the right of cursor
    <C-x>               Decrement first number on or to the right of cursor
    c                   Delete based on motion and enter insert mode (ciw to change word)
    C or c$             Delete from cursor to end of line, enter insert mode
    cc                  Delete line and enter insert mode
    x                   Cut a character
    ~                   Swap character case
    g~[motion]          Swap charcter case based on motion (g~~ does whole line)
    gU                  Make upper case based on motion (gUU does whole line)
    gu                  Make lower case based on motion (guu does whole line)
    .                   Repeat last command
    &                   Repeat last substitute (&& also keeps flags as well)
    gww                 Format line to fit textwidth (or 80 if no textwidth set)
    [<space>            Insert empty line above
    ]<space>            Insert empty line below
  // Cursor Movement
    $                   Goto end of current line
    0                   Goto beginning of current line
    ^                   Goto first character on current line
    w                   Jump to next word (and W for whitespace based)
    b                   Jump to previous word (and B for whitespace based)
    e                   Jump to end of current word (and E for whitespace based)
    ge                  Jump back to end of previous word (also gE)
    gv                  Reselect previous visual selection
    viw                 Select the word that the cursor is on in visual mode
    viW                 Select contigous text in both directions
    va( or va{ or vab   Select next brace block with braces included
    vi( or vi{ or vib   Select next brace block without braces
    gg                  Goto top of buffer
    [number]G           Goto line [number] or bottom if no number
    :[number]           Goto line [number] or bottom if no number
    { and }             Jump paragraphs
    /                   Search forward
    gn                  Goto next match of previous search and enter visual mode
    gN                  Goto previous match of previous search and enter visual mode
    %                   Goto matching matching brace, on same line goto brace face cursor
    f[x]                Find next occurence of character [x] on the current line
    t[x]                Same as 'f[x]' but cursor moved before the character instead
    F[x]                Find previous occurence of character [x] on the current line
    T[x]                Same as 'F[x]' but cursor moved before the character instead
    ;                   Repeat previous f,F,t,T movement
    ,                   Repeat previous f,F,t,T movement backwards
    H,L,M               Move the cursor to Top,Bottom,Middle of the screen
    {count}<C-e>        Scroll count lines down, keep cursor in place
  // Indentation
    >>                  Indent line
    <<                  de-indent line
    >%                  Indent block with () or {}, cursor must be on brace
    <%                  De-indent block with () or {}, cursor must be on brace
    ]p                  paste and adjust indent to current line
  // Window Management
    <C-w>s              Split window horizontally
    <C-w>v              Split window vertically
    <C-w>w              Cycle active buffer
    <C-w>h              Switch to buffer on the left
    <C-w>j              Switch to buffer below
    <C-w>k              Switch to buffer above
    <C-w>l              Switch to buffer on the right
    zz                  Center the cursor on screen, keeping it in place
    <C-e>               Move screen up one line
    <C-y>               Move screen down one line
    gO                  Get table of contents in quickfix list (mainly for :help)
    ZZ                  Save and quit Vim
    ZQ                  Quit Vim without saving
  // Folds
    zi                  Toggle Fold functionality
    zc                  Close Fold
    zo                  Open Fold
    zM                  Mask (close all Folds), m to only do one level
    zR                  Reveal (open all Folds), r to only do one level
    zf[motion]          Create fold up to motion
    zd                  Delete fold, does not delete content
  // Utility
    gx                  Open URl under the cursor with system default handler
    gf                  Open the file(path) under the cursor (searches path)
    zg                  Add word under cursor to spellfile (see :h spell)
    zw                  Mark the word under cursor as a wrong (bad) word
    z=                  Suggset corrections for word under cursor
    {count}<C-g>        Show file info, no count just shows name & info, setting
                        count gives full path, count > 1 also gives buffer number
// Insert Mode
  // Entering Insert Mode
    i                   before cursor
    I                   at beginning of line
    a                   after cursor
    A                   at end of line
    o                   after current line
    O                   before current line
    <C-v>               Escape sequence to enter special keys like <esc>
                        useful for example to edit macros
  // Actions in Insert Mode
    <C-h>               Delete character befor cursor
    <C-j>               Same as Newline
    <C-e>               Copy character from line below
    <C-y>               Copy character from line above
    <C-w>               Delete word before the cursor
    <C-u>               Undo last insertion, or complete line if no insertion
    <C-t>               Indent current line one shiftwidth
    <C-d>               De-indent current line one shiftwidth
    0<C-d>              De-indent current line fully
    ^<C-d>              De-indent line fully (restores indent for next line)
    <C-o>               Issue one normal mode command
    <C-r>{register}     Paste the contents of {register}
    <C-K>               Enter a digraph (see :dig and :h diagraph)
                        For example '-M' creates an Em Dash (—)
// Visual Mode
  gc                    Toggle comment of the region
  g<C-a>                Increment first number in selection based on line offset
  J                     Collapse selection into single line (with spaces)
  o                     Swap selection direction
  s                     Delete selection and go into insert mode
  [a,i]b                Mark block ()
  [a,i]B                Mark block {}
  [a,i]t                Mark block <>
  u                     Make lower case
  U                     Make upper case
```

# Registers
Registers are being stored in ~/.viminfo, and will be loaded again on restart.

The 26 named registers "a to "z only get filled by user commands.
Using lower case overwrites the contents, uppercase appends to them.

The 10 numbered registers "0 to "9 contain the delete and paste history.
Contents from "1 onward get pushed higher with new edits (1 to 2, 2 to 3, etc).
```
:reg[isters]            show registers content
"xy                     yank into register x
"xp                     paste contents of register x
"+y                     yank into the system clipboard register
"+p                     paste from the system clipboard register
<C-r>x                  paste contents of redgister x while in insert mode
```
Special registers:
```
0 - last yank
1 - last text deleted or changed
" - unnamed register, last delete or yank
% - current file name, read-only
# - alternate file name (alternate buffer)
* - clipboard contents (X11 primary)
+ - clipboard contents (X11 clipboard)
/ - last search pattern
: - last command-line, read-only
. - last inserted text, read-only
- - last small (less than a line) delete
= - expression register
_ - black hole register
```

# Macros
```
q[0-9a-z]               Start recording into the register, use [A-Z] to append actions
q                       Stop recording if a recording is ongoing (from normal mode)
@[0-9a-z]               Run macro in the register (can also prefix a count)
@@                      Rerun last played macro
```

# Marks
A local mark is specific to a file and uses a lowercase letter\
Global marks are universal across all files and use uppercase letters.\
To jump to a mark either use a backtick (\`) or an apostrophe (\').\
Using an apostrophe jumps to the first character on the line holding the mark.
```
:marks                  View list of marks
ma                      Set current position for mark A
`a                      jump to position of mark A
y`a                     Yank text to position of mark A
`0                      Go to the position where Vim was previously exited
`"                      Go to the position when last editing this file
`.                      Go to the position of the last change in this file
``                      Go to the position before the last jump
<C-i>                   Move forward through jump list
<C-o>                   Move backwards through jump list
:ju[mps]                View the jumplist
:clearjumps             Delete the jump list
:changes                List of changes
g,                      Go to newer position in change list
g;                      Go to older position in change list
```

# Useful commands
`:only` or append `| only` to a command to maximize the current buffer.

`:vsplit` and `:split` for vertical/horizontal splits (instead of the `C-w` keybinds)

`:ve` to get the current version of Neovim.

`:r[ead]` paste contents of a file below the cursor

`:echo &filetype` to get the type of the current buffer (to add a ftplugin)

# Format Strings for Time and Date
```
Format String           Example output
%c                      Thu 27 Sep 2007 07:37:42 AM EDT
%a %d %b %Y             Thu 27 Sep 2007
%b %d, %Y               Sep 27, 2007
%H:%M:%S                07:36:44
%T                      07:38:09
%m/%d/%y                09/27/07
%y%m%d                  070927
%x %X (%Z)              09/27/2007 08:00:59 AM (EDT)
%Y-%m-%d                2016-11-23
%F                      2016-11-23 (works on some systems)
%d/%m/%y %H:%M:%S       27/09/07 07:36:32
```

# Sessions
```
:mksession [name]       Save current session, optionally give file [name]
                        if no file name given the default is Session.vim is used
:source <name>          Load the session stored in <name>
```
Or use the following keybinds:
```
<leader>ls              Save current state
<leader>lg              Load the previously saved state
```
A couple of extra states can be saved/loaded with:
```
<leaader>lls1
<leaader>lls2
<leader>llg1
<leader>llg2
```

