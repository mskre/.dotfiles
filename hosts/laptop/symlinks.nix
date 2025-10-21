{
  config,
  lib,
  pkgs,
  ...
}:

let
  dotfiles = "/home/mikkel/.dotfiles/config";

  mkSymlink = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${path}";

in
{
  home.file = {
    # Zsh
    ".zshrc".source = mkSymlink ".zshrc";

    # Ghostty
    ".config/ghostty/config".source = mkSymlink "ghostty/config";

    # Hyprland (hyprland.conf, hyprlock.conf, hyprpaper.conf osv.)
    ".config/hypr".source = mkSymlink "hypr";

    # Hyprland (hyprland.conf, hyprlock.conf, hyprpaper.conf osv.)
    ".config/rofi".source = mkSymlink "rofi";

    # Starship
    ".config/starship.toml".source = mkSymlink "starship.toml";

    # Tmux
    ".tmux.conf".source = mkSymlink "tmux/.tmux.conf";

    # Waybar
    ".config/waybar".source = mkSymlink "waybar";
  };
}
