let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'

	Plug 'preservim/nerdtree'

    " Best dark
	Plug 'joshdick/onedark.vim'
	Plug 'arcticicestudio/nord-vim'
	Plug 'cocopon/iceberg.vim'
	Plug 'altercation/vim-colors-solarized'
	Plug 'tomasr/molokai'
    " Best light
    Plug 'therubymug/vim-pyte'
    " Best monotone
    Plug 'preservim/vim-colors-pencil'
    Plug 'dracula/vim'

    Plug 'itchyny/lightline.vim'
    Plug 'ap/vim-buftabline'

    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-fugitive'

    Plug 'tpope/vim-commentary'

    Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

    " TODO fix completion bug with snippets beginning with \
    Plug 'SirVer/ultisnips'

    Plug 'simnalamburt/vim-mundo'
    Plug 'wellle/targets.vim'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-surround'

	Plug 'whonore/Coqtail'
    "Plug 'joom/latex-unicoder.vim'

    "Plug 'vim-latex/vim-latex'
    Plug 'lervag/vimtex'

    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set mouse=a

let mapleader=" "
let maplocalleader=" "

"set relativenumber
set number
"set cursorline

set tabstop=4
set shiftwidth=4
set expandtab

set scrolloff=5

set foldmethod=indent
set foldlevelstart=99

set clipboard+=unnamedplus

set undofile

set spell spelllang=en_gb

set title


" Buffer management
nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>
nnoremap <leader>bd :bp <bar> bd # <CR>
nnoremap <leader>wh <c-w>h
nnoremap <leader>wj <c-w>j
nnoremap <leader>wk <c-w>k
nnoremap <leader>wl <c-w>l
nnoremap <leader>w<Left> <c-w><Left>
nnoremap <leader>w<Right> <c-w><Right>
nnoremap <leader>w<Up> <c-w><Up>
nnoremap <leader>w<Down> <c-w><Down>

" Remove search highlight
nnoremap <esc> :noh<CR><esc>

" Color scheme

" Use gui colors
set termguicolors

" Set Coq hightlight in nord color scheme
augroup CoqtailHighlights
  autocmd!
  autocmd ColorScheme dracula
    \  hi def CoqtailChecked ctermbg=0 guibg=#1D3824
    \| hi def CoqtailSent    ctermbg=53 guibg=#291616
augroup END

colorscheme dracula

" Highlight cursorline
" hi clear CursorLine
" augroup CLClear
"     autocmd! ColorScheme * hi clear CursorLine
" augroup END


" For fzf
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>bb :Buffers<CR>
nnoremap <leader>ag :Ag!<CR>
nnoremap <leader>fl :Lines!<CR>
nnoremap <leader>h :Help<CR>
nnoremap <leader>u :MundoToggle<CR>
nnoremap <leader>? :Maps<CR>


" Lightline
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" For GitGutter
set updatetime=100

let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-space>"
let g:UltiSnipsJumpBackwardTrigger="<c-s-space>"

" Latex
let g:vimtex_view_method = 'zathura'
autocmd Filetype tex setlocal linebreak


"" Commenting
" gcc: comment single line
" gcgc: uncomment connected lines
" gc: toggle comment of motion, selection, etc.

"" Coqtail
" <space>cj   -k   -l  move proof
" <space>cc start proof mode
" <space>cq end prove mode
" <space>cr restore panels

" --- Coq
"let g:coqtail_auto_set_proof_diffs = 'on'
function Coq_do_windows()
    let width = winwidth(0)
    if &columns - 110 > 110
        execute "vert res " . (&columns-110)
    else
        execute "vert res " . (&columns/2)
    endif
endfunction

nmap <leader>c. <leader>cl
nmap <M-down> <leader>cj
nmap <M-up> <leader>ck
nmap <M-right> <leader>cl
nmap <leader>cw :call Coq_do_windows()<CR>
imap <M-down> <c-o><leader>cj
imap <M-up> <c-o><leader>ck
imap <M-right> <c-o><leader>cl


let g:coqtail_noimap=1

