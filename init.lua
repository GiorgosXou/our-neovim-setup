-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- install those packages:
-- `sudo pacman -S ripgrep lazygit`

_G.IS_WINDOWS = vim.loop.os_uname().sysname:find "Windows" and true or false
_G.XKB_SWITCH = vim.fn.executable "xkb-switch" == 1

local plugins = {
  {"AstroNvim/AstroNvim", version = "^5", import = "astronvim.plugins" },
  {"AstroNvim/astrocore",
    opts = { -- Configure core features of AstroNvim
      on_keys = {
        auto_hlsearch = {
          function(char)
              if vim.fn.mode() == "n" and vim.fn.keytrans(char) == "<Esc>" then
                vim.cmd ":noh" -- Disable search highlights when 'Esc' is pressed in normal-mode
            end
          end,
      },},
      features = {
        diagnostics = { -- diagnostic mode
          virtual_text   = true,
          virtual_lines  = false
        },
        notifications    = true, -- enable notifications at start
        highlighturl     = true, -- highlight URLs at start
        autopairs        = true, -- enable autopairs at start
        cmp              = true, -- enable completion at start
        size             = 1024 * 100, -- max file size (or false to disable check)
        lines            = 10000, -- max number of lines (or false to disable check)
        line_length      = 1000,
      },
      options = { -- vim options can be configured here
        opt = { -- vim.opt.<key>
          signcolumn     = "auto:2", -- sets vim.opt.signcolumn to auto
          spell          = false   , -- sets vim.opt.spell
          wrap           = false   , -- sets vim.opt.wrap
          number         = true    , -- sets vim.opt.number
          relativenumber = true    , -- sets vim.opt.relativenumber
        },
        g = {
          VM_maps = {
            ['Find Under']      = '<C-n>'  ,
            ["Add Cursor Down"] = '<C-A-j>',
            ["Add Cursor Up"]   = '<C-A-k>',
          },
          SetUsLayout = function()
            _G.KLANG = string.sub(vim.api.nvim_call_function('system', {'xkb-switch'}),1,-2)
            vim.api.nvim_command('silent !xkb-switch -s us') -- yay -S xkb-switch
          end,

          ResetLayout = function()
            vim.api.nvim_command(('silent !xkb-switch -s %q'):format(_G.KLANG)) -- yay -S xkb-switch
          end,

          set_cursor_to_find = function(ref)
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            for line_number, ln in ipairs(lines) do
              local start_index, end_index = string.find(ln, ref)
              if start_index and end_index then
                vim.api.nvim_win_set_cursor(0, {line_number, start_index})
                break  -- Stop the loop because we found the search string
              end
            end
          end,

          go_to_markdown_ref = function()
            local cursor = vim.api.nvim_win_get_cursor(0)
            local line   = vim.api.nvim_buf_get_lines (0, cursor[1]-1, cursor[1] , false)[1]

            for match in string.gmatch(line, "%(([^'%)]+)") do
              local start_pos = string.find(line, match)
              local end_pos   = start_pos + string.len(match)
              local link      = ''
              if cursor[2] +1 >= start_pos and cursor[2] < end_pos then
                local rel_path = string.gsub(vim.api.nvim_buf_get_name(0), "(.+/)(.+)", "%1")
                vim.api.nvim_command(':edit ' .. rel_path .. string.match(match, "^([^#]*)"))
                vim.api.nvim_command("m\'")
                link = string.match(match,'#(.*)$')
                if link then
                  vim.api.nvim_command(":call set_cursor_to_find('" .. link .. "')") -- GOD PLEASE WHY
                end
              end
            end
          end,
  },},},},

  {"AstroNvim/astroui",
    opts = {
      colorscheme = "ayu-dark", -- change colorscheme
      icons = { -- Icons can be configured throughout the interface | configure the loading of the lsp in the status line
        LSPLoading1 = "⠋", LSPLoading2 = "⠙", LSPLoading3 = "⠹", LSPLoading4 = "⠸", LSPLoading5  = "⠼",
        LSPLoading6 = "⠴", LSPLoading7 = "⠦", LSPLoading8 = "⠧", LSPLoading9 = "⠇", LSPLoading10 = "⠏",
  },},},

  {"AstroNvim/astrocommunity",
    { import = "astrocommunity.color.transparent-nvim"},
    { import = "astrocommunity.pack.rust"},
    { import = "astrocommunity.pack.cpp"},
    { import = "astrocommunity.pack.lua"},
    { import = "astrocommunity.diagnostics.trouble-nvim"},
    { import = "astrocommunity.markdown-and-latex.render-markdown-nvim"},
    -- { import = "astrocommunity.color.modes-nvim"} -- interesting one
  },

  {"render-markdown.nvim", config = function() require("render-markdown").setup({
    heading = {
      signs = { '🭮▒' },
      icons = { '▒▒▓▓▓████ 󰲡 ', '▒▒▓▓▓ 󰲣 ', '▒▒ 󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' }, -- icons = { '▓██▓▒░ 󰲡 ', '▓▓▒░ 󰲣 ', '▒▒░ 󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
      left_pad = 0,
      left_margin = 0,
    },
    bullet = {
      icons = { '·', '•', '▪', '*', '⁕', '✦', '✺'},
    }
  }) end,},


  {"ray-x/lsp_signature.nvim", event = "BufRead", config = function() require("lsp_signature").setup(({hint_prefix='• '})) end,}, -- hints
  {"folke/snacks.nvim", opts = { dashboard = { preset = { header = table.concat({
    "             \\                                      [            ",
    "              @                 ⟡                  ╢             ",
    "      /       ╣▒                                  ]▒       \\     ",
    "     ╔       ]Ñ▒                                  ╟╣┐       ▓    ",
    "    ╢╣       ╣▓            √          t            ▓╣       ▓╣   ",
    "   ▓╣▒╖    ╓╫╜           ╥▓   ASTROν   ▓@           ╙▓╖    ╔╣╢║  ",
    "   ▓▓▓▓  ,p▓,,,,,,      ╜╙▓▄╖,      ,╓╥╜╙╙    ,,,,,,,,▓▓,  ▀▓▓╣U ",
    "   ▀▓Ö   ╙█▓▓▓▓▓▓╢╫╣▓▓▓▓▓╦, ▀▓▓╗  g╢▓╝ ,╓H╢╢╢╢╢╢▓▓▓▓▓▓▒▓╜   ]▓▓  ",
    '    ▓▓▓╦╥╖ ╙╙╙╙`     `""▀▓▓@ ▐█▓L]▓╫╛ Æ▒╨╜"       ""╙╙` ╓╖∩▒▒▓   ',
    ' ╒▓▒╜""╙▀▓▓                ▀  █▒Γ▐▓▓  ╩                ▓╢╜""╙▀█╫L',
    " ▐▌`      └╝                  ▓▒` █▓                  ╜       └█▓",
    "▐▓                            ▓▒  █╢                           ▐▓",
    ' ▐Γ                            ╛  ▐"                           ▐[',
    " ¬U                                                            jU",
    "  C                                                            j ",
    "   L                                                          ]  ",
  },"\n"),},},},},

  -- Colorschemes
  {"szorfein/darkest-space", lazy = true },
  {"navarasu/onedark.nvim" , lazy = true },
  {"nikolvs/vim-sunbather" , lazy = true },
  {"Mofiqul/vscode.nvim"   , lazy = true },
  {"nocksock/nazgul-vim"   , lazy = true },
  {"fcpg/vim-orbital"      , lazy = true },
  {"Koalhack/darcubox-nvim", lazy = true },

  -- LSP - DAP
  {"WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        -- install language servers
        "basedpyright", "marksman", "clangd", "texlab", --  "arduino-language-server"
        -- install debuggers
        "codelldb", "debugpy",
  },},},

  -- TS
  {"nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "python", "markdown", "markdown_inline", "arduino", "cpp", "c" }},},
  {"nvim-treesitter/nvim-treesitter-context", lazy = false }, -- top context-bar when scrolling

  {"akinsho/flutter-tools.nvim"             }, -- add lsp plugin
  {"chrisgrieser/nvim-various-textobjs"     },
  {"mcauley-penney/visual-whitespace.nvim"  , config = true},
  {"stevearc/vim-arduino"                   , lazy = false }, -- sudo pacman -S screen arduino-cli (and arduino?) | arduino-cli config init
  {"godlygeek/tabular"                      , lazy = false }, -- ALIGN <leader>a | https://stackoverflow.com/questions/5436715/how-do-i-align-like-this-with-vims-tabular-plugin
  {"svermeulen/vim-yoink"                   , lazy = false }, -- TERMUX https://github.com/GiorgosXou/our-neovim-setup/issues/2
  {"Shadowsith/vim-minify"                  , lazy = false }, -- TODO: It needs to be Checked 2023-03-24 06:29:23 PM
  {"m-pilia/vim-smarthome"                  , lazy = false },
  {"mg979/vim-visual-multi"                 , lazy = false },
  {"hiphish/rainbow-delimiters.nvim"        , lazy = false },
  {"vim-scripts/ReplaceWithRegister"        , lazy = false, config = function() vim.keymap.set('n', '<Space>r', '<Plug>ReplaceWithRegisterOperator', { desc = "Replace with register"}) end},
  {'iamcco/markdown-preview.nvim'           ,               config = function() vim.fn["mkdp#util#install"]() end , ft = { "markdown" }},
  {"rachartier/tiny-glimmer.nvim"           ,               config = function() require("tiny-glimmer").setup({
    overwrite = {
      paste = { enabled = false },
      undo  = { enabled = true   ,
        default_animation = {
          name = "fade",
          settings = {
            from_color   = "DiffDelete",
            max_duration = 1000,
            min_duration = 1000,
        },},
        undo_mapping = "u",
      },

      redo = { enabled = true,
        default_animation = {
          name = "fade",
          settings = {
            from_color = "DiffAdd",
            max_duration = 1000,
            min_duration = 1000,
        },},
        redo_mapping = "<c-r>",
      },
    },
    hijack_ft_disabled = {
      "neo-tree"
    }})
    end, event = "VeryLazy", priority = 10, -- Low priority to catch other plugins' keybindings
  },
  {'lewis6991/satellite.nvim'               ,               config = function() require("satellite" ).setup({
    current_only = false,
    winblend     = 40,
    zindex       = 50,
    width        = 2,
    excluded_filetypes = {},
    handlers = {
      cursor = { enable  = true,
        symbols = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻'},
      },
      search = { enable = true, },
      diagnostic = {
        enable = true,
        signs  = {
          error = { 'x', '=', 'Ξ' },
          warn  = { '▲', '=', 'Ξ' },
          info  = { 'i', '=', 'Ξ' },
          hint  = { '⋄', '=', 'Ξ' },
        },
        min_severity = vim.diagnostic.severity.HINT,
      },
      gitsigns = { enable = true,
        signs  = {
          add    = "│",
          change = "│",
          delete = "┆",
      },},
      marks = {
        enable        = true,
        show_builtins = false, -- shows the builtin marks like [ ] < >
        key           = 'm'
      },
      quickfix = {
        signs = { '-', '=', 'Ξ' },
      }
    },
  }) end},
  {'nat-418/boole.nvim'                     , lazy = false, config = function() require('boole'     ).setup({ -- https://www.reddit.com/r/neovim/comments/y2h9sq/new_plugin_boolenvim_toggle_booleans_cycle_days/
    mappings = {
      increment = '<C-a>',
      decrement = '<C-x>'
    },
    additions = {
      {'Foo', 'Bar'},
      {'tic', 'tac', 'toe'}
    },
    allow_caps_additions = {
      {'enable', 'disable'}
    }
  }) end},
  {'kylechui/nvim-surround'   , config = function() require("nvim-surround").setup() end, event = "VeryLazy", version = "*"},
  {'Shatur/neovim-ayu'        , config = function()  -- local utils = require "default_theme.utils"
    require('ayu').setup({                               -- don't forger :PackerCompile if it doesn't work
    overrides =  function()
      if vim.o.background == 'dark' then
        return {                 -- lua Snacks.picker.highlights()
          Type                       = {fg = '#FF5F00'},
          Macro                      = {fg = '#FF5F00'},
          Normal                     = {bg = '#000000'}, -- 'NONE'
          Repeat                     = {fg = '#FF5F00'},
          Method                     = {fg = '#FF5F00'},
          PreProc                    = {fg = '#FF5F00'},
          IncSearch                  = {fg = '#FF8F40', bg = '#22354a'},
          Include                    = {fg = '#FF5F00'},
          ["@property"]              = {fg = '#64BAAA'},
          ["@markup.link"]           = {fg = '#39bae6' , underline = true, sp = '#004182'}, -- #0400d1
          ["@markup.heading"]        = {fg = '#FFF000' , bold      = true},
          Keyword                    = {fg = '#FF5F00' , bold      = true},
          RenderMarkdownBullet       = {fg = '#64BAAA'},
          Exception                  = {fg = '#FF5F00'},
          Statement                  = {fg = '#FF5F00'},
          Constructor                = {fg = '#FF5F00'},
          FuncBuiltin                = {fg = '#FF5F00'},
          DapBreakpoint              = {fg = '#FF5F00'},
          DapLogPoint                = {fg = '#61afef'},
          DapStopped                 = {fg = '#98c379'},
          TypeDefinition             = {fg = '#FF5F00'},
          KeywordFunction            = {fg = '#FF5F00'},
          NotifyBackground           = {bg = '#000000'}, -- TODO: may need to be changed to snacks.nvim something
          IndentBlanklineContextChar = {fg = '#FF5F00'},
          LspReferenceRead           = {bg = '#626A73'},
          LspReferenceText           = {bg = '#626A73'},
          LspReferenceWrite          = {bg = '#626A73'},
          LineNr                     = {fg = '#626A73'},
          RenderMarkdownH1Bg         = {bg = '#3e2e2e'},
          RenderMarkdownH2Bg         = {bg = '#2e1e1e'},
          RenderMarkdownH3Bg         = {bg = '#1e0e0e'},
          RenderMarkdownH4Bg         = {bg = '#0e0e0e'},
          RenderMarkdownH5Bg         = {bg = '#0e0e0e'},
          RenderMarkdownH6Bg         = {bg = '#0e0e0e'},
          SatelliteBar               = {bg = "#454545"},
          SatelliteCursor            = {fg = "#626A73", default = true, },
          SatelliteMark              = {fg = "#626A73", default = true, },
          SnacksPickerDir            = {fg = "#626A73", default = true, },
          -- DiagnosticError =  utils.parse_diagnostic_style { fg = '#cc241d'},
          -- DiagnosticWarn  =  utils.parse_diagnostic_style { fg = '#ff8f40'},
          -- DiagnosticInfo  =  utils.parse_diagnostic_style { fg = '#39bae6'},
          -- DiagnosticHint  =  utils.parse_diagnostic_style { fg = '#95e6cb'},
          -- #FFC26B #860000 #64BAAA #006B5D #FF6A13 #FFB454 #FFF000 #FFE0F0 #Maybe?
        }
      else
        return {                 -- lua Snacks.picker.highlights()
          Type                       = {fg = '#FF5F00'},
          Macro                      = {fg = '#FF5F00'},
          Repeat                     = {fg = '#FF5F00'},
          Method                     = {fg = '#FF5F00'},
          PreProc                    = {fg = '#FF5F00'},
          IncSearch                  = {fg = '#FF8F40', bg = '#22354a'},
          Include                    = {fg = '#FF5F00'},
          Special                    = {fg = '#FF8742'}, -- #FFF999 #A1F011
          String                     = {fg = '#2cbf15'}, -- #FFF999 #A1F011
          ["@Function"]              = {fg = '#bf5915'}, -- '#7d3200'},
          ["@variable"]              = {fg = '#717272'}, -- '#39bae6'},
          ["@property"]              = {fg = '#FF5F00'},
          ["@lsp.type.parameter"]    = {fg = '#7d3200'}, -- #8a88e3 #FF9F90
          SnacksIndent               = {fg = '#F4E6F9' },
          ["@markup.link"]           = {fg = '#39bae6' , underline = true, sp = '#004182'}, -- #0400d1
          ["@markup.heading"]        = {fg = '#FFF000' , bold      = true},
          Keyword                    = {fg = '#FF5F00' , bold      = true},
          RenderMarkdownBullet       = {fg = '#64BAAA'},
          Exception                  = {fg = '#FF5F00'},
          Statement                  = {fg = '#FF5F00'},
          Constructor                = {fg = '#FF5F00'},
          FuncBuiltin                = {fg = '#FF5F00'},
          DapBreakpoint              = {fg = '#FF5F00'},
          DapLogPoint                = {fg = '#61afef'},
          DapStopped                 = {fg = '#98c379'},
          TypeDefinition             = {fg = '#FF5F00'},
          KeywordFunction            = {fg = '#FF5F00'},
          NotifyBackground           = {bg = '#000000'}, -- TODO: may need to be changed to snacks.nvim something
          IndentBlanklineContextChar = {fg = '#FF5F00'},
          LspReferenceRead           = {bg = '#626A73'},
          LspReferenceText           = {bg = '#626A73'},
          LspReferenceWrite          = {bg = '#626A73'},
          LineNr                     = {fg = '#626A73'},
          RenderMarkdownH1Bg         = {bg = '#3e2e2e'},
          RenderMarkdownH2Bg         = {bg = '#2e1e1e'},
          RenderMarkdownH3Bg         = {bg = '#1e0e0e'},
          RenderMarkdownH4Bg         = {bg = '#0e0e0e'},
          RenderMarkdownH5Bg         = {bg = '#0e0e0e'},
          RenderMarkdownH6Bg         = {bg = '#0e0e0e'},
          SatelliteBar               = {bg = "#454545"},
          SatelliteCursor            = {fg = "#626A73", default = true, },
          SatelliteMark              = {fg = "#626A73", default = true, },
          SnacksPickerDir            = {fg = "#626A73", default = true, },
          -- DiagnosticError =  utils.parse_diagnostic_style { fg = '#cc241d'},
          -- DiagnosticWarn  =  utils.parse_diagnostic_style { fg = '#ff8f40'},
          -- DiagnosticInfo  =  utils.parse_diagnostic_style { fg = '#39bae6'},
          -- DiagnosticHint  =  utils.parse_diagnostic_style { fg = '#95e6cb'},
          -- #FFC26B #860000 #64BAAA #006B5D #FF6A13 #FFB454 #FFF000 #FFE0F0 #Maybe?
        }
      end
    end
    }) end                                   },
  {"lewis6991/gitsigns.nvim",
    config = function()
      -- require('gitsigns').setup(require('astronvim.plugins.gitsigns').opts())
      local opts = require("astronvim.plugins.gitsigns").opts()
      opts.sign_priority = 14
      require("gitsigns").setup(opts)
      -- require("scrollbar.handlers.gitsigns").setup()
    end
  },
  {"mfussenegger/nvim-dap", config = function()
      local dap = require "dap" -- dap.defaults.fallback.force_external_terminal = true
      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/alacritty",
        args    = { "-e" }            ,
      }
      dap.configurations.python = {
        { -- The first three options are required by nvim-dap
          type       = "python"                            , -- the type here established the link to the adapter definition : `dap.adapters.python`
          request    = "launch"                            ,
          name       = "Launch file in external terminal"  ,
          console    = "externalTerminal"                  , -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
          program    = "${file}"                           , -- This configuration will launch the current file if used.
          pythonPath = "/usr/bin/python"
        },
        { -- The first three options are required by nvim-dap
          type       = "python"                            , -- the type here established the link to the adapter definition : `dap.adapters.python`
          request    = "launch"                            ,
          name       = "Launch file in integrated terminal",
          console    = "integratedTerminal"                , -- Options here and  below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
          program    = "${file}"                           , -- This configuration will launch the current file if used.
          pythonPath = "/usr/bin/python"
      },}
    end,
  },
  -- { "Darazaki/indent-o-matic" , disable = true },
  -- { "yioneko/nvim-yati"              , config = function () -- #2
  --   require("nvim-treesitter.configs").setup {
  --     yati = {
  --       enable           = true,
  --       disable          = {'python', 'markdown', 'lua', 'cpp' }, -- Disable by languages, see `Supported languages`
  --       default_lazy     = true, -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
  --       default_fallback = "auto"
  --     },
  --     indent   = {
  --       enable = true -- disable builtin indent module
  --     }
  --   }
  -- end, requires = "nvim-treesitter/nvim-treesitter"
  -- },
  {"nvim-neo-tree/neo-tree.nvim" , opts = {
    window                    = { position = 'right' },
    default_component_configs = {
      indent                  = {
        last_indent_marker    = '╰',
  },},},},

  {"AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    servers = { -- enable servers that you already have installed without mason
      -- "tst_lsp"
      "dartls"
    },
    handlers = { -- customize how language servers are attached
      dartls = function(_, opts) require("flutter-tools").setup { lsp = opts } end,
    },
    opts = {
      features = {
        autoformat      = false, -- enable or disable auto formatting on start
        codelens        = true , -- enable/disable codelens refresh on start
        inlay_hints     = false, -- enable/disable inlay hints on start
        semantic_tokens = true , -- enable/disable semantic token highlighting
      },
      formatting       = {       -- control auto formatting on save
        format_on_save = {
          enabled = false,       -- enable or disable format on save globally
          allow_filetypes  = {}, -- enable format on save for specified filetypes only
          ignore_filetypes = {}, -- disable format on save for specified filetypes
        },
        disabled   = {},         -- disable formatting capabilities for the listed language servers
        timeout_ms = 1000,       -- default format timeout
      },
      -- customize language server configuration options passed to `lspconfig`
      ---@diagnostic disable: missing-fields
      config = {
        dartls = {
          color = {
            enabled = true,
          },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
        },},

        texlab = { -- sudo pacman -S tectonic | yay -S sioyek-appimage
          settings = {
            texlab = {
              build = {
                onSave = true,
                executable = "tectonic",
                args = {
                  "-X",
                  "compile",
                  "%f",
                  "--synctex",
                  "--keep-logs",
                  "--keep-intermediates"
        },},},},},

        -- tst_lsp = function() -- pottential memmory leak from not closing the script in exit?
        --   return {
        --     cmd = {
        --       'python',
        --       '/home/xou/Desktop/xou/programming/python/trash/lsptst.py'
        --     };
        --     -- filetypes = {"tst"};
        --     root_dir = require("lspconfig.util").root_pattern("test.tst");
        --   }
        -- end,


        -- arduino_language_server = { --  https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/arduino_language_server | https://discord.com/channels/939594913560031363/1078005571451621546/threads/1122910773270818887
        --   on_new_config = function (config, root_dir)
        --     local my_arduino_fqbn = { -- arduino-cli core install arduino:... 
        --       ["/home/xou/Desktop/xou/programming/hardware/arduino/nano"              ]  = "arduino:avr:nano", -- arduino-cli board listall
        --       ["/home/xou/Desktop/xou/programming/hardware/arduino/uno"               ]  = "arduino:avr:uno" ,
        --       ["/home/xou/Desktop/xou/programming/hardware/esp32/AirM2M_CORE_ESP32C3" ]  = "esp32:esp32:AirM2M_CORE_ESP32C3" ,
        --       ["/home/xou/Desktop/xou/programming/hardware/esp32/"                    ]  = "esp32:esp32:AirM2M_CORE_ESP32C3" ,
        --       ["/home/xou/Desktop/xou/programming/hardware/attiny/85_Digispark"       ]  = "ATTinyCore:avr:attinyx5micr",
        --     }
        --     local DEFAULT_FQBN = "arduino:avr:uno"
        --     local fqbn = my_arduino_fqbn[root_dir:match(".*/"):sub(1, -2)]
        --     if not fqbn then
        --       -- vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
        --       fqbn = DEFAULT_FQBN
        --     end
        --     config.capabilities.textDocument.semanticTokens = vim.NIL
        --     config.capabilities.workspace.semanticTokens = vim.NIL
        --     config.cmd = {         --  https://forum.arduino.cc/t/solved-errors-with-clangd-startup-for-arduino-language-server-in-nvim/1019977
        --       "arduino-language-server",
        --       "-cli-config" , "~/.arduino15/arduino-cli.yaml", -- just in case it was /home/xou/.arduino15/arduino-cli.yaml 
        --       "-cli"        , "/usr/bin/arduino-cli", -- 2023-06-26 ERROR | "Runs" if I set a wrong path
        --       "-clangd"     , "/usr/bin/clangd",
        --       "-fqbn"       , fqbn
        --     }
        --   end
        -- },


        basedpyright     = {
          settings       = {
            basedpyright = {
              analysis   = {
                typeCheckingMode      = "basic",
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                reportUnusedImport          = "information",
                reportUnusedFunction        = "information",
                reportUnusedVariable        = "information",
                reportGeneralTypeIssues     = "none",
                reportOptionalMemberAccess  = "none",
                reportOptionalSubscript     = "none",
                reportPrivateImportUsage    = "none",
                reportAttributeAccessIssue  = "information",
                reportArgumentType          = "none",
                reportOptionalOperand       = "none",
                reportIndexIssue            = "none",
                reportCallIssue             = "none",
                reportOperatorIssue         = "none"
      },},} },},},

      -- mappings to be set up on attaching of a language server
      mappings = {
        n = {
          -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
          gD = {
            function() vim.lsp.buf.declaration() end,
            desc = "Declaration of current symbol",
            cond = "textDocument/declaration",
          },
          ["<Leader>uY"] = {
            function() require("astrolsp.toggles").buffer_semantic_tokens() end,
            desc = "Toggle LSP semantic highlight (buffer)",
            cond = function(client)
              return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
            end,
      },},},

      -- on_attach = function(client, bufnr)
      --   -- this would disable semanticTokensProvider for all clients
      --   -- client.server_capabilities.semanticTokensProvider = nil
      -- end,
    },
  },
}



