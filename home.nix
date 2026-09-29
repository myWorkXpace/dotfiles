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
    jq        # json on the command line
    _7zz-rar  # official 7-Zip (7zz), with RAR support
    lazygit
    neovim
    github-copilot-cli
    codex
    gemini-cli
    # Pi Coding Agent CLI
    pi-coding-agent
    # the font everything renders in
    nerd-fonts.hack
  ];
  fonts.fontconfig.enable = true;
  programs.vscode = {
    enable = true;
    profiles.default.extensions = [ pkgs.vscode-extensions.github.copilot ];
  };
  home.sessionVariables = {
    EDITOR = "nvim";
    JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];
  home.activation.upgradeSerenaSitter = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    PATH="/opt/homebrew/bin:/usr/bin:/bin" /opt/homebrew/bin/pipx upgrade serenasitter
  '';
  home.activation.installLatestLtsNode = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    activationPath="$PATH"
    export PATH="$PATH:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    export NVM_DIR="$HOME/.nvm"
    . /opt/homebrew/opt/nvm/nvm.sh
    nvm install --lts
    nvm alias default 'lts/*'
    export PATH="$activationPath"
    unset activationPath
  '';

  programs.zsh = {
    enable = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];
    };
    syntaxHighlighting.enable = true;  # commands turn green when valid
    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    profileExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
    '';
    # fzf-tab must load after compinit (570) and before autosuggestions (700).
    initContent = lib.mkMerge [
      (lib.mkOrder 600 ''
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zstyle ':completion:*' menu no
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':fzf-tab:*' switch-group '<' '>'
      '')
      ''
        bindkey '^f' autosuggest-accept
        # Up/Down search history by the typed prefix; both normal and application-mode arrow codes.
        autoload -U up-line-or-beginning-search down-line-or-beginning-search
        zle -N up-line-or-beginning-search
        zle -N down-line-or-beginning-search
        bindkey '^[[A' up-line-or-beginning-search
        bindkey '^[OA' up-line-or-beginning-search
        bindkey '^[[B' down-line-or-beginning-search
        bindkey '^[OB' down-line-or-beginning-search
        export PATH="$HOME/.local/bin:$PATH"
        export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
        # Interactive gcc/g++ -> Homebrew GNU GCC; build tools keep Apple clang via PATH.
        for _gcc in /opt/homebrew/opt/gcc/bin/gcc-<->(N); do
          alias gcc="$_gcc" g++="''${_gcc:h}/g++-''${_gcc##*-}"
        done
        unset _gcc
      ''
    ];
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

  programs.fzf.enable = true;       # Ctrl-R history, Ctrl-T files, Alt-C dirs
  programs.carapace.enable = true;  # completions for 1000+ CLIs

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
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
}
