#!/usr/bin/env zsh

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
    echo "$branch_name$(git_modified) "
  fi
}

git_grep_modified_files() {
  grep -e "^.M" -e "^M." -e "^A." -e "^D." -e "^.D"
}

git_modified() {
  if [ -n "$(git status --porcelain | git_grep_modified_files)" ]
  then
    echo "*"
  fi
}

PROMPT='%n@%m %{$fg[yellow]%}%20<..<%~%<< '\
'%{$fg[cyan]%}$(git_branch)'\
'%{$fg[red]%}%(?..[%?] )%{$fg[magenta]%}%# %{$reset_color%}'
PROMPT2='%_> '
RPROMPT=' %W %T' # doesn't work well...


# antigen

. "$HOME/.antigen/antigen.zsh"

antigen-apply
