gs() {
  git status "$@"
}

gpl() {
  git pull "$@"
}

gps() {
  git push "$@"
}

gppa() {
  git pull --all && git push --all
}

gd() {
  git diff "$@"
}

gdc() {
  git diff --cached "$@"
}

ga() {
  git add "$@"
}

gc() {
  if [ $# -lt 1 ]
  then
    echo "Invalid number of arguments" >&2
    return 1
  fi

  message=$1
  shift

  git commit -m "$message" "$@"
}
