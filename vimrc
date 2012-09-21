syntax on
filetype on
filetype plugin on
filetype indent on
colorscheme wombat256

set nu
set term=rxvt-unicode-256color
set t_Co=256
set autoindent
set textwidth=78
set backspace=indent,eol,start
set tabstop=4
set expandtab
set shiftwidth=4
set shiftround

set shiftwidth=4
set ruler
set hlsearch
set vb t_vb=
set showmatch
set viminfo='10,\"100,:20,%,n~/.viminfo

set tags+=,~/ctags/perl.tags,~/ctags/git.tags,~/ctags/haskell.tags

" use the xselection buffer
set clipboard=unnamed

" reselect visual block after indent/outdent
vnoremap < <gv
vnoremap > >gv

" move between windows
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" set leader
let mapleader = ","

" Jump to the start/end of the line using home row keys
noremap H ^
noremap L $

" toggle invisibles
noremap <Leader>i :set list!<CR>

" toggle invisibles
nnoremap <Leader>r :call g:ToggleNuMode()<CR>
function! g:ToggleNuMode()
    if(&rnu == 1)
        set nu
    else
        set rnu
    endif
endfunc

" set invisibles
set list
" set listchars=tab:▸\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

" return to last buffer
noremap <Leader><Leader> <C-^>

" spell check git commit messages
autocmd BufRead COMMIT_EDITMSG setlocal spell!

" Tag list
nnoremap t :Tlist<CR>

nnoremap <silent> <Leader>f :NERDTreeToggle<CR>

" drag current line/s vertically
noremap  J :m+<CR>
noremap  K :m-2<CR>
inoremap J <Esc>:m+<CR>
inoremap K <Esc>:m-2<CR>
vnoremap J :m'>+<CR>gv
vnoremap K :m-2<CR>gv

" CommandT
map <Leader>t :CommandT<CR>
map <Leader>T :CommandTBuffer<CR>
" map <Leader>t :CtrlP<CR>
" map <Leader>T :CtrlPBuffer<CR>
" map <Leader>m :CtrlPBuffer<CR>

let g:CommandTMaxFiles=20000
let g:ctrlp_map = ''  " Leave this empty to disable the default mapping
" let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_max_height = 50

" put cursor in the right place after a '.'
nmap . .`[

" automatically save when doing a :make
set autowrite

" make searches case-insensitive, unless they contain upper-case letters
set ignorecase
set smartcase

" show the `best match so far' as search strings are typed:
set incsearch

" use <Ctrl>+N/<Ctrl>+P to cycle through buffers:
nnoremap <C-N> :bn<CR>
nnoremap <C-P> :bN<CR>
nnoremap <silent> <C-C> :!ltags<Enter><Enter>

" pop open a tmux debug pane below
map <Leader>d :call TmuxDebugOpen()<CR>
map <Leader>D :call TmuxDebugClose()<CR>
map <silent> <Leader>x :w<CR>:call TmuxDebugRerun()<CR>

function! TmuxDebugOpen()
    let output = system('tmux split-window -l 12 && tmux select-pane -t 0')
endfunction

function! TmuxDebugClose()
    let output = system('tmux kill-pane -t 1')
endfunction

function! TmuxDebugRerun()
    let output = system('tmux send-keys -t 1 ')
endfunction


" highlight the current column on <F8>
highlight CursorColumn cterm=none
highlight CursorColumn ctermbg=blue
nnoremap <F8> :set invcursorcolumn<CR>

" highlight the current row on <F9>
highlight CursorLine cterm=none
highlight CursorLine ctermbg=blue
nnoremap <F9> :set invcursorline<CR>

" folding options
" set foldmethod=indent
" autocmd BufNewFile,BufRead * execute "normal " "zR"
"nnoremap  <silent>  <space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<cr>

" Treat angle brackets as matchable pairs
set matchpairs+=<:>

" Toggle paste mode
set pastetoggle=<F10>

" Edit at the end of the line
imap <C-e> <ESC>A

" Use the termcap that comes with vim
" set ttybuiltin

" set command completion colors
highlight Pmenu term=bold ctermbg=4

" unhighlight search matches...
map <Leader>s :nohlsearch<cr>

" ack for the word under the cursor
map <Leader>a :Ack <cword><CR>

" Highlight word at cursor without changing position
nnoremap <Leader>h *<C-O>

"
" remove end of line whitespace on write
" autocmd BufWritePre *.pl,*.pm,*.t,*.pod :call RmEolWhiteSpace()
map <Leader>w :call RmEolWhiteSpace()<CR>
function! RmEolWhiteSpace()
    let s:curLine = line('.')
    let s:curCol  = col('.')

    %s/\s\+$//e

    call cursor(s:curLine, s:curCol)
