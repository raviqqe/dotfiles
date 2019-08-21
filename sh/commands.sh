# cd

alias ct='cd "$(git rev-parse --show-toplevel)"'
alias cr='cd "$(fd -at d . $(git rev-parse --show-toplevel) | fzf)"'
alias ch='cd "$(dirs -lp | sort -u | fzf)"'
alias cs='cd "$(ghq list --full-path | fzf)"'

times() {
  yes $2 | head -$1 | tr -d [:space:]
}

for n in $(seq 3 8); do
  alias $(times $n .)=$(times $(expr $n - 1) ../)
done

c() {
  local dir=$(fd -t d . | fzf)

  [ -n "$dir" ] && cd "$dir"
}

# tmux

alias tmux='TERM=screen-256color tmux'
alias t=tmux
alias ta='tmux a'
alias tl='tmux ls'

# git

alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcw='git commit -m WIP'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdh='git diff HEAD^ HEAD'
alias gl='git log'
alias glf='git log -p --name-only'
alias glg='git log --decorate --graph --oneline'
alias glp='git log -p'
alias gm='git merge'
alias gpl='git pull'
alias gpp='git pull && git push'
alias gppa='git pull --all && git push'
alias gps='git push'
alias gpsu='git push -u origin $(git symbolic-ref --short HEAD)'
alias grc='git rebase --continue'
alias gri='git rebase -i'
alias grm='git rebase master'
alias gs='git status'
alias gsm='git submodule'
alias gsma='git submodule add'
alias gsmu='git submodule update --init --recursive'
alias gw='git worktree'
alias gwc='cd "$(git worktree list | fzf | cut -f 1 -d " ")"'
alias gwl='git worktree list'
alias gwr='git worktree remove "$(git worktree list | fzf | cut -f 1 -d " ")"'
alias gz='git stash'
alias gzd='git stash drop'
alias gzl='git stash list'
alias gzp='git stash pop'
alias gzs='git stash show -p'

ga() {
  if [ $# -eq 0 ]; then
    git add --all
  else
    git add "$@"
  fi &&
    git status
}

gc() {
  if [ $# -eq 0 ]; then
    return 1
  fi

  git commit -m "$@"
}

grh() {
  local message=$(git log --format=%B -n 1 HEAD^)
  git reset --soft HEAD^^ &&
    git commit -m "$message"
}

gwa() {
  local branch=$(git branch --format '%(refname:short)' | fzf)
  local dir=~/worktree/"$branch"

  git worktree add "$dir" "$branch" &&
    cd $dir
}

# Editor

alias eg='nvim -c :Rg!'
alias eh='nvim -c :History!'
alias er='nvim -c :GitFiles!'

e() {
  if [ $# -eq 0 ]; then
    local file=$(fd -t f . | fzf)

    [ -n "$file" ] && nvim "$file"
  else
    nvim "$@"
  fi
}

# ls

alias ls="$(which exa >/dev/null 2>&1 && echo exa || echo /bin/ls --color)"
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
alias r='eval "$(fc -ln 0 | sort -u | fzf)"'

f() {
  if [ $# -eq 0 ]; then
    bat "$(fd -t f | fzf)"
    return
  fi

  bat "$@"
}

if which rg >/dev/null 2>&1; then
  alias s='rg --line-number'
else
  alias s='grep -Hnr --color'
fi
