return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.dirman'] = {
          config = {
            workspaces = {
              test = '~/src/test-neorg',
            },
          },
        },
      },
    }

    vim.wo.foldlevel = 99
    vim.wo.conceallevel = 2
  end,
}
