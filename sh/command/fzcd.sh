. $HOME/.sh/util.sh


# variables

export FZCD_FILTER_COMMAND=fzf
export FZCD_CD_COMMAND=cd
export FZCD_HISTORY_COMMAND="dirs -p"


# commands

fzcd() {
  check_num_of_args fzcd 1 $# &&

  local dir &&
  dir=$(_fzcd_search_directories "$1" | grep -v "/\\." \
                                      | $FZCD_FILTER_COMMAND) &&
  $FZCD_CD_COMMAND "$dir"
}

fzcd-all() {
  check_num_of_args fzcd-all 1 $# &&

  local dir &&
  dir=$(_fzcd_search_directories "$1" | $FZCD_FILTER_COMMAND) &&
  $FZCD_CD_COMMAND "$dir"
}

fzcd-history() {
  check_num_of_args fzcd-history 0 $# &&

  local dir &&
  dir=$($FZCD_HISTORY_COMMAND | $FZCD_FILTER_COMMAND) &&
  $FZCD_CD_COMMAND "$dir"
}

_fzcd_search_directories() {
  check_num_of_args _fzcd_search_directories 1 $# &&

  find "$1" -type d
}
