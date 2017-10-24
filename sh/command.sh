. $HOME/.sh/util.sh
. $HOME/.sh/command/fzcd.sh
. $HOME/.sh/command/stacd.sh



# interactive filters

filter() {
  fzf
}


# history

alias r='eval "$( fc -ln 0 | fzf )"'


# cd

export FZCD_CD_COMMAND=stacd
export FZCD_HISTORY_COMMAND=stacd-history
export FZCD_FILTER_COMMAND=filter

alias cd=stacd
alias c="fzcd ."
alias ch=fzcd-history
alias cm="fzcd $HOME"
alias cma="fzcd-all $HOME"

cg() {
  cd "$(git rev-parse --show-toplevel)"
}

cs() {
  cd "$(ds | fzf)"
}


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


# homebrew

alias brew="unset LD_LIBRARY_PATH && brew"


# git

alias gcl='git clone --recursive'
alias gcf='git commit -m "TEMPORARY COMMIT"'
alias gco='git checkout'
alias gs='git status'
alias gpl='git pull'
alias gps='git push'
alias gpp='git pull && git push'
alias gppa='git pull --all && git push --all'
alias gl='git log'
alias glp='git log -p'
alias glf='git log -p --name-only'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD^ HEAD'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gm='git merge'
alias gri='git rebase -i'
alias gsm='git submodule'
alias gsma='git submodule add'
alias gsmu='git submodule update --init --recursive'
alias gcp='git cherry-pick'
alias gcb='git chbr'

ga() {
  if [ $# -eq 0 ]
  then
    git add .
  else
    git add "$@"
  fi &&

  git status
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

grh() {
  message=$(git log --format=%B -n 1 HEAD^)
  git reset --soft HEAD^^ &&
  git commit -m "$message"
}


# editor

alias edit=vim
alias eh='vim -c :History'
alias vimupdate='vim +PlugUpgrade +PlugClean! +PlugUpdate +UpdateRemotePlugins +qall'

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
alias er="vim -R"

e() {
  if [ $# -eq 0 ]
  then
    el .
    return $?
  fi

  edit "$@"
}

eg() {
  filename=$(s "$1" | fzf | awk -F : '{print "+" $2 " " $1}')
  [ -n "$filename" ] && e $filename
}


# ls

alias ls=$(which exa > /dev/null 2>&1 && echo exa || echo /bin/ls)
alias d=ls
alias da='ls -a'
alias dl='ls -l'
alias dla='ls -la'
alias dm="ls \"$HOME\""
alias dma="ls -a \"$HOME\""
alias ds='ghq list --full-path'


# less

alias less="less -R"


# ack clone

alias s='rg --line-number'


# ninja

if which ninja-build > /dev/null 2>&1
then
  alias ninja=ninja-build
fi
