#!/usr/bin/env zsh
# ~/.zshrc

# The following lines were added by compinstall
zstyle :compinstall filename '/home/raviqqe/.zshrc'

autoload -Uz compinit
autoload -U colors
compinit


# history
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# options
setopt appendhistory autocd extendedglob
unsetopt beep notify nomatch

# key binds
bindkey -e
bindkey "^[[3~" delete-char

# aliases
alias ls='ls -F'

# prompt
PROMPT='%n@%m %20<..<%~%<< %(?..[%?] )%# '
PROMPT2='%_> '
RPROMPT=' %W %T' # doesn't work well...
