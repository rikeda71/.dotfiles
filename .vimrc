" setting
" 構文ハイライトを有効
syntax enable
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" 不可視文字を可視化
set list listchars=tab:»-,trail:-,nbsp:%,eol:↲
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2
" 改行時に自動でインデントを行う
set autoindent

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

" backspace使用可
set backspace=indent,eol,start
noremap!  

" 256色対応
set t_Co=256

" rubyが遅くならないように対策
set re=1

" powerline設定
set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

"NeoBundle Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
let OSTYPE = system('uname')
if OSTYPE == "Linux\n"
  set runtimepath^=/home/user/.vim/bundle/neobundle.vim/
  call neobundle#begin(expand('/home/user/.vim/bundle'))
else
  set runtimepath^=/home/riked/.vim/bundle/neobundle.vim/
  call neobundle#begin(expand('/home/riked/.vim/bundle'))
endif

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

" powerline
NeoBundle 'Lokaltog/powerline', {'rtp' : 'powerline/bindings/vim'}

" solarized
NeoBundle 'altercation/vim-colors-solarized'

" molokai
NeoBundle 'tomasr/molokai'

" hybrid
NeoBundle 'w0ng/vim-hybrid'

"railscasts
NeoBundle 'jpo/vim-railscasts-theme'

" Required:
call neobundle#end()

"colorscheme
colorscheme railscasts

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"End NeoBundle Scripts-------------------------


