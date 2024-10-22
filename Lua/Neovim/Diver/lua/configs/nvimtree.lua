return {
  filters = {
    dotfiles = false,
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    width = 30,
    preserve_window_proportions = true,
  },
  renderer = {
    highlight_git = true,
    root_folder_modifier = ":t",
    indent_markers = {
      enable = true,
    },
    icons = {
      show = {
        git = true,
        folder = true,
        file = true,
        folder_arrow = true,
      },
      glyphs = {
        default = "󰈚",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}


--[[
NvimTree Configuration Explanation:

1. filters:
   - dotfiles: false -> Display dotfiles (hidden files, e.g., .gitignore).

2. disable_netrw & hijack_netrw:
   - disable_netrw: true -> Disable netrw (default file explorer) entirely.
   - hijack_netrw: true -> Make NvimTree take over all netrw actions.

3. hijack_cursor:
   - hijack_cursor: true -> Keep the cursor on the first entry when opening NvimTree.

4. sync_root_with_cwd:
   - sync_root_with_cwd: true -> Synchronize the root directory of NvimTree with the current working directory.

5. update_focused_file:
   - enable: true -> Updates the currently focused file in the explorer automatically.
   - update_root: false -> Keep the root directory of NvimTree constant even when files are updated.

6. view:
   - width: 30 -> Set the width of the file explorer window.
   - preserve_window_proportions: true -> Maintain window proportions when splitting.

7. renderer:
   - highlight_git: true -> Highlight git status in NvimTree.
   - root_folder_modifier: ":t" -> Display only the name of the root folder, not the full path.
   - indent_markers: enable = true -> Enable indent markers for a more visual folder structure.
   - icons: Show icons for files, folders, git status, etc., and customize the glyphs for better visual clarity.

8. git:
   - enable: true -> Show Git information.
   - ignore: false -> Do not hide files ignored by Git.
   - timeout: 400 -> Git operations timeout set to 400ms.

9. actions:
   - open_file:
     - quit_on_open: true -> Close NvimTree automatically when a file is opened.

Suggestions for Integration with Mason, null-ls, noice:
1. For **Mason**:
   - Make sure `mason.nvim` is set up properly to install language servers, linters, and formatters.
   - Link this with `null-ls` to provide formatting and diagnostics in an integrated manner with NvimTree.

2. For **null-ls**:
   - Use `null-ls` with the `mason-null-ls.nvim` plugin to install linters/formatters automatically and to integrate better with the LSP diagnostics and formatting needs.
   - Add appropriate diagnostic settings for better visualization within NvimTree for files with issues.

3. For **noice**:
   - Configure **noice.nvim** to show information when actions are triggered in NvimTree. For example, set up notifications to confirm file actions like deleting or renaming.

--]]
