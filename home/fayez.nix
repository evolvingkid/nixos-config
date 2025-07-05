{ config, pkgs, ... }:

{
  home.username = "fayez";
  home.homeDirectory = "/home/fayez";

  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ -f "${pkgs.blesh}/share/blesh/ble.sh" ]]; then
        source "${pkgs.blesh}/share/blesh/ble.sh"
      fi
    '';
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
      ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.background picture-uri "file:///home/fayez/Pictures/zero-two.jpg"
      ${pkgs.gsettings-desktop-schemas}/bin/gsettings set org.gnome.desktop.background picture-options "centered"
    '';
  };

  Install = {
    WantedBy = [ "default.target" ];
  };
};



  home.stateVersion = "25.05";
}
