"====================
" 基本設定
"====================

" 構文ハイライトを有効
syntax enable

" UTF-8
set fenc=utf-8

" 行番号を表示
set number

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

" clipboardとヤンクを結びつけ
set clipboard=unnamed,autoselect

" 最後に開いた位置を保持
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview


"====================
" 表示
"====================

" 入力中のコマンドをステータスに表示
set showcmd

" 括弧入力時の対応する括弧を表示
set showmatch

" ステータスラインを常に表示
set laststatus=2

" ファイル名表示
set statusline=%F

" 変更チェック表示
set statusline+=%m

" 読み込み専用かどうか表示
set statusline+=%r

" これ以降は右寄せ表示
set statusline+=%=

" file encoding
set statusline+=[ENC=%{&fileencoding}]

" 現在行数/全行数
set statusline+=[LOW=%l/%L]

" 不可視文字を可視化
set list listchars=tab:»-,trail:-,nbsp:%, 


"====================
" indent, tab
"====================

" スマートインデント
set smartindent

" tabを空白に
set expandtab

" 行頭以外のTab文字の表示幅
set tabstop=2

" 行頭でのTab文字の表示幅
set shiftwidth=2

" 改行時に自動でインデント
set autoindent


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
" NeoBundle
"====================

if &compatible
  set nocompatible
endif

" Required:
set runtimepath^=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" Add or remove your Bundles here:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'ctrlpvim/ctrlp.vim'
NeoBundle 'flazz/vim-colorschemes'

" You can specify revision/branch/tag.
NeoBundle 'Shougo/vimshell', { 'rev' : '3787e5' }

" unite.vim
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimproc', {
  \ "build": {
  \   "windows"   : "make -f make_mingw32.mak",
  \   "cygwin"    : "make -f make_cygwin.mak",
  \   "mac"       : "make -f make_mac.mak",
  \   "unix"      : "make -f make_unix.mak",
  \ }}

" NERDTree
NeoBundle 'scrooloose/nerdtree'

" neocomplcache
NeoBundle 'Shougo/neocomplcache'

" molokai
NeoBundle 'tomasr/molokai'

" jedi-vim
if has('python') && has('python3')
  NeoBundle 'davidhalter/jedi-vim'
  NeoBundle 'ervandew/supertab'
  autocmd FileType python setlocal completeopt-=preview
  autocmd FileType python setlocal omnifunc=jedi#completions
  let g:jedi#auto_vim_configuration = 0
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif
  let g:jedi#show_call_signatures=2
  let g:jedi#force_py_version=3
  set omnifunc=jedi#completions
  let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^. \t]\.\w*'
endif

" pep8
NeoBundle "andviro/flake8-vim"
let g:PyFlakeOnWrite = 1
let g:PyFlakeCheckers = "pep8"
NeoBundle "hynek/vim-python-pep8-indent"


" Required:
call neobundle#end()

" Required:
filetype plugin indent on

" colorscheme
set background=dark
colorscheme molokai

NeoBundleCheck
