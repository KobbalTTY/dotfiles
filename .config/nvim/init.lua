vim.o.ignorecase = true

vim.o.number         = true
vim.o.relativenumber = true

vim.o.wrap          = false
vim.o.swapfile      = false
vim.o.winborder     = "rounded"
vim.o.signcolumn    = "yes"
vim.o.colorcolumn   = "80"
vim.o.winborder     = "rounded"
vim.o.showtabline   = 0
vim.o.scrolloff     = 8
vim.o.sidescrolloff = 8

vim.opt.tabstop     = 2
vim.opt.expandtab   = true
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

vim.pack.add({
  { src = "https://github.com/nvim-mini/mini.nvim" },
  { src = "https://github.com/monkoose/neocodeium" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/NStefan002/screenkey.nvim" },

  { src = "https://codeberg.org/mfussenegger/nvim-fzy" },

  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/glottologist/keylog.nvim" },
})

require "mini.pairs".setup()
require "mini.comment".setup()
require "mini.bufremove".setup()
require "mini.completion".setup()
require "mini.trailspace".setup()
require('mini.hipatterns').setup({
  highlighters = {
    url = {
      pattern = 'https?://[%w-_%.%?%.:/%+=&#]+',
      group = 'Special',
    },
  },
})

require "mini.jump2d".setup({
  spotter = require "mini.jump2d".builtin_opts.word_start.spotter,
  labels = 'nrtshaeibldwfouj', -- easy spots for graphite layout
})

require "toggleterm".setup()
require "screenkey".setup()
require "keylog".setup()

require "nvim-treesitter.configs".setup {
  ensure_installed = {
    "html", "css", "javascript", "typescript", "tsx", "json", "vue", "svelte",
    "scss", "bash", "fish", "make", "dockerfile", "yaml", "toml", "markdown",
    "markdown_inline", "gitcommit", "gitattributes", "gitignore", "c", "cpp",
    "cuda", "objc", "cmake", "python", "ruby", "perl", "lua", "rust", "go",
    "dart", "java", "kotlin", "scala", "groovy", "php", "twig", "blade",
    "haskell", "elm", "elixir", "erlang", "ocaml", "fsharp", "ocamllex",
    "racket", "json5", "toml", "yaml", "sql", "graphql", "regex", "lua", "vim",
    "vimdoc", "norg", "markdown", "markdown_inline", "query", "c_sharp",
    "julia", "nim", "zig", "hcl", "r", "swift", "powershell", "elvish",
    "pascal", "fortran", "matlab", "vala"
  },
  highlight = { enable = true },
  indent = { enable = true }
}

NeoCodeium = require "neocodeium"
NeoCodeium.setup()

yazi = require "yazi"
yazi.setup({
  open_for_directories = true,
})
vim.g.loaded_netrw = 1

fzy = require "fzy"

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function(ev)
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if path ~= "" and vim.fn.isdirectory(path) == 1 then
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          vim.api.nvim_buf_delete(ev.buf, { force = true })
          require("yazi").yazi(nil, path)
        end
      end)
    end
  end,
})

function map(modes, key, func)
  vim.keymap.set(modes, key, func, { silent = true })
end

map('n', 'gt', vim.cmd.bnext)
map('n', 'gT', vim.cmd.bprevious)
map('i', '<C-a>', NeoCodeium.accept)
map({'n', 'v'}, '<leader>y', '"+y')
map({'n', 'v'}, '<leader>p', '"+p')
map('n', '<leader>w', vim.cmd.update)
map('n', '<leader>d', function() vim.cmd("lua MiniBufremove.delete()") end)
map('n', '<leader>a', function() vim.cmd("NeoCodeium toggle") end)
map('n', '<leader>s', function() vim.cmd("Screenkey toggle") end)
map('n', '<leader>f', function() vim.cmd("Yazi") end)
map('n', '<leader>r', function() vim.cmd("source $MYVIMRC") end)
map('n', '<leader>h', function() print(vim.inspect(vim.treesitter.get_captures_at_cursor(0))) end)
map('n', '<leader>nc', function() fzy.execute('fd', fzy.sinks.edit_file) end)
map('n', '<leader>nm', function() fzy.execute('cd ~/ && fd', fzy.sinks.edit_file) end)
map('n', '<leader>nh', function() fzy.execute("cd /hub/ && fd", fzy.sinks.edit_file) end)

-- map('n', '<leader>t', function() vim.cmd("ToggleTerm direction=vertical size=80") end)
-- map('t', '<C-t>', '<C-\\><C-n>')

local saturation = 30
local light      = 70
local hsl_to_hex = dofile("/hub/include/lua/hsl-to-hex.lua")
require('mini.base16').setup({
  palette = {
    base00 = hsl_to_hex(0,   0, 0),  -- background
    base01 = hsl_to_hex(0,   0, 0),  -- dark grey
    base02 = hsl_to_hex(0,   0, 20), -- grey
    base03 = hsl_to_hex(0,   0, 30), -- light grey
    base04 = hsl_to_hex(0,   0, light), -- fg low contrast
    base05 = hsl_to_hex(0,   0, light), -- fg
    base06 = hsl_to_hex(50,  saturation, light), -- yellow
    base07 = hsl_to_hex(50,  saturation, light), -- bright yellow / bright fg
    base08 = hsl_to_hex(0,   saturation, light), -- red
    base09 = hsl_to_hex(30,  saturation, light), -- orange
    base0A = hsl_to_hex(60,  saturation, light), -- yellow
    base0B = hsl_to_hex(120, saturation, light), -- green
    base0C = hsl_to_hex(180, saturation, light), -- cyan / aqua
    base0D = hsl_to_hex(220, saturation, light), -- blue
    base0E = hsl_to_hex(280, saturation, light), -- purple
    base0F = hsl_to_hex(10,  saturation, light), -- brown / muted red
  }
})

vim.cmd [[
  highlight StatusLine  guibg=#101010
  highlight ColorColumn guibg=#101010
]]

vim.cmd [[
  autocmd FileType help wincmd L
  autocmd FileType man  wincmd L
]]

local restraints = true
if restraints then
  vim.opt.mouse = ""
  vim.keymap.set({'n', 'i', 'v'}, '<Up>',    '<nop>', { silent = true })
  vim.keymap.set({'n', 'i', 'v'}, '<Down>',  '<nop>', { silent = true })
  vim.keymap.set({'n', 'i', 'v'}, '<Left>',  '<nop>', { silent = true })
  vim.keymap.set({'n', 'i', 'v'}, '<Right>', '<nop>', { silent = true })
end

local kanata_hl = true
if kanata_hl then
  vim.api.nvim_set_hl(0, "NoOp", { fg = "#707070" })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.kbd",
    callback = function()
      vim.cmd([[
        syn match NoOp "\v(_|XX|✗|∅|•|nop[0-9])"
        syn match Delimiter "[()]"
        hi link Delimiter Delimiter
      ]])
    end,
  })
end

local enable_lsp = true
if enable_lsp then
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if client:supports_method('textDocument/completion') then
        vim.lsp.completion.enable(true, client.id, ev.buf,
        { autotrigger = true })
      end
    end,
  }); vim.cmd("set completeopt=menu,menuone,noselect")
  vim.lsp.enable({
    "ts_ls", "eslint", "html", "cssls",
  })
end

-- the builtin terminal doesnt have the right bg without this
if vim.g._config_reloaded ~= true then
    vim.g._config_reloaded = true
    dofile(vim.env.MYVIMRC)
end
