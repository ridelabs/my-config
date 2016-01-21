set nocompatible
"source $VIMRUNTIME/vimrc_example.vim
behave xterm
"hi Normal guibg=darkblue guifg=white
hi Normal guibg=black guifg=white
"hi Normal guibg=DeepSkyBlue4 guifg=honeydew
"hi Normal guibg=DarkCyan guifg=honeydew
syntax on
set wmh=0
set bs=2
set hlsearch
set incsearch
set tabstop=4
set shiftwidth=4
set expandtab
set showmatch
set hidden
set autoindent
set splitbelow
set suffixes=.aux,.bak,.dvi,.gz,.idx,.log,.ps,.swp,.tar,.class,.jar
set nostartofline
set showmode
set ttyfast
set ttyscroll=0
set report=0
set ruler
set noignorecase
" extended regex
set magic 
set pastetoggle=<f9> " toggle paste mode
set laststatus=2
set statusline=[%n]\ %f\ %(\(%MMODIFIED%M%R%H)%)\ Pos=<l=%l\,c=%c%V,b=%o>\ %P\ ASCII=%b\ HEX=%B 
set wildchar=<TAB> " tab completion
set wildmenu "pretty menu when tabbing
set fileformat=unix " always write as unix
" set visualbell " don't annoy my classmates with an audio bell!


"       statusline:  customize contents of the windows' status line.
"       I prfer it this way:
"       Show the current buffer number and filename with info on
"       modification, read-only, and whether it is a help buffer
"       (show only when applied).
" set   statusline=[%n]\ %f\ %(\ %M%R%H)%)
"
"       Move the rest to the right side, eg a copyright text:
" set   statusline=[%n]\ %f\ %(\ %M%R%H)%)%=(c)\ Sven\ Guckes
"
"       Show the value of the current character in ASCII and Hex:
" set   statusline=[%n]\ %f\ %(\ %M%R%H)%)\=ASCII=%b\ HEX=%B
"
"       Show the current position with line+column+virtual_column:
" set   statusline=[%n]\ %f\ %(\ %M%R%H)%)\=Pos=<%l\,%c%V>\ %P
"       Adding color through UserN groups:
" set   statusline=%1*[%02n]%*\ %2*%F%*\ %(\ %M%R%H)%)%=%3*Pos=<%l,%c%V>%*
"       User1: color for buffer number
 "hi    User1 ctermfg=red   ctermbg=yellow
"       User2: color for filename
 "hi    User2 ctermfg=green ctermbg=yellow
"       User3: color for position
 "hi    User3 ctermfg=blue  ctermbg=yellow
"

" abbrievations

