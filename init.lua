-- =========================
-- 1. Basic settings
-- =========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

vim.g.mapleader = " "

-- =========================
-- 2. LSP keymaps
-- =========================
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }

        local telescope = require("telescope.builtin")

        vim.keymap.set("n", "gd", telescope.lsp_definitions, opts)
        vim.keymap.set("n", "gr", telescope.lsp_references, opts)
        vim.keymap.set("n", "gi", telescope.lsp_implementations, opts)

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    end,
})

-- =========================
-- 3. Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- 4. Plugins
-- =========================
require("lazy").setup({

    -- =========================
    -- LSP
    -- =========================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Define servers
            vim.lsp.config("clangd", {
                capabilities = capabilities,
            })

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
            })

            -- Enable them
            vim.lsp.enable("clangd")
            vim.lsp.enable("rust_analyzer")
        end,
    },

    -- =========================
    -- Completion
    -- =========================
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },

    -- =========================
    -- Telescope
    -- =========================
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    -- =========================
    -- Treesitter
    -- =========================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            ensure_installed = { "c", "rust", "lua" },
            highlight = { enable = true },
        },
    },

    -- =========================
    -- Cargo / Rust helper
    -- =========================
    {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        opts = {
            completion = { crates = { enabled = true } },
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },

    -- =========================
    -- Theme
    -- =========================
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "night", -- storm | night | moon | day
                transparent = false,
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    section_separators = "",
                    component_separators = "",
                },
            })
        end,
    },
},
{
    -- Optional: disable luarocks warnings
    rocks = { enabled = false },
})

-- =========================
-- 5. Format on save
-- =========================
-- vim.api.nvim_create_autocmd("BufWritePre", {
    --     callback = function()
        --         vim.lsp.buf.format({ async = false })
        --     end,
        -- })
        --

local telescope = require("telescope.builtin")

vim.keymap.set("n", "<leader>gc", telescope.git_commits)
vim.keymap.set("n", "<leader>gs", telescope.git_status)
vim.keymap.set("n", "<leader>gb", telescope.git_branches)
