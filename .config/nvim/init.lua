vim.o.autochdir = true

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
  { src = "https://github.com/chomosuke/typst-preview.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/lervag/vimtex" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
})

require "mini.ai".setup()
require "mini.align".setup()
require "mini.pairs".setup()
require "mini.comment".setup()
require "mini.bufremove".setup()
require "mini.completion".setup()
require "mini.trailspace".setup()
require "mini.files".setup({ mappings = { close = 't' } })
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

require "typst-preview".setup({
  port = 1984,
  -- invert_colors = 'always', -- stylus extension works better
  follow_cursor = true,
})


local NeoCodeium = require "neocodeium"
NeoCodeium.setup()

vim.g.vimtex_view_method = "zathura"
vim.g.vimtex_view_forward_search_on_start = false
vim.g.vimtex_compiler_latexmk = {
  aux_dir = "/home/azalea/.cache/vimtex/aux/",
  out_dir = "/home/azalea/.cache/vimtex/out/",
}

function map(modes, key, func)
  vim.keymap.set(modes, key, func, { silent = true })
end

-- uncategorized
map({'i'}, '<C-z>', "<ESC>ZZ")
map({'i'}, '<C-b>', NeoCodeium.accept)

-- fast access
map({'n'}, '<leader>d', function() vim.cmd("lua MiniBufremove.delete()") end)
map({'n'}, '<leader>q', function() vim.cmd("q") end)
map({'n'}, '<leader>w', vim.cmd.update)
map({'n'}, 'gT', vim.cmd.bprevious)
map({'n'}, 'gt', vim.cmd.bnext)
map({'t'}, '<C-s>', '<C-\\><C-n>')
map({'n', 'v'}, '<leader>y', '"+y')
map({'n', 'v'}, '<leader>p', '"+p')
map({'n', 'v'}, 'n', ":norm ")

-- mnemonically coded
map({'n'}, '<leader>lf', vim.lsp.buf.format)
map({'n'}, '<leader>tl', function() vim.cmd("set list!") end)
map({'n'}, '<leader>tn', function() vim.cmd("NeoCodeium toggle") end)
map({'n'}, '<leader>tt', function() vim.cmd("TypstPreviewToggle") end)
map({'n'}, '<leader>tv', function() vim.cmd(":ToggleTerm direction=vertical size=80") end)
map({'n'}, '<leader>vr', function() vim.cmd("source $MYVIMRC") end)
map({'n'}, '<leader>fc', function() vim.cmd("lua MiniFiles.open()") end)
map({'n'}, '<leader>fp', function() vim.cmd("lua MiniFiles.open('~/personal/')") end)
map({'n'}, '<leader>fn', function() vim.cmd("lua MiniFiles.open('~/personal/notes/')") end)
map({'n'}, '<leader>fd', function() vim.cmd("lua MiniFiles.open('~/dotfiles/')") end)

-- evergreen with pitch black bg
require('mini.base16').setup({
  palette = {
    base00 = "#000000", -- background
    base01 = "#000000", -- grey0
    base02 = "#303030", -- grey1
    base03 = "#909090", -- grey2
    base04 = "#d3c6aa", -- fg
    base05 = "#d3c6aa", -- fg
    base06 = "#dbbc7f", -- yellow
    base07 = "#ffffff", -- brightfg
    base08 = "#e67e80", -- red
    base09 = "#e69875", -- orange
    base0A = "#dbbc7f", -- yellow
    base0B = "#a7c080", -- green
    base0C = "#83c092", -- aqua
    base0D = "#7fbbb3", -- blue
    base0E = "#d699b6", -- purple
    base0F = "#e67e80", -- red
  }
})

vim.cmd [[
  highlight StatusLine   guibg=#101010
  highlight ColorColumn  guibg=#101010
]]

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

local disable_mouse = true
if disable_mouse then
  vim.opt.mouse = ""
  for _, key in ipairs({ '<up>', '<down>', '<left>', '<right>' }) do
    vim.keymap.set({'n','i'}, key, '<nop>', { silent = true })
  end
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
