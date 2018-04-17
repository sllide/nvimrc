set nocompatible
set encoding=UTF-8
filetype plugin on

"Automaticly install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
  "UI
  Plug 'morhetz/gruvbox' "best colorscheme
  Plug 'mhinz/vim-startify' "welcome screen
  Plug 'itchyny/lightline.vim' "status bar
  Plug 'mgee/lightline-bufferline' "buffer tab bar

  "project searcing
  Plug 'Shougo/denite.nvim', {'do': ':UpdateRemotePlugins' }

  "linting engine
  Plug 'neomake/neomake'

  "ftp mirroring
  Plug 'sllide/ftphelper'
  
  "File manager
  Plug 'scrooloose/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

  "Tag overview
  Plug 'majutsushi/tagbar'

  "fancy icons, loaded last for compatibility
  Plug 'ryanoasis/vim-devicons'
call plug#end()

"theme
  set termguicolors
  set background=dark
  let g:gruvbox_contrast_dark='hard'
  let g:gruvbox_italic=1
  colorscheme gruvbox

"startify
  let g:startify_lists = [
        \ {'type': 'commands', 'header': ['SPESJUL']},
        \ {'type': 'bookmarks', 'header': ['PROJECTS']},
        \ {'type': 'files', 'header': ['RECENT']},
        \ ]
  let g:startify_bookmarks = split(globpath('~/projects','*'))
  let g:startify_custom_indices = map(range(1,100), 'string(v:val)')
  let g:startify_enable_special = 0
  let g:startify_commands = [
    \ {'n': ['New buffer', 'enew']},
    \ {'c': ['Edit vimrc', 'e ~/.config/nvim/init.vim']},
    \ {'q': ['Quit vim', 'qa']},
    \ ]
  source ~/.config/nvim/header.vim

"lightline
  let g:lightline = {}
  let g:lightline.colorscheme = 'gruvbox'
  let g:lightline.separator = { 'left': '', 'right': '' }
  let g:lightline.subseparator = { 'left': '', 'right': '' }
  let g:lightline.tabline          = {'left': [['buffers']], 'right':[[]]}
  let g:lightline.component_expand = {'buffers': 'lightline#bufferline#buffers'}
  let g:lightline.component_type   = {'buffers': 'tabsel'}
  let g:lightline.component_function = {'filetype': 'CustomFiletype', 'fileformat': 'CustomFileformat'} 
  function! CustomFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
  endfunction
  function! CustomFileFormat()
    return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
  endfunction
  "lightline bufferline
    let g:lightline#bufferline#enable_devicons = 1
    let g:lightline#bufferline#unicode_symbols = 1
    let g:lightline#bufferline#shorten_path = 0
    "bufferline vim options
      set noshowmode
      set showtabline=2
      set guioptions-=e

"denite
  "denite file search parameters
    call denite#custom#var('file_rec', 'command', ['rg', '--files'])

  "denite project search parameters
    call denite#custom#source('grep', 'matchers', ['matcher_fuzzy'])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep', '-o', '-M', '200'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--fixed-strings'])
    call denite#custom#var('grep', 'separator', ['--'])

    call denite#custom#map('insert', '<Down>', '<denite:move_to_next_line>', 'noremap')
    call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')

"neomake
  "Fire linter on open and insert leave
  call neomake#configure#automake({
  \ 'InsertLeave': {},
  \ 'BufWinEnter': {},
  \ 'FileType': {},
  \ })
  let g:neomake_php_enabled_makers = ['php']

"ftphelper
  let g:ftphelper_excludes = ['*.git/', '*Payment/', '*fonts/', '*images/', '*logs/', '*files/']
  let g:ftphelper_includes = ['*.conf', '*.css', '*.html', '*.ini', '*.js', '*.json', '*.php', '*.txt', '*.tpl']

"NERDTree
  let g:NERDTreeLimitedSyntax = 1
  let g:NERDTreeHighlightCursorline = 0
  let g:NERDTreeQuitOnOpen = 1

"key mapping
  "escape terminal with escape
    tnoremap <Esc> <C-\><C-n>
  "enable sane tabbing
    inoremap <S-Tab> <C-D>
    vnoremap <Tab> >gv
    vnoremap <S-Tab> <gv
  "(shift-)tab buffers in normal mode
    nnoremap <TAB> :bn<CR>
    nnoremap <s-TAB> :bp<CR>
  "Disable tab when in special windows
    autocmd FileType nerdtree noremap <buffer> <TAB> <nop>
    autocmd FileType nerdtree noremap <buffer> <s-TAB> <nop>
  "denite file search
    noremap <F3> :Denite file_rec<CR>
  "denite project search
    noremap <F4> :Denite grep -auto-preview<CR>
  "and ofcourse nerdtree mappings
    noremap <C-n> :NERDTreeToggle<CR>
  "TagBar toggle
    noremap <C-t> :TagbarToggle<CR>


"misc settings
  set mouse=a
  set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
  set hidden
  set ignorecase smartcase
  set number relativenumber
  set wildmenu
  set wildmode=longest:full,full
  set ffs=unix,dos,mac
  set clipboard=unnamedplus
  set nowrap
  let g:terminal_scrollback_buffer_size = 1000

"Ignore whitespace in diff mode
  if &diff
    set diffopt+=iwhite
  endif
