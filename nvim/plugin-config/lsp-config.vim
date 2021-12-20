" lspconfig
" https://github.com/neovim/nvim-lspconfig

" Mappings
nnoremap <silent> <C-k>      <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader>D  <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <leader>e  <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> <leader>q  <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <leader>wa <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <silent> <leader>wl <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <silent> <leader>wr <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> g0         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gW         <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> ga         <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> Ä          <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> ä          <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
