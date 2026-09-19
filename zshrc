. ~/.shrc

setopt autocd autopushd hist_ignore_all_dups hist_reduce_blanks inc_append_history interactive_comments prompt_subst sh_word_split share_history
unsetopt banghist beep nomatch notify

autoload -Uz add-zsh-hook cdr chpwd_recent_dirs select-bracketed select-quoted vcs_info

add-zsh-hook chpwd chpwd_recent_dirs
add-zsh-hook precmd vcs_info

zstyle :chpwd:* recent-dirs-insert fallback
zstyle :chpwd:* recent-dirs-pushd true
zstyle completion:*:*:cdr:*:* menu selection

zle -N select-bracketed
zle -N select-quoted

bindkey -v
bindkey -v ^? backward-delete-char
bindkey -v ^f forward-char
bindkey -v ^h backward-delete-char

HISTFILE=~/.zsh_history
HISTSIZE=$((2 ** 32))
SAVEHIST=$HISTSIZE

# Prompt

chpwd() (
  ls
)

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
