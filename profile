#!/bin/sh

. $HOME/.sh/util.sh


# environment variables

export BLOCKSIZE=K
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export MANWIDTH=tty
export PAGER=less
export TZ=Asia/Tokyo

LOCAL=$HOME/.local

export PATH=$HOME/bin:$LOCAL/bin:$PATH
export MANPATH=$LOCAL/share/man:/usr/share/man:/usr/local/man

## c language

export CC=clang
export CXX=clang++
export C_INCLUDE_PATH=$LOCAL/include
export CPLUS_INCLUDE_PATH=$C_INCLUDE_PATH
export LIBRARY_PATH=$LOCAL/lib64:$LOCAL/lib
export LD_LIBRARY_PATH=$LIBRARY_PATH

## cuda

if on_linux
then
  export PATH=$PATH:/usr/local/cuda/bin
  export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/cuda/lib64
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
fi

## cmake configuration

export CMAKE_INCLUDE_PATH=$C_INCLUDE_PATH
export CMAKE_LIBRARY_PATH=$LIBRARY_PATH
export CMAKE_PREFIX_PATH=$LOCAL

## haskell

export PATH=$HOME/.cabal/bin:$PATH

## go lang

export GOPATH=$HOME/.go
export PATH=$GOPATH/bin:$PATH

## git

unset SSH_ASKPASS

## linuxbrew

if on_linux
then
  linuxbrew_dir=$HOME/.linuxbrew
  export PATH=$linuxbrew_dir/bin:$PATH
  export MANPATH=$linuxbrew_dir/share/man:$MANPATH
  export LIBRARY_PATH=$linuxbrew_dir/lib64:$linuxbrew_dir/lib:$LIBRARY_PATH
  export LD_LIBRARY_PATH=$LIBRARY_PATH
fi

## xdg

export XDG_CONFIG_HOME=$HOME/.config
