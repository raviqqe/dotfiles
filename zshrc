#!/usr/bin/env zsh

. $HOME/.zsh/util.zsh
. $HOME/.zsh/command.zsh


# options

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

autoload -Uz colors
colors

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle 'completion:*:*:cdr:*:*' menu selection
zstyle ':chpwd:*' recent-dirs-insert fallback
zstyle ':chpwd:*' recent-dirs-pushd true
autoload -Uz select-bracketed select-quoted
zle -N select-bracketed
zle -N select-quoted

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt appendhistory autocd extendedglob prompt_subst
unsetopt beep notify nomatch

bindkey -v
bindkey "^[[3~" delete-char
bindkey -a '?' history-incremental-pattern-search-backward


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

prompt_with_vimode() {
  echo '%n@%m %{$fg[yellow]%}%20<..<%~%<< '\
'%{$fg[cyan]%}$(git_branch)'\
'%{$fg[red]%}%(?..[%?] )'\
"$1"'%{$fg[magenta]%}%# %{$reset_color%}'
}

insert_mode='%{$fg[magenta]%}I'
normal_mode='%{$fg[white]%}N'
visual_mode='%{$fg[yellow]%}V'

PROMPT=$(prompt_with_vimode $insert_mode)
PROMPT2='%_> '
RPROMPT=' %W %T'

function zle-line-init zle-keymap-select {
  PROMPT=$(prompt_with_vimode \
           ${${KEYMAP/vicmd/$normal_mode}/(main|viins)/$insert_mode})
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# plugins

. "$HOME/.zplug/zplug"

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "ehamberg/zsh-cabal-completion"
zplug "k4rthik/git-cal", as:command

zplug "mollifier/anyframe"
zstyle ":anyframe:selector:" use fzf
zstyle ":anyframe:selector:fzf:" command 'fzf --select-1'

bindkey "^xw" anyframe-widget-select-widget
bindkey "^xb" anyframe-widget-cdr
bindkey "^xr" anyframe-widget-execute-history
bindkey "^xp" anyframe-widget-put-history
bindkey "^xk" anyframe-widget-kill
bindkey "^xf" anyframe-widget-insert-filename

zplug "zsh-users/zsh-history-substring-search"
bindkey -a 'k' history-substring-search-up
bindkey -a 'j' history-substring-search-down

zplug "b4b4r07/enhancd", of:enhancd.sh
export ENHANCD_FILTER=fzf
export ENHANCD_DISABLE_DOT=1
export ENHANCD_COMMAND=c

if ! zplug check --verbose
then
  zplug install
fi
zplug load


# fzf

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
bindkey -a '?' fzf-history-widget


# initialization

dotfiles_dir=~/.dotfiles
if ! is_clean_git_repo $dotfiles_dir
then
  warn "dotfiles directory, \"$dotfiles_dir\" is not clean." \
       "Please push the changes to the upstream."
fi
