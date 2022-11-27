_G.IS_WINDOWS   = vim.loop.os_uname().sysname:find 'Windows' and true or false
_G.PYTHON_PATH  = _G.IS_WINDOWS and 'C:\\Users\\gxous\\AppData\\Local\\Programs\\Python\\Python39\\python.exe' or '/usr/sbin/python'--'/usr/local/bin/python3'
-- _G.ZK_HONE_PATH = _G.IS_WINDOWS and 'C:\\Users\\gxous\\Desktop\\notes' or vim.fn.expand('~/Desktop/xou/notes')


local config = {
  updater    = {
    commit         = nil      , -- commit hash (NIGHTLY ONLY)
    branch         = "nightly", -- branch name (NIGHTLY ONLY)
    remote         = "origin" , -- remote to use
    channel        = "nightly", -- "stable" or "nightly"
    version        = "latest" , -- "latest", tag name, or regex search like "v1.*" to only do updates before v2 (STABLE ONLY)
    pin_plugins    = nil      , -- nil, true, false (nil will pin plugins on stable only)
    skip_prompts   = false    , -- skip prompts about breaking changes
    show_changelog = true     , -- show the changelog after performing an update
  },
  colorscheme = 'nazgul', -- Set colorscheme

  options = { -- set vim options here (vim.<first_key>.<second_key> =  value)
    opt   = { -- clipboard = "",
      relativenumber = true, -- sets vim.opt.relativenumber
    },
    g = {
      mkdp_theme         = 'dark',
      mapleader          = " "   , -- sets vim.g.mapleader
      autoformat_enabled = false ,
      VM_maps            = {
        ['Find Under']      = '<C-n>'  ,
        ["Add Cursor Down"] = '<C-A-j>',
        ["Add Cursor Up"]   = '<C-A-k>',
      },
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
    colors            = { -- Modify the color table
      fg              = "#abb2bf"        ,
    },

    highlights          = function(highlights) -- Modify the highlight groups
      local C           = require "default_theme.colors"
      highlights.Normal = { fg = C.fg, bg = C.bg }
      return highlights
    end,

    plugins = { -- enable or disable extra plugin highlighting
      aerial                = true ,
      notify                = true ,
      rainbow               = true ,
      telescope             = true ,
      dashboard             = true ,
      bufferline            = true ,
      highlighturl          = true ,
      indent_blankline      = true ,
      ["nvim-web-devicons"] = true ,
      ["neo-tree"         ] = true ,
      ["which-key"        ] = true ,
      ["nvim-tree"        ] = false,
      hop                   = false,
      vimwiki               = false,
      beacon                = false,
      lightspeed            = false,
      symbols_outline       = false,
  },},


  ui                 = { -- Disable AstroNvim ui features
    nui_input        = true,
    telescope_select = true,
  },


  plugins = { -- Configure plugins
    init  = { -- Add plugins, the packer syntax without the "use"
      {'mg979/vim-visual-multi'                 },
      {'folke/zen-mode.nvim'                    },
      {'m-pilia/vim-smarthome'                  },
      {'nikolvs/vim-sunbather'                  },
      {'nocksock/nazgul-vim'                    },
      {'szorfein/darkest-space'                 },
      {'owickstrom/vim-colors-paramount'        },
      {'navarasu/onedark.nvim'                  },
      {'fcpg/vim-orbital'                       },
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
      {'svermeulen/vim-subversive'              },
      {'folke/trouble.nvim'                     },
      {'godlygeek/tabular'                      }, -- ALIGN <leader>a | https://stackoverflow.com/questions/5436715/how-do-i-align-like-this-with-vims-tabular-plugin
      {'mfussenegger/nvim-dap'           ,
        config = function()
          local dap, dapui = require("dap"), require("dapui")
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open () end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited    ["dapui_config"] = function() dapui.close() end
        end}, -- python -m pip install debugpy
      {"Pocco81/DAPInstall.nvim"                },
      {"nvim-telescope/telescope-dap.nvim"      },
      -- {'renerocksai/telekasten.nvim'     , config = function() require('telekasten'           ).setup { home = _G.ZK_HONE_PATH } end},
      {'folke/twilight.nvim'             , config = function() require('twilight'             ).setup { context=50 }             end}, -- TODO: FIX
      {'theHamsta/nvim-dap-virtual-text' , config = function() require("nvim-dap-virtual-text").setup()                          end},
      {"mfussenegger/nvim-dap-python"    , config = function() require('dap-python'           ).setup(_G.PYTHON_PATH)            end},
      {'petertriho/nvim-scrollbar'       , config = function() require("scrollbar"            ).setup()                          end},
      {"rcarriga/nvim-dap-ui"            , config = function() require("dapui"                ).setup()                          end , requires = {"nvim-dap"}},
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
          -- #FFC26B #860000 #64BAAA #006B5D  #Maybe?
      }}) end                       },
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
      window                    = { position = 'left' },
      default_component_configs = {
        indent                  = {
          last_indent_marker    = '╰',
    },},},

    -- All other entries override the setup() call for default plugins
    ["null-ls"] = function(config)
      local null_ls = require "null-ls"
      -- Check supported formatters and linters
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
      config.sources = {
        null_ls.builtins.formatting.rufo    , -- Set a formatter
        null_ls.builtins.diagnostics.rubocop, -- Set a linter
      }

      config.on_attach = function(client)                        -- set up null-ls's on_attach function
        if client.resolved_capabilities.document_formatting then -- NOTE: You can remove this on attach function to disable format on save
          vim.api.nvim_create_autocmd("BufWritePre", {
            desc     = "Auto format before save"   ,
            pattern  = "<buffer>"                  ,
            callback = vim.lsp.buf.formatting_sync ,
          })
        end
      end
      return config -- return final config table
    end,
    treesitter             = { ensure_installed = { "lua"         } },
    ["nvim-lsp-installer"] = { ensure_installed = { "sumneko_lua" } },
    packer                 = {
      compile_path         = vim.fn.stdpath "data" .. "/packer_compiled.lua",
  },},


  luasnip                = {   -- LuaSnip Options
    vscode_snippet_paths = {}, -- Add paths for including more VS Code style snippets in luasnip
    filetype_extend      = {
      javascript         = { "javascriptreact" }
  },}, -- Extend filetypes


  ["which-key"]       = { -- Modify which-key registration
    register_mappings = { -- Add bindings
      n               = { -- first key is the mode, n == normal mode
        ["<leader>"]  = { -- second key is the prefix, <leader> prefixes
          -- which-key registration table for normal mode, leader prefix
          -- ["N"] = { "<cmd>tabnew<cr>", "New Buffer" },
  },},},},


  cmp               = {
    source_priority = {
      nvim_lsp      = 1000 ,
      luasnip       = 750  ,
      buffer        = 500  ,
      path          = 250  ,
  },},


  lsp       = { -- Extend LSP configuration
    servers = { -- enable servers that you already have installed without lsp-installer
    },
    -- add to the server on_attach function
    -- on_attach = function(client, bufnr)
    -- end,

    -- override the lsp installer server-registration function
    -- server_registration = function(server, opts)
    --   require("lspconfig")[server].setup(opts)
    -- end,

    -- Add overrides for LSP server settings, the keys are the name of the server
    ["server-settings"] = { 
      pyright           = {
        settings        = {
          python        = {
            analysis    = {
              typeCheckingMode = "off",
    },} },} },},

  diagnostics    = { -- Diagnostics configuration (for vim.diagnostics.config({}))
    virtual_text = true,
    underline    = true,
  },



  polish = function() -- This function is run last -- good place to configure mappings and vim options
    local map  = vim.keymap
    local opts = { silent=true }

    map.set('n', '<Leader>tt', 'a<C-R>=strftime("%Y-%m-%d %I:%M:%S %p")<CR><Esc>', { desc = 'print time'} )

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

    map.set('v', "<A-h>"    , '<gv')
    map.set('v', "<A-l>"    , '>gv')
    map.set('n', "<A-h>"    , '<<' )
    map.set('n', "<A-l>"    , '>>' )

    map.set('n', '<Leader>L' , ':BufferLineCycleNext<CR>')
    map.set('n', '<Leader>H' , ':BufferLineCyclePrev<CR>')

    map.set('n', "yH"       , 'y^')
    map.set('n', "yL"       , 'y$')
    map.set('n', "dH"       , 'd^')
    map.set('n', "dL"       , 'd$')
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

    map.set("n", "<F5>"      , ":lua require('dap').continue()<cr>"         , opts)
    map.set("n", "<F10>"     , ":lua require('dap').step_over()<cr>"        , opts)
    map.set("n", "<F11>"     , ":lua require('dap').step_into()<cr>"        , opts)
    map.set("n", "<F12>"     , ":lua require('dap').step_out()<cr>"         , opts)
    map.set("n", "<leader>b" , ":lua require('dap').toggle_breakpoint()<cr>", { desc = 'Breakpoint Toggle'} )
    map.set("n", "<leader>B" , ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>"      , { desc = 'Breakpoint Condition'} )
    map.set("n", "<leader>lp", ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Logpoint message: '))<cr>", opts)
    map.set("n", "<leader>rp", ":lua require('dap').repl.open()<cr>"        , opts)
    map.set("n", "<leader>RR", ":lua require('dap').run_last()<cr>"         , opts)
    map.set("n", "<leader>XX", ":lua require('dap').terminate()<cr>"        , { desc = 'Terminate DAP'})


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
  

    vim.api.nvim_command('set conceallevel=1')

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
      vim.api.nvim_command('highlight LspReferenceRead  guibg=#626A73')
      vim.api.nvim_command('highlight LspReferenceWrite guibg=#626A73')
      vim.api.nvim_command('highlight LspReferenceText  guibg=#626A73')
    end
    vim.fn.sign_define  ('DapBreakpoint', { text='●', texthl='DapBreakpoint', numhl='DapBreakpoint'})


    vim.api.nvim_create_augroup("packer_conf" , { clear = true }) -- Set autocommands
    vim.api.nvim_create_autocmd("BufWritePost", {
      desc    = "Sync packer after modifying plugins.lua",
      group   = "packer_conf"                            ,
      pattern = "plugins.lua"                            ,
      command = "source <afile> | PackerSync"            ,
    })

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
  * nvim-telescope/telescope-media-files.nvim      MUST INSTALL
  * https://github.com/xiyaowong/nvim-transparent
  * https://github.com/sindrets/winshift.nvim
  * https://github.com/kevinhwang91/nvim-hlslens
  * https://github.com/sindrets/diffview.nvim

]]--

