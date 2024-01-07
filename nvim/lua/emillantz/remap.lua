vim.keymap.set("n", "<leader>pc", vim.cmd.Ex)

vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })


--plugin specifics

--undotree
vim.keymap.set("n", "<leader>z", vim.cmd.UndoTreeToggle)

--vim-fugitive
vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

--telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

--copilot
vim.keymap.set('i', '<C-Space>', '<Plug>(copilot-dismiss)')
