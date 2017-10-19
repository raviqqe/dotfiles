#!/bin/sh

. $HOME/.sh/util.sh


# constants

github_address=https://github.com


# functions

info() {
  echo "$@" >&2
}

fail() {
  info "$@"
  exit 1
}

info_installing() {
  info "$(basename $0): Installing" "$@" "..."
}

git_clone_to_dir() {
  check_num_of_args "git_clone_to_dir" 2 $#
  address=$1
  dir=$2

  if is_git_repo "$dir"
  then
    git -C "$dir" pull
  else
    mkdir -p "$dir" &&
    git clone "$address" "$dir"
  fi
}

is_64_bit() {
  [ $(getconf LONG_BIT) = 64 ]
}

is_x86_64() {
  [ "$(uname -m)" = x86_64 ]
}

gem_install() {
  gem install "$@" && gem update "$@"
}

install_linuxbrew() {
  info_installing "linuxbrew" &&

  linuxbrew_dir=$HOME/.linuxbrew

  if [ ! -d $linuxbrew_dir ]
  then
    git clone $github_address/Linuxbrew/linuxbrew.git $linuxbrew_dir
  fi
}

install_linuxbrew_packages() {
  while getopts dv option
  do
    case $option in
    d)
      desktop=true
      ;;
    v)
      verbose=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  info_installing "linuxbrew packages" &&

  brew update &&
  brew update &&

  brew upgrade &&

  if is_64_bit
  then
    brew tap thoughtbot/formulae &&
    brew install rcm
  fi &&

  brew install ${verbose:+-v} \
      --without-docs --without-doxygen --without-icu4c --without-jemalloc \
      --without-libgit2 \
      curl $(is_x86_64 && echo exa) zsh git tmux lynx links htop tig \
      $(is_x86_64 && echo go) ruby python python3 neovim node nvm gawk \
      gnu-sed yarn &&
  # ghc haskell-stack elm-format git-lfs

  if [ -n "$desktop" ]
  then
    brew tap homebrew/x11 &&
    brew install feh mupdf
  fi
}

install_elm_format() {
  info_installing "elm-format" &&

  if is_x86_64 && uname -a | grep Linux > /dev/null
  then
    file=/tmp/elm-format-$$.tgz
    curl -sSL 'https://github.com/avh4/elm-format/releases/download/0.6.0-alpha/elm-format-0.18-0.6.0-alpha-linux-x64.tgz' > $file &&
    ( cd $(dirname $file) && tar xf $file ) &&
    mv /tmp/elm-format ~/.local/bin
  fi
}

install_haskell_packages() {
  info_installing "haskell packages" &&

  install_elm_format

  # Cabal doesn't work on low-memory systems.
  # if which cabal
  # then
  #   cabal update
  #   cabal install --upgrade-dependencies ShellCheck
  # fi
}

install_rustup() {
  info_installing "rustup" &&

  if ! which rustup
  then
    curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
  fi &&

  rustup self update &&
  rustup update &&
  rustup install stable &&
  rustup default stable
}

install_rust_packages() {
  info_installing "rust packages" &&

  cargo='rustup run stable cargo'
  packages='cargo-update fd-find racer ripgrep rustfmt tokei'

  for package in $packages
  do
    $cargo install $package || :
  done &&

  $cargo install-update $packages &&

  if [ -n "$RUST_SRC_PATH" ]
  then
    repo="$(dirname "$RUST_SRC_PATH")"

    rm -rf "$repo" &&
    git clone --depth 1 https://github.com/rust-lang/rust "$repo"
  else
    fail '$RUST_SRC_PATH is not set.'
  fi
}

install_go_packages() {
  info_installing "go packages" &&

  go get "$@" -u \
      golang.org/x/tools/cmd/... \
      github.com/alecthomas/gometalinter \
      github.com/client9/misspell/... \
      github.com/constabulary/gb/... \
      github.com/fatih/hclfmt \
      github.com/junegunn/fzf \
      github.com/github/hub \
      github.com/ethereum/go-ethereum/cmd/geth \
      github.com/golang/lint/golint \
      github.com/hashicorp/packer \
      github.com/hashicorp/terraform \
      github.com/k0kubun/pp \
      github.com/mitchellh/gox \
      github.com/motemen/ghq \
      github.com/motemen/gore \
      github.com/mvdan/interfacer/... \
      github.com/mvdan/sh/cmd/shfmt \
      github.com/nsf/gocode \
      github.com/raviqqe/bstie \
      github.com/rogpeppe/godef \
      honnef.co/go/tools/...
}

