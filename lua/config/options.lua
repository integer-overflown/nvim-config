-- Set the tab width to 4
vim.opt.shiftwidth = 4
-- Enable line numbers by default
vim.opt.number = true
-- Enable syntax highlighting
vim.opt.syntax = "on"
-- Expand tabs to spaces
vim.opt.expandtab = true
-- Enable relative numbers by default
vim.opt.relativenumber = true
-- Automatically read from disk when file is changed
-- externally (by VCS, for example)
vim.opt.autoread = true

-- Set the leader key to Space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Configure how new splits should be opened
vim.opt.splitright = false
vim.opt.splitbelow = false

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Live command substitution (for substitute and user commands)
vim.opt.inccommand = "split"

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("ovf-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function make_ignore_map(filetypes)
  local ret = {}

  for _, value in ipairs(filetypes) do
    ret[value] = true
  end

  return ret
end

local ignored = make_ignore_map({
  "TelescopePrompt",
  "TelescopePromptBorder",
  "TelescopeResults",
  "dashboard",
  "neo-tree",
  "neo-tree-popup",
  "notify",
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable spell-check for editable buffers",
  group = vim.api.nvim_create_augroup("ovf-buf-spellcheck", { clear = true }),
  callback = function(args)
    local ft = args.match

    if ignored[ft] then
      return
    end

    local win = vim.api.nvim_get_current_win()
    vim.wo[win].spell = true
    vim.bo[args.buf].spelllang = "en_us"
  end,
})
