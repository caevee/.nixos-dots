# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Use the systemd-boot EFI boot loader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  # Necessary to run League of Legends (due to anticheat)
  boot.kernel.sysctl."abi.vsyscall32" = 0;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  environment.variables.EDITOR = "vim";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

#    services.xserver.displayManager.gdm.monitorsConfig = ''
#  	<monitors version="2">
#  	  <configuration>
#  	    <logicalmonitor>
#  	      <x>1920</x>
#  	      <y>0</y>
#  	      <scale>1</scale>
#  	      <primary>yes</primary>
#  	      <monitor>
#  		<monitorspec>
#  		  <connector>HDMI-0</connector>
#  		  <vendor>HAR</vendor>
#  		  <product>LTF22Z6</product>
#  		  <serial>0x01010101</serial>
#  		</monitorspec>
#  		<mode>
#  		  <width>1680</width>
#  		  <height>1050</height>
#  		  <rate>59.954250335693359</rate>
#  		</mode>
#  	      </monitor>
#  	    </logicalmonitor>
#  	    <logicalmonitor>
#  	      <x>0</x>
#  	      <y>0</y>
#  	      <scale>1</scale>
#  	      <monitor>
#  		<monitorspec>
#  		  <connector>DP-3</connector>
#  		  <vendor>SNY</vendor>
#  		  <product>SONY TV</product>
#  		  <serial>0x01010101</serial>
#  		</monitorspec>
#  		<mode>
#  		  <width>1920</width>
#  		  <height>1080</height>
#  		  <rate>60</rate>
#  		</mode>
#  	      </monitor>
#  	    </logicalmonitor>
#  	  </configuration>
#  	</monitors>
#    '';
systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${pkgs.writeText "gdm-monitors.xml" ''
  	<monitors version="2">
  	  <configuration>
  	    <logicalmonitor>
  	      <x>1920</x>
  	      <y>0</y>
  	      <scale>1</scale>
  	      <primary>yes</primary>
  	      <monitor>
  		<monitorspec>
  		  <connector>HDMI-0</connector>
  		  <vendor>HAR</vendor>
  		  <product>LTF22Z6</product>
  		  <serial>0x01010101</serial>
  		</monitorspec>
  		<mode>
  		  <width>1680</width>
  		  <height>1050</height>
  		  <rate>59.954250335693359</rate>
  		</mode>
 	      </monitor>
  	    </logicalmonitor>
  	    <logicalmonitor>
  	      <x>0</x>
  	      <y>0</y>
  	      <scale>1</scale>
  	      <monitor>
  		<monitorspec>
  		  <connector>DP-3</connector>
  		  <vendor>SNY</vendor>
  		  <product>SONY TV</product>
  		  <serial>0x01010101</serial>
  		</monitorspec>
  		<mode>
  		  <width>1920</width>
  		  <height>1080</height>
  		  <rate>60</rate>
  		</mode>
  	      </monitor>
 	    </logicalmonitor>
  	  </configuration>
  	</monitors>
    ''}"
  ];
  

  # Configure keymap in X11
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.caevee = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    firefox
    pciutils
    wine
    (winetricks.override { wine = wine; })
    gnomeExtensions.appindicator
    gnomeExtensions.gamemode
    gnome.gnome-terminal
    alacritty
    gnome.nautilus
    file
    appimage-run
    fzf
    bspwm
    sxhkd
    killall
    freetype
    openssl
    gnome.zenity
    vulkan-tools
    barrier
    nextcloud-client
    virt-manager
    git
  ];

  services.gnome.core-utilities.enable = false;
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  # Open port for barrier
  networking.firewall.allowedTCPPorts = [ 24800 ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.flatpak.enable = true;
  programs.steam.enable = true;
  programs.gamemode.enable = true;
  services.syncthing = {
    enable = true;
    user = "caevee";
    dataDir ="/home/caevee/Sync";
    configDir = "/home/caevee/Sync/.config/syncthing";
  };
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

