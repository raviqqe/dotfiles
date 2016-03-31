on_linux() {
  [ "$(uname)" = Linux ]
}

on_freebsd() {
  [ "$(uname)" = FreeBSD ]
}

is_git_repo() {
  if [ $# -ne 1 ]
  then
    error "is_git_repo():" "Invalid number of arguments" >&2
    return 1
  fi

  [ -d "$1/.git" ]
}

info() {
  echo "$@" >&2
}

warn() {
  info "WARNING:" "$@"
  return 1
}

error() {
  info "ERROR:" "$@"
  return 1
}
