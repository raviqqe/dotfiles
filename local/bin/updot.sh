#!/bin/sh

# constants

log_file=$(basename "$0.log")
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

install_linuxbrew() {
  info_installing "linuxbrew" &&

  linuxbrew_dir=$HOME/.linuxbrew

  if [ ! -d $linuxbrew_dir ]
  then
    git clone $github_address/Linuxbrew/linuxbrew.git $linuxbrew_dir
  fi
}

install_linuxbrew_packages() {
  while getopts d option
  do
    case $option in
    d)
      desktop_mode=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  info_installing "linuxbrew packages" &&

  brew update &&
  brew update &&

  if [ $(getconf LONG_BIT) = 64 ]
  then
    brew tap thoughtbot/formulae &&
    brew install rcm
  fi &&

  brew tap homebrew/dupes &&
  brew install gperf m4 bison &&

  brew install libevent --without-doxygen &&
  brew install zsh git tmux lynx links irssi bmake htop tig \
               ruby python python3 \
               gawk && # for zplug
  # brew install ghc haskell-stack &&

  brew install neovim/neovim/neovim &&

  if [ -n "$desktop_mode" ]
  then
    brew tap homebrew/x11 &&
    brew install feh
  fi
}

install_freebsd_pkg() {
  info_installing "freebsd pkg command" &&
  if ! pkg -N > /dev/null 2>&1
  then
    sudo pkg bootstrap
  fi
}

install_freebsd_packages() {
  while getopts dx option
  do
    case $option in
    d)
      desktop_mode=true
      ;;
    x)
      extra_mode=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  local portmaster="sudo portmaster -Gdy --no-confirm"
  local pkg_install="sudo pkg install -y"

  info_installing "freebsd packages" &&
  sudo pkg upgrade -y &&
  sudo portsnap fetch update &&

  info_installing "freebsd base packages" &&
  $pkg_install \
      sudo nmap arping htop ca_root_nss \
      portmaster portlint \
      zsh bash tmux lynx ii simpleirc rcm \
      git subversion fossil tig \
      go ghc hs-cabal-install stack nasm gmake ninja \
      python35 python ruby devel/ruby-gems \
      qemu bsdtris bsdgames &&
  (cd /usr/ports/editors/neovim && sudo make reinstall) &&
  # $portmaster neovim &&
  python3.5 -m ensurepip --user --upgrade &&
  python -m ensurepip --user --upgrade &&

  if [ -n "$desktop_mode" ]
  then
    info_installing "freebsd desktop packages" &&
    $pkg_install \
        xorg-minimal xorg-docs xsetroot xset xlsfonts xfontsel xrdb xsm \
        xrandr xrefresh fontconfig xautolock nvidia-driver \
        dwm xdm rxvt-unicode surf-browser feh scrot slock \
        firefox thunderbird pcmanfm inkscape gimp libreoffice mupdf \
        terminus-font terminus-ttf ja-font-ipa ubuntu-font \
        ja-ibus-mozc poppler-utils libX11 libXft freetype2 &&
    fc-cache -f
  fi &&

  if [ -n "$extra_mode" ]
  then
    info_installing "freebsd extra packages" &&
    $pkg_install texlive-full
  fi
}

install_rustup() {
  info_installing "rustup" &&

  if ! which rustup
  then
    script=/tmp/$$-rustup.sh
    curl https://sh.rustup.rs -sSf > $script &&
    sh $script -y &&
    rm $script
  fi &&

  rustup self update &&
  rustup update &&
  rustup install nightly &&
  rustup default nightly
}

install_rust_packages() {
  info_installing "rust packages" &&

  for crate in racer
  do
    rustup run stable cargo install --force $crate | :
  done &&

  if [ -n "$RUST_SRC_PATH" ]
  then
    git_clone_to_dir https://github.com/rust-lang/rust/ \
                     "$(dirname "$RUST_SRC_PATH")"
  else
    fail '$RUST_SRC_PATH is not set.'
  fi
}

install_gvm() {
  info_installing "gvm" &&

  if [ -n "$(uname -a | grep -o arm)" ]
  then
    info "gvm doesn't work well on arm..."
    return
  fi

  if [ ! -d "$HOME/.gvm" ]
  then
    curl -sSL https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | zsh
  fi &&

  zsh -c '
    . "$HOME/.gvm/scripts/gvm" &&
    tag=go1.7
    gvm install $tag --prefer-binary && gvm use $tag'
}

