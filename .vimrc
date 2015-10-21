" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END


"""
" 検索関係
set ignorecase          " 大文字小文字を区別しない
set smartcase           " 検索文字に大文字がある場合は大文字小文字を区別
set incsearch           " インクリメンタルサーチ
" set hlsearch            " 検索マッチテキストをハイライト (2013-07-03 14:30 修正）

" (検索関係)??? 意味がわかったらコメントアウトしよう
" バックスラッシュやクエスチョンを状況に合わせ自動的にエスケープ
" cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
" cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'



"""
" 編集関係
set shiftround          " '<'や'>'でインデントする際に'shiftwidth'の倍数に丸める
set infercase           " 補完時に大文字小文字を区別しない
"set virtualedit=all     " カーソルを文字が存在しない部分でも動けるようにする
set hidden              " バッファを閉じる代わりに隠す（Undo履歴を残すため）
set switchbuf=useopen   " 新しく開く代わりにすでに開いてあるバッファを開く
set showmatch           " 対応する括弧などをハイライト表示する
set matchtime=3         " 対応括弧のハイライト表示を3秒にする

" 対応括弧に'<'と'>'のペアを追加
set matchpairs& matchpairs+=<:>

" バックスペースでなんでも消せるようにする
set backspace=indent,eol,start

" クリップボードをデフォルトのレジスタとして指定。後にYankRingを使うので
" 'unnamedplus'が存在しているかどうかで設定を分ける必要がある
if has('unnamedplus')
    " set clipboard& clipboard+=unnamedplus " 2013-07-03 14:30 unnamed 追加
    set clipboard& clipboard+=unnamedplus,unnamed 
else
    " set clipboard& clipboard+=unnamed,autoselect 2013-06-24 10:00 autoselect 削除
    set clipboard& clipboard+=unnamed
endif

" Swapファイル？Backupファイル？前時代的すぎ
" なので全て無効化する
set nowritebackup
set nobackup
set noswapfile

" 誤爆すると危ないキーを無効
nnoremap ZZ <Nop> " 保存して閉じる
nnoremap ZQ <Nop>> " 保存せず閉じる

"""
" 表示関係
set list                " 不可視文字の可視化
set number              " 行番号の表示
set wrap                " 長いテキストの折り返し
set textwidth=0         " 自動的に改行が入るのを無効化
" set colorcolumn=80      " その代わり80文字目にラインを入れる

" 前時代的スクリーンベルを無効化
set t_vb=
set novisualbell

" デフォルト不可視文字は美しくないのでUnicodeで綺麗に
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲



"""
" マクロおよびキー設定


" ESCを二回押すことでハイライトを消す
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" カーソル下の単語を * で検索
vnoremap <silent> * "vy/\V<C-r>=substitute(escape(@v, '\/'), "\n", '\\n', 'g')<CR><CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" j, k による移動を折り返されたテキストでも自然に振る舞うように変更
nnoremap j gj
nnoremap k gk

" vを二回で行末まで選択
vnoremap v $h

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %

" Ctrl + hjkl でウィンドウ間を移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" T + ? で各種設定をトグル
nnoremap [toggle] <Nop>
nmap T [toggle]
nnoremap <silent> [toggle]s :setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]l :setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]t :setl expandtab!<CR>:setl expandtab?<CR>
nnoremap <silent> [toggle]w :setl wrap!<CR>:setl wrap?<CR>

" make, grep などのコマンド後に自動的にQuickFixを開く
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" :e などでファイルを開く際にフォルダが存在しない場合は自動作成
function! s:mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
        \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction
autocmd MyAutoCmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)

" vim 起動時のみカレントディレクトリを開いたファイルの親ディレクトリに指定
autocmd MyAutoCmd VimEnter * call s:ChangeCurrentDir('', '')
function! s:ChangeCurrentDir(directory, bang)
    if a:directory == ''
        lcd %:p:h
    else
        execute 'lcd' . a:directory
    endif

    if a:bang == ''
        pwd
    endif
endfunction

" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif




