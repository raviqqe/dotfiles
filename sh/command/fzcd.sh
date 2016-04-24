. $HOME/.sh/util.sh


# variables

export FZCD_FILTER_COMMAND=fzf
export FZCD_CD_COMMAND=cd
export FZCD_HISTORY_COMMAND="dirs -p"


# commands

fzcd() {
  check_num_of_args fzcd 1 $# &&

  _fzcd_check_filter &&
  $FZCD_CD_COMMAND \
      $(_fzcd_search_directories "$1" | grep -v "/\\." | $FZCD_FILTER_COMMAND)
}

fzcd-all() {
  check_num_of_args fzcd-all 1 $# &&

  _fzcd_check_filter &&
  $FZCD_CD_COMMAND $(_fzcd_search_directories "$1" | $FZCD_FILTER_COMMAND)
}

fzcd-history() {
  check_num_of_args fzcd-history 0 $# &&

  _fzcd_check_filter &&
  $FZCD_CD_COMMAND $($FZCD_HISTORY_COMMAND | $FZCD_FILTER_COMMAND)
}

_fzcd_search_directories() {
  check_num_of_args _fzcd_search_directories 1 $# &&

  find "$1" -type d
}

_fzcd_check_filter() {
  if ! type "$FZCD_FILTER_COMMAND" > /dev/null 2>&1
  then
    echo "Cannot find the filter command, \`$FZCD_FILTER_COMMAND\`." >&2
    return 1
  fi
}
