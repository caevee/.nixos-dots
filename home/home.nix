{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "caevee";
    userEmail = "pister.alex.cv@gmail.com";
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "caevee";
  home.homeDirectory = "/home/caevee";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  # home.stateVersion = "21.05";

  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-nix ];
    extraConfig = ''
      set mouse=
      syntax on
      set relativenumber
      inoremap jk <Esc>
    '';
  };

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    obsidian
    gnome.gnome-tweaks
    discord
    lutris
    spotify
    tdesktop
    mgba
    neofetch
    terminal-typeracer
    terminal-parrot
    htop
    gnome.gedit
    evince
    anydesk
    libsForQt5.breeze-gtk
    bpytop
    ranger
    feh
    mpv
    simplescreenrecorder
    (retroarch.override {
      cores = [
        libretro.mgba
      ];
    })
    qutebrowser
    dmenu
    unzip
    tela-icon-theme
    ungoogled-chromium
    baobab
    qbittorrent
    gnome.gnome-disk-utility
    gnome.gnome-calculator
  ];
}
