return {

  -- Custom Keymaps

  -- Source Current File

  vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>', { desc = 'Sources Current File' }),

  -- Neo-tree maps
  vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Neotree' }),

  -- Powershell Terminal
  vim.keymap.set('n', '<leader>t', '<cmd>split (:sp)<CR><cmd>term<CR>', { desc = 'Open Terminal in current dir' }),

  -- Resizeing Buffers
  vim.keymap.set('n', '<leader>p', '<cmd>resize +5<CR>', { desc = 'Increase current window height by 10' }),
  vim.keymap.set('n', '<leader>m', '<cmd>resize -5<CR>', { desc = 'Decrease current window height by 10' }),
  vim.keymap.set('n', '<leader>vp', '<cmd>vertical resize +5<CR>', { desc = 'Increase current window height by 10' }),
  vim.keymap.set('n', '<leader>vm', '<cmd>vertical resize -5<CR>', { desc = 'Decrease current window height by 10' }),

  -- Buffer splitting
  vim.keymap.set('n', '<leader>sl', '<cmd>split<CR>', { desc = 'Create Horizontal Split' }),
  vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Create Vertical Split' }),
}
