gs() {
  git status "$@"
}

gsc() {
  git status --cached "$@"
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
