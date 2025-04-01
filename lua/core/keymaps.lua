return {
  setup = function()
    -- Helper function for setting keymaps
    local function map(mode, lhs, rhs, opts)
      -- Initialize opts if not provided
      opts = opts or {}
      opts = vim.tbl_extend("force", {
        silent = true,
        desc = opts.desc or "No description", -- Ensure every mapping has a description
      }, opts)
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Leader key
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "
    map({ "n", "v" }, "<Space>", "<Nop>", { desc = "Unmap space leader" })

    -- Better window navigation
    map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
    map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
    map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
    map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

    -- Better navigation
    map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move cursor up" })
    map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move cursor down" })
    map("n", "<C-u>", "<C-u>zz", { desc = "Page up and center" })
    map("n", "<C-d>", "<C-d>zz", { desc = "Page down and center" })
    map("n", "n", "nzzzv", { desc = "Next search result and center" })
    map("n", "N", "Nzzzv", { desc = "Previous search result and center" })
    map("n", "G", "Gzz", { desc = "Go to end of file and center" })

    -- Redo
    map("n", "U", "<C-r>", { desc = "Redo" })

    -- Line manipulation
    map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
    map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

    -- EasyAlign
    map("x", "ga", "<Plug>(EasyAlign)", { desc = "Start EasyAlign in visual mode" })
    map("n", "ga", "<Plug>(EasyAlign)", { desc = "Start EasyAlign for motion/text object" })

    -- Cellular Automaton
    map("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", { desc = "Make it rain" })

    -- Toggle inlay hints
    map("n", "<leader>i", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end, { desc = "Toggle Inlay Hints" })
  end,
}
