-- git integration
local M = {
  'tpope/vim-fugitive',
  cmd = 'Git',
  keys = {
    { '<leader>g', desc = 'Open Git' },
  },
  tag = 'v3.7',
  config = function()
    -- fugitive (the other keybindings are default, see list at the bottom)
    require('which-key').add({
      mode = 'n', -- NORMAL mode
      silent = true, -- use `silent` when creating keymaps
      noremap = true, -- use `noremap` when creating keymaps
      nowait = false, -- use `nowait` when creating keymaps
      { '<leader>g', vim.cmd.Git, desc = 'Open Git' },
    })
  end,
}

return M

-- -- Summary of the binds for fugitive (removed some that I thought were not very useful)
-- g?                      Show this help. (when inside the :Git buffer)
-- --Staging/unstaging maps
-- s                       Stage (add) the file or hunk under the cursor.
-- u                       Unstage (reset) the file or hunk under the cursor.
-- -                       Stage or unstage the file or hunk under the cursor.
-- U                       Unstage everything.
-- X                       Discard the change under the cursor.  This uses `checkout` or `clean` under the hood.  A command is echoed that shows how to undo the change.
--                         Consult `:messages` to see it again.  During a merge conflict, use 2X to call `checkout --ours` or 3X to call `checkout --theirs` .
-- =                       Toggle an inline diff of the file under the cursor.
-- gI                      Open .git/info/exclude in a split and add the file under the cursor. Use a count to open .gitignore.
--
-- --Diff maps
-- dd                      Perform a |:Gdiffsplit| on the file under the cursor.
-- dv                      Perform a |:Gvdiffsplit| on the file under the cursor.
-- ds                      Perform a |:Ghdiffsplit| on the file under the cursor.
-- dh                      Perform a |:Ghdiffsplit| on the file under the cursor.
-- dq                      Close all but one diff buffer, and |:diffoff|! the last one.
--
-- --Navigation maps
-- <CR>                    Open the file or |fugitive-object| under the cursor. In a blob, this and similar maps jump to the patch from the diff where this was added, or where it was
--                         removed if a count was given.  If the line is still in the work tree version, passing a count takes you to it.
-- o                       Open the file or |fugitive-object| under the cursor in a new split.
-- gO                      Open the file or |fugitive-object| under the cursor in a new vertical split.
-- O                       Open the file or |fugitive-object| under the cursor in a new tab.
-- p                       Open the file or |fugitive-object| under the cursor in a preview window.  In the status buffer, 1p is required to bypass the legacy usage instructions.
-- ~                       Open the current file in the [count]th first ancestor.
-- P                       Open the current file in the [count]th parent.
-- C                       Open the commit containing the current file.
-- (                       Jump to the previous file, hunk, or revision.
-- )                       Jump to the next file, hunk, or revision.
-- [[                      Jump [count] sections backward.
-- ]]                      Jump [count] sections forward.
-- *                       On the first column of a + or - diff line, search for the corresponding - or + line.  Otherwise, defer to built-in |star|.
-- #                       Same as '*', but search backward.
-- gu                      Jump to file [count] in the 'Untracked' or 'Unstaged' section.
-- gU                      Jump to file [count] in the 'Unstaged' section.
-- gs                      Jump to file [count] in the 'Staged' section.
-- gp                      Jump to file [count] in the 'Unpushed' section.
-- gP                      Jump to file [count] in the 'Unpulled' section.
-- gr                      Jump to file [count] in the 'Rebasing' section.
-- gi                      Open .git/info/exclude in a split.  Use a count to open .gitignore.
--
-- --Commit maps
-- cc                      Create a commit.
-- ca                      Amend the last commit and edit the message.
-- ce                      Amend the last commit without editing the message.
-- cw                      Reword the last commit.
-- cf                      Create a `fixup!` commit for the commit under the cursor.
-- cF                      Create a `fixup!` commit for the commit under the cursor and immediately rebase it.
-- cs                      Create a `squash!` commit for the commit under the cursor.
-- cS                      Create a `squash!` commit for the commit under the cursor and immediately rebase it.
-- cA                      Create a `squash!` commit for the commit under the cursor and edit the message.
-- c<Space>                Populate command line with ':Git commit '.
-- crc                     Revert the commit under the cursor.
-- crn                     Revert the commit under the cursor in the index and work tree, but do not actually commit the changes.
-- cr<Space>               Populate command line with ':Git revert '.
-- cm<Space>               Populate command line with ':Git merge '.
--
-- --Checkout/branch maps
-- coo                     Check out the commit under the cursor.
-- cb<Space>               Populate command line with ':Git branch '.
-- co<Space>               Populate command line with ':Git checkout '.
--                                                 *fugitive_cz*
-- --Stash maps
-- czz                     Push stash.  Pass a [count] of 1 to add `--include-untracked` or 2 to add `--all`.
-- czw                     Push stash of the work-tree.  Like `czz` with `--keep-index`.
-- czs                     Push stash of the stage.  Does not accept a count.
-- czA                     Apply topmost stash, or stash@{count}.
-- cza                     Apply topmost stash, or stash@{count}, preserving the index.
-- czP                     Pop topmost stash, or stash@{count}.
-- czp                     Pop topmost stash, or stash@{count}, preserving the index.
-- cz<Space>               Populate command line with ':Git stash '.
--
-- --Rebase maps
-- ri                      Perform an interactive rebase.  Uses ancestor of
-- u                       commit under cursor as upstream if available.
-- rf                      Perform an autosquash rebase without editing the todo list.  Uses ancestor of commit under cursor as upstream if available.
-- ru                      Perform an interactive rebase against @{upstream}.
-- rp                      Perform an interactive rebase against @{push}.
-- rr                      Continue the current rebase.
-- rs                      Skip the current commit and continue the current rebase.
-- ra                      Abort the current rebase.
-- re                      Edit the current rebase todo list.
-- rw                      Perform an interactive rebase with the commit under the cursor set to `reword`.
-- rm                      Perform an interactive rebase with the commit under the cursor set to `edit`.
-- rd                      Perform an interactive rebase with the commit under the cursor set to `drop`.
-- r<Space>                Populate command line with ':Git rebase '.
--
-- --Miscellaneous maps
-- gq                      Close the status buffer.
-- .                       Start a |:| command line with the file under the cursor prepopulated.
-- g?                      Show help for |fugitive-maps|.
--
