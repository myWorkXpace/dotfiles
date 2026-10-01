{ config, pkgs, user, lib, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    superfile  # terminal file manager (spf), for herdr panes
    # Pi Coding Agent CLI
    pi-coding-agent
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  home.sessionVariables.EDITOR = "nvim";
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/Developer/flutter/bin"
    "$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
  ];
  home.activation.upgradeSerenaSitter = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="/opt/homebrew/bin:/usr/bin:/bin" /opt/homebrew/bin/pipx upgrade serenasitter
  '';

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/Developer/flutter/bin:$PATH"
    '';
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      [ -f /usr/libexec/java_home ] && export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/Developer/flutter/bin:$PATH"
      export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
    '';
    initContent = ''
      bindkey '^f' autosuggest-accept
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="$HOME/Developer/flutter/bin:$PATH"
      export PATH="$HOME/Library/Application Support/JetBrains/Toolbox/scripts:$PATH"
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --full-auto";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  # superfile keeps its config outside ~/.config on macOS
  home.file."Library/Application Support/superfile/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/Library/Application Support/superfile/config.toml";
  home.file."Library/Application Support/superfile/hotkeys.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/Library/Application Support/superfile/hotkeys.toml";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
