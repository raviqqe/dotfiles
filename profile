#!/bin/sh

export BLOCKSIZE=K
export EDITOR=nvim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less

export PATH=$HOME/.local/bin:$PATH

# Homebrew

export HOMEBREW_NO_EMOJI=1

if [ $(uname) = Linux ]; then
  base=/home/linuxbrew/.linuxbrew
else
  base=/opt/homebrew
fi

for directory in \
  bin \
  sbin \
  opt/llvm/bin \
  opt/ruby/bin \
  opt/rustup/bin; do
  export PATH=$base/$directory:$PATH
done

## Python

export PYTHON_JIT=1
export AUTOSWITCH_DEFAULT_PYTHON=$base/bin/python3

# Languages

## Haskell

export PATH=$HOME/.cabal/bin:$PATH

## OCaml

export PATH=$HOME/.opam/default/bin:$PATH

## Go

export GOPATH=$HOME/.go
export GO111MODULE=on
export PATH=$GOPATH/bin:$PATH

## Rust

export PATH=$HOME/.cargo/bin:$PATH
export OPENSSL_STATIC=1 # for openssl-sys

## Node.js

export NODE_OPTIONS=--max-old-space-size=4096

## Scheme

export PATH=/opt/homebrew/opt/gambit-scheme/bin:$PATH

## Pen

export PEN_ROOT=$HOME/src/github.com/pen-lang/pen

# Tools

## git

unset SSH_ASKPASS

## ghq

export GHQ_ROOT=$HOME/src

## android

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

## fzf

export FZF_DEFAULT_OPTS='--exit-0 --select-1'

## skim

export SKIM_DEFAULT_OPTIONS='--ansi --exit-0 --select-1'

## zsh

export PURE_PROMPT_SYMBOL='>'
export PURE_PROMPT_VICMD_SYMBOL='<'
export PURE_GIT_DOWN_ARROW=v
export PURE_GIT_UP_ARROW=^
export PURE_GIT_STASH_SYMBOL==

# Custom profiles

export CACHED_PROFILE=$HOME/.cache/profile

local_profile=$HOME/.local/etc/profile

for file in $CACHED_PROFILE $local_profile; do
  if [ -r $file ]; then
    . $file
  fi
done
