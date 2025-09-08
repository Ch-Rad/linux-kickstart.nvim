-- Keymap: <leader>t to toggle terminal in 15-line horizontal split at the bottom
vim.keymap.set('n', '<leader>t', function()
  local term_buf = nil
  local term_win = nil

  -- Find an existing terminal buffer (if any)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == 'terminal' then
      term_buf = buf
      -- Check if it's currently visible in a window
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        if vim.api.nvim_win_get_buf(win) == buf then
          term_win = win
          break
        end
      end
      break
    end
  end

  if term_buf and term_win then
    -- Terminal is visible → close its window
    vim.api.nvim_win_close(term_win, true)
  elseif term_buf and not term_win then
    -- Terminal exists but is hidden → reopen it in a 15-line horizontal split at the bottom
    vim.cmd 'botright 15split'
    vim.api.nvim_set_current_buf(term_buf)
  else
    -- No terminal exists → create new one in 15-line horizontal split at the bottom
    vim.cmd 'botright 15split | terminal'
  end
end, { noremap = true, silent = true })

-- Map 'jk' in terminal mode to exit back to normal mode
vim.keymap.set('t', 'jk', [[<C-\><C-n>]], { noremap = true, silent = true })
