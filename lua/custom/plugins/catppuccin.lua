return {
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'catppuccin/nvim',
  lazy = false,
  priority = 1000,
  init = function()
    require('catppuccin').setup { transparent_background = true }
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

    --   -- You can configure highlights by doing something like:
    --   vim.cmd [[
    --     highlight Normal guibg=none
    --     highlight NeoTreeNormal guibg=none
    --     highlight NormalNC guibg=none
    --     highlight NeoTreeNormalNC guibg=none
    --     highlight NonText guibg=none
    --     highlight Normal ctermbg=none
    --     highlight NeoTreeNormal ctermbg=none
    --     highlight NormalNC guibg=none
    --     highlight NormalNC ctermbg=none
    --     highlight NeoTreeNormalNC ctermbg=none
    --     highlight NonText ctermbg=none
    --     highlight Comment gui=none
    --
    --   ]]
  end,
}
