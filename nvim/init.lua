-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Leader key（lazy.nvim より前に設定）
vim.g.mapleader = " "

---------- 基本設定 ----------

vim.opt.encoding = "utf-8"
vim.opt.cursorline = true
vim.opt.virtualedit = "onemore"
vim.opt.wildmode = { "list:longest" }
vim.opt.wildmenu = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.history = 10000
vim.opt.belloff = "all"
vim.opt.mouse = "a"

-- 表示
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.laststatus = 2
vim.opt.ruler = true
vim.opt.list = true
vim.opt.listchars = { tab = "»-", trail = "-", nbsp = "%" }
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- インデント
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.autoindent = true
vim.opt.expandtab = true

-- ファイル
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.clipboard = "unnamedplus"

-- 検索
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true

---------- キーマップ ----------

local keymap = vim.keymap.set

-- 折り返し時に表示行単位で移動
keymap("n", "j", "gj", { silent = true })
keymap("n", "k", "gk", { silent = true })

-- jj で ESC
keymap("i", "jj", "<ESC>", { silent = true })

-- ESC 連打でハイライト解除
keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { silent = true })

---------- プラグイン ----------

require("lazy").setup({
  -- カラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = { theme = "tokyonight" },
    },
  },

  -- 末尾空白の可視化
  { "ntpeters/vim-niceblock" },
  {
    "echasnovski/mini.trailspace",
    config = function()
      require("mini.trailspace").setup()
    end,
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },

  -- 自動括弧補完
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Rainbow CSV
  { "mechatroner/rainbow_csv" },
})

---------- ftplugin ----------

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})
