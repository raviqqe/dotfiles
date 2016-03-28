#!/usr/bin/env zsh

. $HOME/.include.sh


# options

zstyle :compinstall filename '/home/raviqqe/.zshrc'

autoload -Uz compinit
autoload -U colors
compinit
colors

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd extendedglob prompt_subst
unsetopt beep notify nomatch

bindkey -e
bindkey "^[[3~" delete-char


# aliases

if on_linux
then
  alias ls="ls --color=auto"
elif on_freebsd
then
  alias ls="ls -G"
  #alias ls="ls -F"
fi

alias peco="peco --select-1"
alias fzf="fzf --select-1"


# prompt

git_branch() {
  branch_name=$(git symbolic-ref --short HEAD 2> /dev/null)
  if [ -n "$branch_name" ]
  then
    echo "$branch_name$(git_modified) "
  fi
}

git_grep_modified_files() {
  grep -e "^.M" -e "^M." -e "^A." -e "^D." -e "^.D"
}

git_modified() {
  if [ -n "$(git status --porcelain 2> /dev/null | git_grep_modified_files)" ]
  then
    echo "*"
  fi
}

PROMPT='%n@%m %{$fg[yellow]%}%20<..<%~%<< '\
'%{$fg[cyan]%}$(git_branch)'\
'%{$fg[red]%}%(?..[%?] )%{$fg[magenta]%}%# %{$reset_color%}'
PROMPT2='%_> '
RPROMPT=' %W %T'


# antigen

. "$HOME/.antigen/antigen.zsh"

antigen bundle "zsh-users/zsh-syntax-highlighting"
antigen bundle "zsh-users/zsh-history-substring-search"
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M emacs '^H' history-substring-search-down
antigen bundle "b4b4r07/enhancd"
export ENHANCD_FILTER=peco
export ENHANCD_DISABLE_DOT=1

antigen-apply


# fzf

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
