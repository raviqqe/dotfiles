. $HOME/.sh/util.sh
. $HOME/.sh/command/fzcd.sh
. $HOME/.sh/command/stacd.sh



# interactive filters

alias peco="peco --select-1"
alias fzf="fzf --select-1 --exit-0"
alias filter=fzf


# cd

export FZCD_CD_COMMAND=stacd
export FZCD_HISTORY_COMMAND=stacd-history
export FZCD_FILTER_COMMAND=filter

alias cd=stacd
alias c="fzcd ."
alias ch=fzcd-history
alias cm="fzcd $HOME"
alias cma="fzcd-all $HOME"
alias cs="fzcd $GHQ_ROOT"


# tmux

alias tmux="TERM=screen-256color tmux"
alias t=tmux
alias tl="tmux ls"

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
alias gb="git branch"

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

alias edit="vim"
alias eh="vim -c \":Unite file_mru\""
alias vimupdate="vim +PlugInstall +qall"

el() {
  local show_hidden_files=false

  while getopts a option
  do
    case $option in
    a)
      show_hidden_files=true
      ;;
    esac
  done

  shift $(expr $OPTIND - 1)

  if [ $# -eq 1 ]
  then
    local file
    file=$(find "$1" -type f |
           if [ $show_hidden_files = true ]; then cat; else grep -v '/\.'; fi |
           filter) &&
    edit "$file"
    return
  elif [ $# -eq 0 -a $show_hidden_files = true ]
  then
    el -a .
    return
  elif [ $# -eq 0 ]
  then
    el .
    return
  fi

  error "Invalid number of arguments."
}

alias es="el \"$GHQ_ROOT\""
alias em="el \"$HOME\""
alias ema="el -a \"$HOME\""

e() {
  if [ $# -eq 0 ]
  then
    el .
    return $?
  fi

  edit "$@"
}


# ls

if on_linux
then
  alias ls="ls --color=auto"
elif on_freebsd
then
  alias ls="ls -G"
fi

alias d=ls
alias da="ls -a"
alias dl="ls -lh"
alias dla="ls -lha"
alias dm="ls \"$HOME\""
alias dma="ls -a \"$HOME\""
alias ds="ghq list --full-path"


# ninja

if which ninja-build > /dev/null 2>&1
then
  alias ninja=ninja-build
fi
