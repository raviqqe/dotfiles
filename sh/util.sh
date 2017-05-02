on_zsh() {
  ps $$ | grep -o '[^a-zA-Z]zsh' > /dev/null
}

is_network_alive() {
  check_num_of_args is_clean_git_repo 0 $# || return 1

  ping -w 1 -c 1 8.8.8.8 > /dev/null
}

is_clean_git_repo() {
  check_num_of_args is_clean_git_repo 1 $# || return 1
  dir=$1

  is_git_repo $dir && [ -z "$(git -C "$dir" status --porcelain)" ] && return 0
  return 1
}

is_git_repo() {
  check_num_of_args is_git_repo 1 $# || return 1
  dir=$1

  [ -d "$dir/.git" ]
}

info() {
  echo "$@" >&2
}

warn() {
  info "WARNING:" "$@"
}

error() {
  info "ERROR:" "$@"
}

check_num_of_args() {
  message="Invalid number of arguments"

  if [ $# -ne 3 ]
  then
    error "check_num_of_args():" "$message" >&2
    return 1
  fi

  func_name=$1
  proper_num_of_args=$2
  actual_num_of_args=$3

  if [ $actual_num_of_args -ne $proper_num_of_args ]
  then
    error "$func_name():" "$message" >&2
    return 1
  fi
}
