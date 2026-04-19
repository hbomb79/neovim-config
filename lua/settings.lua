-- Main settings file where (Neo)Vim settings can
-- be adjusted. These settings will be applied
-- before any plugins are loaded so sane defaults
-- can be placed here

local function apply(target, tbl)
	for k, v in pairs(tbl) do
		target[k] = v
	end
end

local function set(arg)
	for _, v in pairs(arg) do
		vim.cmd("set " .. v)
	end
end

-- Basic Configurations
vim.cmd([[
    syntax on
]])

-- Vim 'cmd set' commands go here
set({
	"iskeyword+=-",
	"shortmess+=c",
	"inccommand=split",
	"whichwrap+=<,>,[,],h,l",
	"colorcolumn=0",
	"ts=4",
	"sw=4",
	"expandtab",
	"cursorline",
	"incsearch",
	"nocompatible",
	"completeopt=menu,menuone,noselect",
	"laststatus=3",
	"winbar=%=%m\\ %f",
	"cmdheight=1",
	"clipboard+=unnamedplus",
	"ignorecase",
	"smartcase",
	"spell",
	"spelloptions=noplainbuffer,camel",
})

-- Buffer/general options go here
apply(vim.o, {
	hidden = true,
	title = false,
	pumheight = 10,
	fileencoding = "utf-8",
	mouse = "a",
	splitbelow = true,
	scrolloff = 10,
	termguicolors = true,
	splitright = true,
	conceallevel = 0,
	showtabline = 1,
	showmode = false,
	backup = false,
	writebackup = false,
	updatetime = 300,
	clipboard = "unnamedplus",
	guifont = "SauceCodePro Nerd Font:h17",
	foldmethod = "indent",
	foldnestmax = 5,
	foldenable = false,
	foldlevel = 2,
})

-- Window options
apply(vim.wo, {
	wrap = false,
	number = true,
	relativenumber = true,
	cursorline = true,
	signcolumn = "yes",
})

-- Window keybinds
vim.keymap.set({ "n", "t" }, "<C-h>", "<cmd>wincmd h<cr>")
vim.keymap.set({ "n", "t" }, "<C-j>", "<cmd>wincmd j<cr>")
vim.keymap.set({ "n", "t" }, "<C-k>", "<cmd>wincmd k<cr>")
vim.keymap.set({ "n", "t" }, "<C-l>", "<cmd>wincmd l<cr>")
vim.keymap.set({ "n", "t" }, "<S-Left>", "<cmd>vertical resize -10<CR>")
vim.keymap.set({ "n", "t" }, "<S-Right>", "<cmd>vertical resize +10<CR>")
vim.keymap.set({ "n", "t" }, "<S-Up>", "<cmd>resize +10<CR>")
vim.keymap.set({ "n", "t" }, "<S-Down>", "<cmd>resize -10<CR>")
vim.keymap.set("n", "<S-x>", "<cmd>bdelete<CR>")
vim.keymap.set("t", "<S-x>", "<cmd>bdelete!<CR>")

-- Global options (likely for plugin configuration, which should
-- be placed in the plugins config function instead).
apply(vim.g, {
	clang_library_path = "/usr/lib/libclang.so",
	mapleader = " ",
	nvcode_termcolors = 256,
	gitblame_enabled = 0,
})
vim.keymap.set("n", "<Space>", "<NOP>")
vim.keymap.set("n", "<leader><leader>", "<cmd>nohlsearch<CR>", { desc = "Clear search Highlight" })