"iab cerr      cerr<<"[debug err]"<<
iab alos      also
iab aslo      also
iab bianry    binary
iab bianries  binaries
iab charcter  character
iab charcters characters
iab exmaple   example
iab exmaples  examples
iab shoudl    should
iab seperate  separate
iab teh       the
iab slef      self
iab sefl      self
iab hte       the
iab tpyo      typo
iab sout      System.out.println("
iab serr      System.err.println("
iab pri       print "
iab _log      log_message('error', "



if !has("unix")
iab YDATE <C-R>=strftime("%c %a")<CR>
else
iab YDATE <C-R>=strftime("%D %T %a")<CR>
endif

" ctrl z bg's vim, not shells out
map  :suspend
" mapping....
"map <F4>  :split<C-M>
"map <F5>  :bp<C-M>
"map <F6>  :bn<C-M>
"map <F12> :bd<C-M>
"map <TAB>  :bp<C-M>
"map <F2>  :bp<C-M> " tab between opened files
" resizing buffers just got easier
" ctrl right
map <C-l> 1>
" ctrl left
map <C-h> 1<
" ctrl up
map <C-k> 1+
" ctrl down
map <C-j> 1-
" sessions
set sessionoptions+=resize,buffers,help,options,winsize
"let SESSION_FILE = "last-session.vim"
map <F3> :wall<CR>:mksession! last-session.vim<CR>:echo "Session Saved! to restore, \":source last-session.vim\" or <F4>."<CR>
map <F4> :source last-session.vim<CR>
if filereadable("last-session.vim")
    echo "Hit <F4> to restore your last session!"
    "exe "source " . "last-session.vim"   " actually lets just remind!
endif

"echo "Hit <F5> to load python folds into any buffer"
"map <F5> :source ~/.vim/ftplugin/python_fold.vim<CR>

" make c++/java style single line comments!
"map  ^i//j
" make c style comments
map  ^i/*$a */j^

map <F2> \cr " this searches for c help on the word that your cursor is over

"let winManagerWindowLayout = 'FileExplorer|TagsExplorer|BufExplorer' 
"let winManagerWindowLayout = 'FileExplorer|TagsExplorer' 
"let winManagerWindowLayout = 'TagsExplorer' 
nnoremap <silent> <F8> :Tlist<CR>
nnoremap <silent> <F7> :Explore<CR>
nnoremap <silent> <F6> :BufExplorer<CR>


" temp entry!
map <F12> :w<CR>:!./makestring <CR>

fun! SwitchF9CompilerTarget() 
  "echo "mapping <F9> to compile/interpret files of type: " &filetype 
  if &filetype ==? "c"
      map <F10> :w<CR>:!clear; f=`echo %\|sed 's/\.[a-zA-Z]//'`; rm $f; make all test<CR>
      map <F9> :w<CR>:!clear; f=`echo %\|sed 's/\.[a-zA-Z]//'`; gcc -o $f % && ./$f <CR>
  elseif &filetype ==? "cpp" || &filetype ==? "cc"
      map <F10> :w<CR>:!clear; f=`echo %\|sed 's/\.[a-zA-Z]//'`; rm $f; make all test<CR>
      map <F9> :w<CR>:!clear; f=`echo %\|sed 's/\.[a-zA-Z]*//'`; g++ -o $f % && ./$f<CR>
  elseif &filetype ==? "ada"
      map <F9> :w<CR>:!clear; f=`echo %\|sed 's/\.[a-zA-Z]*//'`; gnatmake $f && (echo "===== running $f ===="; ./$f)<CR>
  elseif &filetype ==? "scheme"
      map <F9> :w<CR>:!clear; mzscheme --load eopl.scm < % <CR>
      map <F10> :w<CR>:!clear; mzscheme --load eopl.scm --script % <CR>
  elseif &filetype ==? "python"
      "map <F9> :w<CR>:!python % \|less<CR>
      map <F9> :w<CR>:!clear; python % <CR>
  elseif &filetype ==? "java"
      map <F9> :w<CR>:!clear; f=`basename %\|sed 's$\.java$$'`; javac % && java -classpath $CLASSPATH:. $f <CR>
  else
      "echo "<F9> not mapped... no support for files of type: " &filetype
  endif
endfun

" compiling / running
if has("autocmd")
 augroup F9Compiling 
  au!
  autocmd BufRead,BufEnter,FileType * call SwitchF9CompilerTarget()
 augroup END
endif

"autocmd *.c map <F9> :w<RETURN>:!gcc -o `echo %\|sed 's/\.[a-zA-Z]//'` %<RETURN>
"fun! ToggleFold() 
"if &filetype ==? "c"
"    echo "press <F9> to compile % (c style)"
"    map <F9> :w<RETURN>:!gcc -o `echo %\|sed 's/\.[a-zA-Z]//'` %<RETURN>
"elseif &filetype ==? "scheme"
"    echo "press <F9> to run % (scheme style)"
"    map <F9> :w<RETURN>:!mzscheme --load eopl.scm < % <RETURN>
"    map <F10> :w<RETURN>:!mzscheme --load eopl.scm --script % <RETURN>
"elseif &filetype ==? "python"
"    echo "press <F9> to run % (python style)"
"    map <F9> :w<RETURN>:!python % <RETURN>
"else
"    echo "HOW DO I COMPILE FILE TYPE " &filetype
"endif

" ------------------
"If you examine the first line, you will see that it does the following.

"Moves to the beginning of the line 
"Enters Insert Mode 
"Places "\*" there 
"Escapes to command mode 
"Adds "*/" to the end of the line 
"Escapes to command mode 
"Moves down One line 
"The second line does the following. 
"Moves to the beginning of the line 
"Removes 2 characters 
"Moves to the end of the line 
"Removes 2 characters 
"Moves down One line 
"I can type "12C" in command mode and it will comment out the next dozen lines. and "12T" will uncomment a dozen lines that were commented by "C". 

"map C 0i/*[CTRL-ESC]A*/[CTRL-ESC]j
"map T 0xx$xxj

" -------- colors ---------
hi Scrollbar      guifg=darkcyan guibg=cyan
hi Menu           guifg=black guibg=cyan
hi SpecialKey     term=bold  cterm=bold  ctermfg=darkred  guifg=Blue
hi NonText        term=bold  cterm=bold  ctermfg=darkred  gui=bold  guifg=Blue
hi Directory      term=bold  cterm=bold  ctermfg=brown  guifg=Blue
hi ErrorMsg       term=standout  cterm=bold  ctermfg=grey  ctermbg=blue  guifg=White  guibg=Red
hi Search         term=reverse  ctermfg=white  ctermbg=red  guifg=white  guibg=Red
hi MoreMsg        term=bold  cterm=bold  ctermfg=darkgreen  gui=bold  guifg=SeaGreen
hi ModeMsg        term=bold  cterm=bold  gui=bold  guifg=White  guibg=Blue
hi LineNr         term=underline  cterm=bold  ctermfg=darkcyan  guifg=Yellow
hi Question       term=standout  cterm=bold  ctermfg=darkgreen  gui=bold  guifg=Green
"hi StatusLine     term=bold,reverse  cterm=bold ctermfg=lightblue ctermbg=white gui=bold guifg=blue guibg=white
hi StatusLine     ctermfg=lightblue ctermbg=white guifg=white guibg=black
hi StatusLineNC   term=reverse  ctermfg=white ctermbg=lightblue guifg=white guibg=blue
hi Title          term=bold  cterm=bold  ctermfg=darkmagenta  gui=bold  guifg=Magenta
hi Visual         term=reverse  cterm=reverse  gui=reverse
hi WarningMsg     term=standout  cterm=bold  ctermfg=darkblue  guifg=Red
hi Cursor         guifg=bg  guibg=Green
hi Normal         guifg=white  guibg=black
hi Comment        term=bold  cterm=bold ctermfg=cyan  guifg=#80a0ff
hi Constant       term=underline  cterm=bold ctermfg=magenta  guifg=#ffa0a0
hi Special        term=bold  cterm=bold ctermfg=red  guifg=Orange
hi Identifier     term=underline   ctermfg=brown  guifg=#40ffff
hi Statement      term=bold  cterm=bold ctermfg=yellow  gui=bold  guifg=#ffff60
hi PreProc        term=underline  ctermfg=red  guifg=#ff80ff
hi Type           term=underline  cterm=bold ctermfg=lightgreen  gui=bold  guifg=#60ff60
hi Error          term=reverse  ctermfg=darkcyan  ctermbg=black  guifg=Red  guibg=Black
hi Todo           term=standout  ctermfg=black  ctermbg=darkcyan  guifg=Blue  guibg=Yellow
hi link IncSearch       Visual
hi link String          Constant
hi link Character       Constant
hi link Number          Constant
hi link Boolean         Constant
hi link Float           Number
hi link Function        Identifier
hi link Conditional     Statement
hi link Repeat          Statement
hi link Label           Statement
hi link Operator        Statement
hi link Keyword         Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link Delimiter       Special
hi link SpecialComment  Special
hi link Debug           Special


" ----- folding ------

" most languages
"syn region myFold start="{" end="}" transparent fold
"syn sync fromstart
"set foldmethod=syntax
"
" author  Max Ischenko 
" Toggle fold state between closed and opened. 
" 
" If there is no fold at current line, just moves forward. 
" If it is present, reverse it's state. 
fun! ToggleFold() 
if foldlevel('.') == 0 
normal! l 
else 
if foldclosed('.') < 0 
. foldclose 
else 
. foldopen 
endif 
endif 
" Clear status line 
echo 
endfun 
"
"" Map this function to Space key. 
noremap <space> :call ToggleFold()<CR> 

"set background=light
set background=dark
colorscheme ron
"colorscheme darkblue

"if has("gui_kde")
    "set guifont=helvetica/14/-1/0/50/0/0/0/0/0
"endif
"

"if has("gui_kde")
    "set guifont=Monospace/12/-1/5/50/0/0/0/0/0
"endif



