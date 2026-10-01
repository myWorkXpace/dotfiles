{ user, pkgs, lib, ... }:

let
  # Not in nixpkgs, Homebrew, or the App Store; official notarized DMG, pinned by hash.
  neat-download-manager = pkgs.stdenvNoCC.mkDerivation {
    pname = "neat-download-manager";
    version = "1.3";
    # Unversioned URL: if the vendor ships a new build, update version and hash.
    src = pkgs.fetchurl {
      url = "https://www.neatdownloadmanager.com/file/NeatDMInstaller.dmg";
      hash = "sha256-wOMB7ksTUEp262xUhGydz22BSNMkibS7kb0gYtRx74E=";
    };
    # undmg only handles HFS; this DMG isn't.
    nativeBuildInputs = [ pkgs._7zz ];
    sourceRoot = "NeatDownloadManager.app";
    # Stripping/patching binaries would break the Developer ID signature.
    dontFixup = true;
    installPhase = ''
      mkdir -p "$out/Applications/NeatDownloadManager.app"
      cp -R . "$out/Applications/NeatDownloadManager.app"
    '';
    meta = {
      homepage = "https://www.neatdownloadmanager.com/";
      license = lib.licenses.unfree;
      platforms = lib.platforms.darwin;
    };
  };
in

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
  # NDM refuses to run unless it is a real copy directly in /Applications (not a symlink or subfolder).
  system.activationScripts.postActivation.text = ''
    echo "installing /Applications/NeatDownloadManager.app..." >&2
    ${lib.getExe pkgs.rsync} --archive --checksum --delete --chmod=-w --no-group --no-owner \
      ${neat-download-manager}/Applications/NeatDownloadManager.app/ /Applications/NeatDownloadManager.app/
  '';
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
      "mas"
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
      "chatgpt"
      "claude"
      "claude-code"
      "dockdoor"
      # Fully-qualified so only these casks are trusted, not their whole (untrusted) taps.
      "xykong/tap/flux-markdown"
      "git-credential-manager"
      "github-copilot-app"
      "google-chrome"
      "google-drive"
      "maccy"
      "ngrok"
      "orbstack"
      "pear-desktop"
      "raycast"
      "warp"
      "wezterm"
    ];
    masApps = {
    };
  };
}
