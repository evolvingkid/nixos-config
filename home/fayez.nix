{ config, pkgs, ... }:

let
  bashItSrc = builtins.fetchGit {
    url = "https://github.com/Bash-it/bash-it.git";
    rev = "4c5ac697f593169ab09a63e0f78f85a20d01c47a";  # Replace with the latest commit if needed
  };
in {
  home.username = "fayez";
  home.homeDirectory = "/home/fayez";

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ -f "${pkgs.blesh}/share/blesh/ble.sh" ]]; then
        source "${pkgs.blesh}/share/blesh/ble.sh"
      fi

      export BASH_IT="${config.home.homeDirectory}/.bash_it"
      export BASH_IT_THEME="clean"
      source "$BASH_IT/bash_it.sh"
    '';

  };

  home.file.".bash_it" = {
    source = bashItSrc;
    recursive = true;
  };

  home.packages = with pkgs; [
    blesh
  ];

  systemd.user.services.set-wallpaper = {
    Unit = {
      Description = "Set GNOME wallpaper using gsettings";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = ''
        ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.background picture-uri "file:///home/fayez/Wallpapers/zero-two.jpg"
        ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.background picture-options "centered"
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.stateVersion = "25.05";
}

