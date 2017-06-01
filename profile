#!/bin/sh

. $HOME/.sh/util.sh


LOCAL=$HOME/.local


# environment variables

export BLOCKSIZE=K
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less
export TZ=Asia/Tokyo

export PATH=$HOME/bin:$LOCAL/bin:$PATH
export MANPATH=$LOCAL/share/man:/usr/share/man:/usr/local/man

## c language

# export CC=clang
# export CXX=clang++
export C_INCLUDE_PATH=$LOCAL/include
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH
export LIBRARY_PATH=$LOCAL/lib64:$LOCAL/lib

## cuda

export PATH=$PATH:/usr/local/cuda/bin
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64

## cmake configuration

export CMAKE_INCLUDE_PATH=$C_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=$LIBRARY_PATH
export CMAKE_PREFIX_PATH=$LOCAL

## linuxbrew

linuxbrew_dir=$HOME/.linuxbrew
export PATH=$linuxbrew_dir/bin:$linuxbrew_dir/sbin:$PATH
export MANPATH=$linuxbrew_dir/share/man:$MANPATH
export LIBRARY_PATH=$linuxbrew_dir/lib64:$linuxbrew_dir/lib:$LIBRARY_PATH
export HOMEBREW_NO_EMOJI=1

if type nproc > /dev/null 2>&1
then
  export HOMEBREW_MAKE_JOBS=$(nproc)
else
  export HOMEBREW_MAKE_JOBS=2
fi

## haskell

export PATH=$HOME/.cabal/bin:$PATH

## go

export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH

## rust

export PATH="$HOME/.cargo/bin:$PATH"
export RUST_SRC_PATH=$HOME/.cache/racer/rust/src
export RUSTUP_USE_HYPER=1

## python

if on_mac
then
  mac_python=$HOME/Library/Python/3.6
  export MYPYPATH=$mac_python/lib/python/site-packages
  export PATH=$mac_python/bin:$PATH
else
  export MYPYPATH=$LOCAL/lib/python3.6/site-packages
fi

## javascript

if which yarn > /dev/null 2>&1
then
  export PATH=$(yarn global bin):$HOME/.config/yarn/global/node_modules/.bin:$PATH
fi

## git

unset SSH_ASKPASS

## xdg

export XDG_CONFIG_HOME=$HOME/.config

## ghq

export GHQ_ROOT=$HOME/src

## android

export ANDROID_HOME=$HOME/.linuxbrew/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools

## fzf

export FZF_DEFAULT_OPTS='--exit-0 --select-1'

## LD_LIBRARY_PATH

# Because exporting LD_LIBRARY_PATH causes some unexpectable problems,
# unexport it as default and export it only when it needed.

ld_library_path=$LIBRARY_PATH
