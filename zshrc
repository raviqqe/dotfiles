#!/usr/bin/env zsh

. ~/.sh/util.sh
. ~/.sh/command.sh


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

HISTFILE=~/.zhistory
HISTSIZE=$((2 ** 16))
SAVEHIST=$((2 ** 17))

setopt autocd autopushd extendedglob hist_ignore_dups prompt_subst \
       sh_word_split share_history
unsetopt beep notify nomatch banghist

bindkey -v
bindkey "^[[3~" delete-char
bindkey -a '?' history-incremental-pattern-search-backward

function chpwd {
  ls
}


# suffix alias

for suffix in c cc cxx go graphql h html js json jsx md py rb rs ts tsx vim yml
do
  alias -s $suffix=$EDITOR
done

for suffix in txt log
do
  alias -s $suffix=less
done


# emacs key mapping

bindkey -v '\er' history-incremental-pattern-search-forward
bindkey -v '^?' backward-delete-char
bindkey -v '^A' beginning-of-line
bindkey -v '^B' backward-char
bindkey -v '^D' delete-char-or-list
bindkey -v '^E' end-of-line
bindkey -v '^F' forward-char
bindkey -v '^G' send-break
bindkey -v '^H' backward-delete-char
bindkey -v '^K' kill-line
bindkey -v '^U' backward-kill-line
bindkey -v '^W' forward-word
bindkey -v '^Y' yank


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

function zle-line-init zle-keymap-select {
  PROMPT=$(prompt_with_vimode \
           ${${KEYMAP/vicmd/$normal_mode}/(main|viins)/$insert_mode})
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select


# plugins

. ~/.zplug/init.zsh

zplug zsh-users/zsh-autosuggestions, lazy:true
zplug zsh-users/zsh-completions, lazy:true
zplug zsh-users/zsh-syntax-highlighting
zplug zsh-users/zsh-history-substring-search

bindkey -v '^P' history-substring-search-up
bindkey -v '^N' history-substring-search-down
bindkey -a k history-substring-search-up
bindkey -a j history-substring-search-down

if ! zplug check --verbose
then
  zplug install
fi
zplug load > /dev/null

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=6


# fzf

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
bindkey -a '?' fzf-history-widget


# google cloud sdk

if [ -f $HOME/.google/google-cloud-sdk/path.zsh.inc ]
then
  . $HOME/.google/google-cloud-sdk/path.zsh.inc
fi

if [ -f $HOME/.google/google-cloud-sdk/completion.zsh.inc ]
then
  . $HOME/.google/google-cloud-sdk/completion.zsh.inc
fi


# ssh-agent

linked_socket="$HOME/.ssh/agent.sock"

if [ -z "$SSH_AUTH_SOCK" ]
then
  eval `ssh-agent` && ssh-add
fi > /dev/null 2>&1

# `ssh $(hostname)` and then `ssh-add -l` would be stuck with the code below.
# So, it is commented out.
# Moreover, I don't use ssh from inside tmux sessions when forwarding
# credentials.
#
# if [ "$SSH_AUTH_SOCK" != "$linked_socket" ]
# then
#   ln -sf "$SSH_AUTH_SOCK" "$linked_socket"
#   SSH_AUTH_SOCK=$linked_socket
# fi


# initialization

dotfiles_dir=~/.dotfiles
if ! is_clean_git_repo $dotfiles_dir
then
  warn "dotfiles directory, $dotfiles_dir is not clean." \
       "Please push the changes to the upstream."
fi
