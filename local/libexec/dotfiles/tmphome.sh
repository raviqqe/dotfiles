#!/bin/sh

home_dir=/home/raviqqe
home_size=512m


# functions

update_git() {
  if [ $# -ne 1 ]
  then
    echo "usage: $0 <git repo dir>" >&2
    exit 1
  fi

  git_repo_dir=$1

  if [ -d "$git_repo_dir" ]
  then
    (
      cd "$git_repo_dir"
      git pull --all
    )
  fi
}

copy_all_contents() {
  for file in $(find "$1" -maxdepth 1 -mindepth 1)
  do
    cp -a "$file" "$2"
  done
}


# main routine

if [ -d "$home_dir/.git" ]
then
  update_git "$home_dir"
fi

tmp_home_dir=/tmp/$home_dir

mkdir -p "$tmp_home_dir"
copy_all_contents "$home_dir" "$tmp_home_dir"
mount -t tmpfs -o size="$home_size" tmpfs "$home_dir"
copy_all_contents "$tmp_home_dir" "$home_dir"
