-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- NOTE: General Keymaps outside of leader

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>')
-- No-op for Q to avoid getting stuck in Command mode
vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader>n', ':Neotree filesystem reveal left<CR>')
-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--

-- NOTE: Keymaps with Direct Access from leader

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- This keybinding deletes what's selected and pastes while preserving the yank register.
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Delete preserving yank' })
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = 'Toggle Undotree' })

do -- Telescope direct access binds
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find Files' })
end

-- NOTE: Leader b Maps
-- Commands with buffers

vim.keymap.set('n', '<leader>bs', '<cmd>Scratch<cr>', { desc = 'Scratch Buffer' })
vim.keymap.set('n', '<leader>bS', '<cmd>ScratchSplit<cr>', { desc = 'Scratch Buffer (Split)' })

do -- Telescope buffer binds
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = 'Find existing buffers' })
end

-- NOTE: LEADER c Maps

vim.keymap.set('n', '<leader>cf', ":lua require('conform').format { async = true, lsp_format = 'fallback' }<cr>", { desc = 'Conform file' })
vim.keymap.set('n', '<leader>cps', ":lua require('minty.shades').open()<cr>", { desc = 'Minty Shades color picker.' })
vim.keymap.set('n', '<leader>cph', ":lua require('minty.huefy').open()<cr>", { desc = 'Minty Hue color picker.' })
vim.keymap.set('n', '<leader>cn', vim.lsp.buf.format, { desc = 'Run linter/formatter' })

vim.keymap.set('n', '<leader>cTt', ':TestNearest<CR>', { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>cTT', ':TestFile<CR>', { desc = 'Test file' })
vim.keymap.set('n', '<leader>cTa', ':TestSuite<CR>', { desc = 'Test suite' })
vim.keymap.set('n', '<leader>cTl', ':TestLast<CR>', { desc = 'Run last test' })
vim.keymap.set('n', '<leader>cTg', ':TestVisit<CR>', { desc = 'Visit relevant test' })

-- NOTE: LspAttach Keybindings
-- These keybinds are set every time an Lsp attaches to a buffer.

-- NOTE: Leader f binds
-- File operations

do -- Telescope File search binds
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
end

-- NOTE: Leader g
-- Github actions

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        return ']c'
      end
      vim.schedule(function()
        gs.next_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    map('n', '[c', function()
      if vim.wo.diff then
        return '[c'
      end
      vim.schedule(function()
        gs.prev_hunk()
      end)
      return '<Ignore>'
    end, { expr = true })

    -- Actions
    map('n', '<leader>gs', gs.stage_hunk, { desc = 'Stage hunk' })
    map('n', '<leader>gr', gs.reset_hunk, { desc = 'Reset hunk' })
    map('v', '<leader>gs', function()
      gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Stage line' })
    map('v', '<leader>gr', function()
      gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    end, { desc = 'Reset line' })
    map('n', '<leader>gS', gs.stage_buffer, { desc = 'Stage buffer' })
    map('n', '<leader>gu', gs.undo_stage_hunk, { desc = 'Undo Stage hunk' })
    map('n', '<leader>gR', gs.reset_buffer, { desc = 'Reset buffer' })
    map('n', '<leader>gp', gs.preview_hunk, { desc = 'Preview hunk' })
    map('n', '<leader>gb', function()
      gs.blame_line { full = true }
    end, { desc = 'Blame Line' })
    map('n', '<leader>gb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
    map('n', '<leader>gd', gs.diffthis, { desc = 'Diff this' })
    map('n', '<leader>gD', function()
      gs.diffthis '~'
    end, { desc = 'Diff this' })
    map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end,
}

-- NOTE: Leader h remaps
-- Harpoon and navigation

do --Harpoon maps
  local harpoon = require 'harpoon'
  local conf = require('telescope.config').values

  local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
      table.insert(file_paths, item.value)
    end

    require('telescope.pickers')
      .new({}, {
        prompt_title = 'Harpoon',
        finder = require('telescope.finders').new_table {
          results = file_paths,
        },
        previewer = conf.file_previewer {},
        sorter = conf.generic_sorter {},
      })
      :find()
  end

  vim.keymap.set('n', '<leader>ha', function()
    harpoon:list():add()
  end, { desc = '[A]dd to Harpoon list' })
  vim.keymap.set('n', '<leader>ht', function()
    toggle_telescope(harpoon:list())
  end, { desc = '[T]elescope Harpoon' })
  vim.keymap.set('n', '<leader>hd', function()
    harpoon:list():remove(1)
  end, { desc = '[D]elete a harpoon' })
  vim.keymap.set('n', '<leader>h1', function()
    harpoon:list():select(1)
  end, { desc = '[1]st harpoon' })
  vim.keymap.set('n', '<leader>h2', function()
    harpoon:list():select(2)
  end, { desc = '[2]nd harpoon' })
  vim.keymap.set('n', '<leader>h3', function()
    harpoon:list():select(3)
  end, { desc = '[3]rd harpoon' })
  vim.keymap.set('n', '<leader>h4', function()
    harpoon:list():select(4)
  end, { desc = '[4]th harpoon' })
end

-- NOTE: Leader s remaps
-- Text Searching

do -- Telescope text search binds
  local builtin = require 'telescope.builtin'

  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
end

-- NOTE: Leader p remaps
-- Project based binds

do --Telescope project binds
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>pf', builtin.git_files, { desc = '[P]roject git [F]iles' })
end
