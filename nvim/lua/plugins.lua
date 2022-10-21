require('packer').startup(function() 
  use 'wbthomason/packer.nvim'
  use {
  'nvim-telescope/telescope.nvim', tag = '0.1.0',
    -- or                            , branch = '0.1.x',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'onsails/lspkind-nvim'

  use 'hrsh7th/cmp-buffer' -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp' -- Completion
  use 'neovim/nvim-lspconfig' -- LSP
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

  use 'glepnir/lspsaga.nvim'
  
  use 'kyazdani42/nvim-web-devicons'
  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'
  use 'norcalli/nvim-colorizer.lua'

  use {"akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end}

  use 'navarasu/onedark.nvim'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = function() require('nvim-treesitter.install').update({with_sync = true}) end
  }

  use {
    'junegunn/fzf', run = './install --bin'
  }

  use {
    'ibhagwan/fzf-lua'
  }

  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'kyazdani42/nvim-web-devicons'}
end)


-- toggleterm
require('toggleterm').setup({
  open_mapping = [[<c-\>]],
  hide_numbers = true,
  shell = vim.o.shell,
  direction = 'float',
  shading_factor = 2,
  float_opts = {
    border = 'curved',
    winblend = 0,
    highlights = {
      border = 'Normal',
      background = 'Normal'
    },
    height = 40,
    width = 100
  },
})

-- onedark
require('onedark').setup{
  style = 'darker'
}

require('onedark').load()

-- nvim-colorizer
require('colorizer').setup()

-- autotag
require('nvim-ts-autotag').setup()

-- nvim-autopairs
require('nvim-autopairs').setup{}

-- lualine
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'palenight',
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 0 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = {
      { 'diagnostics', sources = { "nvim_diagnostic" }, symbols = { error = ' ', warn = ' ', info = ' ',
        hint = ' ' } },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { {
      'filename',
      file_status = true, -- displays file status (readonly status, modified status)
      path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
    } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = { 'fugitive' }
}

-- cmp
require'cmp'.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = require('cmp').mapping.preset.insert({
    ['<C-d>'] = require('cmp').mapping.scroll_docs(-4),
    ['<C-f>'] = require('cmp').mapping.scroll_docs(4),
    ['<C-Space>'] = require('cmp').mapping.complete(),
    ['<C-e>'] = require('cmp').mapping.close(),
    ['<CR>'] = require('cmp').mapping.confirm({
      behavior = require('cmp').ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  },
  formatting = {
    format = require('lspkind').cmp_format({ with_text = false, maxwidth = 50 })
  }
}


vim.cmd [[
  set completeopt=menuone,noinsert,noselect
  highlight! default link CmpItemKind CmpItemMenuDefault
]]


-- mason setup
require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true
})

-- nvim-cmp
-- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })
  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    "tsx",
    "json",
    "yaml",
    "css",
    "html",
    "lua",
    "scss",
    "typescript",
    "javascript"
  },
  autotag = {
    enable = true,
  },
}

require('lspkind').init({
  -- enables text annotations
  --
  -- default: true
  mode = 'symbol',

  -- default symbol map
  -- can be either 'default' (requires nerd-fonts font) or
  -- 'codicons' for codicon preset (requires vscode-codicons font)
  --
  -- default: 'default'
  preset = 'codicons',

  -- override preset symbols
  --
  -- default: {}
  symbol_map = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "ﰠ",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "塞",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "פּ",
    Event = "",
    Operator = "",
    TypeParameter = ""
  },
})

-- bufferline

require("bufferline").setup({
  options = {
    mode = "tabs",
    separator_style = 'slant',
    always_show_bufferline = false,
    show_buffer_close_icons = false,
    show_close_icon = false,
    color_icons = true
  },
  highlights = {
    separator = {
      fg = '#073642',
      bg = '#002b36',
    },
    separator_selected = {
      fg = '#073642',
    },
    background = {
      fg = '#657b83',
      bg = '#002b36'
    },
    buffer_selected = {
      fg = '#fdf6e3',
      bold = true,
    },
    fill = {
      bg = '#073642'
    }
  },

})


-- icons


require('nvim-web-devicons').setup {
  -- your personnal icons can go here (to override)
  -- DevIcon will be appended to `name`
  override = {
  },
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true
}

