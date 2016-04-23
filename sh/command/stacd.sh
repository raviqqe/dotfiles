. $HOME/.sh/util.sh



# variables

: ${_stacd_history:=$HOME}
export MAX_STACD_HISTORY=256


# commands

stacd() {
  _stacd_original_cd "$@" &&
  if ! on_zsh
  then
    _stacd_push_dir
  fi
}

stacd-history() {
  echo "$_stacd_history" | sed 's/\([^\]\):/\1\
/g' | sort | uniq
}

_stacd_push_dir() {
  _stacd_history=$(pwd | sed 's/:/\\:/g'):$_stacd_history

  local dir_entry='\([^:]\|\\\\:\)\+'
  local truncated_history=$(echo "$_stacd_history" | grep -o \
  '\('"$dir_entry"':\)\{'"$(expr $MAX_STACD_HISTORY - 1)"'\}'"$dir_entry")

  if [ -n "$truncated_history" ]
  then
    _stacd_history=$truncated_history
  fi
}

_stacd_original_cd() {
  if type builtin > /dev/null 2>&1
  then
    builtin cd "$@"
  else
    cd "$@"
  fi
}


# configuration

if on_zsh
then
  autoload -Uz add-zsh-hook &&
  add-zsh-hook chpwd _stacd_push_dir
fi
