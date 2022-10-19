--[[
lvim is the global options object
Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "github_dark"
-- theme settings
vim.cmd([[
  let g:gruvbox_material_palette = 'original'
  let g:gruvbox_material_background = 'hard'
  let g:gruvbox_material_diagnostic_virtual_text = 'colored'
]])
vim.opt.relativenumber = true
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- easymotion
vim.cmd([[
	map <leader><leader>. <Plug>(easymotion-repeat)
	map <leader><leader>f <Plug>(easymotion-bd-f)
	map <leader><leader>j <Plug>(easymotion-bd-line)
	map <leader><leader>k <Plug>(easymotion-bd-line)
	map <leader><leader>w <Plug>(easymotion-bd-w)
	map  / <Plug>(easymotion-sn)
	omap / <Plug>(easymotion-tn)
]])
vim.opt.termguicolors = true

-- general
vim.cmd([[
	map H ^
	map L $
  map <tab> :BufferLineCycleNext<CR>
  map <s-tab> :BufferLineCyclePrev<CR>
	nnoremap <leader>u :UndotreeShow<CR>
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
  let g:detect_mod_reg_state = -1
  function! DetectRegChangeAndUpdateMark()
      let current_small_register = getreg('"-')
      let current_mod_register = getreg('""')
      if g:detect_mod_reg_state != current_small_register || 
                  \ g:detect_mod_reg_state != current_mod_register
          normal! mM
          let g:detect_mod_reg_state = current_small_register
      endif
  endfunction
  autocmd InsertLeave * execute 'normal! mI'
  autocmd CursorMoved * call DetectRegChangeAndUpdateMark()
  autocmd InsertLeave * execute 'normal! mM'
  let g:astro_typescript = 'enable'
]])

-- vim-visual-multi
vim.cmd([[
  let g:VM_mouse_mappings = 1
  let g:VM_maps = {}
  let g:VM_maps['Find Under'] = '<C-N>'
  let g:VM_maps['Find Subword Under'] = '<C-N>'
]])

-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }
lvim.builtin.which_key.mappings["lh"] = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover" }
lvim.builtin.which_key.mappings["r"] = {
  name = "+Replace",
  r = { ":%s/<C-r><C-w>/<C-r><C-w>/gIc<left><left><left><left>", "Find and replace (confirm)" },
  a = { ":%s/<C-r><C-w>/<C-r><C-w>/gI<Left><Left><Left>", "Find and replace (all)" },
}
lvim.builtin.which_key.mappings["t"] = {
  name = "+Terminal",
  t = { ":!{nohup st </dev/null >/dev/null 2>&1 &}<CR><CR>", "Open path in terminal" },
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  -- { command = "black", filetypes = { "python" } },
  -- { command = "isort", filetypes = { "python" } },
  {
    -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "prettierd",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    -- extra_args = { "--print-with", "100" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css", "json", "yaml" },
  },
}

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
-- lvim.plugins = {
--     {"folke/tokyonight.nvim"},
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }
lvim.plugins = {
  { "sainnhe/gruvbox-material" },
  { "easymotion/vim-easymotion" },
  { "tpope/vim-surround" },
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },
  { "mg979/vim-visual-multi" },
  { "projekt0n/github-nvim-theme" },
  { "wuelnerdotexe/vim-astro" },
  { "glacambre/firenvim" },
  { "github/copilot.vim" },
  { "uga-rosa/ccc.nvim" }
}


local ccc = require("ccc")
local mapping = ccc.mapping
ccc.setup({
  highlighter = { auto_enable = true }
})
-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })
