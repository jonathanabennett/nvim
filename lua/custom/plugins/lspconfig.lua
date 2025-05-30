return {

  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    { 'mason-org/mason.nvim', opts = {} }, -- NOTE: Must be loaded before dependents
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    'barreiroleo/ltex-extra.nvim',
    -- Useful status updates for LSP.
    -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by nvim-cmp
    'saghen/blink.cmp',
  },
  config = function()
    -- Brief aside: **What is LSP?**
    --
    -- LSP is an initialism you've probably heard, but might not understand what it is.
    --
    -- LSP stands for Language Server Protocol. It's a protocol that helps editors
    -- and language tooling communicate in a standardized fashion.
    --
    -- In general, you have a "server" which is some tool built to understand a particular
    -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
    -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
    -- processes that communicate with some "client" - in this case, Neovim!
    --
    -- LSP provides Neovim with features like:
    --  - Go to definition
    --  - Find references
    --  - Autocompletion
    --  - Symbol Search
    --  - and more!
    --
    -- Thus, Language Servers are external tools that must be installed separately from
    -- Neovim. This is where `mason` and related plugins come into play.
    --
    -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
    -- and elegantly composed help section, `:help lsp-vs-treesitter`

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- Enable the following language servers
    --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
    --
    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      clojure_lsp = {
        capabilities = capabilities,
      },
      docker_compose_language_service = {
        capabilities = capabilities,
      },
      dockerls = {
        capabilities = capabilities,
      },
      html = {
        capabilities = capabilities,
      },
      jdtls = {
        capabilities = capabilities,
      },
      eslint = {
        capabilities = capabilities,
      },
      jsonls = {
        capabilities = capabilities,
      },
      cssls = {
        capabilities = capabilities,
      },
      marksman = {
        capabilities = capabilities,
      },
      rnix = {
        capabilities = capabilities,
      },
      pylsp = {
        capabilities = capabilities,
      },
      sqlls = {
        capabilities = capabilities,
      },
      taplo = {
        capabilities = capabilities,
      },
      vimls = {
        capabilities = capabilities,
      },
      yamlls = {
        capabilities = capabilities,
      },
      bashls = {
        capabilities = capabilities,
      },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'clj-kondo',
      'cljfmt',
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- TODO: Update whole Mason config to match Kickstart. It's currently too confused.
    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_enable = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for tsserver)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
        ['ltex'] = function()
          require('lspconfig').ltex.setup {
            filetypes = { 'gitcommit', 'markdown', 'org', 'text' },
            autostart = false,
            on_attach = function(client, bufnr)
              require('ltex_extra').setup {
                load_langs = { 'en' },
                path = vim.fn.expand '~' .. '/.local/share/ltex',
              }
            end,
            settings = {
              ltex = {
                language = 'en',
              },
            },
          }
        end,
      },
    }
  end,
}
