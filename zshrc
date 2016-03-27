#!/usr/bin/env zsh
# ~/.zshrc

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

alias ls='ls -F'


# prompt

git_branch() {
  branch_name=$(git symbolic-ref --short HEAD 2> /dev/null)
  if [ -n "$branch_name" ]
  then
    echo "$branch_name "
  fi
}

PROMPT='%n@%m $fg[yellow]%20<..<%~%<< '\
'$fg[cyan]$(git_branch)'\
'$fg[red]%(?..[%?] )$fg[magenta]%# $reset_color'
PROMPT2='%_> '
#RPROMPT=' %W %T' # doesn't work well...


# antigen

. "$HOME/.antigen/antigen.zsh"

antigen-apply
