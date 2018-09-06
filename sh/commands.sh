# cd

alias cr='cd "$(fd -at d . $(git rev-parse --show-toplevel) | fzf)"'
alias ch='cd "$(dirs -lp | sort -u | fzf)"'
alias cs='cd "$(ghq list --full-path | fzf)"'

c() {
  local dir=$(find "${1:-.}" -type d | grep -v '/\.' | fzf)

  [ -n "$dir" ] && cd "$dir"
}


# tmux

alias tmux='TERM=screen-256color tmux'
alias t=tmux
alias tl='tmux ls'

ta() {
  if [ $# -eq 0 ]
  then
    tmux a
  else
    tmux a -t "$@"
  fi
}


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
alias gz='git stash'
alias gzp='git stash pop'
alias gzl='git stash list'

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
  if [ $# -eq 0 ]
  then
    return 1
  fi

  git commit -m "$@"
}

grh() {
  local message=$(git log --format=%B -n 1 HEAD^)
  git reset --soft HEAD^^ &&
  git commit -m "$message"
}


# Editor

alias eh='nvim -c :History'
alias er='nvim -c :GitFiles'

e() {
  if [ $# -eq 0 ]
  then
    local file=$(find . -type f | grep -v '/\.' | fzf)
    [ -n "$file" ] && nvim "$file"
  else
    nvim "$@"
  fi
}

eg() {
  local line=$(s "$1" | fzf)
  [ -n "$line" ] && nvim +$(echo "$line" | cut -d : -f 2) "$(echo "$line" | cut -d : -f 1)"
}


# ls

alias ls="$(which exa > /dev/null 2>&1 && echo exa || echo /bin/ls --color)"
alias d=ls
alias d1='ls -1'
alias da='ls -a'
alias dl='ls -l'
alias dla='ls -la'
alias dm='ls ~'
alias dma='ls -a ~'
alias ds='ghq list --full-path'


# Others

alias less='less -R'
alias r='eval "$( fc -ln 0 | sort -u | fzf )"'

if which rg > /dev/null 2>&1
then
  alias s='rg --line-number'
else
  alias s='grep -Hnr --color'
fi
