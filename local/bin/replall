#!/bin/sh

SUFFIX=.replaced.tmp

if [ $# -ne 1 ]
then
  echo "usage: $0 <s command>" >&2
  exit 1
fi

for file in $(find . -type f)
do
  if [ -r "$file" ] \
      && [ -w "$file" ] \
      && [ -n "$(file "$file" | grep text)" ] \
      && [ -z "$(echo "$file" | grep -e '/\.' -e '^\.[^/]')" ]
  then
    sed "$1" "$file" > "$file$SUFFIX"
    mv "$file$SUFFIX" "$file"
  fi
done
