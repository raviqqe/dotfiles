. $HOME/.sh/util.sh



# variables

: ${_fzcd_history:=$HOME}
export MAX_FZCD_HISTORY=256
export FZCD_FILTER=fzf


# commands

fzcd() {
  _fzcd_original_cd "$@" &&
  if ! on_zsh
  then
    fzcd-push-dir
  fi
}

fzcd-home() {
  _fzcd_check_filter &&
  fzcd $(_fzcd_directories_in_home | grep -v "/\\." | $FZCD_FILTER)
}

fzcd-home-all() {
  _fzcd_check_filter &&
  fzcd $(_fzcd_directories_in_home | $FZCD_FILTER)
}

fzcd-history() {
  _fzcd_check_filter &&
  fzcd $(_fzcd_print_history | $FZCD_FILTER)
}

fzcd-push-dir() {
  _fzcd_history=$(pwd | sed 's/:/\\:/g'):$_fzcd_history

  local dir_entry='\([^:]\|\\\\:\)\+'
  local truncated_history=$(echo "$_fzcd_history" | grep -o \
        '\('"$dir_entry"':\)\{'"$(expr $MAX_FZCD_HISTORY - 1)"'\}'"$dir_entry")

  if [ -n "$truncated_history" ]
  then
    _fzcd_history=$truncated_history
  fi
}

_fzcd_directories_in_home() {
  find "$HOME" -type d
}

_fzcd_original_cd() {
  if type builtin > /dev/null 2>&1
  then
    builtin cd "$@"
  else
    cd "$@"
  fi
}

_fzcd_print_history() {
  echo "$_fzcd_history" | sed 's/\([^\]\):/\1\
/g' | sort | uniq
}

_fzcd_check_filter() {
  if ! which "$FZCD_FILTER" > /dev/null 2>&1
  then
    echo "Cannot find the filter command, \`$FZCD_FILTER\`." >&2
    return 1
  fi
}


# configuration

if on_zsh
then
  autoload -Uz add-zsh-hook &&
  add-zsh-hook chpwd fzcd-push-dir
fi