local scroll_timer = nil -- Disable expensive features while scrolling (keyboard + mouse)
local hl_timer     = nil -- Optimize horizontal movement (h/l)


local function disable_expensive()
  vim.schedule(function() vim.cmd("NoMatchParen"   )           end)
  pcall       (function() vim.cmd("IlluminatePause")           end) -- Pause illuminate
  -- pcall       (function() require("snacks.indent"  ).disable() end) -- Disable Snacks indent
  vim.opt.cursorcolumn = false -- Disable cursorcolumn
  vim.cmd("set lazyredraw")
end


local function enable_expensive()
  vim.schedule(function() vim.cmd("DoMatchParen"    )          end)
  pcall       (function() vim.cmd("IlluminateResume")          end) -- Resume illuminate
  -- pcall       (function() require("snacks.indent"   ).enable() end) -- Re-enable Snacks indent
  vim.opt.cursorcolumn = true -- Restore cursorcolumn
  vim.cmd("set nolazyredraw")
end


local function throttled_disable()
  disable_expensive()
  -- Reset timer
  if scroll_timer then
    scroll_timer:stop ()
    scroll_timer:close()
  end
  -- re-enable after 300ms of no scrolling
  scroll_timer = vim.loop.new_timer()
  scroll_timer:start(300, 0, vim.schedule_wrap(enable_expensive))
