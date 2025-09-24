{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Extra packages available to nvim
    extraPackages = with pkgs; [
      # Language servers
      lua-language-server
      nil # Nix LSP
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      nodePackages.bash-language-server
      gopls
      pyright
      rust-analyzer

      # Formatters
      nixpkgs-fmt
      prettier
      black
      rustfmt
      gofumpt

      # Tools
      ripgrep
      fd
      tree-sitter
    ];

    # Basic configuration
    extraConfig = ''
      " Basic settings
      set encoding=utf-8
      set fileencoding=utf-8
      set fileencodings=utf-8
      set bomb
      set binary
      set ttyfast

      " UI settings
      set number
      set relativenumber
      set cursorline
      set showcmd
      set showmode
      set showmatch
      set ruler
      set laststatus=2
      set wildmenu
      set wildmode=list:longest,full
      set cmdheight=1
      set title

      " Search settings
      set hlsearch
      set incsearch
      set ignorecase
      set smartcase

      " Indentation
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2
      set autoindent
      set smartindent

      " No backup files
      set nobackup
      set nowritebackup
      set noswapfile

      " Better display
      set wrap
      set linebreak
      set scrolloff=8
      set sidescrolloff=15

      " Split settings
      set splitbelow
      set splitright

      " Enable mouse
      set mouse=a

      " Clipboard
      set clipboard=unnamedplus

      " Undo
      set undofile
      set undodir=$HOME/.local/share/nvim/undo
      set undolevels=1000
      set undoreload=10000

      " Leader key
      let mapleader = ","
      let g:mapleader = ","

      " Quick save
      nnoremap <leader>w :w!<CR>

      " Clear search highlight
      nnoremap <leader><space> :nohlsearch<CR>

      " Navigate splits
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      " Tab navigation
      nnoremap <leader>tn :tabnew<CR>
      nnoremap <leader>tc :tabclose<CR>
      nnoremap <leader>to :tabonly<CR>
      nnoremap <leader>tm :tabmove<CR>
      nnoremap <leader>t<leader> :tabnext<CR>
      nnoremap <leader>th :tabprevious<CR>

      " Buffer navigation
      nnoremap <leader>bn :bnext<CR>
      nnoremap <leader>bp :bprevious<CR>
      nnoremap <leader>bd :bdelete<CR>

      " Terminal settings
      tnoremap <Esc> <C-\\><C-n>
      tnoremap <C-w> <C-\\><C-n><C-w>

      " Auto commands
      augroup auto_commands
        autocmd!
        " Return to last edit position
        autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        " Remove trailing whitespace on save
        autocmd BufWritePre * :%s/\s\+$//e
        " Format options
        autocmd FileType * setlocal formatoptions-=cro
      augroup END

      " File type specific settings
      autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4
      autocmd FileType go setlocal noexpandtab shiftwidth=4 softtabstop=4 tabstop=4
      autocmd FileType yaml setlocal shiftwidth=2 softtabstop=2 tabstop=2
      autocmd FileType json setlocal shiftwidth=2 softtabstop=2 tabstop=2
      autocmd FileType nix setlocal shiftwidth=2 softtabstop=2 tabstop=2
    '';

    # Note: For a full Neovim configuration, we'll later import
    # the existing ~/.config/nvim setup or create a more comprehensive
    # Nix-based configuration with plugins managed by Nix
  };

  # Create nvim directories
  xdg.dataFile."nvim/undo/.keep".text = "";

  # Link existing nvim config if it exists
  # This can be replaced with a full Nix configuration later
  xdg.configFile."nvim".source =
    let
      nvimConfigPath = "${config.home.homeDirectory}/.config/nvim";
    in
      if builtins.pathExists nvimConfigPath
      then config.lib.file.mkOutOfStoreSymlink nvimConfigPath
      else pkgs.writeTextDir "init.lua" ''
        -- Minimal init.lua
        -- TODO: Migrate full nvim configuration
        vim.notify("Neovim configuration needs to be migrated to Nix", vim.log.levels.INFO)
      '';
}