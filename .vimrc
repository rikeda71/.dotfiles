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

" UTF-8
set fenc=utf-8

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

set viminfo=

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

" view
Plug 'itchyny/lightline.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'Yggdroot/indentLine'

" auto indent
Plug 'cohama/lexima.vim'

" other
Plug 'Shougo/vimproc.vim'
Plug 'scrooloose/nerdtree'
Plug 'ervandew/supertab'

if has('python3') && v:version >= 800

  "deoplete setting
  Plug 'Shougo/deoplete.nvim', {'for': ['c', 'cpp', 'ruby']}
  Plug 'roxma/nvim-yarp', {'for': ['c', 'cpp', 'ruby']}
  Plug 'roxma/vim-hug-neovim-rpc', {'for': ['c', 'cpp', 'ruby']}
  let g:deoplete#enable_at_startup = 1

  " intellisence
  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  imap <C-k>     <Plug>(neosnippet_expand_or_jump)
  smap <C-k>     <Plug>(neosnippet_expand_or_jump)
  xmap <C-k>     <Plug>(neosnippet_expand_target)

  " SuperTab like snippets behavior.
  imap <expr><TAB>
  \ pumvisible() ? "\<C-n>" :
  \ neosnippet#expandable_or_jumpable() ?
  \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
  smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
  \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

  " For conceal markers.
  if has('conceal')
    set conceallevel=2 concealcursor=i
  endif
  "set snippet file dir
  let g:neosnippet#snippets_directory='~/.vim/bundle/neosnippet-snippets/snippets/,~/.vim/snippets'

  " cpp settings
  Plug 'zchee/deoplete-clang', {'for': ['c', 'cpp']}
  let g:deoplete#sources#clang#libclang_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'

endif

" python settings
if has('python') && has('python3')
  Plug 'davidhalter/jedi-vim', {'for': 'python'}
  let g:jedi#auto_vim_configuration = 0
  let g:jedi#show_call_signatures=1
  let g:jedi#popup_select_first=1
  let g:jedi#force_py_version=3
  let g:SuperTabContextDefaultCompletionType="context"
  let g:SuperTabDefaultCompletionType="<c-n>"
Plug 'andviro/flake8-vim', {'for': 'python'}
let g:PyFlakeOnWrite = 1
let g:PyFlakeCheckers = 'pep8'
Plug 'hynek/vim-python-pep8-indent', {'for': 'python'}

endif

call plug#end()

filetype on
filetype plugin indent on


syntax enable

" 行番号
set relativenumber

colorscheme molokai