end


local function disable_hl_expensive()
  vim.schedule(function() vim.cmd("NoMatchParen") end)
  vim.cmd("set lazyredraw")
  -- vim.opt.cursorcolumn = false -- Disable cursorcolumn
end


local function enable_hl_expensive()
  vim.schedule(function() vim.cmd("DoMatchParen") end)
  vim.cmd("set nolazyredraw")
  -- vim.opt.cursorcolumn = true -- Restore cursorcolumn
end


local function throttled_hl()
  disable_hl_expensive()
  -- Reset timer if already running
  if hl_timer then
    hl_timer:stop ()
    hl_timer:close()
  end
  -- Re-enable after 300ms of no horizontal movement
  hl_timer = vim.loop.new_timer()
  hl_timer:start(300, 0, vim.schedule_wrap(enable_hl_expensive))
end



-- This function is run last and is a good place to configuring
-- augroups/autocommands and custom filetypes also this just pure lua so
-- anything that doesn't fit in the normal config locations above can go here
local polish = function()
  local mset = vim.keymap.set
  local api  = vim.api
  local gs   = require('gitsigns')
  -- local opts = { silent=true }


  -- if _G.XKB_SWITCH then
  --   api.nvim_command('autocmd InsertLeave * call SetUsLayout()')
  --   api.nvim_command('autocmd InsertEnter * call ResetLayout()')
  -- end

  mset('n', 'cml', '<Leader>/', { remap = true, desc = 'Toggle comment on current line' })
  mset('n', 'cm', 'gc', { remap = true})
  mset('v', 'cm', 'gc', { remap = true})

  mset('v', '<leader>gs', function() gs.stage_hunk      {vim.fn.line('.'), vim.fn.line('v')} end)
  mset('v', '<leader>gu', function() gs.undo_stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)

  mset('n', '<Leader>tt', 'a<C-R>=strftime("%Y-%m-%d %I:%M:%S %p")<CR><Esc>', { desc = 'print time'} )
  mset('n', '<Leader>i' , 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>'    , { desc = 'print time'} ) -- TODO: store it into register
  mset('n', '<Leader>I' , 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>'    , { desc = 'print time'} )
  mset('n', '";', '"_')

  mset('i', '<C-S>'     , '<C-o>:w<cr>'         )
  mset('i', '<C-Q>'     , '<C-o>:q!<cr>'        )
  mset('v', '<A-k>'     , ":m '<-2<CR>gv=gv"    )
  mset('v', '<A-j>'     , ":m '>+1<CR>gv=gv"    )
  mset('n', '<a-k>'     , ':m-2<cr>=='          )
  mset('n', '<a-j>'     , ':m+1<cr>=='          )
  mset('i', '<A-k>'     , '<C-o>:m-2<cr>'       )
  mset('i', '<A-j>'     , '<C-o>:m+1<cr>'       )
  mset('v', 's'         , "\"fy/\\V<C-R>f<CR>N" ) -- https://vi.stackexchange.com/a/34743/42370 | https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim#comment2699355_41400 TODO: Fix when autocomplete ~if and then type s
  mset('n', 'x'         , '"_x'                 )
  mset('n', 'X'         , '"_X'                 )

  mset('i', "<A-h>"     , '<ESC><<')
  mset('i', "<A-l>"     , '<ESC>>>')
  mset('v', "<A-h>"     , '<gv'    )
  mset('v', "<A-l>"     , '>gv'    )
  mset('n', "<A-h>"     , '<<'     )
  mset('n', "<A-l>"     , '>>'     )
  mset('v', "<S-h>"     , '^'    )
  mset('v', "<S-l>"     , '$'    )

  mset('n', "<A-;>"     , '%' )

  mset('n', '<Leader>L' , ':bnext<cr>'    )
  mset('n', '<Leader>H' , ':bprevious<cr>')

  mset('n', "H"         , ":call smarthome#SmartHome('n')<cr>")
  mset('n', "L"         , ":call smarthome#SmartEnd('n')<cr>" )
  mset('n', "<Home>"    , ":call smarthome#SmartHome('n')<cr>")
  mset('n', "<End>"     , ":call smarthome#SmartEnd('n')<cr>" )
  mset('i', "<Home>"    , "<C-r>=smarthome#SmartHome('i')<cr>")
  mset('i', "<End>"     , "<C-r>=smarthome#SmartEnd('i')<cr>" )

  -- mset('n', '<Tab>'     ,function() require("astronvim.utils.buffer").nav_to(vim.v.count +  1) end, { desc ="Go to Buffer" }) -- TODO: Messes up with CTRL+I

  mset('n', '<Leader>j' , ':call vm#commands#add_cursor_down(0,1)<CR>'      , { desc = 'Add cursor down'})
  mset('n', '<Leader>k' , ':call vm#commands#add_cursor_up(0,1)<CR>'        , { desc = 'Add cursor down'})
  mset('i', '<C-A-up>'  , '<ESC>:call vm#commands#add_cursor_up(0,1)<CR>'   )
  mset('i', '<C-A-down>', '<ESC>:call vm#commands#add_cursor_down(0,1)<CR>' )

  api.nvim_command('set cursorcolumn')

  api.nvim_command("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
  api.nvim_command("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

  -- api.nvim_command("let g:yoinkAutoFormatPaste='1'") -- Indent on paste
  api.nvim_command("map <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)'    : '<plug>(YoinkPaste_p)'")
  api.nvim_command("map <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'")
  api.nvim_command('xmap p <plug>(SubversiveSubstitute)')
  api.nvim_command('xmap P <plug>(SubversiveSubstitute)')
  --Tabularize /(.*)

  mset('v', 'p', '"_dP')

  -- api.nvim_command('autocmd FileType markdown set conceallevel=2') -- au FileType markdown setl conceallevel=0
  api.nvim_command('autocmd FileType tex,markdown setlocal wrap')
  api.nvim_command('au BufRead,BufNewFile *.md nnoremap <buffer> gf :call go_to_markdown_ref()<cr>') -- https://www.reddit.com/r/vim/comments/yu49m1/rundont_run_vim_command_based_on_current_file/

  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>aa <cmd>call arduino#Attach()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>as <cmd>call arduino#Serial()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>am <cmd>call arduino#Verify()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>au <cmd>call arduino#Upload()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ad <cmd>call arduino#UploadAndSerial()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ab <cmd>call arduino#ChooseBoard()<CR>')
  api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ap <cmd>call arduino#ChooseProgrammer()<CR>')

  mset("n", "<leader>al", "<cmd>Tab /[=:|]/<cr>"                          , {desc = 'Align text'})

  api.nvim_command(':set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz') --  https://github.com/neovim/neovim/issues/2420

  -- api.nvim_command("nnoremap <c-a> :if !switch#Switch({'reverse': 0}) <bar> exe 'normal! <c-a>' <bar> endif<cr>") -- https://github.com/AndrewRadev/switch.vim/pull/41
  -- api.nvim_command("nnoremap <c-x> :if !switch#Switch({'reverse': 1}) <bar> exe 'normal! <c-x>' <bar> endif<cr>")

  -- api.nvim_command("let g:python3_host_prog = 'C:\\Users\\gxous\\AppData\\Local\\Programs\\Python\\Python39\\python.exe'")
  -- mset('n', 'N', '#') -- IF NOT ALREADY SLASH SEARCH (i think i can do this with lua and states)
  -- mset('n', 'n', '*') -- IF NOT ALREADY SLASH SEARCH
  if ( vim.g.colors_name == 'sunbather' or vim.g.colors_name == 'nazgul') then
    if _G.IS_WINDOWS then
      api.nvim_command('highlight Normal guibg=none')
    else
      api.nvim_command('highlight Normal guibg=#000000')
    end
    api.nvim_command('highlight LspReferenceRead  guibg=#353535')
    api.nvim_command('highlight LspReferenceWrite guibg=#353535')
    api.nvim_command('highlight LspReferenceText  guibg=#353535')
    api.nvim_command('highlight MatchParen        guibg=#000000 guifg=#FFFFFF guisp=#000000 cterm=underline gui=underline')
    api.nvim_command('highlight IndentBlanklineContextChar  guifg=#FFFFFF')
  end

  -- Keys that count as scrolling
  local scroll_keys = {
    "j", "k", "gj", "gk",
    "<C-d>", "<C-u>",
    "<C-f>", "<C-b>",
  }

  for _, key in ipairs(scroll_keys) do
    vim.keymap.set("n", key, function()
      if vim.v.count == 0 then
        throttled_disable()
      end
      return key
    end, { expr = true, silent = true })
  end

  -- Mouse wheel events
  local mouse_scroll = {
    "<ScrollWheelUp>"    ,
    "<ScrollWheelDown>"  ,
    "<S-ScrollWheelUp>"  ,
    "<S-ScrollWheelDown>",
    "<C-ScrollWheelUp>"  ,
    "<C-ScrollWheelDown>",
  }

  for _, key in ipairs(mouse_scroll) do
    vim.keymap.set("", key, function()
      throttled_disable()
      return key
    end, { expr = true, silent = true })
  end

  -- Horizontal keys: h, l, and wrapped ones: gh, gl
  local hl_keys = { "h", "l", "gh", "gl" }

  for _, key in ipairs(hl_keys) do
    vim.keymap.set("n", key, function()
      throttled_hl()
      return key
    end, { expr = true, silent = true })
  end

  -- vim.filetype.add { -- Set up custom filetypes
  --   extension    = { foo                   = "fooscript", },
  --   filename     = { ["Foofile"]           = "fooscript", },
  --   pattern      = { ["~/%.config/foo/.*"] = "fooscript", },
  -- }
end

-- initialize lazy
require("lazy").setup {
  spec = plugins,
  ui = { backdrop = 100 },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
},},},}

polish()


--[[
  "Trust your Intuitions" -- Related to motions


  =====================================================================
                            REMIND STUFF
  =====================================================================
  * SmartHome SmartEnd but "smarter",  4 steps instead of 3 , a middle one where you were before taking the action


  =====================================================================
                            REMIND STUFF
  =====================================================================
  * http://www.viemu.com/vi-vim-tutorial-1.gif
  * https://www.youtube.com/watch?v=qZO9A5F6BZs
  * https://stackoverflow.com/a/26920014/11465149
  * nvim --startuptime output
  * :set background=light
  * :!git add *
  * :!git commit -m "whatever"
  * :!git push
  * git config --global credential.helper store (and after the first push credentials get stored)


  =====================================================================
                         FOR THING TO WORK 
  =====================================================================
  * CPP
  * * install gdb for cpp in dap
  * * compile with -g : g++ -g file.cpp -o file.o
  * Clean Install 
  * * sudo -E rm -r ~/.local/share/nvim
  * * sudo -E rm -r ~/.config/nvim
  * * sudo -E rm -r /usr/share/nvim/
  * * sudo -E rm -r /home/xou/.cache/nvim
  * * sudo pacman -R neovim
  * * sudo pacman -S neovim


  =====================================================================
                           HELPFUL STUFF
  =====================================================================
  * https://alpha2phi.medium.com/neovim-for-beginners-debugging-using-dap-44626a767f57
  * https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
  * https://github.com/rockerBOO/awesome-neovim#markdown--latex



  =====================================================================
                         POTENTIAL PLUGINS 
  =====================================================================
  * https://www.reddit.com/r/neovim/comments/1p5t0x0/i_built_vscodediffnvim_a_cpowered_plugin_to_bring/
  * https://github.com/phaazon/hop.nvim
  * https://github.com/xiyaowong/nvim-transparent
  * https://github.com/sindrets/winshift.nvim
  * https://github.com/kevinhwang91/nvim-hlslens
  * https://github.com/sindrets/diffview.nvim
  * https://github.com/glts/vim-radical
  * https://github.com/terryma/vim-expand-region
  * https://github.com/ThePrimeagen/harpoon
  * https://github.com/fedepujol/move.nvim


  =====================================================================
                           Watch Later 
  =====================================================================
  * https://www.youtube.com/watch?v=vpwJ7fqD1CE
  * https://www.youtube.com/watch?v=VFESU67M4bk
  * https://www.youtube.com/watch?v=Bi9JiW5nSig


  =====================================================================
                             REFERENCES
  =====================================================================
  - #2 fix python indent (example: open brackets in comment like "# ([)")
  - - https://github.com/yioneko/nvim-yati
  - - https://github.com/nvim-treesitter/nvim-treesitter/issues/1136#issuecomment-1127145770  
]]--

