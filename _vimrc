"---------------------------------------------------------------
" WINDOWS SPECIAL 
"---------------------------------------------------------------
" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=$VIM/bundle/vundle
set rtp+=$VIM/bundle/vim-ycm-windows-x64
call vundle#rc("$VIM/bundle")

" let Vundle manage Vundle required! 
Bundle 'gmarik/vundle'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'vim-scripts/Align'
Bundle 'vim-scripts/Vim-R-plugin'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'SirVer/ultisnips'
Bundle 'fholgado/minibufexpl.vim'
Bundle 'bling/vim-airline'
Bundle 'Lokaltog/powerline-fonts'
Bundle 'kien/ctrlp.vim'
"Bundle 'Lokaltog/vim-powerline'
"Bundle 'Valloric/YouCompleteMe'

" vim-scripts repos
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
"Bundle 'file:///Users/gmarik/path/to/plugin'

filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..
 
"---------------------------------------------------------------
" WINDOWS SPECIAL 
"---------------------------------------------------------------
"Remove the <Alt> windows special key
set winaltkeys=no

"---------------------------------------------------------------
" GLOBAL LOGIC
"---------------------------------------------------------------
" Attempt to determine the type of a file based on its name and possibly its
" contents.  Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype plugin on
filetype indent on

"The 'syntax enable' command will keep your current color settings.  This
"allows using 'highlight' commands to set your preferred colors before or
"after using this command.  If you want Vim to overrule your settings with the
"defaults, use syntax on
syntax   enable

"autoreload the vimrc when saved
autocmd! bufwritepost $VIM/_vimrc source %

"---------------------------------------------------------------
" INDENTATION LOGIC
" http://www.vim.org/scripts/script.php?script_id=231
"---------------------------------------------------------------
set noexpandtab
set cindent
set tabstop=4            " To cause the TAB file-character to be displayed as mod-N in vi and vim
set softtabstop=4        " Standard vi interprets the tab key literally, but there are popular
                         " vi-derived alternatives that are smarter, like vim. To get vim to interpret
                         " tab as an ``indent'' command instead of an insert-a-tab command
set shiftwidth=4         " To set the mod-N indentation used when you hit the tab key in vim
set cinoptions=(0,u0,U0)
"forbid the automatic comment 
"NOTE: this is alright because we can use NERDCommenter anyway
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"---------------------------------------------------------------
" MOUSE AND OTHER STUFF
" http://nvie.com/posts/how-i-boosted-my-vim/
"---------------------------------------------------------------
set bs=2                               " To enable backspace == delete
set scrolloff=999                      " Always have the cursor in middle of the screen
set showmatch                          " set show matching parenthesis
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode                           " Show partial commands in the last line of the screen
set hidden                             " It hides buffers instead of closing them
set history=1000                       " remember more commands and search history
set undolevels=1000                    " use many muchos levels of undo
set visualbell                         " don't beep
set noerrorbells                       " don't beep
set colorcolumn=100                    " print red column at column 100
" set wildignore=*.swp,*.bak,*.pyc,*.class

"---------------------------------------------------------------
" SAVE LOGIC 
"---------------------------------------------------------------
set nobackup             " no backup
set noswapfile           " no swap
set nowritebackup

"---------------------------------------------------------------
" META KEYS
"---------------------------------------------------------------
for i in range(104,108)
	let c = nr2char(i)
	exec "set <M-".c.">=\<Esc>".c
endfor
"for i in range(17,20)
	"let c = nr2char(i)
	"exec "set <M-".c.">=\<Esc>".c
"endfor

"---------------------------------------------------------------
" BUFFER LOGIC
"---------------------------------------------------------------
"left/right arrows to switch buffers in normal mode
nmap <c-Tab> :bnext<CR>			
nmap <c-S-Tab> :bprevious<CR>

"---------------------------------------------------------------
" WINDOW LOGIC
"---------------------------------------------------------------
nmap <c-down> <c-w>j
nmap <c-up> <c-w>k
nmap <c-left> <c-w>h
nmap <c-right> <c-w>l

"---------------------------------------------------------------
" SEARCH LOGIC
"---------------------------------------------------------------
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  " case-sensitive otherwise
"tired of clearing highlighted searches by searching for ldsfhjkhgakjk
nmap <silent> /# :nohlsearch<CR>  

"-----------------------------------------------------------------------
" COLORSCHEME LOGIC
"-----------------------------------------------------------------------
set t_Co=256
set guifont=Inconsolata_for_Powerline:h10:cANSI
set encoding=utf-8

"autocmd BufEnter,FileType *
"	\   if &ft ==# 'c' || &ft ==# 'cpp' || &ft ==# 'vim'| colors af |
"	\   elseif &ft ==? 'r' | colors desert |
"	\   else | colors default |
"	\   endif

"-----------------------------------------------------------------------
" COMPLETION LOGIC (see supertab in _vim_plugin)
"-----------------------------------------------------------------------
"autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType R set completeopt=longest,menuone

"---------------------------------------------------------------
" STATUS LINE LOGIC
" http://www.point-libre.org/~dimitri/blog/index.php/2006/08/01/138
" http://stackoverflow.com/questions/9065941/how-can-i-change-vim-status-line-colour
"---------------------------------------------------------------
"set statusline=[%F]\ [TYPE=%Y]\ [POS=%04l,%04v]\ [%p%%]\ [LEN=%L]