"""
" NeoBundle
let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
    " NeoBundleが存在しない、もしくはVimのバージョンが古い場合はプラグインを一切
    " 読み込まない
    let s:noplugin = 1
else
    " NeoBundleを'runtimepath'に追加し初期化を行う
    if has('vim_starting')
        execute "set runtimepath+=" . s:neobundle_root
    endif

    call neobundle#begin(s:bundle_root)

    " NeoBundle自身をNeoBundleで管理させる
    NeoBundleFetch 'Shougo/neobundle.vim'

    " 非同期通信を可能にする
    " 'build'が指定されているのでインストール時に自動的に
    " 指定されたコマンドが実行され vimproc がコンパイルされる
    NeoBundle "Shougo/vimproc", {
        \ "build": {
        \   "windows"   : "make -f make_mingw32.mak",
        \   "cygwin"    : "make -f make_cygwin.mak",
        \   "mac"       : "make -f make_mac.mak",
        \   "unix"      : "make -f make_unix.mak",
        \ }}

    " (ry

    " インストールされていないプラグインのチェックおよびダウンロード
    NeoBundleCheck
endif


" Web関連
NeoBundle 'othree/html5.vim'
NeoBundle 'hail2u/vim-css3-syntax'
" NeoBundle 'pangloss/vim-javascript'
" NeoBundle 'jelera/vim-javascript-syntax'



" NeoBundle 'Shougo/unite.vim'
NeoBundleLazy "Shougo/unite.vim", {
      \ "autoload": {
      \   "commands": ["Unite", "UniteWithBufferDir"]
      \ }}
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/neomru.vim'

let g:unite_split_rule = 'botright'
let g:unite_enable_start_insert=1
nnoremap [unite] <Nop>
nmap , [unite]
nnoremap <silent> [unite]y :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]f :<C-u>Unite file<CR>
nnoremap <silent> [unite]d :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>


NeoBundleLazy "Shougo/vimfiler", {
      \ "depends": ["Shougo/unite.vim"],
      \ "autoload": {
      \   "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
      \   "mappings": ['<Plug>(vimfiler_switch)'],
      \   "explorer": 1,
      \ }}


" if has('lua') && v:version > 703 && has('patch825') 2013-07-03 14:30 > から >= に修正
" if has('lua') && v:version >= 703 && has('patch825') 2013-07-08 10:00 必要バージョンが885にアップデートされていました
" if has('lua') && v:version >= 703 && has('patch885')
"     NeoBundleLazy "Shougo/neocomplete.vim", {
"         \ "autoload": {
"         \   "insert": 1,
"         \ }}
"     " 2013-07-03 14:30 NeoComplCacheに合わせた
"     let g:neocomplete#enable_at_startup = 1
"     let s:hooks = neobundle#get_hooks("neocomplete.vim")
"     function! s:hooks.on_source(bundle)
"         let g:acp_enableAtStartup = 0
"         let g:neocomplet#enable_smart_case = 1
"         " NeoCompleteを有効化
"         " NeoCompleteEnable
"     endfunction
" else
"     NeoBundleLazy "Shougo/neocomplcache.vim", {
"         \ "autoload": {
"         \   "insert": 1,
"         \ }}
"     " 2013-07-03 14:30 原因不明だがNeoComplCacheEnableコマンドが見つからないので変更
"     let g:neocomplcache_enable_at_startup = 1
"     let s:hooks = neobundle#get_hooks("neocomplcache.vim")
"     function! s:hooks.on_source(bundle)
"         let g:acp_enableAtStartup = 0
"         let g:neocomplcache_enable_smart_case = 1
"         " NeoComplCacheを有効化
"         " NeoComplCacheEnable 
"     endfunction
" endif


" " NeoBundle "Shougo/neocomplete.vim"
NeoBundle "Shougo/neocomplcache.vim"
"
NeoBundle "git://github.com/tsukkee/unite-tag.git"
" " path にヘッダーファイルのディレクトリを追加することで
" " neocomplcache が include 時に tag ファイルを作成してくれる
"
" set path+=$LIBSTDCPP
" set path+=$BOOST_LATEST_ROOT

" neocomplcache が作成した tag ファイルのパスを tags に追加する
function! s:TagsUpdate()
    " include している tag ファイルが毎回同じとは限らないので毎回初期化
    setlocal tags=
    for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
        execute "setlocal tags+=".neocomplcache#cache#encode_name('tags_output', filename)
    endfor
endfunction

command!
    \ -nargs=? PopupTags
    \ call <SID>TagsUpdate()
    \ |Unite tag:<args>

function! s:get_func_name(word)
    let end = match(a:word, '<\|[\|(')
    return end == -1 ? a:word : a:word[ : end-1 ]
endfunction

" " カーソル下のワード(word)で絞り込み
noremap <silent> g<C-]> :<C-u>execute "PopupTags ".expand('<cword>')<CR>

"""
" C++ completion
NeoBundle "Shougo/neocomplcache-clang"
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
    let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction


" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
" let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'


" これをしないと候補選択時に Scratch ウィンドウが開いてしまう 
set completeopt=menuone

let g:neocomplcache_clang_use_library  = 1

" libclang.so を置いたディレクトリを指定
let g:neocomplcache_clang_library_path = '/usr/share/clang'

" Include するディレクトリは各自の環境に合わせて設定
let g:neocomplcache_clang_user_options =
       \ '-I /usr/include/ '.
       \ '-I /usr/include/cairo/ '.
       \ '-fms-extensions -fgnu-runtime '.
       \ '-include malloc.h '

let g:neocomplcache_max_list=10000
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" カーソル下のワード(WORD)で ( か < か [ までが現れるまでで絞り込み
" 例)
" boost::array<std::stirng... → boost::array で絞り込み
" noremap <silent> G<C-]> :<C-u>execute "PopupTags "
    \.substitute(<SID>get_func_name(expand('<cWORD>')), '\:', '\\\:', "g")<CR>
" 現在のバッファのタグファイルを生成する
" neocomplcache からタグファイルのパスを取得して、tags に追加する
nnoremap <expr><Space>tu g:TagsUpdate()
function! g:TagsUpdate()
    execute "setlocal tags=./tags,tags"
    let bufname = expand("%:p")
    if bufname!=""
        call system(
            \ "ctags ". 
            \ "-R --tag-relative=yes --sort=yes ".
            \ "--c++-kinds=+p --fields=+iaS --extra=+q "
            \ .bufname." `pwd`")
    endif
    for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
        execute "set tags+=".neocomplcache#cache#encode_name('include_tags', filename)
    endfor
    return ""
endfunction

NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'


" NeoBundle "nathanaelkane/vim-indent-guides"
" let s:hooks = neobundle#get_hooks("vim-indent-guides")
" function! s:hooks.on_source(bundle)
"   let g:indent_guides_guide_size = 1
"   IndentGuidesEnable " 2013-06-24 10:00 追記
" endfunction

NeoBundle "Yggdroot/indentLine"

NeoBundleLazy "sjl/gundo.vim", {
      \ "autoload": {
      \   "commands": ['GundoToggle'],
      \}}


NeoBundle "scrooloose/syntastic"
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options =
    \ ' -std=c++11 -DLOCAL '.
    \ '-I /usr/include/cairo/ '

let g:syntastic_python_checkers = 1
" let g:syntastic_python_python_exec = 'python3'
" let g:syntastic_python_checkers = ['flake8']
" let g:syntastic_python_flake8_args = '--ignore=E501,E225'

" NeoBundleLazy "davidhalter/jedi-vim"
" let s:hooks = neobundle#get_hooks("jedi-vim")
" function! s:hooks.on_source(bundle)
"   " jediにvimの設定を任せると'completeopt+=preview'するので
"   " 自動設定機能をOFFにし手動で設定を行う
"   let g:jedi#auto_vim_configuration = 0
"   " 補完の最初の項目が選択された状態だと使いにくいためオフにする
"   let g:jedi#popup_select_first = 0
"   " " quickrunと被るため大文字に変更
"   " let g:jedi#rename_command = '<Leader>R'
"   " " gundoと被るため大文字に変更 (2013-06-24 10:00 追記）
"   " let g:jedi#goto_command = '<Leader>G'
"
"   autocmd FileType python setlocal completeopt-=preview
" endfunction

""""""""""""""""""""""""


"""
" color scheme
" solarized カラースキーム
  NeoBundle 'altercation/vim-colors-solarized'
" mustang カラースキーム
  NeoBundle 'croaker/mustang-vim'
" wombat カラースキーム
  NeoBundle 'jeffreyiacono/vim-colors-wombat'
" jellybeans カラースキーム
  NeoBundle 'nanotech/jellybeans.vim'
" lucius カラースキーム
  NeoBundle 'vim-scripts/Lucius'
" zenburn カラースキーム
  NeoBundle 'vim-scripts/Zenburn'
" mrkn256 カラースキーム
  NeoBundle 'mrkn/mrkn256.vim'
" railscasts カラースキーム
  NeoBundle 'jpo/vim-railscasts-theme'
" pyte カラースキーム
  NeoBundle 'therubymug/vim-pyte'
" molokai カラースキーム
  NeoBundle 'tomasr/molokai'


" カラースキーム一覧表示に Unite.vim を使う
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'bling/vim-airline'
set laststatus=2


""""
NeoBundle 'thinca/vim-quickrun'

