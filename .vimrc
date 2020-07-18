"====================
" 基本設定
"====================

" 一旦ファイルタイプ関連を無効化
filetype off
filetype plugin indent off

" 文字コード
set encoding=utf-8
scriptencoding utf-8

if &compatible
  set nocompatible
endif

" 現在の行を強調表示
set cursorline

" 行末の1文字先までカーソルを移動可能に
set virtualedit=onemore

" コマンドラインの補完
set wildmode=list:longest

" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" backspace使用可
set backspace=indent,eol,start
noremap!  

" 256色対応
set t_Co=256

" コマンドの補完
set wildmenu
set history=10000

" 最後に開いた位置を保持
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent! loadview

" F2 で貼り付けモードに入る
set pastetoggle=<f2>

" viminfoを作成しない
set viminfofile=NONE

" beep off
set belloff=all

" jj escape
function! ImInActivate()
  call system('fcitx-remote -c')
endfunction

inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>:call ImInActivate()<CR>

"====================
" 表示
"====================

" 入力中のコマンドをステータスに表示
set showcmd

" 括弧入力時の対応する括弧を表示
set showmatch

" ステータスラインを常に表示
set laststatus=2

" コマンドをステータスラインの下に表示
set showcmd

" ステータスラインの右側にカーソルの現在位置を表示する
set ruler

" 不可視文字を可視化
set list listchars=tab:»-,trail:-,nbsp:%

" 文字崩れの解消
set ambiwidth=double

"====================
" indent, tab
"====================

" スマートインデント
set smartindent

" 行頭以外のTab文字の表示幅
set tabstop=2

" 行頭でのTab文字の表示幅
set shiftwidth=2

" tabでのインデント
set softtabstop=2

" 改行時に自動でインデント
set autoindent

" tabを空白に
set expandtab

"====================
" ファイル関連
"====================

" ファイルを作らない
set nobackup
set noswapfile

" 編集中のファイルが変更されたら自動で読み直す
set autoread

" バッファが編集中でもその他のファイルを開けるように
set hidden

" clipboard setting
if has('nvim')
  set clipboard=unnamedplus
else
  set clipboard=unnamed,autoselect
endif

"====================
" 検索
"====================

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase

" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch

" 検索時に最後まで行ったら最初に戻る
set wrapscan

" 検索語をハイライト表示
set hlsearch

" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

"====================
" vim-plug
"====================


call plug#begin('~/.vim/plugged')

" colorscheme
Plug 'tomasr/molokai'
Plug 'micha/vim-colors-solarized'

" view
" Plug 'itchyny/lightline.vim'
let g:lightline = {
  \ 'colorscheme': 'powerline',
  \ }
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/indentLine'

" auto indent
Plug 'cohama/lexima.vim'

" other
Plug 'Shougo/vimproc.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'

if has('python3') && v:version >= 800

  " python settings
  Plug 'prabirshrestha/vim-lsp'
  Plug 'prabirshrestha/async.vim'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  let g:lsp_preview_autoclose = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_highlight_references_enabled = 1
  let g:asyncomplete_auto_popup = 1
  augroup MyLsp
  autocmd!
  " pip install python-language-server
  if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': { server_info -> ['pyls'] },
        \ 'whitelist': ['python'],
        \ 'workspace_config': {'pyls': {'plugins': {
        \   'pycodestyle': {'enabled': v:false},
        \   'jedi_definition': {'follow_imports': v:true, 'follow_builtin_imports': v:true},}}}
        \})
    autocmd FileType python call s:configure_lsp()
  endif
  augroup END
  function! s:configure_lsp() abort
    setlocal omnifunc=lsp#complete
    nnoremap <buffer> <C-]> :<C-u>LspDefinition<CR>
    nnoremap <buffer> gd :<C-u>LspDefinition<CR>
    nnoremap <buffer> gD :<C-u>LspReferences<CR>
    nnoremap <buffer> gs :<C-u>LspDocumentSymbol<CR>
    nnoremap <buffer> gS :<C-u>LspWorkspaceSymbol<CR>
    nnoremap <buffer> gQ :<C-u>LspDocumentFormat<CR>
    vnoremap <buffer> gQ :LspDocumentRangeFormat<CR>
    nnoremap <buffer> K :<C-u>LspHover<CR>
    nnoremap <buffer> <F1> :<C-u>LspImplementation<CR>
    nnoremap <buffer> <F2> :<C-u>LspRename<CR>
  endfunction
  let g:lsp_diagnostics_enabled = 0
  let g:lsp_diagnostics_echo_cursor = 0
  highlight lspReference ctermfg=red guifg=red ctermbg=green guibg=green
endif

" tex
Plug 'lervag/vimtex', {'for': 'tex'}
let g:vimtex_compiler_latexmk_engines={'_': '-pdfdvi'}
let g:vimtex_compiler_latexmk = {
    \ 'background': 1,
    \ 'build_dir': '',
    \ 'continuous': 1,
    \ 'options': [
    \    '-pdfdvi',
    \    '-verbose',
    \    '-file-line-error',
    \    '-synctex=1',
    \    '-interaction=nonstopmode',
    \],
    \}

let g:vimtex_view_general_viewer
      \ = '/Applications/Skim.app/Contents/SharedSupport/displayline'
let g:vimtex_view_general_options = '-r @line @pdf @tex'
" コンパイル結果のエラーメッセージにerrorがなくwarningだけである場合、メッセージを表示しない
let g:vimtex_quickfix_open_on_warning = 0
let g:SuperTabContextDefaultCompletionType="context"
let g:SuperTabDefaultCompletionType="<c-n>"
Plug 'dense-analysis/ale'
let g:ale_linters = {
  \ 'python': ['flake8', 'mypy'],
  \ }
let g:ale_fixers = {
  \  'python': ['black', 'isort'],
  \ }
let g:ale_python_auto_pipenv = 1
let g:ale_python_flake8_auto_pipenv = 1
let g:ale_python_flake8_options = '-m flake8 --max-line-length=88'
let g:ale_python_black_auto_pipenv = 1
let g:ale_python_black_use_global = 0
"let g:ale_python_black_options = '-m black --skip-string-normalization'
let g:ale_python_mypy_auto_pipenv = 1
let g:ale_python_mypy_options='--warn-unused-ignores'
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_completion_enabled = 1
let g:ale_history_enabled = 1
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}
Plug 'chase/vim-ansible-yaml'
Plug 'mechatroner/rainbow_csv'
Plug 'vim-airline/vim-airline'

call plug#end()

filetype on
filetype plugin indent on


syntax enable
set background=dark

" 行番号
set relativenumber

colorscheme molokai
"colorscheme solarized
let g:solarized_termcolors=256

