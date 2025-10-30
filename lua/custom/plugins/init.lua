-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  -- {
  --   'akinsho/toggleterm.nvim',
  --   version = 'v1.*',
  --   opts = {},
  --   config = function()
  --     require('toggleterm').setup {}
  --   end,
  -- },
  -- {
  --   'vidocqh/data-viewer.nvim',
  --   opts = {},
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'kkharji/sqlite.lua', -- Optional, sqlite support
  --   },
  -- },
  {
    'rebelot/kanagawa.nvim',
    config = function()
      require('kanagawa').load 'dragon'
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    {
      'mikavilpas/yazi.nvim',
      event = 'VeryLazy',
      dependencies = {
        -- check the installation instructions at
        -- https://github.com/folke/snacks.nvim
        'folke/snacks.nvim',
      },
      keys = {
        -- 👇 in this section, choose your own keymappings!
        {
          '<leader>-',
          mode = { 'n', 'v' },
          '<cmd>Yazi<cr>',
          desc = 'Open yazi at the current file',
        },
        {
          -- Open in the current working directory
          '<leader>cw',
          '<cmd>Yazi cwd<cr>',
          desc = "Open the file manager in nvim's working directory",
        },
        {
          '<c-up>',
          '<cmd>Yazi toggle<cr>',
          desc = 'Resume the last yazi session',
        },
      },
      ---@type YaziConfig | {}
      opts = {
        -- if you want to open yazi instead of netrw, see below for more info
        open_for_directories = false,
        keymaps = {
          show_help = '<f1>',
        },
      },
      -- 👇 if you use `open_for_directories=true`, this is recommended
      init = function()
        -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
        -- vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
      end,
    },
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },
  -- using lazy.nvim
  {
    'S1M0N38/love2d.nvim',
    event = 'VeryLazy',
    version = '2.*',
    opts = {
      path_to_love_bin = 'C:/Program Files/LOVE/love.exe',
    },
    keys = {
      { '<leader>v', ft = 'lua', desc = 'LÖVE' },
      { '<leader>vv', '<cmd>LoveRun<cr>', ft = 'lua', desc = 'Run LÖVE' },
      { '<leader>vs', '<cmd>LoveStop<cr>', ft = 'lua', desc = 'Stop LÖVE' },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      require('mason').setup()
      require('mason-lspconfig').setup {
        -- List of servers to ensure installed by Mason
        ensure_installed = { 'clangd' },
        handlers = {
          -- Default handler for all servers managed by mason-lspconfig
          function(server_name)
            require('lspconfig')[server_name].setup {}
          end,
          -- Specific configuration for clangd
          clangd = function()
            require('lspconfig').clangd.setup {
              init_options = {
                fallbackFlags = {
                  '-std=c++23',
                },
              },
              -- You can add specific clangd options here
              -- For example, to specify compilation database location:
              -- root_dir = require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt"),
              capabilities = require('cmp_nvim_lsp').default_capabilities(),
              -- Additional settings for clangd
              settings = {
                -- Example: to include system headers
                clangd = {
                  arguments = {
                    '--query-driver=/usr/bin/gcc', -- Or your specific compiler
                  },
                },
              },
            }
          end,
        },
      }
    end,
  },
}
