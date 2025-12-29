setopt autocd autopushd hist_ignore_all_dups hist_reduce_blanks inc_append_history interactive_comments prompt_subst sh_word_split share_history
unsetopt banghist beep nomatch notify

autoload -Uz add-zsh-hook cdr chpwd_recent_dirs select-bracketed select-quoted

add-zsh-hook chpwd chpwd_recent_dirs

zstyle completion:*:*:cdr:*:* menu selection
zstyle :chpwd:* recent-dirs-insert fallback
zstyle :chpwd:* recent-dirs-pushd true

zle -N select-bracketed
zle -N select-quoted

bindkey -v
bindkey -v ^f forward-char
bindkey -v ^r history-incremental-pattern-search-forward

HISTFILE=~/.zsh_history
HISTSIZE=$((2 ** 32))
SAVEHIST=$HISTSIZE

# Plugins

eval "$(sheldon source)"

bindkey -a ? fzf-history-widget
bindkey -a k history-substring-search-up
bindkey -a j history-substring-search-down

# ssh-agent

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent)
  ssh-add
fi

# Extra commands

. ~/.shrc

chpwd() (
  ls
)
