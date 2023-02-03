vim.opt.cmdheight = 1 -- TODO: Hide cmdline and show messages somehwere else
vim.opt.conceallevel = 2 -- Hide concealed text unless replacement character defined
vim.opt.cursorline = true -- highlight current line
vim.opt.signcolumn = 'yes' -- always show signcolumn
vim.opt.undofile = true
vim.opt.jumpoptions:append('stack')

-- Terminal setup
vim.opt.title = true
vim.opt.termguicolors = true

-- Default tab settings - will be overridden by filetype specific stuff
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Break lines on punctuation and indent carry-on lines
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Natural splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Ignore case in commands unless uppercase is used. Make tags file case-sensitive
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.tagcase = 'match'

-- Fold with indents and start unfolded
-- TODO: Possibly integrate tree-sitter here
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99

-- Hide extraneous cmdline info
vim.opt.showmode = false
vim.opt.showcmd = false

-- ZSH style completion
vim.opt.completeopt = 'menuone,noinsert'
vim.opt.wildmode = 'longest:full,full'

-- Relative line numbers when not in insert mode
vim.opt.number = true
vim.opt.relativenumber = true
do
  local augroup_id = vim.api.nvim_create_augroup("relnum", { clear = true })
  vim.api.nvim_create_autocmd("InsertEnter", {
    group = augroup_id,
    pattern = { "*" },
    callback = function(_)
      vim.opt_local.relativenumber = false
    end,
  })
  vim.api.nvim_create_autocmd("InsertLeave", {
    group = augroup_id,
    pattern = { "*" },
    callback = function(_)
      vim.opt_local.relativenumber = true
    end,
  })
end

-- Disable line numbers and signcolumn in terminal
do
  local augroup_id = vim.api.nvim_create_augroup("termsetup", { clear = true })
  vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup_id,
    pattern = { "*" },
    callback = function(_)
      vim.opt_local.number = false
      vim.opt_local.signcolumn = 'no'
    end,
  })
end

-- Fix cursor when leaving neovim
do
  local augroup_id = vim.api.nvim_create_augroup("cursorfix", { clear = true })
  vim.api.nvim_create_autocmd({ 'VimLeave', 'VimSuspend' }, {
    group = augroup_id,
    pattern = { "*" },
    callback = function(_)
      vim.opt.guicursor = 'a:ver25'
    end,
  })
end

-- Auto-create non-existent directories
do
  local augroup_id = vim.api.nvim_create_augroup("autocreatedir", { clear = true })
  vim.api.nvim_create_autocmd({ 'BufWritePre', 'FilterWritePre' }, {
    group = augroup_id,
    pattern = { "*" },
    -- From https://raw.githubusercontent.com/jghauser/mkdir.nvim/034c04ff1efb98aa6e4017b23846c4ad9c5313ab/lua/mkdir.lua
    callback = function(_)
      local dir = vim.fn.expand('<afile>:p:h')
      if dir:find('%l+://') == 0 and vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
    end,
  })
end

-- netrw options
vim.g.netrw_altfile = 1 -- Don't use netrw as alt buffer
vim.g.netrw_fastbrowse = 0 -- Always reload files from directory

-- Mappings
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Diagnostics
do
  local opts = { float = false }
  vim.keymap.set('n', '<leader>d', function() vim.diagnostic.goto_next(opts) end)
  vim.keymap.set('n', '<leader>D', function() vim.diagnostic.goto_prev(opts) end)
end

-- Clear HL
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>')
vim.keymap.set('', '<C-l>', '<cmd>noh<cr>')

-- Disable arrow keys
vim.keymap.set('', '<up>', '<nop>')
vim.keymap.set('', '<down>', '<nop>')
vim.keymap.set('', '<left>', '<nop>')
vim.keymap.set('', '<right>', '<nop>')

-- Line traversal that respects visual folds
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

-- Buffer navigation
vim.keymap.set('', '<Tab>', '<cmd>b#<cr>')
vim.keymap.set('', '<C-i>', '<C-i>') -- fix jump navigation, if CSI u supported

vim.keymap.set('', '<A-]>', '<cmd>bnext<cr>')
vim.keymap.set('', '<A-[>', '<cmd>bprev<cr>')
vim.keymap.set('', '<leader>b', '<cmd>ls<cr>:b<space>')

-- Split navigation
vim.keymap.set('', '<A-h>', '<C-w><C-h>')
vim.keymap.set('', '<A-j>', '<C-w><C-j>')
vim.keymap.set('', '<A-k>', '<C-w><C-k>')
vim.keymap.set('', '<A-l>', '<C-w><C-l>')

-- Save & Exit
vim.keymap.set('', '<leader>w', '<cmd>w<cr>')
vim.keymap.set('', 'zz', '<cmd>wqall<cr>')
vim.keymap.set('', 'zx', '<cmd>qall!<cr>')
