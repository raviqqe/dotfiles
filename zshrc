setopt autocd autopushd extended_glob hist_ignore_all_dups hist_reduce_blanks inc_append_history interactive_comments prompt_subst sh_word_split share_history
unsetopt bang_hist beep nomatch notify

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

HISTFILE=~/.zsh_history
HISTSIZE=$((2 ** 32))
SAVEHIST=$HISTSIZE

# Plugins

eval "$(sheldon source)"

bindkey -a '?' fzf-history-widget
bindkey -v '^P' history-substring-search-up
bindkey -v '^N' history-substring-search-down
bindkey -a k history-substring-search-up
bindkey -a j history-substring-search-down

# ssh-agent

if [ -z "$SSH_AUTH_SOCK" ]; then
  eval $(ssh-agent) && ssh-add
fi >/dev/null 2>&1

# Extra commands

. ~/.shrc

chpwd() (
  ls
)
