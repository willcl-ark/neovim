return {
  cmd = { "basedpyright-langserver", "--stdio" },
  root_markers = { "pyproject.toml", "setup.py", ".git" },
  filetypes = { "python" },
  single_file_support = true,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        -- Use Ruff's import organizer
        disableOrganizeImports = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { "*" },
      },
    },
  },
}
