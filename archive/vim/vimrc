filetype off
set modelines=0

call plug#begin('~/.vim/plugged')
  "Core
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'bling/vim-airline'
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'
  Plug 'tpope/vim-fugitive'
  Plug 'mileszs/ack.vim'
  Plug 'vim-scripts/YankRing.vim'
  Plug 'jlanzarotta/bufexplorer'

  "Language-specific
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-haml'
  Plug 'othree/html5.vim'
  Plug 'kchmck/vim-coffee-script'
  Plug 'tpope/vim-cucumber'
  Plug 'dagwieers/asciidoc-vim'
  Plug 'elixir-lang/vim-elixir'
  Plug 'pangloss/vim-javascript'
  Plug 'mxw/vim-jsx'
  "Plug 'slashmili/alchemist.vim'
  "Plug 'fatih/vim-go'

  "Additional
  Plug 'w0rp/ale'
  Plug 'prettier/prettier'
  Plug 'vim-scripts/Rainbow-Parenthesis'
  Plug 'ervandew/supertab'
  Plug 'scrooloose/snippets'
  Plug 'tpope/vim-endwise'
  Plug 'vim-scripts/sessionman.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'tpope/vim-surround'
  Plug 'ryanoasis/vim-devicons'

  " Testing
  Plug 'airblade/vim-gitgutter'
  Plug 'mattn/emmet-vim'
  Plug 'sheerun/vim-polyglot'
  " Plug 'easymotion/vim-easymotion'
  
  " Themes
  Plug 'joshdick/onedark.vim'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'hzchirs/vim-material'
call plug#end()  

if (has("termguicolors"))
  set termguicolors
endif


syntax enable
set encoding=utf-8
set showcmd                     " display incomplete commands
filetype plugin indent on       " load file type plugins + indentation
set spelllang=en_us
set visualbell
set history=1000
set autoread
set showcmd
set cursorline
set ruler
set wildmenu
set wildmode=list:longest

"Allow usage of mouse in iTerm
set ttyfast
set mouse=a
set ttymouse=xterm2

set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set pastetoggle=<F2>

let mapleader=','
let g:mapleader=','

"" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter
set gdefault
set showmatch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Turn backup off, since most stuff is in git anyway...
set nobackup
set nowb
set noswapfile

silent !mkdir -p ~/\.vim_runtime/undos > /dev/null 2>&1
set undodir=~/.vim_runtime/undos
set undofile

" Themes
let g:material_style='palenight'
set background=dark
colorscheme vim-material

"let g:onedark_termcolors=256
"let g:onedark_terminal_italics=1
"set background=dark
"colorscheme onedark

"Airline/Powerline
let g:airline_powerline_fonts = 1
"let g:airline_theme='onedark'
let g:airline_theme='material'
let g:Powerline_symbols='fancy'
set laststatus=2 " Always show status line

set guioptions=Amg
set nofoldenable                " disable code folding

set wildignore+=tags,.hg,.git,.svn,*.pyc,*.spl,*.o,*.out,*.DS_Store,*.class,*.manifest,*~,#*#,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,*.xc*,*.pbxproj,*.xcodeproj/**,*.xcassets/**
set wildignore+=node-modules,*sass-cache*,log/**,tmp/**,vendor/**
let g:user_zen_expandabbr_key = '<c-Space>'
let g:use_zen_complete_tag = 1

set number
set autoindent
set linebreak
set scrolloff=8

set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

nmap <leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

"When vimrc is edited, reload it
autocmd BufWritePost .vimrc source %

"Netwr
let g:netrw_liststyle = 3

"Key Mappings
nnoremap <leader>a :Ack<CR>
nnoremap <leader>d :NERDTreeToggle<CR>

map <leader>e :e! ~/.vimrc<cr>
map <leader>E :e! ~/.gvimrc<cr>

"Navigate between splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Strip all trailing whitespace from current document
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

"Select text just pasted for further formatting
nnoremap <leader>v V`]


"Yankring
let g:yankring_history_file = '.vim_runtime/yankring_history'

"CtrlP Options
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_map = '<leader>,'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 20
let g:ctrlp_extensions = ['tag']

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|_site|node_modules)$',
  \ }

"I prefer CtrlP on top... #twss
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 1

let g:sparkupExecuteMapping='<C-e>'

" Syntastic config
let g:syntastic_javascript_checkers = ['standard', 'eslint']
let g:syntastic_javascript_standard_exec = "/usr/local/bin/standard"
let g:syntastic_javascript_eslint_exec = "/usr/local/bin/eslint"
autocmd bufwritepost *.js silent !standard --fix -w %
set autoread


"Save on lost focus
" au FocusLost * :wa

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>

"Cool macro to add = dividers
nnoremap <leader>1 yypVr=

autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
if has ('gui_running')
  autocmd! BufWritePost $MYVIMRC,$MYGVIMRC so $MYVIMRC | so $MYGVIMRC | echom "Reloaded " . $MYVIMRC . " and " . $MYGVIMRC | redraw
endif

" Standard/JS format on save
autocmd bufwritepost *.js silent !standard --fix %
set autoread