endfunction

"
" perl stuff
"
" autocmd FileType perl :noremap K :!perldoc <cword> <bar><bar> perldoc -f <cword><CR><CR>

" Use perl compiler for all *.pl and *.pm files.
autocmd BufNewFile,BufRead *.p? compiler perl
autocmd BufNewFile,BufRead *.t  set filetype=perl
autocmd BufNewFile,BufRead *.p? set makeprg=perl\ -c\ %
autocmd BufNewFile,BufRead *.t  set makeprg=perl\ -c\ %

autocmd BufNewFile,BufRead *.yml setlocal iskeyword=48-57,_,A-Z,a-z,-,:
autocmd BufNewFile,BufRead *.pl setlocal iskeyword=48-57,_,A-Z,a-z,:
autocmd BufNewFile,BufRead *.pm setlocal iskeyword=48-57,_,A-Z,a-z,:
autocmd BufNewFile,BufRead *.t setlocal iskeyword=48-57,_,A-Z,a-z,:

" Perl Tidy
nnoremap <silent> _t :%!perltidy -q<Enter>
vnoremap <silent> _t :!perltidy -q<Enter>

" add a use line for the word under the cursor
"
" make sure you have
" setlocal iskeyword=48-57,_,A-Z,a-z,-,:
" so colons are recognized as part of a keyword
function! PerlAddUseStatement()
    let s:package = input('Package? ', expand('<cword>'))
    " skip if that use statement already exists
    if (search('^use\s\+'.s:package, 'bnw') == 0)
        " below the last use statement, except for some special cases
        let s:line = search('^use\s\+\(constant\|strict\|warnings\|parent\|base\|5\)\@!','bnw')
        " otherwise, below the ABSTRACT (see Dist::Zilla)
        if (s:line == 0)
            let s:line = search('^# ABSTRACT','bnw')
        endif
        " otherwise, below the package statement
        if (s:line == 0)
            let s:line = search('^package\s\+','bnw')
        endif
        " if there isn't a package statement either, put it below
        " the last use statement, no matter what it is
        if (s:line == 0)
            let s:line = search('^use\s\+','bnw')
        endif
        " if there are no package or use statements, it might be a
        " script; put it below the shebang line
        if (s:line == 0)
            let s:line = search('^#!','bnw')
        endif
        " if s:line still is 0, it just goes at the top
        call append(s:line, 'use ' . s:package . ';')
    endif
endfunction

map <Leader>us :<C-u>call PerlAddUseStatement()<CR>

"
" end of perl stuff
"

" kepad keys mappings
imap <esc>OM <c-m>
map <esc>OM <c-m>
imap <esc>OP <nop>
map <esc>OP <nop>
imap <esc>OQ /
map <esc>OQ /
imap <esc>OR *
map <esc>OR *
imap <esc>OS -
map <esc>OS -

imap <esc>Op 0
imap <esc>Ol +
imap <esc>Om -
imap <esc>On ,
imap <esc>Op 0
imap <esc>Oq 1
imap <esc>Or 2
imap <esc>Os 3
imap <esc>Ot 4
imap <esc>Ou 5
imap <esc>Ov 6
imap <esc>Ow 7
imap <esc>Ox 8
imap <esc>Oy 9
imap <esc>Oz 0

" pairs
" noremap! "" ""<left>
" noremap! '' ''<left>
"
" noremap! (( ()<left>
" noremap! (<cr> (<cr>)<c-o>O
" noremap! (; ();<esc>hi
" noremap! (<cr>; (<cr>);<c-o>O
" noremap! ('; ('');<esc>hhi
" noremap! ("; ("");<esc>hhi
" noremap! (' ('')<esc>hi
" noremap! (" ("")<esc>hi
"
" noremap! {{ {}<left>
noremap! {<cr> {<cr>}<c-o>O
" noremap! {; {};<esc>hi
" " noremap! {<cr>; {<cr>};<c-o>O
" noremap! {'; {''};<esc>hhi
" noremap! {"; {""};<esc>hhi
" noremap! {' {''}<esc>hi
" noremap! {" {""}<esc>hi
"
" noremap! [[ []<left>
" noremap! [<cr> [<cr>]<c-o>O
" noremap! [; [];<esc>hi
" noremap! [<cr>; [<cr>];<c-o>O
" noremap! ['; [''];<esc>hhi
" noremap! ["; [""];<esc>hhi
" noremap! [' ['']<esc>hi
" noremap! [" [""]<esc>hi
