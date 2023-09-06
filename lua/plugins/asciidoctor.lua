return {
  "habamax/vim-asciidoctor",
  config = function()
    vim.cmd([[
      " List of filetypes to highlight, default `[]`
      let g:asciidoctor_fenced_languages = ['python', 'c', 'cpp', 'rust']

      " Fold sections, default `0`.
      let g:asciidoctor_folding = 0

      " Fold options, default `0`.
      let g:asciidoctor_fold_options = 1
    ]])
  end,
  ft = { "adoc", "asciidoc", "asciidoctor" },
}
