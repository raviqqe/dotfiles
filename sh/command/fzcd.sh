# variables

export FZCD_FILTER_COMMAND=fzf
export FZCD_CD_COMMAND=cd
export FZCD_HISTORY_COMMAND="dirs -p"


# commands

fzcd-home() {
  _fzcd_check_filter &&
  $FZCD_CD_COMMAND \
      $(_fzcd_directories_in_home | grep -v "/\\." | $FZCD_FILTER_COMMAND)
}

fzcd-home-all() {
  _fzcd_check_filter &&
  $FZCD_CD_COMMAND $(_fzcd_directories_in_home | $FZCD_FILTER_COMMAND)
}

fzcd-history() {
  _fzcd_check_filter &&
  $FZCD_CD_COMMAND $($FZCD_HISTORY_COMMAND | $FZCD_FILTER_COMMAND)
}

_fzcd_directories_in_home() {
  find "$HOME" -type d
}

_fzcd_check_filter() {
  if ! type "$FZCD_FILTER_COMMAND" > /dev/null 2>&1
  then
    echo "Cannot find the filter command, \`$FZCD_FILTER_COMMAND\`." >&2
    return 1
  fi
}
