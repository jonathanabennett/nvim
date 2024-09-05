return {
  'goolord/alpha-nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.startify'
    dashboard.file_icons.provider = 'devicons'

    alpha.setup(dashboard.config)
  end,
}
