local builtin = require("telescope.builtin")

-- Telescope keymaps
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })

-- Utility keymaps
vim.keymap.set("n", "<leader>fp", function()
  vim.cmd("let @+=@%")
end, { desc = "Copy current file path to the system clipboard" })

vim.keymap.set("n", "<leader>m", "o<ESC>", { desc = "Add a new line under the cursor" })
vim.keymap.set("n", "<leader>M", "O<ESC>", { desc = "Add a new line above the cursor" })

-- Neo-tree keymaps
vim.keymap.set("n", "<leader>bf", ":Neotree toggle show buffers right<cr>", { desc = "Show currently opened buffers" })
vim.keymap.set("n", "<leader>s", ":Neotree float git_status<cr>", { desc = "Open git status in a floating window" })
vim.keymap.set("n", "|", ":Neotree toggle<cr>", { desc = "Open neo-tree file view" })

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.type_definition, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set({ "n", "i" }, "<c-p>", vim.lsp.buf.signature_help, opts)
  end,
})

vim.keymap.set("n", "<leader>or", ":OverseerRun<cr>", { desc = "Select and run an Overseer task" })
vim.keymap.set("n", "<leader>ot", ":OverseerToggle<cr>", { desc = "Toggle Overseer task view" })

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  local desc = require("utils").desc

  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], desc(opts, "Exit terminal mode"))
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], desc(opts, "Move to the left"))
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], desc(opts, "Move to the bottom"))
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], desc(opts, "Move to the top"))
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], desc(opts, "Move to the right"))
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], desc(opts, "Enter a command mode"))
end

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = set_terminal_keymaps,
})
