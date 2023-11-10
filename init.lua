-- install those packages:
-- `sudo pacman -S ripgrep lazygit`

_G.IS_WINDOWS  = vim.loop.os_uname().sysname:find 'Windows' and true or false
_G.IS_ARCH     = vim.loop.os_uname().release:find 'arch'    and true or false

return {
  -- updater = {                  -- Configure AstroNvim updates
  --   remote         = "origin", -- remote to use
  --   channel        = "stable", -- "stable" or "nightly"
  --   version        = "latest", -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
  --   pin_plugins    = nil     , -- nil, true, false (nil will pin plugins on stable only)
  --   skip_prompts   = false   , -- skip prompts about breaking changes
  --   show_changelog = true    , -- show the changelog after performing an update
  --   auto_quit      = false   , -- automatically quit the current session after a successful update
  -- },
  colorscheme ='nazgul', -- Set colorscheme to use

  options = {
    opt   = {
      relativenumber = true  , -- sets vim.opt.relativenumber
      number         = true  , -- sets vim.opt.number
      spell          = false , -- sets vim.opt.spell
      signcolumn     = "auto", -- sets vim.opt.signcolumn to auto
      wrap           = false , -- sets vim.opt.wrap
      -- shiftwidth     = 4     ,
      -- tabstop        = 4     ,
    },
    g = {
      mapleader                  = " "   , -- sets vim.g.mapleader
      diagnostics_mode           = 3     , -- set the visibility of diagnostics in the UI (0=off, 1=only show in status line, 2=virtual text off, 3=all on)
      autoformat_enabled         = false , -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled                = true  , -- enable completion at start
      autopairs_enabled          = true  , -- enable autopairs at start
      icons_enabled              = true  , -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled   = true  , -- disable notifications when toggling UI elements
      VM_maps            = {
        ['Find Under']      = '<C-n>'  ,
        ["Add Cursor Down"] = '<C-A-j>',
        ["Add Cursor Up"]   = '<C-A-k>',
      },

      SetUsLayout = function()
        vim.api.nvim_command('silent !xkb-switch -s us') -- yay -S xkb-switch
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
  },},

  plugins = {                       -- Configure plugins
    { "goolord/alpha-nvim",
      opts = function(_, opts)      -- override the options using lazy.nvim
        opts.section.header.val = { -- change the header section value
          '             \\                                      [            ',
          '              @                 ⟡                  ╢             ',
          '      /       ╣▒                                  ]▒       \\     ',
          '     ╔       ]Ñ▒                                  ╟╣┐       ▓    ',
          '    ╢╣       ╣▓            √          t            ▓╣       ▓╣   ',
          '   ▓╣▒╖    ╓╫╜           ╥▓   ASTROν   ▓@           ╙▓╖    ╔╣╢║  ',
          '   ▓▓▓▓  ,p▓,,,,,,      ╜╙▓▄╖,      ,╓╥╜╙╙    ,,,,,,,,▓▓,  ▀▓▓╣U ',
          '   ▀▓Ö   ╙█▓▓▓▓▓▓╢╫╣▓▓▓▓▓╦, ▀▓▓╗  g╢▓╝ ,╓H╢╢╢╢╢╢▓▓▓▓▓▓▒▓╜   ]▓▓  ',
          '    ▓▓▓╦╥╖ ╙╙╙╙`     `""▀▓▓@ ▐█▓L]▓╫╛ Æ▒╨╜"       ""╙╙` ╓╖∩▒▒▓   ',
          ' ╒▓▒╜""╙▀▓▓                ▀  █▒Γ▐▓▓  ╩                ▓╢╜""╙▀█╫L',
          ' ▐▌`      └╝                  ▓▒` █▓                  ╜       └█▓',
          '▐▓                            ▓▒  █╢                           ▐▓',
          ' ▐Γ                            ╛  ▐"                           ▐[',
          ' ¬U                                                            jU',
          '  C                                                            j ',
          '   L                                                          ]  ',
        }
      end,
    },
    -- Colorschemes
    {'fcpg/vim-orbital'                       },
    {'nocksock/nazgul-vim'                    },
    {'Mofiqul/vscode.nvim'                    },
    {'nikolvs/vim-sunbather'                  },
    {'navarasu/onedark.nvim'                  },
    {'szorfein/darkest-space'                 },
    {'owickstrom/vim-colors-paramount'        },
    -- LSP - TS - DAP
    {"williamboman/mason-lspconfig.nvim", opts   = { ensure_installed = {'pyright', 'lua_ls', 'marksman'}}}, -- 'arduino_language_server'
    {"nvim-treesitter/nvim-treesitter"  , opts   = { ensure_installed = {'python' , 'lua'   , 'markdown', 'markdown_inline', 'arduino', 'cpp', 'c'}}},
    {"jay-babu/mason-nvim-dap.nvim"     , opts   = { ensure_installed = {'python' , 'lua'}}},
    {"akinsho/flutter-tools.nvim"             }, -- add lsp plugin
    {"p00f/clangd_extensions.nvim",              -- install lsp plugin
      init = function()
        -- load clangd extensions when clangd attaches
        local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
          group = augroup,
          desc = "Load clangd_extensions with clangd",
          callback = function(args)
            if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
              require "clangd_extensions"
              -- add more `clangd` setup here as needed such as loading autocmds
              vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
            end
          end,
        })
      end,
    },
    {"williamboman/mason-lspconfig.nvim", opts = { ensure_installed = { "clangd" },},},

    {'kana/vim-textobj-entire'                },

    {'kiyoon/treesitter-indent-object.nvim'   },
    {'nvim-treesitter/nvim-treesitter'        },
    {'stevearc/vim-arduino'                   }, -- sudo pacman -S arduino-cli (and arduino?) 
    {'hiphish/rainbow-delimiters.nvim'        , lazy = false},
    {'folke/zen-mode.nvim'                    , lazy = false },
    {'godlygeek/tabular'                      , lazy = false }, -- ALIGN <leader>a | https://stackoverflow.com/questions/5436715/how-do-i-align-like-this-with-vims-tabular-plugin
    {'folke/trouble.nvim'                     , lazy = false },
    {'svermeulen/vim-yoink'                   , lazy = false }, -- TERMUX https://github.com/GiorgosXou/our-neovim-setup/issues/2
    {'Shadowsith/vim-minify'                  , lazy = false }, -- TODO: It needs to be Checked 2023-03-24 06:29:23 PM
    {'m-pilia/vim-smarthome'                  , lazy = false },
    {'mg979/vim-visual-multi'                 , lazy = false },
    {'nvim-treesitter/nvim-treesitter-context', lazy = false },
    {'vim-scripts/ReplaceWithRegister'        , lazy = false },
    {'iamcco/markdown-preview.nvim'           ,               config = function() vim.fn["mkdp#util#install"]() end , ft = { "markdown" }},
    {'petertriho/nvim-scrollbar'              , lazy = false, config = function() require("scrollbar" ).setup() end},
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
    {'numToStr/Comment.nvim'    , config = function() require('Comment'      ).setup({
      toggler = {
          line  = 'cml', -- Line-comment toggle keymap
          block = 'gbc', -- Block-comment toggle keymap
      },
      opleader = {
          line  = 'cm', ---Line-comment keymap
          block = 'gb', ---Block-comment keymap
      },
    }) end, lazy = false}, -- permanant solution until fix https://discord.com/channels/939594913560031363/1088835559012716584
    {'Shatur/neovim-ayu'           , config = function()
      -- local utils = require "default_theme.utils"
      require('ayu').setup({                               -- don't forger :PackerCompile if it doesn't work
      overrides                        = {                 -- :Telescope highlights https://github.com/Shatur/neovim-ayu#overrides-examples <------
        Type                           = {fg = '#FF5F00'},
        Macro                          = {fg = '#FF5F00'},
        Normal                         = {bg = '#000000'}, -- 'NONE'
        Repeat                         = {fg = '#FF5F00'},
        Method                         = {fg = '#FF5F00'},
        PreProc                        = {fg = '#FF5F00'},
        Include                        = {fg = '#FF5F00'},
        Keyword                        = {fg = '#FF5F00'},
        Exception                      = {fg = '#FF5F00'},
        Statement                      = {fg = '#FF5F00'},
        Constructor                    = {fg = '#FF5F00'},
        FuncBuiltin                    = {fg = '#FF5F00'},
        TypeDefinition                 = {fg = '#FF5F00'},
        KeywordFunction                = {fg = '#FF5F00'},
        IndentBlanklineContextChar     = {fg = '#FF5F00'},
        LspReferenceRead               = {bg = '#626A73'},
        LspReferenceText               = {bg = '#626A73'},
        LspReferenceWrite              = {bg = '#626A73'},
        LineNr                         = {fg = '#626A73'},
        -- DiagnosticError =  utils.parse_diagnostic_style { fg = '#cc241d'},
        -- DiagnosticWarn  =  utils.parse_diagnostic_style { fg = '#ff8f40'},
        -- DiagnosticInfo  =  utils.parse_diagnostic_style { fg = '#39bae6'},
        -- DiagnosticHint  =  utils.parse_diagnostic_style { fg = '#95e6cb'},
        -- #FFC26B #860000 #64BAAA #006B5D #FF6A13 #FFB454 #FFF000 #Maybe?
    }}) end                                   },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require('gitsigns').setup()
        require("scrollbar.handlers.gitsigns").setup()
      end
    },
    { "mfussenegger/nvim-dap", config = function()
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
  },


  diagnostics    = { -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    virtual_text = true,
    underline    = true,
  },

  -- Extend LSP configuration
  lsp       = {
    servers = { -- enable servers that you already have installed without mason
      -- "tst_lsp"
      "dartls",
    },
    setup_handlers = { -- add custom handler
      dartls = function(_, opts) require("flutter-tools").setup { lsp = opts } end,
    },
    -- on_attach = function(client, bufnr)
    --   if client.name == "arduino_language_server" then
    --     client.server_capabilities.semanticTokensProvider = nil
    --     -- client.server_capabilities.semanticTokensProvider = false
    --   end
    -- end,
    formatting       = {
      format_on_save = { -- control auto formatting on save
        enabled = true,  -- enable or disable format on save globally
        allow_filetypes  = {},
        ignore_filetypes = {},
      },
      disabled   = {}  ,
      timeout_ms = 1000, -- default format timeout
    },
    mappings = { -- easily add or disable built in mappings added during LSP attaching
      n      = { -- ["<leader>lf"] = false -- disable formatting keymap
    },},

    ["config"] = { -- Add overrides for LSP server settings, the keys are the name of the server
      dartls = {
        color = {
          enabled = true,
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
      },},

      tst_lsp = function()
        return {
          cmd = {
            'cmake-language-server'
          };
          -- filetypes = {"tst"};
          root_dir = require("lspconfig.util").root_pattern("pdack.tst");
        }
      end,
      -- arduino_language_server = { --  https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/arduino_language_server | https://discord.com/channels/939594913560031363/1078005571451621546/threads/1122910773270818887
      --   on_new_config = function (config, root_dir)
      --     local my_arduino_fqbn = {
      --       ["/home/xou/Desktop/xou/programming/hardware/arduino/nano"]  = "arduino:avr:nano", -- arduino-cli board listall
      --       ["/home/xou/Desktop/xou/programming/hardware/arduino/uno" ]  = "arduino:avr:uno" ,
      --     }
      --     local DEFAULT_FQBN = "arduino:avr:uno"
      --     local fqbn = my_arduino_fqbn[root_dir]
      --     if not fqbn then
      --       -- vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
      --       fqbn = DEFAULT_FQBN
      --     end
      --     config.cmd = {         --  https://forum.arduino.cc/t/solved-errors-with-clangd-startup-for-arduino-language-server-in-nvim/1019977
      --       "arduino-language-server",
      --       "-cli-config" , "~/.arduino15/arduino-cli.yaml", -- just in case it was /home/xou/.arduino15/arduino-cli.yaml
      --       "-cli"        , "/usr/bin/arduino-cli", -- 2023-06-26 ERROR | "Runs" if I set a wrong path
      --       "-clangd"     , "/usr/bin/clangd",
      --       "-fqbn"       , fqbn
      --     }
      --   end
      -- },
      pyright        = {
        settings     = {
          python     = {
            analysis = {
              typeCheckingMode = "off",
    },} },}
  },},

  lazy = { -- Configure require("lazy").setup() options
    defaults = { lazy = true },
    performance = {
      rtp = { -- customize default disabled vim plugins
        disabled_plugins = { "tohtml", "gzip", "matchit", "zipPlugin", "netrwPlugin", "tarPlugin" },
  },},},

  -- This function is run last and is a good place to configuring
  -- augroups/autocommands and custom filetypes also this just pure lua so
  -- anything that doesn't fit in the normal config locations above can go here
  polish = function()
    local map  = vim.keymap
    local api  = vim.api
    local opts = { silent=true }
    local gs   = require('gitsigns')

    if _G.IS_ARCH then
      api.nvim_command('autocmd InsertLeave * call SetUsLayout()')
    end

    map.set('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)

    map.set('n', '<Leader>tt', 'a<C-R>=strftime("%Y-%m-%d %I:%M:%S %p")<CR><Esc>', { desc = 'print time'} )
    map.set('n', '<Leader>i' , 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>'    , { desc = 'print time'} ) -- TODO: store it into register
    map.set('n', '<Leader>I' , 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>'    , { desc = 'print time'} )
    map.set('n', '";', '"_')

    map.set({"x", "o"}, "ai" , "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>"    ) -- select context-aware indent
    map.set({"x", "o"}, "aI" , "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>") -- ensure selecting entire line (or just use Vai)
    map.set({"x", "o"}, "ii" , "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>"    ) -- select inner block (only if block, only else block, etc.)
    map.set({"x", "o"}, "iI" , "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>") -- select entire inner range (including if, else, etc.)

    map.set('i', '<C-S>'     , '<C-o>:w<cr>'              )
    map.set('i', '<C-Q>'     , '<C-o>:q!<cr>'             )
    map.set('v', 'p'         , '"_dP'                     )
    map.set('v', '<A-k>'     , ":m '<-2<CR>gv=gv"         )
    map.set('v', '<A-j>'     , ":m '>+1<CR>gv=gv"         )
    map.set('n', '<a-k>'     , ':m-2<cr>=='               )
    map.set('n', '<a-j>'     , ':m+1<cr>=='               )
    map.set('i', '<A-k>'     , '<C-o>:m-2<cr>'            )
    map.set('i', '<A-j>'     , '<C-o>:m+1<cr>'            )
    map.set('n', 'i'         , ':noh<cr>i'                )
    map.set('n', '<ESC>'     , ':noh<cr>'                 )
    map.set('v', 's'         , "\"fy/\\V<C-R>f<CR>N"      ) -- https://vi.stackexchange.com/a/34743/42370 | https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim#comment2699355_41400
    map.set('n', 'x'         , '"_x'                      )
    map.set('n', 'X'         , '"_X'                      )

    map.set('i', "<A-h>"     , '<ESC><<')
    map.set('i', "<A-l>"     , '<ESC>>>')
    map.set('v', "<A-h>"     , '<gv'    )
    map.set('v', "<A-l>"     , '>gv'    )
    map.set('n', "<A-h>"     , '<<'     )
    map.set('n', "<A-l>"     , '>>'     )
    map.set('v', "<S-h>"     , '^'    )
    map.set('v', "<S-l>"     , '$'    )

    map.set('n', "<Leader>h"    , '%' )

    map.set('n', 'gtn'       , ':bnext<cr>'    )
    map.set('n', 'gtb'       , ':bprevious<cr>')
    map.set('n', '<Leader>L' , ':bnext<cr>'    )
    map.set('n', '<Leader>H' , ':bprevious<cr>')

    map.set('n', "<S-h>"     , ":call smarthome#SmartHome('n')<cr>")
    map.set('n', "<S-l>"     , ":call smarthome#SmartEnd('n')<cr>" )
    map.set('n', "<Home>"    , ":call smarthome#SmartHome('n')<cr>")
    map.set('n', "<End>"     , ":call smarthome#SmartEnd('n')<cr>" )
    map.set('i', "<Home>"    , "<C-r>=smarthome#SmartHome('i')<cr>")
    map.set('i', "<End>"     , "<C-r>=smarthome#SmartEnd('i')<cr>" )

    map.set('n', '<Space>r'  , '<Plug>ReplaceWithRegisterOperator', { desc = "Replace with register"})

    -- map.set('n', '<Tab>'     ,function() require("astronvim.utils.buffer").nav_to(vim.v.count +  1) end, { desc ="Go to Buffer" }) -- TODO: Messes up with CTRL+I

    map.set('n', '<Leader>j' , ':call vm#commands#add_cursor_down(0,1)<CR>'      , { desc = 'Add cursor down'})
    map.set('n', '<Leader>k' , ':call vm#commands#add_cursor_up(0,1)<CR>'        , { desc = 'Add cursor down'})
    map.set('i', '<C-A-up>'  , '<ESC>:call vm#commands#add_cursor_up(0,1)<CR>'   )
    map.set('i', '<C-A-down>', '<ESC>:call vm#commands#add_cursor_down(0,1)<CR>' )

    map.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>"                      , {silent = true, noremap = true})
    map.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
    map.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" , {silent = true, noremap = true})
    map.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>"              , {silent = true, noremap = true})
    map.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>"             , {silent = true, noremap = true})
    map.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>"               , {silent = true, noremap = true})

    -- map.set('n', "<Tab>"   , ">>"              )
    -- map.set('n', "<S-Tab>" , "<<"              ) -- windows issue

    -- map.set("n", "<leader>b" , ":lua require('dap').toggle_breakpoint()<cr>", { desc = 'Breakpoint Toggle'} )

    api.nvim_command('set cursorcolumn')

    api.nvim_command("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'")
    api.nvim_command("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'")

    -- api.nvim_command("let g:yoinkAutoFormatPaste='1'") -- Indent on paste
    api.nvim_command("map <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)'    : '<plug>(YoinkPaste_p)'")
    api.nvim_command("map <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'")
    api.nvim_command('xmap p <plug>(SubversiveSubstitute)')
    api.nvim_command('xmap P <plug>(SubversiveSubstitute)')
    --Tabularize /(.*)

    api.nvim_command('set conceallevel=3') -- au FileType markdown setl conceallevel=0
    api.nvim_command('au BufRead,BufNewFile *.md nnoremap <buffer> gf :call go_to_markdown_ref()<cr>') -- https://www.reddit.com/r/vim/comments/yu49m1/rundont_run_vim_command_based_on_current_file/

    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>aa <cmd>ArduinoAttach<CR>')
    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>am <cmd>ArduinoVerify<CR>')
    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>au <cmd>ArduinoUpload<CR>')
    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ad <cmd>ArduinoUploadAndSerial<CR>')
    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ab <cmd>ArduinoChooseBoard<CR>')
    api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ap <cmd>ArduinoChooseProgrammer<CR>')

    map.set("n", "<leader>al", "<cmd>Tab /[=:|]/<cr>"                          , {desc = 'Align text'})

    -- api.nvim_command("nnoremap <c-a> :if !switch#Switch({'reverse': 0}) <bar> exe 'normal! <c-a>' <bar> endif<cr>") -- https://github.com/AndrewRadev/switch.vim/pull/41
    -- api.nvim_command("nnoremap <c-x> :if !switch#Switch({'reverse': 1}) <bar> exe 'normal! <c-x>' <bar> endif<cr>")

    -- api.nvim_command("let g:python3_host_prog = 'C:\\Users\\gxous\\AppData\\Local\\Programs\\Python\\Python39\\python.exe'")
    -- map.set('n', 'N', '#') -- IF NOT ALREADY SLASH SEARCH (i think i can do this with lua and states)
    -- map.set('n', 'n', '*') -- IF NOT ALREADY SLASH SEARCH
    if ( vim.g.colors_name == 'ayu') then
      api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg=0, fg='#FF5F00'})
      api.nvim_set_hl(0, 'DapLogPoint'  , { ctermbg=0, fg='#61afef'})
      api.nvim_set_hl(0, 'DapStopped'   , { ctermbg=0, fg='#98c379'})
    elseif ( vim.g.colors_name == 'sunbather' or vim.g.colors_name == 'nazgul') then
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

    -- vim.filetype.add { -- Set up custom filetypes
    --   extension    = { foo                   = "fooscript", },
    --   filename     = { ["Foofile"]           = "fooscript", },
    --   pattern      = { ["~/%.config/foo/.*"] = "fooscript", },
    -- }
  end,
}


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
  * https://github.com/phaazon/hop.nvim
  * nvim-telescope/telescope-media-files.nvim      MUST INSTALL
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
