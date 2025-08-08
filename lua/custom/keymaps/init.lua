return {

  -- Custom Keymaps

  -- Source Current File

  vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>', { desc = 'Sources Current File' }),

  -- Neo-tree maps
  vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle Neotree' }),

  -- Powershell Terminal
  vim.keymap.set('n', '<leader>t', '<cmd>split (:sp)<CR><cmd>term<CR>', { desc = 'Open Terminal in current dir' }),

  -- Busted Lua Shortcut
  -- vim.keymap.set('n', '<leader>lb', function()
  --   vim.cmd('TermExec cmd="C:\\msys64\\mingw64\\bin\\busted.bat .\\' .. vim.fs.basename(vim.fn.expand '%:r') .. '_spec.lua"')
  -- end, { desc = 'Run tests for a lua project using buster (<file>_spec.lua should be in the same dir)' }),
}
