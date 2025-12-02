vim.g.mapleader = " "
vim.o.number = true
vim.o.termguicolors = true
vim.cmd.colorscheme("habamax")

vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true })



