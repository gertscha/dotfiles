# Installation
Add place the content of this repo in the nvim config folder.
Use `:h $XDG_CONFIG_HOME` to verify the location.

On Windows this should be `C:\Users\USERNAME\AppData\Local\nvim`.
On Linux this should be `~/.config/nvim.

The config uses the [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager by folke.
Setup should be automatic on first startup but a restart is usually required.

If there are languages missing from the system there are likely going to be errors.
Either install the language or remove it from the table in init.lua.

To display some of the icons a nerd-font needs to be available and setup for the terminal.
Install one and set it up. On windows use Windows Terminal (get from Windows Store if on Windows 10)
and set the font there. Alternatively the icons can be replaced by adjusting `lua/settings/icons.lua`.

Use `:checkhealth` to see if other components are missing from the system.

# Keybinds Reference
This is a reference to the keybinds (sample of the default bindings at the end).
"Which-Key" plugin is also installed.

## Adjusted & Custom Global Keybinds
Adjusted keybinds have a alteration remark in braces i.e. key - effect (deviation from default)
```
space => <leader>
// Normal Mode
QQ                      Close current buffer
WW                      Save current buffer
<leader>p               Paste most recent yank
<leader>r               Redo last undo
<leader>ca              Select entire buffer, going into visual mode
<C-d>                   Jump half page down (keep always keep cursor centered)
n                       Go to next search match (keeps the cursor centered)
N                       Go to previous search match (keeps the cursor centered)
J                       Append next line to current line (cursor doesn't move)
gJ                      Append next line to current line without space (cursor in place)

// Visual Mode
>                       Increase indentation (remains in this mode i.e. repeatable)
<                       Reduce indentation (remains in this mode i.e. repeatable)
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
  // ToggleTerm (Terminal) // disabled 
  <C-t>                 Toggle floating terminal //can only be modified in insert mode

// Insert Mode
  // Autopairs // disabled
  <A-e>                 Enter fast wrap, instert mode (select where closing bracket should go)
```

## Telescope
```
// Normal Mode
<leader>sf              Search Files
<leader>sb              Search open Buffers
<leader>sr              Search Git Repository
<leader>sh              Search Help
<leader>sw              Search Word under cursor (ripgrep)
<leader>sg              Search with Grep
```

## LSP
Use `:LspInfo` to get a status on the language server\
Use `:Mason` to manage the language servers
```
// Normal Mode
gd                      Go to definition
gD                      Go to declaration
K                       Lookup symbol (overrides the 'keywordprg' lookup with lsp lookup)
<leader>df              Open diagnostic float (on lines with a diagnostic marker)
<leader>dds             Search diagnostics list (requries Telescope)
<leader>dda             View code actions
<leader>ddw             View all symbols in the current workspace in the quickfix window
<leader>ddr             View references in quickfix window
<leader>dr              Rename all references to the symbol under the cursor
```

## Fugitive (Git)
A bigger list can be found in the fugitive.lua file
```
<leader>g               Open fugitive window

// while inside the fugitive buffer
g?                      Show the help with all the key binds
gq                      Close the status buffer
s                       Stage (add) the file or hunk under the cursor (push if on commit)
u                       Unstage (reset) the file or hunk under the cursor
U                       Unstage everything
X                       Discard the change under the cursor.  This uses `checkout` or `clean`
                        under the hood. A command is echoed that shows how to undo the change
=                       Toggle an inline diff of the file under the cursor
o                       Open the file or |fugitive-object| under the cursor in a new split
gO                      Open the file or |fugitive-object| under the cursor in a new vertical split
[[                      Jump [count] sections backward
]]                      Jump [count] sections forward
cc                      Create a commit. use `:x` to finish it after setting a message
ca                      Amend the last commit and edit the message
ce                      Amend the last commit without editing the message
crc                     Revert the commit under the cursor
crn                     Revert the commit under the cursor in the index and work tree, but do not
                        actually commit the changes
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
<leader>n               Go to file 1
<leader>m               Go to file 2
<leader>b               Go to file 3
<C-k>                   Go to previous file in swap list
<C-l>                   Go to next file in swap list
```

## CMP
```
<Tab>                   Super Tab, use to step through the options
<CR> or <C-i>           Accept the suggestion
<Shift-Tab>             Step backwards through options
<C-n>                   Select next item in the list
<C-p>                   Select previous item the list
<C-e>                   Close the suggestions float
<C-s>                   Complete the suggestions
```

## Move
```
// Normal Mode
<A-j>                   Move line under cursor down
<A-k>                   Move line under cursor up
<leader>wf              Move [W]ord [F]orward
<leader>wb              Move [W]ord [B]ackward

// Visual Mode
<A-h>                   Move selection to the left
<A-j>                   Move selection down
<A-k>                   Move selection up
<A-l>                   Move selection to the right
```

## Comments
```
// Normal Mode
`gcc`                   Toggle current line
`gbc`                   Toggle current line in blockwise comment style
`gc[count]{motion}`     (Op-pending) Toggles the region using linewise comment
`gb[count]{motion}`     (Op-pending) Toggles the region using blockwise comment

// Visual Mode
`gc`                    Toggles the region using linewise comment
`gb`                    Toggles the region using blockwise comment
```
This means all the default commands work in normal mode, i.e.
```
gco                     Insert comment to the next line and enters INSERT mode
gcO                     Insert comment to the previous line and enters INSERT mode
gcA                     Insert comment to end of the current line and enters INSERT mode
gc$                     Toggle from the current cursor position to the end of line
gc}                     Toggle until the next blank line
gc8k                    Toggle 8 lines before the current cursor position
gcip                    Toggle inside of paragraph
gca}                    Toggle around curly brackets
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
    <C-a>               Increment first number on or to the right of cursor
    <C-x>               Decrement first number on or to the right of cursor
    c                   Delete based on motion and enter insert mode (ciw to change word)
    C or c$             Delete from cursor to end of line, enter insert mode
    cc                  Delete line and enter insert mode
    x                   Cut a character
    g~                  Swap case based on motion text (g~~ does whole line)
    gU                  Make upper case based on motion (gUU does whole line)
    gu                  Make lower case based on motion (guu does whole line)
    .                   Repeat last command
    &                   Repeat last substitute (&& also keeps flags as well)
  // Cursor Movement
    $                   Goto end of current line
    0                   Goto beginning of current line
    ^                   Goto first character on current line
    w                   Jump to next word
    b                   Jump to previous word
    e                   Jump to end of current word
    ge                  Jump back to end of previous word
    viw                 Select the word that the cursor is on in visual mode
    viW                 Select contigous text in both directions
    va( or va{          Select next brace block with braces included
    vi( or vi{          Select next brace block without braces
    gg                  Goto top of buffer
    [number]G           Goto line [number] or bottom if no number
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
  // Folds
    zi                  Toggle Fold functionality
    zc                  Close Fold
    zo                  Open Fold
    zM                  Mask (close all Folds), m to only do one level
    zR                  Reveal (open all Folds), r to only do one level
    zf[motion]          Create fold up to motion
    zd                  Delete fold, does not delete content
// Insert Mode
  // Entering Insert Mode
    i                   before cursor
    I                   at beginning of line
    a                   after cursor
    A                   at end of line
    o                   after current line
    O                   before current line
  // Actions in Insert Mode
    <C-h>               Delete character befor cursor
    <C-j>               Create line break at cursor position
    <C-w>               Delete word before the cursor
    <C-t>               Indent line
    <C-d>               De-indent line
    <C-o>               Issue one normal mode command
// Visual Mode
  o                     Goto other end of marked area
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
@[0-9a-z]               Run macro in the register                 
@@                      Rerun last played macro
```

# Marks
A local mark is specific to a file and uses a lowercase letter\
Global marks are universal across all files and use uppercase letters.\
To jump to a mark either use a backtick (`) or an apostrophe (').\
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

