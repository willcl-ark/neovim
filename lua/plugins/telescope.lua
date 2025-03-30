return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
    },
    cmd = "Telescope",
    config = function()
      local actions = require("telescope.actions")
      local actions_state = require("telescope.actions.state")

      local diffview_open = function()
        -- Open in diffview
        local selected_entry = actions_state.get_selected_entry()
        local value = selected_entry.value
        -- close Telescope window properly prior to switching windows
        vim.api.nvim_win_close(0, true)
        vim.cmd("stopinsert")
        vim.schedule(function()
          vim.cmd(("DiffviewOpen %s^!"):format(value))
        end)
      end

      require("telescope").setup({
        pickers = {
          colorscheme = {
            enable_preview = true,
          },
          find_files = {
            -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
          git_commits = {
            mappings = {
              n = {
                ["<C-o>"] = actions.select_default,
                ["<CR>"] = diffview_open,
              },
              i = {
                ["<C-o>"] = actions.select_default,
                ["<CR>"] = diffview_open,
              },
            },
          },
        },
        defaults = {
          layout_strategy = "flex", -- Dynamic switch between horiz and vert
          layout_config = {
            flex = {
              height = 0.95,
              width = 0.95,
              prompt_position = "bottom",
              flip_columns = 160, -- horizontal if term wider than 160 cols
              horizontal = {
                preview_width = 0.50,
              },
              vertical = {
                prompt_position = "bottom",
                preview_cutoff = 50,
              },
            },
          },
          preview = {
            filesize_limit = 0.2, -- MB
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
          },
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { truncate = 5 },
          extensions = {
            fzf = {
              fuzzy = true, -- false will only do exact matching
              override_generic_sorter = true, -- override the generic sorter
              override_file_sorter = true, -- override the file sorter
              case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            },
          },
          mappings = {
            i = {
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-p>"] = actions.cycle_history_prev,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<esc>"] = actions.close,
              -- ["<C-d>"] = actions.delete_buffer + actions.move_to_top,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
            },
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
              ["?"] = actions.which_key,
            },
          },
        },
      })
    end,
    -- stylua: ignore start
    keys = {
        { "<leader>?",        "<cmd>Telescope oldfiles<cr>",                       desc = "[?] Find recently opened files" },
        { "<leader><leader>", "<cmd>Telescope buffers<cr>",                        desc = "[ ] Find existing buffers" },
        { "<leader>sf",       "<cmd>Telescope find_files <cr>",                    desc = "[S]earch [F]iles" },
        { "<leader>sw",       "<cmd>Telescope grep_string<cr>",                    desc = "[S]earch [W]ord" },
        { "<leader>sg",       "<cmd>Telescope live_grep<cr>",                      desc = "[S]earch by [G]rep" },
        { "<leader>ss",       "<cmd>Telescope live_grep search_dirs={'src/'}<cr>", desc = "[S]earch [S]rc folder with Grep" },
        { "<leader>sh",       "<cmd>Telescope help_tags<cr>",                      desc = "[S]earch [H]elp" },
        { "<leader>sm",       "<cmd>Telescope marks<cr>",                          desc = "[S]earch [M]arks" },
        { "<leader>sq",       "<cmd>Telescope quickfix<cr>",                       desc = "[S]earch [Q]uickfix list" },
        { "<leader>sc",       "<cmd>Telescope git_commits<cr>",                    desc = "[S]earch [C]ommits" },
        { "<leader>sj",       "<cmd>Telescope jumplist<cr>",                       desc = "[S]earch [J]ump list" },
        { "<leader>sk",       "<cmd>Telescope keymaps<cr>",                        desc = "[S]earch [K]eymaps" },
        { "<leader>st",       "<cmd>Telescope colorscheme<cr>",                    desc = "[S]earch [T]hemes" },
        { "<leader>sr",       "<cmd>Telescope resume<cr>",                         desc = "[S]earch [R]esume" },
        {
            "<leader>sb",
            function()
                require("telescope.builtin").current_buffer_fuzzy_find({ fuzzy = false, case_mode = "ignore_case" })
            end,
            desc = "[S]earch [B]uffer Fuzzily",
        },
    },
    -- stylua: ignore end
  },
}
