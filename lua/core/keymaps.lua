return {
  setup = function()
    -- Set <space> as the leader key
    -- See `:help mapleader`
    --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      opts.silent = opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Unset leader key mappings
    map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

    -- Deal with word wrap
    map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
    map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

    -- Center cursor after screen jump
    map("n", "<C-u>", "<C-u>zz")
    map("n", "<C-d>", "<C-d>zz")

    -- Center search results
    map("n", "n", "nzzzv")
    map("n", "N", "Nzzzv")

    -- Center after linejump
    map("n", "G", "Gzz")

    -- Move highlighted lines with ctrl+k/j
    map("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move highlighted lines down" })
    map("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move hightligted lines up" })

    -- Sync OBC to server
    map("n", "<leader>so", ":!./sync<CR>", { desc = "[S]ync [O]BC" })
    map(
      "n",
      "<leader>ga",
      ":!asciidoctor -r asciidoctor-diagram --verbose --trace index.adoc<CR>",
      { desc = "[M]ake [A]sciidoctor" }
    )

    -- Cellular Automaton
    map("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
  end,
}
