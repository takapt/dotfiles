# # Set up the prompt
# autoload -Uz promptinit
# promptinit
# prompt adam1


# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'



# Created by newuser for 4.3.17
# autoload -U compinit
# compinit

# export LANG=ja_JP.UTF-8

PROMPT="%B%{[34m%}%~ %% %{[m%}%b"


# title
# tmuxで意味ない
case "${TERM}" in
kterm*|xterm)
    precmd() {
        echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
    }
    ;;
esac

## Command history configuration
#
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data



# auto change directory
setopt auto_cd

# auto directory pushd that you can get dirs list by cd -[tab]
setopt auto_pushd

# command correct edition before each completion attempt
setopt correct

# compacked complete list display
setopt list_packed

# no beep sound when complete list displayed
setopt nolistbeep

# no remove postfix slash of command line
setopt noautoremoveslash

## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes 
#   to end of it)
#
bindkey -e

# # historical backward/forward search with linehead string binded to ^P/^N
# #
# autoload history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^P" history-beginning-search-backward-end
# bindkey "^N" history-beginning-search-forward-end


# dir's color
# http://news.mynavi.jp/column/zsh/009/index.html
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;32:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=32;1' 'bd=46;34' 'cd=43;34'


autoload zed

# ls after cd
# function chpwd() { ls }
# chpwd() { ls_abbrev }
# ls_abbrev() {
#     # -a : Do not ignore entries starting with ..
#     # -C : Force multi-column output.
#     # -F : Append indicator (one of */=>@|) to entries.
#     local cmd_ls='ls'
#     local -a opt_ls
#     # opt_ls=('-aCF' '--color=always')
#     opt_ls=('-CF' '--color=always')
#     case "${OSTYPE}" in
#         freebsd*|darwin*)
#             if type gls > /dev/null 2>&1; then
#                 cmd_ls='gls'
#             else
#                 # -G : Enable colorized output.
#                 opt_ls=('-aCFG')
#             fi
#             ;;
#     esac
#  
#     local ls_result
#     ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')
#  
#     local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')
#  
#     if [ $ls_lines -gt 10 ]; then
#         echo "$ls_result" | head -n 5
#         echo '...'
#         echo "$ls_result" | tail -n 5
#         echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
#     else
#         echo "$ls_result"
#     fi
# }




# alias
setopt complete_aliases # aliased ls needs if file/dir completions work

alias ls="ls --color=auto"
alias r="./a.out"
alias rm="trash-put"
alias grep="grep --color=always"
alias less="less -R"
alias lc='locate'

alias ctex="latexmk -pdfdvi"
alias cltex='rm *log *dvi *aux *fdb_latexmk *toc'

alias xclip='xclip -selection clipboard'

alias iimg='grep -iv "jpg\|png\|bmp\|\gif\|url"'

# alias g++='g++ -std=c++11'
alias g++='g++ -std=c++11 -DLOCAL'
# alias g++d='g++ -D_GLIBCXX_DEBUG'
# alias g++='g++ -std=c++0x -DLOCAL -I/home/takapt/work/'

alias nt="for a in \`seq 1 6\`; do ping -c 1 192.168.10.\$a | grep -u1 '1 recei' | grep ^\-; done"
# path
PATH=$PATH:/usr/sbin:~/tools/bin

# OpenCV
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig
export PKG_CONFIG_PATH


# ## Python virtualenvwrapper
# export WORKON_HOME=$HOME/.virtualenvs
#
# if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
#  source /usr/local/bin/virtualenvwrapper.sh
# fi
#
# ## Python pip -> virtualenv only
# export PIP_REQUIRE_VIRTUALENV=true
# export PIP_RESPECT_VIRTUALENV=true
#
# # default python
# workon py3
