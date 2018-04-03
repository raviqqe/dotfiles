setopt autocd autopushd extendedglob hist_ignore_dups prompt_subst sh_word_split share_history
unsetopt beep notify nomatch banghist

autoload -Uz add-zsh-hook cdr chpwd_recent_dirs compinit select-bracketed select-quoted

compinit
add-zsh-hook chpwd chpwd_recent_dirs

zstyle completion:*:*:cdr:*:* menu selection
zstyle :chpwd:* recent-dirs-insert fallback
zstyle :chpwd:* recent-dirs-pushd true

zle -N select-bracketed
zle -N select-quoted

bindkey "^[[3~" delete-char
bindkey -v
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

HISTFILE=~/.zhistory
HISTSIZE=$((2 ** 16))
SAVEHIST=$((2 ** 17))

function chpwd {
  ls
}

for suffix in c cc cxx go graphql h html js json jsx md py rb rs ts tsx vim yml
do
  alias -s $suffix=$EDITOR
done

for suffix in txt log
do
  alias -s $suffix=$PAGER
done


# Prompt

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

PROMPT=$(prompt_with_vimode $insert_mode)
PROMPT2='%_> '

function zle-line-init zle-keymap-select {
  PROMPT=$(prompt_with_vimode ${${KEYMAP/vicmd/$normal_mode}/(main|viins)/$insert_mode})
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select


# Plugins

. ~/.zplug/init.zsh

zplug junegunn/fzf, use:shell/*.zsh
zplug zsh-users/zsh-autosuggestions
zplug zsh-users/zsh-completions, lazy:true
zplug zsh-users/zsh-syntax-highlighting
zplug zsh-users/zsh-history-substring-search

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=6

bindkey -a ? fzf-history-widget
bindkey -v '^P' history-substring-search-up
bindkey -v '^N' history-substring-search-down
bindkey -a k history-substring-search-up
bindkey -a j history-substring-search-down

if ! zplug check
then
  zplug install
fi

zplug load


# Google Cloud SDK

include_file=~/.google/google-cloud-sdk/completion.zsh.inc

if [ -f $include_file ]
then
  . $include_file
fi


# ssh-agent

if [ -z "$SSH_AUTH_SOCK" ]
then
  eval `ssh-agent` && ssh-add
fi > /dev/null 2>&1


# Extra commands

. ~/.sh/command.sh
