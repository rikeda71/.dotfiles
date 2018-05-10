augroup python
  autocmd!
  autocmd FileType python setlocal completeopt-=preview
  autocmd FileType python setlocal omnifunc=jedi#completions
  autocmd BufNewFile,BufRead setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END