"function! InsertStatuslineColor(mode)
  "if a:mode == 'i'
    "hi statusline guibg=darkgreen ctermfg=white guifg=Black ctermbg=darkgreen
  "else
    "hi statusline guibg=white ctermfg=black guifg=Black ctermbg=white
  "endif
"endfunction

"" default the statusline to green when entering Vim
"au InsertEnter * call InsertStatuslineColor(v:insertmode)
"au InsertLeave * hi statusline guibg=darkred ctermfg=white guifg=Black ctermbg=darkred

" dialogue asking if you wish to save changed files.
set confirm
" Set the command window height to 2 lines, to avoid many cases of having to
" 'press <Enter> to continue'
set cmdheight=2
" Always display the status line, even if only one window is displayed
set laststatus=2

"---------------------------------------------------------------
" FOLD LOGIC
"---------------------------------------------------------------
set foldmethod=indent
set foldlevel=99
"set foldmethod=manual
set foldmarker={,}

"---------------------------------------------------------------
" CURSOR LINE LOGIC
"---------------------------------------------------------------
"set cursorline
"hi CursorLine cterm=NONE ctermbg=grey ctermfg=white guibg=darkred guifg=white
"hi CursorColumn cterm=NONE ctermbg=lightgrey ctermfg=black guibg=lightgrey guifg=lightgrey
"nnoremap <Leader>c :hi CursorLine cterm=NONE ctermbg=grey ctermfg=white guibg=darkred guifg=white<CR>

" Set an orange cursor in insert mode, and a red cursor otherwise.
" Works at least for xterm and rxvt terminals.
" Does not work for gnome terminal, konsole, xfce4-terminal.
"if &term =~ "xterm\\|rxvt"
"  :silent !echo -ne "\033]12;red\007"
"  let &t_SI = "\033]12;orange\007"
"  let &t_EI = "\033]12;red\007"
"  autocmd VimLeave * :!echo -ne "\033]12;red\007"
"endif

"----------------------------------------------------------------------
" MARKING LOGIC
" see http://www.linux.com/archive/articles/54159
"----------------------------------------------------------------------
set viminfo='100,f1

"----------------------------------------------------------------------
" VIEWS LOGIC
" see
"----------------------------------------------------------------------
"autocmd BufWritePost * silent mkview
"autocmd BufWinLeave * silent mkview
"autocmd BufWinEnter * silent loadview

"-----------------------------------------------------------------------
"VIMDIFF
"http://blog.objectmentor.com/articles/2008/04/30/vim-as-a-diff-merge-tool
"-----------------------------------------------------------------------
"set diffexpr=MyDiff()
"function MyDiff()
  "let opt = '-a --binary '
  "if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  "if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  "let arg1 = v:fname_in
  "if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  "let arg2 = v:fname_new
  "if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  "let arg3 = v:fname_out
  "if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  "let eq = ''
  "if $VIMRUNTIME =~ ' '
	"if &sh =~ '\<cmd'
	  "let cmd = '""' . $VIMRUNTIME . '\diff"'
	  "let eq = '"'
	"else
	  "let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
	"endif
  "else
	"let cmd = $VIMRUNTIME . '\diff'
  "endif
  "execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
"endfunction

"2013-09-28: I had to had this so that vim knows where to find a diff.exe
let $PATH.=';C:/MyPgm/msys64/bin'
if &diff
        colorscheme evening
endif
set diffopt=filler
set diffopt+=iwhite

"---------------------------------------------------------------
" MAPS
"---------------------------------------------------------------
"go to the .h automatically
map <F3> :e %:p:s,\/include\/,X123X,:s,\/src\/,\/include\/,:s,X123X,\/src\/,:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>
"display date
inoremap <Leader>date <C-R>=strftime("%Y-%m-%d")<CR>
inoremap <Leader>time <C-R>=strftime("%H:%M:%S")<CR>
inoremap <Leader>dt <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>

"allow easier moving blocks of code
vnoremap < <gv
vnoremap > >gv

"---------------------------------------------------------------
" ORTHOGRAPHE 
"---------------------------------------------------------------
"http://blog.fedora-fr.org/metal3d/post/Correction-orthographique-et-grammaticale-avec-Vim
"this function allow to switch between french/english dictinaries easily
function! <SID>ToggleSpell()
    let spelllang_list = [ 'fr', 'en' ]
    let string = []

    for i in range(len(spelllang_list))
        call add(string, i+1 . ") " . spelllang_list[i])
    endfor

    if ! &spell
        let &spell = 1
        let selection = inputlist(string)
        let &spelllang = spelllang_list[selection-1]
    else
        let &spell = 0
        echo "'spell' disabled..."
    endif
endfunction

noremap <F7> :call <SID>ToggleSpell()<CR>
"This allow easy spell fixing, in insert mode and normal mode
imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <c-f> [s1z=<c-o>

"let g:languagetool_jar='$VIM\LanguageTool-2.2\languagetool-commandline.jar'

"---------------------------------------------------------------
" F-MAPS THAT ARE ALREDY DEFINED
"---------------------------------------------------------------
"F1 : call NERDTreeToggle()
"F2 : mode paste
"F3 : change .cpp to .h
"F4 :
"F5 :
"F6 :
"F7 : ORTHOGRAPHE
"F8 :
"F9 :
"F0 :
"---------------------------------------------------------------

source $VIM/_vimrc_plugin
