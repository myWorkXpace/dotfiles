{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  home-manager.backupFileExtension = ".backup";
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
    };
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    #onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    #onActivation.extraFlags = [ "--force" ];
    taps = [
      "pear-devs/pear"
      "supabase/tap"
      "xykong/tap"
    ];
    brews = [
      "bat"
      "dust"
      "duti"
      "fd"
      "ffmpeg"
      "fzf"
      "gcc"
      "gcc@15"
      "gh"
      "git"
      "herdr"
      "htop"
      "httpie"
      "httrack"
      "jq"
      "lazygit"
      "maven"
      "nvm"
      "pipx"
      "pyenv"
      "supabase"
      "tmux"
      "tree"
      "uv"
      "yt-dlp"
      "zoxide"
    ];
    casks = [
      "alt-tab"
      "claude-code"
      "dockdoor"
      "flux-markdown"
      "maccy"
      "ngrok"
      "orbstack"
      "pear-desktop"
      "raycast"
      "warp"
      "wezterm"
    ];
  };
}
