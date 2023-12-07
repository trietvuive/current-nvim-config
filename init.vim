set number mouse=a ts=4 sts=-1 sw=4 hls cindent

" indent rule
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let g:python3_host_prog = 'C:\Python310\python3'

set tabstop=4
set shiftwidth=4
set noexpandtab softtabstop=0
set autoindent
set smartindent
set smarttab
set scl=yes
set clipboard+=unnamedplus

set encoding=utf-8
set completeopt-=preview
set scrolloff=3
set ff=unix

au BufRead,BufNewFile *.r2py set filetype=python
au BufRead,BufNewFile *.h set filetype=cpp

call plug#begin('~/AppData/Local/nvim/autoload/plugged')

" Folding code
Plug 'https://github.com/pseewald/vim-anyfold'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}


" copied from Leon
if (has('nvim')) | Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins', 'for': 'python'} | endif

Plug 'ycm-core/YouCompleteMe'

Plug 'tpope/vim-commentary'
Plug 'SirVer/ultisnips', {} | Plug 'honza/vim-snippets', {'on': []}
Plug 'lervag/vimtex', {'for': 'tex'}

Plug 'lifepillar/vim-gruvbox8'
Plug 'lambdalisue/fern.vim'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'xolox/vim-misc'
Plug 'sainnhe/edge'
Plug 'sainnhe/everforest'
Plug 'sainnhe/sonokai'
Plug 'chriskempson/base16-vim'
Plug 'gkapfham/vim-vitamin-onec'
Plug 'NLKNguyen/papercolor-theme'
Plug 'joshdick/onedark.vim'
Plug 'doums/darcula'
Plug 'phanviet/vim-monokai-pro'
Plug 'lervag/vimtex'
Plug 'preservim/nerdtree'

Plug 'jez/vim-better-sml'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" copied from Leon


call plug#end()

" Set colorscheme
color koehler

" Quit + save everything with a comma
nnoremap , :xa <CR>

" Quit + save with a dot
nnoremap . :x <CR>

" Bind ctrl+s with save
:nmap <c-s> :w<CR>
:imap <c-s> <Esc>:w<CR>a

" Bind ctrl+z with undo
nnoremap <C-Z> u
inoremap <C-Z> <C-O>u

" C++ template
:autocmd BufNewFile *.cpp 0r ~/AppData/Local/nvim/templates/skeleton.cpp

" Latex template
:autocmd BufNewFile *.tex 0r ~/AppData/Local/nvim/templates/skeleton.tex

" Indent on curly braces and line skip 
inoremap {<Enter> {<Enter>}<Esc>O


" autocompile
augroup compile
    autocmd!
    autocmd filetype java map <silent> <F5> :w <bar> :!javac % <CR> :exec ':term java '.shellescape('%:r') <CR>
    autocmd filetype tex map <F5> :w <bar> :VimtexCompile <CR>
    autocmd filetype cpp map <F5> :w <bar> :!del out.exe && g++ -std=c++2a -O2 -Wall -fno-sanitize-recover -o out % && out.exe <CR>
    autocmd filetype python map <F5> :w <bar> :!python3 % <CR>
								
augroup end

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "lua", "rust" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { "c", "rust", "latex" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF



" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on
:au BufNewFile,BufRead * set syntax=on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" YCM with VimTeX
if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme

" settings for sumatraPDF
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = ","
