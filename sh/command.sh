. $HOME/.sh/util.sh
. $HOME/.sh/command/fzcd.sh
. $HOME/.sh/command/stacd.sh



# interactive filters

alias peco="peco --select-1"
alias fzf="fzf --select-1"
alias filter=fzf


# cd

export FZCD_CD_COMMAND=stacd
export FZCD_HISTORY_COMMAND=stacd-history
export FZCD_FILTER_COMMAND=fzf

alias cd=stacd
alias c=cd
alias ch=fzcd-history
alias cm="fzcd $HOME"
alias cma="fzcd-all $HOME"
alias cs="fzcd $GHQ_ROOT"


# tmux

alias tmux="TERM=screen-256color tmux"
alias t=tmux
alias tls="tmux ls"

ta() {
  if [ $# -eq 0 ]
  then
    tmux a
  else
    tmux a -t "$@"
  fi
}


# git

alias gco="git checkout"
alias gs="git status"
alias gpl="git pull"
alias gps="git push"
alias gppa="git pull --all && git push --all"
alias gl="git log"
alias gd="git diff"
alias gdc="git diff --cached"
alias gap="git add --patch"

ga() {
  if [ $# -eq 0 ]
  then
    git add .
  else
    git add "$@"
  fi
}

gc() {
  if [ $# -lt 1 ]
  then
    echo "Invalid number of arguments" >&2
    return 1
  fi

  message=$1
  shift

  git commit -m "$message" "$@"
}


# editor

alias e="vim"
alias eu="vim -c \":Unite file_mru\""
alias vimupdate="vim +PlugInstall +qall"

es() {
  e $(find "$GHQ_ROOT" | grep -v '/\\.' | filter)
}


# ls

if on_linux
then
  alias ls="ls --color=auto"
elif on_freebsd
then
  alias ls="ls -G"
fi

alias s=ls


# ninja

if which ninja-build > /dev/null 2>&1
then
  alias ninja=ninja-build
fi
