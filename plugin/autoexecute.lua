-- Function to open/reuse a horizontal terminal and run the current file
local function run_file_in_terminal()
  -- Save file path before switching buffers
  local file = vim.fn.expand '%:p'
  if file == '' then
    print 'No file to run'
    return
  end
  -- Save the file before running
  vim.cmd 'write'

  -- Detect file extension and base name
  local ext = vim.fn.expand '%:e'
  local filename_no_ext = vim.fn.expand '%:t:r' -- file name without extension
  local file_dir = vim.fn.expand '%:p:h' -- directory of current file

  -- Map file extensions to run commands
  local commands = {
    py = 'python3',
    lua = 'lua5.1',
    js = 'node',
    ts = 'ts-node',
    sh = 'bash',
    cpp = 'g++ "' .. file .. '" -o /tmp/a.out && /tmp/a.out',
    c = 'gcc "' .. file .. '" -o /tmp/a.out && /tmp/a.out',
    go = 'go run',
    rb = 'ruby',
    php = 'php',
  }

  -- Special case: Lua project with .busted file
  if ext == 'lua' and vim.fn.filereadable(vim.fn.getcwd() .. '/.busted') == 1 then
    local spec_file = file_dir .. '/' .. filename_no_ext .. '_spec.lua'
    if vim.fn.filereadable(spec_file) == 0 then
      print('Spec file not found: ' .. spec_file)
      return
    end
    commands.lua = 'C:/msys64/mingw64/bin/busted.bat "' .. spec_file .. '"'
  end

  local cmd = commands[ext]
  if not cmd then
    print('No run command configured for extension: ' .. ext)
    return
  end

  -- Append file path for normal cases if not already in command
  if not cmd:find(file, 1, true) and ext ~= 'cpp' and ext ~= 'c' and not cmd:find '_spec%.lua' then
    cmd = cmd .. ' "' .. file .. '"'
  end

  local term_bufnr = vim.g.runner_term_bufnr
  local term_winnr = nil

  -- Check if terminal buffer still exists
  if term_bufnr and vim.api.nvim_buf_is_valid(term_bufnr) and vim.bo[term_bufnr].buftype == 'terminal' then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_bufnr then
        term_winnr = win
        break
      end
    end
  else
    term_bufnr = nil
  end

  if term_bufnr and term_winnr then
    vim.api.nvim_set_current_win(term_winnr)
  elseif term_bufnr then
    vim.cmd 'belowright split'
    vim.api.nvim_set_current_buf(term_bufnr)
  else
    vim.cmd 'belowright split | terminal'
    term_bufnr = vim.api.nvim_get_current_buf()
    vim.g.runner_term_bufnr = term_bufnr
  end

  -- Send the run command to terminal
  vim.api.nvim_chan_send(vim.b.terminal_job_id, cmd .. '\r')
end

-- Map to <leader>r
vim.keymap.set('n', '<leader>r', run_file_in_terminal, { noremap = true, silent = true })
