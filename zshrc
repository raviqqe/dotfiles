setopt autocd autopushd extendedglob hist_ignore_all_dups inc_append_history prompt_subst sh_word_split share_history
unsetopt banghist beep nomatch notify

autoload -Uz add-zsh-hook cdr chpwd_recent_dirs select-bracketed select-quoted

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
HISTSIZE=$((2 ** 32))
SAVEHIST=$HISTSIZE

# Plugins

. ~/.cache/zsh_plugins.sh

bindkey -a ? fzf-history-widget
bindkey -v '^P' history-substring-search-up
bindkey -v '^N' history-substring-search-down
bindkey -a k history-substring-search-up
bindkey -a j history-substring-search-down

# Google Cloud SDK

include_file=~/.google/google-cloud-sdk/completion.zsh.inc

if [ -f $include_file ]; then
  . $include_file
fi

# ssh-agent

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent) && ssh-add
fi >/dev/null 2>&1

# Extra commands

. ~/.shrc

chpwd() {
  ls
}
