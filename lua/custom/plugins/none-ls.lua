return {
  'nvimtools/none-ls.nvim',
  config = function()
    local null_ls = require 'null-ls'
    null_ls.setup {
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.clj_kondo,
        null_ls.builtins.diagnostics.textlint,
        null_ls.builtins.diagnostics.textidote,
        null_ls.builtins.formatting.cljstyle,
      },
    }
    vim.keymap.set('n', '<leader>gf', vim.lsp.buf.format, {})
  end,
}