install_python_packages() {
  info_installing "python packages" &&
  pip3 install --user --upgrade \
      autopep8 awscli codemod flake8 frosted httpie mkdocs mypy shakyo pylama \
      pylint twine vim-vint
}

install_ruby_gems() {
  info_installing "ruby gems" &&
  gem_install aruba bundler gitlab gist rubocop
}

install_ruby_gem_credential() {
  info_installing "ruby gem credentials"

  local credential_file=$HOME/.gem/credentials

  if [ ! -r "$credential_file" ]
  then
    mkdir -p $(dirname $credential_file) &&
    curl -u raviqqe https://rubygems.org/api/v1/api_key.yaml \
         > "$credential_file" &&
    chmod 600 "$credential_file"
  fi
}

install_yarn_packages() {
  info_installing "yarn packages" &&

  packages='ava babel-eslint depcheck diff-so-fancy git-recall gulp gtop
            js-beautify jshint jsonlint karma leasot npm npm-check-updates
            remark-cli serverless standard stylelint stylelint-config-standard
            tslint typescript-formatter'
  yarn global add --ignore-scripts $packages &&
  yarn global upgrade --ignore-scripts $packages
}

install_vim_plug() {
  info_installing "vim-plug" &&
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_vim_plugins() {
  install_vim_plug &&
  info_installing "neovim plugins" &&

  pip2=pip

  if which pip2 > /dev/null 2>&1
  then
    pip2=pip2
  fi &&

  $pip2 install --user --upgrade neovim &&

  pip3 install --user --upgrade neovim &&
  gem_install neovim
  nvim +PlugUpgrade +PlugClean! +PlugUpdate +qall
}

install_zplug() {
  info_installing "zplug" &&
  git_clone_to_dir https://github.com/zplug/zplug $HOME/.zplug
}

install_zsh_plugins() {
  install_zplug &&
  info_installing "zsh plugins" &&
  zsh -c ". $HOME/.zprofile && . $HOME/.zshrc"
}

install_dwm() {
  info_installing "dwm" &&

  ghq get raviqqe/dwm &&
  (
    cd $HOME/src/github.com/raviqqe/dwm &&
    git checkout freebsd-theme &&
    make &&
    cp dwm $HOME/.local/bin
  )
}

install_tpm() {
  info_installing "tpm" &&
  git_clone_to_dir "$github_address/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
}

install_wallpapers() {
  info_installing "wallpapers" &&
  git_clone_to_dir https://git.raviqqe.com/funny/wallpapers.git \
                   "$HOME/.wallpapers"
}

install_google_cloud_sdk() {
  info_installing "google cloud SDK" &&

  google_dir=$HOME/.google

  mkdir -p $google_dir &&

  if [ ! -d $google_dir/google-cloud-sdk ]
  then
    curl https://sdk.cloud.google.com |
    bash /dev/stdin --disable-prompts --install-dir $google_dir
  fi
}

check_args() {
  if [ $# -ne 0 ]
  then
    fail "usage: $(basename $0) [-b] [-d]"
  fi
}


# main routine

main() {
  while getopts bdhlv option
  do
    case $option in
    b)
      batch=true
      ;;
    d)
      desktop=true
      ;;
    l)
      low_memory=true
      ;;
    h)
      homebrew=false
      ;;
    v)
      verbose=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  check_args "$@"

  (
    . $HOME/.profile &&

    if [ -z "$homebrew" ]
    then
      install_linuxbrew &&
      install_linuxbrew_packages ${desktop:+-d} ${verbose:+-v}
    fi &&

    install_zsh_plugins &&
    install_tpm &&
    install_python_packages &&
    install_ruby_gems &&
    install_yarn_packages &&
    install_haskell_packages &&
    install_rustup &&
    install_rust_packages &&

    if [ -z $low_memory ]
    then
      install_go_packages ${verbose:+-v}
    fi &&

    if [ -n "$desktop" ]
    then
      install_dwm &&
      install_wallpapers
    fi &&

    if is_x86_64
    then
      install_google_cloud_sdk
    fi &&

    if [ -z "$batch" ]
    then
      install_ruby_gem_credential &&
      install_vim_plugins
    fi
  ) ||

  fail "Failed to initialize dotfiles environment."
}

main "$@"
