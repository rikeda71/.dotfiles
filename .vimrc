"====================
" 基本設定
"====================

" 文字コード
set encoding=utf-8
scriptencoding utf-8

if &compatible
  set nocompatible
endif

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

" 最後に開いた位置を保持
autocmd BufWinLeave ?* silent mkview
autocmd BufWinEnter ?* silent loadview

" コマンドの補完
set wildmenu
set history=1000

augroup MyAutoCmd
  autocmd!
  autocmd BufWrite * mkview
  autocmd BufRead * silent! loadview
augroup end

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
" dein.vim
"====================

let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim 自体のインストール
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.cim/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" setting
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" 未インストールのプラグインをインストール
if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
