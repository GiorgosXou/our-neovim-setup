--              AstroNvim Configuration Table
-- All configuration changes should go inside of the table below

-- You can think of a Lua "table" as a dictionary like data structure the
-- normal format is "key = value". These also handle array like data structures
-- where a value with no key simply has an implicit numeric key
local config = {
  updater    = {
    commit         = nil      , -- commit hash (NIGHTLY ONLY)
    branch         = "nightly", -- branch name (NIGHTLY ONLY)
    remote         = "origin" , -- remote to use
    channel        = "nightly", -- "stable" or "nightly"
    version        = "latest" , -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    auto_quit      = false    , -- automatically quit the current session after a successful update
    pin_plugins    = nil      , -- nil, true, false (nil will pin plugins on stable only)
    auto_reload    = false    , -- automatically reload and sync packer after a successful update
    skip_prompts   = false    , -- skip prompts about breaking changes
    show_changelog = true     , -- show the changelog after performing an update
  },
  colorscheme = 'nazgul', -- Set colorscheme to use

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
      mkdp_theme                 = 'dark',
      mapleader                  = " "   , -- sets vim.g.mapleader
      autoformat_enabled         = false , -- enable or disable auto formatting at start (lsp.formatting.format_on_save must be enabled)
      cmp_enabled                = true  , -- enable completion at start
      autopairs_enabled          = true  , -- enable autopairs at start
      diagnostics_enabled        = true  , -- enable diagnostics at start
      status_diagnostics_enabled = true  , -- enable diagnostics in statusline
      icons_enabled              = true  , -- disable icons in the UI (disable if no nerd font is available, requires :PackerSync after changing)
      ui_notifications_enabled   = true  , -- disable notifications when toggling UI elements
      heirline_bufferline        = false , -- enable new heirline based bufferline (requires :PackerSync after changing)
      VM_maps            = {
        ['Find Under']      = '<C-n>'  ,
        ["Add Cursor Down"] = '<C-A-j>',
        ["Add Cursor Up"]   = '<C-A-k>',
      },

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

      go_to_markdown_ref = function ()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_buf_get_lines(0, cursor[1]-1, cursor[1] , false)[1]

        for match in string.gmatch(line, "%(([^'%)]+)") do
          local start_pos = string.find(line, match)
          local end_pos = start_pos + string.len(match)
          local link = ''
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


  header = {
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
  },

  default_theme       = { -- Default theme configuration
    diagnostics_style = { italic = true },
    colors            = { -- Modify the color palette for the default theme
      fg = "#abb2bf",
      bg = "#1e222a",
    },

    highlights  = function(hl) -- or a function that returns a new table of colors to set
      local C   = require "default_theme.colors"
      hl.Normal = { fg = C.fg, bg = C.bg }
      -- New approach instead of diagnostic_style
      hl.DiagnosticError.italic = true
      hl.DiagnosticHint.italic  = true
      hl.DiagnosticInfo.italic  = true
      hl.DiagnosticWarn.italic  = true
      return hl
    end,

    plugins = { -- enable or disable extra plugin highlighting
      indent_blankline      = true ,
      symbols_outline       = false,
      highlighturl          = true ,
      bufferline            = true ,
      beacon                = false,
      notify                = true ,
      aerial                = true ,
      cmp                   = true ,
      hop                   = false,
      rainbow               = true ,
      vimwiki               = false,
      telescope             = true ,
      dashboard             = true ,
      treesitter            = true ,
      lightspeed            = false,
      ["neo-tree"]          = true ,
      ["which-key"]         = true ,
      ["nvim-tree"]         = false,
      ["nvim-web-devicons"] = true ,
  },},

  diagnostics    = { -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    virtual_text = true,
    underline    = true,
  },

  -- Extend LSP configuration
  lsp       = {
    servers = { -- enable servers that you already have installed without mason
    },
    formatting       = {     -- control auto formatting on save
      format_on_save = {
        enabled = true,         -- enable or disable format on save globally
        allow_filetypes  = {},
        ignore_filetypes = {},
      },
      disabled   = {}  ,
      timeout_ms = 1000, -- default format timeout
    },
    mappings = { -- easily add or disable built in mappings added during LSP attaching
      n      = { -- ["<leader>lf"] = false -- disable formatting keymap
    },},

    ["server-settings"] = { -- Add overrides for LSP server settings, the keys are the name of the server
      arduino_language_server = { --  https://github.com/williamboman/nvim-lsp-installer/tree/main/lua/nvim-lsp-installer/servers/arduino_language_server
        on_new_config = function (config, root_dir)
          local my_arduino_fqbn = {
            ["/home/xou/Desktop/programming/hardware/arduino/nano"]  = "arduino:avr:nano", -- arduino-cli board listall
            ["/home/xou/Desktop/programming/hardware/arduino/uno" ]  = "arduino:avr:uno" ,
          }
          local DEFAULT_FQBN = "arduino:avr:uno"
          local fqbn = my_arduino_fqbn[root_dir]
          if not fqbn then
            -- vim.notify(("Could not find which FQBN to use in %q. Defaulting to %q."):format(root_dir, DEFAULT_FQBN))
            fqbn = DEFAULT_FQBN
          end
          config.cmd = {         --  https://forum.arduino.cc/t/solved-errors-with-clangd-startup-for-arduino-language-server-in-nvim/1019977
            "arduino-language-server",
            "-cli-config" , "/home/xou/.arduino15/arduino-cli.yaml",
            "-cli"        , "/usr/bin/arduino-cli",
            "-clangd"     , "/usr/bin/clangd",
            "-fqbn"       , fqbn
          }
        end
      },
      pyright           = {
        settings        = {
          python        = {
            analysis    = {
              typeCheckingMode = "off",
    },} },} },},

  mappings = {
    n = {
      ["<leader>bb"] = { "<cmd>tabnew<cr>"              , desc = "New tab"       },
      ["<leader>bc"] = { "<cmd>BufferLinePickClose<cr>" , desc = "Pick to close" },
      ["<leader>bj"] = { "<cmd>BufferLinePick<cr>"      , desc = "Pick to jump"  },
      ["<leader>bt"] = { "<cmd>BufferLineSortByTabs<cr>", desc = "Sort by tabs"  },
      -- quick save
      -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
    },
    t = {
      -- setting a mapping to false will disable it
      -- ["<esc>"] = false,
    },
  },

  plugins = { -- Configure plugins
    init  = {
      {'mg979/vim-visual-multi'                 },
      {'folke/zen-mode.nvim'                    },
      {'m-pilia/vim-smarthome'                  },
      {'nikolvs/vim-sunbather'                  },
      {'nocksock/nazgul-vim'                    },
      {'szorfein/darkest-space'                 },
      {'owickstrom/vim-colors-paramount'        },
      {'navarasu/onedark.nvim'                  },
      {'fcpg/vim-orbital'                       },
      {'stevearc/vim-arduino'                   }, -- sudo pacman -S arduino-cli (and arduino?) 
      {'Shadowsith/vim-minify'                  },
      {'romainl/vim-malotru'                    },
      {'tpope/vim-sleuth'                       },
      {'tpope/vim-commentary'                   },
      {'tpope/vim-surround'                     },
      {'vim-scripts/ReplaceWithRegister'        },
      {'michaeljsmith/vim-indent-object'        },
      {'kana/vim-textobj-entire'                },
      {'kana/vim-textobj-user'                  },
      {'Mofiqul/vscode.nvim'                    },
      {'nvim-treesitter/nvim-treesitter-context'},
      {'svermeulen/vim-yoink'                   },
      {'AndrewRadev/switch.vim'                 },
      {'svermeulen/vim-subversive'              },
      {'folke/trouble.nvim'                     },
      {'godlygeek/tabular'                      }, -- ALIGN <leader>a | https://stackoverflow.com/questions/5436715/how-do-i-align-like-this-with-vims-tabular-plugin
      {'folke/twilight.nvim'             , config = function() require('twilight'             ).setup { context=50 }             end}, -- TODO: FIX
      {'petertriho/nvim-scrollbar'       , config = function() require("scrollbar"            ).setup()                          end},
      {'iamcco/markdown-preview.nvim'    , run    = function() vim.fn["mkdp#util#install"]()                                     end},
      {'Shatur/neovim-ayu'               , config = function()
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
      { "yioneko/nvim-yati"              , config = function () -- #2
        require("nvim-treesitter.configs").setup {
          yati = {
            enable = true,
            disable = {'python', 'markdown' }, -- Disable by languages, see `Supported languages`
            default_lazy = true, -- Whether to enable lazy mode (recommend to enable this if bad indent happens frequently)
            default_fallback = "auto"
          },
          indent   = {
            enable = false -- disable builtin indent module
          }
        }
      end, 
      tag = "*", requires = "nvim-treesitter/nvim-treesitter" },
    },

    cmp = function(config)
      local cmp                    = require "cmp"
      -- config.mapping["<ESC>"     ] = cmp.mapping.abort()
      config.mapping["<C-Space>" ] = cmp.mapping      ({
        i = function() if cmp.visible() then cmp.abort() else cmp.complete() end end,
        c = function() if cmp.visible() then cmp.close() else cmp.complete() end end,
      })
      config.mapping["<F7>"      ] = config.mapping["<C-Space>"] -- Windows only
      config.enabled               = function         ()         -- https://www.reddit.com/r/neovim/comments/skkp1r/disable_cmp_inside_comments/
        local context = require("cmp.config.context")
        return cmp.visible() or not(
          context.in_treesitter_capture("comment") or
          context.in_treesitter_capture('string' ) or
          context.in_syntax_group      ("Comment")
        )
      end
      return config
    end,

    ["neo-tree"]                = {
      window                    = { position = 'right' },
      default_component_configs = {
        indent                  = {
          last_indent_marker    = '╰',
    },},},

    ["null-ls"] = function(config) -- overrides `require("null-ls").setup(config)`
      config.sources = { -- Set a formatter
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.formatting.prettier,
      }
      return config -- return final config table
    end,
    treesitter          = { -- overrides `require("treesitter").setup(...)`
      ensure_installed  = { "lua" },
    },
    ["mason-lspconfig"] = { -- use mason-lspconfig to configure LSP installations
      ensure_installed  = { "sumneko_lua" },
    },
    ["mason-null-ls"]   = { -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
      -- ensure_installed = { "prettier", "stylua" },
    },
    ["mason-nvim-dap"]  = { -- overrides `require("mason-nvim-dap").setup(...)`
      ensure_installed  = { "python" },
    },
  },


  luasnip           = { -- LuaSnip Options
    filetype_extend = { -- Extend filetypes
      -- javascript = { "javascriptreact" },
    },
    vscode  = { -- Configure luasnip loaders (vscode, lua, and/or snipmate)
      paths = {}, -- Add paths for including more VS Code style snippets in luasnip
  },},


  cmp               = {
    source_priority = {
      nvim_lsp  = 1000,
      luasnip   = 750 ,
      buffer    = 500 ,
      path      = 250 ,
  },},


  heirline = { -- Customize Heirline options
    -- -- Customize different separators between sections
    -- separators = {
    --   tab = { "", "" },
    -- },
    -- -- Customize colors for each element each element has a `_fg` and a `_bg`
    -- colors = function(colors)
    --   colors.git_branch_fg = astronvim.get_hlgroup "Conditional"
    --   return colors
    -- end,
    -- -- Customize attributes of highlighting in Heirline components
    -- attributes = {
    --   -- styling choices for each heirline element, check possible attributes with `:h attr-list`
    --   git_branch = { bold = true }, -- bold the git branch statusline component
    -- },
    -- -- Customize if icons should be highlighted
    -- icon_highlights = {
    --   breadcrumbs = false, -- LSP symbols in the breadcrumbs
    --   file_icon = {
    --     winbar = false, -- Filetype icon in the winbar inactive windows
    --     statusline = true, -- Filetype icon in the statusline
    --   },
    -- },
  },


  ["which-key"]       = { -- Modify which-key registration (Use this with mappings table in the above.)
    register_mappings = { -- Add bindings which show up as group name
      n               = { -- first key is the mode, n == normal mode
        ["<leader>"]  = { -- second key is the prefix, <leader> prefixes
          ["b"] = { name = "Buffer" },
  },},},},


  polish = function()
    local map  = vim.keymap
    local opts = { silent=true }

    map.set('n', '<Leader>tt', 'a<C-R>=strftime("%Y-%m-%d %I:%M:%S %p")<CR><Esc>', { desc = 'print time'} )
    map.set('n', '<Leader>i', 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>', { desc = 'print time'} ) -- TODO: store it into register
    map.set('n', '<Leader>I', 'a<C-R>=strftime("__%Y%m%d%I%M%S%p")<CR><Esc>', { desc = 'print time'} )
    map.set('n', '";', '"_')

    map.set('i', '<C-S>'   , '<C-o>:w<cr>'              )
    map.set('i', '<C-Q>'   , '<C-o>:q!<cr>'             )
    map.set('n', 'cm'      , '<Plug>Commentary'         )
    map.set('n', 'gtn'     , ':BufferLineCycleNext<cr>' )
    map.set('n', 'gtb'     , ':BufferLineCyclePrev<cr>' )
    -- map.set('n', 'mm'      , 'm\''                      )
    map.set('v', '<A-k>'   , ":m '<-2<CR>gv=gv"         )
    map.set('v', '<A-j>'   , ":m '>+1<CR>gv=gv"         )
    map.set('n', '<a-k>'   , ':m-2<cr>=='               )
    map.set('n', '<a-j>'   , ':m+1<cr>=='               )
    map.set('i', '<A-k>'   , '<C-o>:m-2<cr>'            )
    map.set('i', '<A-j>'   , '<C-o>:m+1<cr>'            )
    map.set('n', 'i'       , ':noh<cr>i'                )
    map.set('n', '<ESC>'   , ':noh<cr>'                 )
    map.set('v', '/'       , "\"fy/\\V<C-R>f<CR>N"      ) -- https://superuser.com/questions/41378/how-to-search-for-selected-text-in-vim#comment2699355_41400
    map.set('n', 'x'       , '"_x'                      )
    map.set('n', 'X'       , '"_X'                      )

    map.set('i', "<A-h>"    , '<ESC><<')
    map.set('i', "<A-l>"    , '<ESC>>>')
    map.set('v', "<A-h>"    , '<gv')
    map.set('v', "<A-l>"    , '>gv')
    map.set('n', "<A-h>"    , '<<' )
    map.set('n', "<A-l>"    , '>>' )

    map.set('n', "<Leader>h"    , '%' )

    map.set('n', '<Leader>L' , ':BufferLineCycleNext<CR>')
    map.set('n', '<Leader>H' , ':BufferLineCyclePrev<CR>')

    map.set('n', "<S-h>"    , '^' )
    map.set('n', "<S-l>"    , '$' )
    map.set('n', "<Home>"   , ":call smarthome#SmartHome('n')<cr>")
    map.set('n', "<End>"    , ":call smarthome#SmartEnd('n')<cr>" )
    map.set('i', "<Home>"   , "<C-r>=smarthome#SmartHome('i')<cr>") 
    map.set('i', "<End>"    , "<C-r>=smarthome#SmartEnd('i')<cr>" )

    map.set('n', '<Space>r', '<Plug>ReplaceWithRegisterOperator', { desc = "Replace with register"})

    map.set('n', '<Leader>j' , ':call vm#commands#add_cursor_down(0,1)<CR>'      , { desc = 'Add cursor down'})
    map.set('n', '<Leader>k' , ':call vm#commands#add_cursor_up(0,1)<CR>'        , { desc = 'Add cursor down'})
    map.set('i', '<C-A-up>'  , '<ESC>:call vm#commands#add_cursor_up(0,1)<CR>'   , bufopts)
    map.set('i', '<C-A-down>', '<ESC>:call vm#commands#add_cursor_down(0,1)<CR>' , bufopts)

    map.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>"                      , {silent = true, noremap = true})
    map.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", {silent = true, noremap = true})
    map.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>" , {silent = true, noremap = true})
    map.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>"              , {silent = true, noremap = true})
    map.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>"             , {silent = true, noremap = true})
    map.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>"               , {silent = true, noremap = true})

    -- map.set('n', "<Tab>"   , ">>"              , bufopts)
    -- map.set('n', "<S-Tab>" , "<<"              , bufopts) -- windows issue

    -- map.set("n", "<leader>b" , ":lua require('dap').toggle_breakpoint()<cr>", { desc = 'Breakpoint Toggle'} )


    vim.api.nvim_command("nnoremap <expr> j v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'j' : 'gj'"                      )
    vim.api.nvim_command("nnoremap <expr> k v:count ? (v:count > 5 ? \"m'\" . v:count : '') . 'k' : 'gk'"                      )

    vim.api.nvim_command("let g:yoinkAutoFormatPaste='1'"                                                                      )
    vim.api.nvim_command("map <expr> p yoink#canSwap() ? '<plug>(YoinkPostPasteSwapBack)' : '<plug>(YoinkPaste_p)'"            )
    vim.api.nvim_command("map <expr> P yoink#canSwap() ? '<plug>(YoinkPostPasteSwapForward)' : '<plug>(YoinkPaste_P)'"         )
    vim.api.nvim_command('xmap p <plug>(SubversiveSubstitute)')
    vim.api.nvim_command('xmap P <plug>(SubversiveSubstitute)')
    -- Maybe also add  a paste with indentation? p= somehow
    --Tabularize /(.*)
    -- vim.api.nvim_command('xnoremap p "_dP' ) -- mehh

    vim.api.nvim_command('set conceallevel=3') -- au FileType markdown setl conceallevel=0
    vim.api.nvim_command('au BufRead,BufNewFile *.md nnoremap <buffer> gf :call go_to_markdown_ref()<cr>') -- https://www.reddit.com/r/vim/comments/yu49m1/rundont_run_vim_command_based_on_current_file/

    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>aa <cmd>ArduinoAttach<CR>')
    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>am <cmd>ArduinoVerify<CR>')
    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>au <cmd>ArduinoUpload<CR>')
    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ad <cmd>ArduinoUploadAndSerial<CR>')
    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ab <cmd>ArduinoChooseBoard<CR>')
    vim.api.nvim_command('au BufRead,BufNewFile *.ino nnoremap <buffer> <leader>ap <cmd>ArduinoChooseProgrammer<CR>')

    -- vim.api.nvim_command("nnoremap <c-a> :if !switch#Switch({'reverse': 0}) <bar> exe 'normal! <c-a>' <bar> endif<cr>") -- https://github.com/AndrewRadev/switch.vim/pull/41
    -- vim.api.nvim_command("nnoremap <c-x> :if !switch#Switch({'reverse': 1}) <bar> exe 'normal! <c-x>' <bar> endif<cr>")

    -- vim.api.nvim_command("let g:python3_host_prog = 'C:\\Users\\gxous\\AppData\\Local\\Programs\\Python\\Python39\\python.exe'")
    -- map.set('n', 'N', '#') -- IF NOT ALREADY SLASH SEARCH (i think i can do this with lua and states)
    -- map.set('n', 'n', '*') -- IF NOT ALREADY SLASH SEARCH
    if ( vim.g.colors_name == 'ayu') then
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg=0, fg='#FF5F00'})
      vim.api.nvim_set_hl(0, 'DapLogPoint'  , { ctermbg=0, fg='#61afef'})
      vim.api.nvim_set_hl(0, 'DapStopped'   , { ctermbg=0, fg='#98c379'})
    elseif ( vim.g.colors_name == 'sunbather' or vim.g.colors_name == 'nazgul') then
      if _G.IS_WINDOWS then
        vim.api.nvim_command('highlight Normal guibg=none')
      else
        vim.api.nvim_command('highlight Normal guibg=#000000')
      end
      vim.api.nvim_command('highlight LspReferenceRead  guibg=#353535')
      vim.api.nvim_command('highlight LspReferenceWrite guibg=#353535')
      vim.api.nvim_command('highlight LspReferenceText  guibg=#353535')
      vim.api.nvim_command('highlight MatchParen        guibg=#000000 guifg=#FFFFFF guisp=#000000 cterm=underline gui=underline')
      vim.api.nvim_command('highlight IndentBlanklineContextChar  guifg=#FFFFFF')
    end
    vim.fn.sign_define  ('DapBreakpoint', { text='●', texthl='DapBreakpoint', numhl='DapBreakpoint'})

    -- vim.filetype.add { -- Set up custom filetypes
    --   extension    = { foo                   = "fooscript", },
    --   filename     = { ["Foofile"]           = "fooscript", },
    --   pattern      = { ["~/%.config/foo/.*"] = "fooscript", },
    -- }
  end,
}

return config


--[[
  "Trust your Intuitions" -- Related to motions


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



  =====================================================================
                             REFERENCES
  =====================================================================
  - #2 fix python indent (example: open brackets in comment like "# ([)")
  - - https://github.com/yioneko/nvim-yati
  - - https://github.com/nvim-treesitter/nvim-treesitter/issues/1136#issuecomment-1127145770  
]]--
