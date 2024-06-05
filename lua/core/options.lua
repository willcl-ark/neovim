return {
    setup = function()
        -- See `:help vim.o`
        local opt = vim.opt

        -- Set highlight on search
        opt.hlsearch = false

        -- Make line numbers default
        opt.number = true
        -- Use relative numbers
        opt.relativenumber = true
        -- Don't show less than 8 lines of context
        opt.scrolloff = 8

        -- Always show sign column to avoid text shifting
        opt.signcolumn = "yes"

        -- Don't wrap unless we call :wrap
        opt.wrap = false

        -- Split in sane ways
        opt.splitbelow = true
        opt.splitright = true

        -- Tab settings
        opt.expandtab = true
        opt.shiftwidth = 4
        opt.tabstop = 4
        opt.softtabstop = 4

        -- Use bash as shell instead of fish
        opt.shell = os.getenv("BASH")

        -- Enable mouse mode
        opt.mouse = "a"

        -- Enable break indent
        opt.breakindent = true

        -- Save undo history
        opt.undofile = true

        -- Case insensitive searching UNLESS /C or capital in search
        opt.ignorecase = true
        opt.smartcase = true

        -- Decrease update time
        opt.updatetime = 250

        -- Set colorscheme
        opt.termguicolors = true
        require("plugins.colorscheme")
        SetupColorScheme()

        -- Show `` in markdown files
        opt.conceallevel = 0

        -- Highlight current line
        opt.cursorline = true

        -- Set completeopt to have a better completion experience
        opt.completeopt = "menuone,noselect"

        -- Python venv
        local py_env_var = os.getenv("NVIM_PYTHON")
        local py3_env_var = os.getenv("NVIM_PYTHON3")
        vim.g.python_host_prog = py_env_var and py_env_var or "python"
        vim.g.python3_host_prog = py3_env_var and py3_env_var or "python3"

        -- Use system clipboard
        opt.clipboard = "unnamedplus"

        -- Show trailing whitespace
        opt.listchars = "trail:~,tab:>-,nbsp:␣"
        opt.list = true

        -- Unified status bar for all splits
        opt.laststatus = 3

        -- Don't show mode as we use status line
        opt.showmode = false

        -- use bear to Make
        opt.makeprg = "bear -- make -j16"

        -- Load cfilter by default
        vim.cmd [[packadd cfilter]]

        -- Continue indentation on wrapped lines
        opt.breakindent = true
        opt.linebreak = true
        opt.breakindentopt = 'list:-1'
    end,
}