install_go_packages() {
  info_installing "go packages" &&
  go_get="go get -u" &&
  $go_get github.com/github/hub &&
  $go_get github.com/motemen/ghq &&
  $go_get github.com/peco/peco/cmd/peco &&
  $go_get github.com/monochromegane/the_platinum_searcher/... &&
  $go_get github.com/hashicorp/terraform
}

install_ruby_gems() {
  info_installing "ruby gems" &&
  gem install gist
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

install_vim_plug() {
  info_installing "vim-plug" &&
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_vim_plugins() {
  install_vim_plug &&
  info_installing "neovim plugins" &&

  pip2=pip

  if which -s pip2
  then
    pip2=pip2
  fi &&

  $pip2 install --user --upgrade neovim &&

  pip3 install --user --upgrade neovim &&
  gem install neovim &&

  if ! on_freebsd
  then
    nvim +PlugInstall +qall
  fi
}

install_zplug() {
  info_installing "zplug" &&
  git_clone_to_dir https://github.com/zplug/zplug $HOME/.zplug
}

install_zsh_plugins() {
  install_zplug &&
  info_installing "zsh plugins" &&
  zsh -ic ". $HOME/.zprofile && . $HOME/.zshrc"
}

install_fzf() {
  info_installing "fzf" &&

  fzf_dir=$HOME/.fzf

  git_clone_to_dir "$github_address/junegunn/fzf" "$fzf_dir" &&
  yes | "$fzf_dir/install" --no-update-rc
}

install_dwm() {
  info_installing "dwm" &&

  ghq get raviqqe/dwm &&
  (
    cd $HOME/src/github.com/raviqqe/dwm &&

    if on_freebsd
    then
      git checkout freebsd
    else
      git checkout freebsd-theme
    fi &&
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
  archive=$google_dir/gcloud-$$.tgz

  mkdir -p $google_dir &&
  curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-136.0.0-linux-x86_64.tar.gz > $archive &&
  (
    cd $google_dir &&
    tar xf $archive &&
    ./google-cloud-sdk/install.sh \
        --command-completion false \
        --path-update false \
        --quiet
  )
}

check_args() {
  if [ $# -ne 0 ]
  then
    fail "usage: $(basename $0) [-b] [-d]"
  fi
}

check_old_log_file() {
  if [ -f "$log_file" ]
  then
    fail "Log file, \"$log_file\" already exists. Delete it and rerun me."
  fi
}


# main routine

main() {
  while getopts bdhlx option
  do
    case $option in
    b)
      batch_mode=true
      ;;
    d)
      desktop_mode=true
      ;;
    h)
      no_linuxbrew=true
      ;;
    l)
      no_extra_lang=true
      ;;
    x)
      extra_mode=true
      ;;
    esac
  done
  shift $(expr $OPTIND - 1)

  check_args "$@"
  check_old_log_file

  (
    . $HOME/.profile &&
    success_file=$(basename "$0").first_step_completed.tmp

    {
      if on_linux && [ -z $no_linuxbrew ]
      then
        install_linuxbrew &&
        install_linuxbrew_packages ${desktop_mode:+-d} &&
        install_gvm
      fi &&

      if on_freebsd
      then
        install_freebsd_pkg &&
        install_freebsd_packages ${desktop_mode:+-d} ${extra_mode:+-x}
      fi &&

      install_zsh_plugins &&
      install_tpm &&
      install_go_packages &&
      install_ruby_gems &&
      install_fzf &&

      if [ -z $no_extra_lang ]
      then
        install_rustup &&
        install_rust_packages
      fi &&

      if [ -n "$desktop_mode" ]
      then
        install_dwm &&
        install_wallpapers
      fi &&

      if on_linux && [ "$(uname -m)" = x86_64 ]
      then
        install_google_cloud_sdk
      fi &&

      : > "$success_file"
    } 2>&1 | tee -a "$log_file"

    last_status=$([ -f "$success_file" ]; echo $?) &&
    rm -f "$success_file" &&
    (exit $last_status) &&

    if [ -z "$batch_mode" ]
    then
      install_ruby_gem_credential &&
      install_vim_plugins
    fi
  )

  if [ $? -ne 0 ]
  then
    fail "Failed to initialize dotfiles environment." \
         "See $log_file for troubleshooting."
  else
    rm $log_file
  fi
}

main "$@"