" let g:hier_highlight_group_qf  = "qf_error_ucurl"
" NeoBundle 'jceb/vim-hier'
NeoBundle 'dannyob/quickfixstatus'
" 
" " quickfix のエラー箇所を波線でハイライト
" execute "highlight qf_error_ucurl gui=undercurl guisp=Red"
" 
" 

NeoBundle 'tomtom/tcomment_vim'


NeoBundle 'Shougo/neosnippet'
" Tell Neosnippet about the other snippets

let g:neosnippet#snippets_directory='~/.vim/snippests'
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" imap <expr><C-k> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" smap <C-k> <Plug>(neocomplcache_snippets_expand)


" なぜか使えない
" NeoBundleLazy 'kana/vim-altr'
" nnoremap <Leader>a <Plug>(altr-forward)
NeoBundle 'vim-scripts/a.vim'


NeoBundle 'vim-ruby/vim-ruby'


" NeoBundle 'tpope/vim-endwise'
" NeoBundle 'kana/vim-smartinput'
" let g:smartinput_no_default_key_mappings = 1
" call smartinput#map_trigger_keys()
" call smartinput#define_rule({'at': '\%#', 'char': '(', 'input': '()<Left>'})
" call smartinput#map_to_trigger('i', '<Enter>', '<Enter>', '<Enter>')
" call smartinput#map_to_trigger('i', '<C-j>', '<Enter>', '<Enter>')
" call smartinput#define_rule({'at': '{\%#', 'char': '<Enter>', 'input': '<Enter><Enter>}<Up><Esc>"_S'})
" call smartinput#define_rule({'at': '{\%#', 'char': '<Enter>', 'input': '<Enter>}<Up>'})

NeoBundle "tyru/caw.vim.git"
nmap <Leader>c <Plug>(caw:I:toggle)
vmap <Leader>c <Plug>(caw:I:toggle)


NeoBundle 'Lokaltog/vim-easymotion'
" let g:EasyMotion_do_mapping = 0 "Disable default mappings
nmap s <Plug>(easymotion-s2)
" map f <Plug>(easymotion-fl)
" map t <Plug>(easymotion-tl)
" map F <Plug>(easymotion-Fl)
" map T <Plug>(easymotion-Tl)
map f <Plug>(easymotion-bd-fl)
map t <Plug>(easymotion-bd-tl)

" OSのクリップボードを使う
set clipboard+=unnamed
set clipboard=unnamed


call neobundle#end()


""
" set nocompatible
filetype on
filetype indent on
" filetype plugin on
syntax on


""
" tab
set expandtab
set smarttab
set smartindent
set tabstop=4
set shiftwidth=4
" set autoindent
" autocmd BufRead,BufNewFile *.py set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
" autocmd BufRead,BufNewFile *.cpp,*.c,*.h,*.hpp,*.java set cindent set cinoptions+=g0
autocmd FileType cpp,java set cindent cinoptions+=g0 cino+=N-s
" set cinoptions+=g0
let g:syntastic_cpp_check_header = 1

function! InitPython()
    setlocal expandtab
    setlocal smarttab
    setlocal smartindent
    setlocal tabstop=4
    setlocal shiftwidth=4

    setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

    " コメントを入力したときにインデント解除されるのを防ぐ
    inoremap # X#
endfunction
autocmd FileType python call InitPython()

function! InitRuby()
    setlocal expandtab
    setlocal smarttab
    setlocal smartindent
    setlocal tabstop=2
    setlocal shiftwidth=2
endfunction
autocmd FileType ruby call InitRuby()

" my keymap
" "http://stackoverflow.com/questions/14307697/disable-type-quitenter-to-exit-vim-message-when-pressing-ctrlc
" nnoremap <C-c> <silent> <C-c> 
map <C-c> <Esc>
inoremap <C-d> <Del>

noremap <Enter> o<ESC>
" nnoremap <C-j> <CR>
" inoremap <C-j> <CR>

map <C-j> <Enter>


" normalモードのまま改行を入れる
noremap <C-j> o<ESC>

" 挿入モードでのカーソル移動
" inoremap <C-j> <Down>
" inoremap <C-k> <Up>
" inoremap <C-h> <Left>
" inoremap <C-l> <Right>

set clipboard=unnamedplus

set cursorline

inoremap <expr><C-j> neocomplcache#smart_close_popup()."\<CR>"

set formatoptions-=r
set formatoptions-=o


noremap \<C-i> <C-i>
