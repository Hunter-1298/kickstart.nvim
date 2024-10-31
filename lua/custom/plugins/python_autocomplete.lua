-- .config/nvim/lua/custom/plugins/lsp_config.lua

return {
  -- Add nvim-cmp and its dependencies
  {
    'hrsh7th/nvim-cmp', -- Main completion plugin
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp
      'hrsh7th/cmp-buffer', -- Buffer source for nvim-cmp
      'hrsh7th/cmp-path', -- Path source for nvim-cmp
      'hrsh7th/cmp-cmdline', -- Command-line source for nvim-cmp
      'L3MON4D3/LuaSnip', -- Snippet engine
      'saadparwaiz1/cmp_luasnip', -- Snippet source for nvim-cmp
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept selected completion
        },
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- Snippets source
        }, {
          { name = 'buffer' },
        }),
      }

      -- Set up command-line completion
      cmp.setup.cmdline('/', {
        sources = {
          { name = 'buffer' },
        },
      })
      cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
          { name = 'path' },
        }, {
          { name = 'cmdline' },
        }),
      })
    end,
  },

  -- Add LSP config for pyright with nvim-cmp capabilities
  {
    'neovim/nvim-lspconfig',
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      require('lspconfig').pyright.setup {
        capabilities = capabilities,
      }
    end,
  },

  -- Optionally, if not already installed, add Mason to manage LSP servers
  {
    'williamboman/mason.nvim',
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        ensure_installed = { 'pyright' }, -- Automatically install pyright
      }
    end,
  },
}
