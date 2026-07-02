-- ============================================================================
-- 1. BOOTSTRAP LAZY.NVIM (Plugin Manager)
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git", "clone", "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)

-- Set mapleader before loading plugins
vim.g.mapleader = ","

-- ============================================================================
-- 2. PLUGIN DECLARATIONS (Lazy.nvim)
-- ============================================================================
require("lazy").setup({
   -- Core performance & utilities
   { "nvim-tree/nvim-web-devicons", lazy = true },
   { "preservim/nerdtree", cmd = "NERDTreeToggle" }, 
   { "majutsushi/tagbar", cmd = "TagbarToggle" },
   -- Git staging interface
   { 
      "jreybert/vimagit", 
      cmd = "Magit",
      init = function()
         -- Force discarding an untracked file to physically delete it from the disk
         vim.g.magit_discard_untracked_do_delete = 1
      end
   },
   -- VS Code-like multi-cursor editing
   { "mg979/vim-visual-multi", branch = "master" },
   -- Modern Fuzzy Finder (Replaces CtrlP / Ag seamlessly)
   {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
         require("telescope").setup({
            defaults = {
               file_ignore_patterns = { "%.git/", "%.o$", "%.a$", "build/", "tst/" },
               vimgrep_arguments = {
                  "rg", "--color=never", "--no-heading", "--with-filename",
                  "--line-number", "--column", "--smart-case", "--hidden"
               },
            }
         })
      end
   },

   -- Git integrations
   { "tpope/vim-fugitive" },
   { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
   { "lewis6991/gitsigns.nvim", config = true }, 

   -- Pure-Lua Automatic Completion Menu Manager (Zero external dependencies)
   {
      "echasnovski/mini.completion",
      version = false,
      config = function()
         require("mini.completion").setup({
            -- Automatically opens the menu while typing based on text already in your open files!
            window = {
               info = { height = 25, width = 80, border = 'single' },
               signature = { height = 25, width = 80, border = 'single' },
            }
         })
      end
   },
   -- VS Code Style Toggleable Terminal
   {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
         require("toggleterm").setup({
            size = 15,          -- Height of the bottom split terminal
            open_mapping = [[<C-t>]], -- Use Ctrl + t to toggle the terminal globally
            direction = "horizontal", -- Opens at the bottom, just like VS Code
            shade_terminals = true,
         })

         -- Custom mappings to handle seamless terminal navigation
         local map = vim.keymap.set
         local opts = { buffer = 0 }

         vim.api.nvim_create_autocmd("TermOpen", {
            pattern = "term://*",
            callback = function()
               -- Let Escape put you in Normal Mode inside the terminal if you want to copy text
               map("t", "<Esc>", [[<C-\><C-n>]], opts)
            end,
         })
      end
   },

   -- Color Schemes & Statusline
   { "morhetz/gruvbox" },
   { "cocopon/iceberg.vim" },
   { "folke/tokyonight.nvim", lazy = false, priority = 1000 },
   { "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
   {
      "nvim-lualine/lualine.nvim", 
      config = function()
         require("lualine").setup({ options = { theme = "hybrid" } })
      end
   }
})

-- ============================================================================
-- 3. GENERAL SETTINGS & OPTIMIZATIONS
-- ============================================================================
local opt = vim.opt

-- Colors & UI
opt.termguicolors = true       
vim.cmd("colorscheme kanagawa")   
opt.background = "dark"
opt.cursorline = true
opt.number = true
opt.relativenumber = true       
opt.signcolumn = "yes"          

-- Behaviors & Searching
opt.mouse = "a"
opt.clipboard:append("unnamedplus") 
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.wrap = false
opt.scrolloff = 3
opt.virtualedit = "block"

-- Files, Backups & Undo history
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.autoread = true
opt.undolevels = 1000
opt.history = 1000

-- Tabulations & Formatting Defaults
opt.expandtab = true
opt.smarttab = true
opt.shiftround = true
opt.list = true
opt.listchars = { trail = "·", tab = ">-", eol = "¬", nbsp = "×" }

-- ============================================================================
-- 4. FILETYPE SPECIFIC CONFIGURATIONS (Autocmds)
-- ============================================================================
vim.api.nvim_create_augroup("CustomIndents", { clear = true })

local function set_indent(ts, sw)
   vim.opt_local.tabstop = ts
   vim.opt_local.softtabstop = ts
   vim.opt_local.shiftwidth = sw
end

vim.api.nvim_create_autocmd("FileType", {
   group = "CustomIndents",
   pattern = { "c", "cpp" },
   callback = function() 
      set_indent(3, 3) -- Olivier's signature 3-space indentation preserved
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   group = "CustomIndents",
   pattern = { "lua", "javascript", "bash", "sh", "vim", "html", "css" },
   callback = function() 
      set_indent(3, 3) 
      vim.treesitter.start()
   end,
})

vim.api.nvim_create_autocmd("FileType", {
   group = "CustomIndents",
   pattern = "python",
   callback = function() set_indent(4, 4) end,
})

-- ============================================================================
-- 5. REFINED KEYMAPPINGS
-- ============================================================================

local map = vim.keymap.set
-- Search highlights toggle via Spacebar
map("n", "<space>", ":set hls!<CR>", { silent = true })
-- Toggle interactive Git Graph Tree split panel
map("n", "<leader>gl", ":Flogsplit<CR>", { silent = true, desc = "Toggle Git Log Tree" })

-- Center search results while jumping
map("n", "n", "nzz", { silent = true })
map("n", "N", "Nzz", { silent = true })

-- Toggle UI features safely
map("n", "<F1>", ":set number!<CR>", { silent = true })
map("n", "<leader>t", ":TagbarToggle<CR>", { silent = true })
map("n", "<leader>n", ":NERDTreeToggle<CR>", { silent = true, desc = "Toggle NERDTree" })
map("n", "<leader>g", ":Magit<CR>", { silent = true, desc = "Toggle Vimagit" })
map("n", "<leader>gl", ":Flogsplit<CR>", { silent = true, desc = "Toggle Git Log Tree" })

-- Telescope mappings
local builtin = require("telescope.builtin")
map("n", "sf", builtin.find_files, { desc = "Find Files" })
map("n", "sg", builtin.live_grep, { desc = "Grep Project" })
map("n", "sb", builtin.buffers, { desc = "Find Buffers" })
map("n", "sm", builtin.oldfiles, { desc = "Recent Files (MRU)" })

-- Sudo write shorthand
map("ca", "w!!", "w !sudo tee > /dev/null %")

-- ============================================================================
-- 6. PROXY-PROOF CUSTOM C SYNTAX HIGHLIGHTING (WITH APPIMAGE SAFEGUARD)
-- ============================================================================
local function apply_custom_c_colors()
   -- Use pcall (protected call) to prevent AppImage parser omissions from crashing
   local success, _ = pcall(vim.treesitter.start)

   -- If tree-sitter successfully attached, inject your custom vivid colors!
   if success then
      -- 1. Functions (Bright yellow/gold)
      vim.api.nvim_set_hl(0, "@function", { fg = "#E6DB74", bold = true })
      vim.api.nvim_set_hl(0, "@function.call", { fg = "#E6DB74" })

      -- 2. Function Arguments / Parameters (Bright orange)
      vim.api.nvim_set_hl(0, "@variable.parameter", { fg = "#FD971F", italic = true })

      -- 3. Structure Members e.g., my_struct.member (Bright cyan/blue)
      vim.api.nvim_set_hl(0, "@variable.member", { fg = "#66D9EF" })

      -- 4. Standard Local Variables (Clean off-white)
      vim.api.nvim_set_hl(0, "@variable", { fg = "#F8F8F2" })

      -- 5. Macros and Preprocessor directives (#define, #include - Hot pink)
      vim.api.nvim_set_hl(0, "@keyword.directive", { fg = "#F92672" })
      vim.api.nvim_set_hl(0, "@constant.macro", { fg = "#F92672" })
   end
end

-- Tie this rule safely to C and C++ source files
vim.api.nvim_create_autocmd({ "FileType" }, {
   pattern = { "c", "cpp" },
   callback = apply_custom_c_colors,
})


-- ============================================================================
-- 7. PURE NATIVE LSP FOR CLANGD (Zero Plugins, Zero Proxies)
-- ============================================================================

-- Function to launch Clangd Language Server natively
local function launch_native_clangd()
   if vim.fn.executable("clangd") == 1 then
      vim.lsp.start({
         name = "clangd",
         -- ADDED ARGUMENTS BELOW TO BYPASS AMD/ARM GCC FLAG CONFLICTS
         cmd = { 
            "clangd", 
            "--background-index", 
            "--compile-commands-dir=build",
            -- Force clangd to ignore unknown CPU flags or pass them cleanly
            "-query-driver=/usr/bin/*gcc*,/usr/bin/*g++*",
            -- Injects fallback optimization flags that clang understands implicitly
            "--fallback-style=LLVM"
         },
         root_dir = vim.fs.root(0, { "compile_commands.json", ".git", "Makefile" }),
      })
   end
end

-- Function to launch Python Language Server natively
local function launch_native_pylsp()
   if vim.fn.executable("pylsp") == 1 then
      vim.lsp.start({
         name = "pylsp",
         cmd = { "pylsp" },
         -- Automatically tracks your git root, local scripts, or script directories
         root_dir = vim.fs.root(0, { ".git", "pyproject.toml", "setup.py" }) or vim.fn.getcwd(),
      })
   end
end


-- Automatically launch the internal link when opening a C or C++ file
vim.api.nvim_create_autocmd("FileType", {
   pattern = { "c", "cpp" },
   callback = launch_native_clangd,
})

vim.api.nvim_create_autocmd("FileType", {
   pattern = "python",
   callback = launch_native_pylsp,
})

-- Native LSP Hotkeys (Only active when inside a valid C project)
vim.api.nvim_create_autocmd("LspAttach", {
   callback = function(args)
      local bufnr = args.buf
      local map = vim.keymap.set

      -- Bind your manual autocomplete trigger to the compiler's native data stream
      vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

      -- Precision Navigation Hotkeys
      map("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
      map("n", "gr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to References" })
      map("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })

      -- Manually trigger code completion popup window whenever you want it!
      map("i", "<C-Space>", "<C-x><C-o>", { buffer = bufnr, desc = "Trigger Native Completion" })
   end,
})

-- Show the diagnostic/error message under the cursor in a floating window
map("n", "<leader>e", vim.diagnostic.open_float, { buffer = bufnr, desc = "Show Line Error" })
