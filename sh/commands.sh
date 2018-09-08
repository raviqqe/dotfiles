# cd

alias cr='cd "$(fd -at d . $(git rev-parse --show-toplevel) | fzf)"'
alias ch='cd "$(dirs -lp | sort -u | fzf)"'
alias cs='cd "$(ghq list --full-path | fzf)"'

c() {
  local dir=$(fd -t d "${1:-.}" | fzf)

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

alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcb='git chbr'
alias gcf='git commit -m "TEMPORARY COMMIT"'
alias gcl='git clone --recursive'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD^ HEAD'
alias gl='git log'
alias glf='git log -p --name-only'
alias glp='git log -p'
alias gm='git merge'
alias gpl='git pull'
alias gpp='git pull && git push'
alias gppa='git pull --all && git push --all'
alias gps='git push'
alias gri='git rebase -i'
alias grm='git rebase master'
alias gs='git status'
alias gsm='git submodule'
alias gsma='git submodule add'
alias gsmu='git submodule update --init --recursive'
alias gz='git stash'
alias gzl='git stash list'
alias gzp='git stash pop'

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
    local file=$(fd -t f . | fzf)

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
