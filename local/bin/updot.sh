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

message_installing() {
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
  message_installing "linuxbrew" &&

  linuxbrew_dir=$HOME/.linuxbrew

  if [ ! -d $linuxbrew_dir ]
  then
    git clone $github_address/Linuxbrew/linuxbrew.git $linuxbrew_dir
  fi
}

install_linuxbrew_packages() {
  message_installing "linuxbrew packages" &&

  brew update &&
  brew update &&

  brew tap thoughtbot/formulae &&
  brew install rcm &&

  brew install libevent --without-doxygen &&
  brew install gperftools &&

  brew install git hub tig gist tmux lynx links irssi rust bmake &&
  brew install gawk && # for zplug

  brew install neovim/neovim/neovim
}

install_freebsd_pkg() {
  message_installing "freebsd pkg command" &&
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

  local portmaster="sudo -E portmaster -Gdy --no-confirm"
  local pkg_install="sudo pkg install -y"

  message_installing "freebsd packages" &&
  sudo pkg upgrade -y &&
  sudo portsnap fetch update &&

  message_installing "freebsd base packages" &&
  $pkg_install \
      sudo nmap arping htop ca_root_nss \
      portmaster portlint \
      zsh bash neovim tmux lynx ii simpleirc rcm \
      git subversion fossil hub tig gist \
      go rust cargo ghc hs-cabal-install stack nasm gmake ninja \
      python35 ruby devel/ruby-gems \
      qemu bsdtris bsdgames &&
  # $portmaster some/port # currently not used
  python3.5 -m ensurepip --user --upgrade

  if [ -n "$desktop_mode" ]
  then
    message_installing "freebsd desktop packages" &&
    $pkg_install \
        xorg-minimal xorg-docs xsetroot xset xlsfonts xfontsel xrdb xsm \
        xrandr xrefresh fontconfig xautolock \
        dwm xdm rxvt-unicode surf-browser feh scrot slock \
        firefox thunderbird chromium pcmanfm inkscape gimp libreoffice mupdf \
        terminus-font terminus-ttf ja-font-ipa ubuntu-font \
        ja-ibus-mozc poppler-utils &&
    DWM_CONF=$HOME/.dotfiles/local/etc/dwm/config.h $portmaster dwm &&
    fc-cache -f
  fi &&

  if [ -n "$extra_mode" ]
  then
    message_installing "freebsd extra packages" &&
    $pkg_install texlive-full
  fi
}

install_rust_packages() {
  message_installing "rust packages" &&

  for crate in racer
  do
    cargo install $crate | :
  done &&

  if [ -n "$RUST_SRC_PATH" ]
  then
    git_clone_to_dir https://github.com/rust-lang/rust/ \
                     "$(dirname "$RUST_SRC_PATH")"
  else
    fail '$RUST_SRC_PATH is not set.'
  fi
}

install_go_packages() {
  message_installing "go packages" &&
  go_get="go get -u" &&
  $go_get github.com/motemen/ghq &&
  $go_get github.com/peco/peco/cmd/peco &&
  $go_get github.com/monochromegane/the_platinum_searcher/...
}

install_vim_plug() {
  message_installing "vim-plug" &&
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install_vim_plugins() {
  install_vim_plug &&
  message_installing "neovim plugins" &&
  pip2 install --user --upgrade neovim &&
  pip3 install --user --upgrade neovim &&
  gem install neovim &&
  nvim +PlugInstall +qall
}

install_zplug() {
  message_installing "zplug" &&
  git_clone_to_dir https://github.com/zplug/zplug $HOME/.zplug
}

install_zsh_plugins() {
  install_zplug &&
  message_installing "zsh plugins" &&
  zsh -ic ". $HOME/.zprofile && . $HOME/.zshrc"
}

install_fzf() {
  message_installing "fzf" &&

  fzf_dir=$HOME/.fzf

  git_clone_to_dir "$github_address/junegunn/fzf" "$fzf_dir" &&
  yes | "$fzf_dir/install" --no-update-rc
}

install_tpm() {
  message_installing "tpm" &&
  git_clone_to_dir "$github_address/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
}

install_wallpapers() {
  message_installing "wallpapers" &&
  git_clone_to_dir git://git.raviqqe.com/wallpapers.git "$HOME/.wallpapers"
}

install_haskell_stack() {
  message_installing "haskell stack" &&

  if on_freebsd
  then
    info "Already installed from ports on FreeBSD"
    return
  fi

  if [ -z "$(which stack)" ]
  then
    curl -sSL https://get.haskellstack.org/ | sh &&
    return
  fi

  stack upgrade
}

install_ruby_gem_credential() {
  message_installing "ruby gem credentials"

  local credential_file=$HOME/.gem/credentials

  if [ ! -r "$credential_file" ]
  then
    mkdir -p $(dirname $credential_file) &&
    curl -u raviqqe https://rubygems.org/api/v1/api_key.yaml \
         > "$credential_file" &&
    chmod 600 "$credential_file"
  fi
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
        install_linuxbrew_packages
      fi &&

      if on_freebsd
      then
        install_freebsd_pkg &&
        install_freebsd_packages ${desktop_mode:+-d} ${extra_mode:+-x}
      fi &&

      install_zsh_plugins &&
      install_tpm &&
      install_go_packages &&
      install_fzf &&

      if [ -z $no_extra_lang ]
      then
        install_rust_packages &&
        install_haskell_stack
      fi &&

      if [ -n "$desktop_mode" ]
      then
        install_wallpapers
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
