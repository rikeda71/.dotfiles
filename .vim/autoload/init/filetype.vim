augroup fileTypeIndent
  autocmd!
  autocmd FileType python setlocal completeopt-=preview
  autocmd FileType python setlocal omnifunc=jedi#completions
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
