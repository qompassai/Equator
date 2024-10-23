-- Nerd-to-english translation legend:

-- opt/o/g: Shortcuts for vim.opt, vim.o, and vim.g (global variables)
-- laststatus: Controls the display of the status line (0: never, 1: only if multiple windows, 2: always, 3: global)
-- showmode: Shows the current mode (INSERT, VISUAL, etc.) in the command line
-- clipboard: Configures clipboard behavior, "unnamedplus" uses system clipboard
-- cursorline: Highlights the current line
-- cursorlineopt: Specifies what to highlight in the current line
-- expandtab: Uses spaces instead of tabs for indentation
-- shiftwidth: Number of spaces for each indentation level
-- smartindent: Automatically indents new lines based on the previous line
-- tabstop: Number of spaces that a tab character represents
-- softtabstop: Number of spaces inserted when the tab key is pressed
-- fillchars: Characters used for filling status line and vertical separators
-- ignorecase: Ignores case in search patterns
-- smartcase: Override ignorecase if search pattern contains uppercase characters
-- mouse: Enables mouse support in all modes
-- redrawtime: Maximum time in milliseconds for redrawing the display
-- synmaxcol: Maximum column for syntax highlighting
-- number: Shows line numbers (ie this text is on line 20)
-- numberwidth: Minimum number of columns to use for line numbers
-- ruler: Shows cursor position in the bottom right corner
-- shortmess: Controls the length of messages, 'sI' disables intro message
-- signcolumn: Controls the display of the sign column (for git signs, linting, etc.)
-- splitbelow/splitright: Controls the default position of new splits
-- timeoutlen: Time in milliseconds to wait for a mapped sequence to complete
-- undofile: Enables persistent undo
-- updatetime: Time in milliseconds of no cursor movement to trigger CursorHold event
-- whichwrap: Allows specified keys to move to previous/next line
-- wrap: Enables line wrapping
-- linebreak: Wraps lines at word boundaries
-- showbreak: String to put at the start of wrapped lines

local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "

-------------------------------------- options ------------------------------------------
-- Options
o.laststatus = 3
o.showmode = false

--Clipboard and cursor

o.clipboard = "unnamedplus"
o.cursorline = true
o.cursorlineopt = "number"

-- Indenting
o.expandtab = true
o.shiftwidth = 4
o.smartindent = true
o.tabstop = 4
o.softtabstop = 4

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Files
opt.redrawtime = 1500
opt.synmaxcol = 200

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
---- Timing
o.timeoutlen = 400
o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- g.mapleader = " "

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- Line wrapping
opt.wrap = true
opt.linebreak = true
opt.showbreak = "↪ "

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH
