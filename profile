#!/bin/sh

export BLOCKSIZE=K
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less

export PATH=$HOME/.local/bin:$PATH

## Homebrew

export HOMEBREW_NO_EMOJI=1
export LD_LIBRARY_PATH=$HOME/.homebrew/lib:$LD_LIBRARY_PATH
export PKG_CONFIG_PATH=$(brew --prefix)/opt/openssl/lib/pkgconfig

if [ -d ~/.homebrew ]; then
  eval $(~/.homebrew/bin/brew shellenv)
fi

### OpenSSL

export SSL_CERT_FILE=$HOME/.homebrew/etc/openssl/cert.pem

## Haskell

export PATH=$HOME/.cabal/bin:$PATH

## OCaml

export PATH=$HOME/.opam/default/bin:$PATH

## Go

export GOPATH=$HOME
export GO111MODULE=on
export PATH=$GOPATH/bin:$PATH

## Rust

export PATH=$HOME/.cargo/bin:$PATH
export LD_LIBRARY_PATH=$(rustc --print sysroot 2>/dev/null)/lib:$LD_LIBRARY_PATH

## Ruby

if [ -d ~/.homebrew/Cellar/ruby ]; then
  export PATH=$(echo ~/.homebrew/Cellar/ruby/*/bin ~/.gem/ruby/*/bin | tr ' ' :):$PATH
fi

## Node.js

export NODE_OPTIONS="--max-old-space-size=4092"

## git

unset SSH_ASKPASS

## ghq

export GHQ_ROOT=$HOME/src

## fzf

export FZF_DEFAULT_OPTS='--exit-0 --select-1'

## zsh

export PURE_PROMPT_SYMBOL='>'
export PURE_PROMPT_VICMD_SYMBOL='<'
export PURE_GIT_DOWN_ARROW=v
export PURE_GIT_UP_ARROW=^

export ZPLUG_HOME=$HOME/.homebrew/opt/zplug

## Google Cloud SDK

export PATH=$HOME/.google/google-cloud-sdk/bin:$PATH
