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
