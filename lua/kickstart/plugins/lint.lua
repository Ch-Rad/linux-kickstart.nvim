return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      require('lint').debug = true

      local function project_root()
        local markers = { 'CMakeLists.txt', 'compile_commands.json', '.git' }
        local path = vim.api.nvim_buf_get_name(0)
        local found = vim.fs.find(markers, { upward = true, path = path })[1]
        if not found then
          return nil
        end
        return vim.fs.dirname(found)
      end

      local root = project_root()

      lint.linters.cppcheck = {
        cmd = 'cppcheck',
        stdin = false,
        args = {
          '--enable=warning,style,performance,information',
          -- '--project=build/compile_commands.json',
          '--language=c++',
          -- function()
          --   if vim.fn.isdirectory 'build' == 1 then
          --     return '--cppcheck-build-dir=build'
          --   else
          --     return ''
          --   end
          -- end,
          -- function()
          --   if vim.fn.isdirectory 'build' == 1 then
          --     return '--project=build/compile_commands.json'
          --   else
          --     return ''
          --   end
          -- end,
          '--force',
          '--template={file}:{line}:{column}: [{id}] {severity}: {message}',
          '--quiet',
          '--template=gcc',
        },
        cwd = root,
        stream = 'stderr',
        ignore_exitcode = true,
        parser = require('lint.parser').from_errorformat('%f:%l:%c: %t%*[^:]: %m', { source = 'cppcheck' }),
      }

      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        c = { 'cppcheck' },
        cpp = { 'cppcheck' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
