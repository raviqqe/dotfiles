. $HOME/.sh/util.sh


# interactive filters

alias peco="peco --select-1"
alias fzf="fzf --select-1"
alias filter="fzf"


# cd

: ${cd_history:=$HOME}
max_cd_history=256

c() {
  _original_cd "$@" &&
  cd_history=$(pwd | sed 's/:/\\:/g'):$cd_history
  _truncate_cd_history
}

cm() {
  c $(_directories_in_home | grep -v "/\\." | filter)
}

cma() {
  c $(_directories_in_home | filter)
}

ch() {
  c $(_print_cd_history | filter)
}

_directories_in_home() {
  find "$HOME" -type d
}

_original_cd() {
  if type builtin > /dev/null 2>&1
  then
    builtin cd "$@"
  else
    cd "$@"
  fi
}

_print_cd_history() {
  echo "$cd_history" | sed 's/\([^\]\):/\1\
/g' | uniq
}

_truncate_cd_history() {
  local dir_entry='\([^:]\|\\\\:\)\+'
  local truncated_cd_history=$(echo "$cd_history" | grep -o \
        '\('"$dir_entry"':\)\{'"$(expr $max_cd_history - 1)"'\}'"$dir_entry")

  if [ -n "$truncated_cd_history" ]
  then
    cd_history=$truncated_cd_history
  fi
}


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

alias gs="git status"
alias gpl="git pull"
alias gps="git push"
alias gppa="git pull --all && git push --all"
alias gl="git log"
alias gd="git diff"
alias gdc="git diff --cached"
alias ga="git add"
alias gap="git add --patch"

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


# ls

if on_linux
then
  alias ls="ls --color=auto"
elif on_freebsd
then
  alias ls="ls -G"
fi


# ninja

if which ninja-build > /dev/null 2>&1
then
  alias ninja=ninja-build
fi
