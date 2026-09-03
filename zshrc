. ~/.shrc

setopt autocd autopushd hist_ignore_all_dups hist_reduce_blanks inc_append_history interactive_comments prompt_subst sh_word_split share_history
unsetopt banghist beep nomatch notify

autoload -Uz add-zsh-hook cdr chpwd_recent_dirs select-bracketed select-quoted vcs_info

add-zsh-hook chpwd chpwd_recent_dirs
add-zsh-hook precmd vcs_info

zstyle :chpwd:* recent-dirs-insert fallback
zstyle :chpwd:* recent-dirs-pushd true
zstyle :vcs_info:git:* formats '%F{yellow}%b%f %F{cyan}%m%f'
zstyle :vcs_info:git*+set-message:* hooks git-remote
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

+vi-git-remote() {
  local behind ahead

  git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null |
    read behind ahead ||
    return 0

  if [ $ahead -gt 0 ]; then
    hook_com[misc]+=^
  fi

  if [ $behind -gt 0 ]; then
    hook_com[misc]+=v
  fi

  if [ -n "$hook_com[misc]" ]; then
    hook_com[misc]+=' '
  fi
}

zle-keymap-select() {
  if [ $KEYMAP = vicmd ]; then
    vi_mode='<'
  else
    vi_mode='>'
  fi

  zle reset-prompt
}

zle-line-init() {
  zle-keymap-select
}

zle -N zle-keymap-select
zle -N zle-line-init

PROMPT='%F{blue}%~%f ${vcs_info_msg_0_}%(?..%F{red}[%?]%f )
%F{magenta}$vi_mode%f '

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
