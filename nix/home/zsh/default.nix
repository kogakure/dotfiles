{ lib, pkgs, ... }:

let
  chtCompletionScript = pkgs.writeTextFile {
    name = "_cht";
    text = builtins.readFile ./_cht;
    destination = "/share/zsh/site-functions/_cht";
  };
  sharedAliases = import ../shared/shared-aliases.nix { inherit lib; };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = sharedAliases.shellAliases;
    initExtra = builtins.readFile ./zshrc.sh;

    plugins = [
      {
        name = "cht-completion";
        src = chtCompletionScript;
      }
    ];

    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:plugins/brew"
        "ohmyzsh/ohmyzsh path:plugins/bundler"
        "ohmyzsh/ohmyzsh path:plugins/colored-man-pages"
        "ohmyzsh/ohmyzsh path:plugins/colorize"
        "ohmyzsh/ohmyzsh path:plugins/dotenv"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/fzf"
        "ohmyzsh/ohmyzsh path:plugins/gem"
        "ohmyzsh/ohmyzsh path:plugins/git"
        "ohmyzsh/ohmyzsh path:plugins/git-extras"
        "ohmyzsh/ohmyzsh path:plugins/gitignore"
        "ohmyzsh/ohmyzsh path:plugins/gulp"
        "ohmyzsh/ohmyzsh path:plugins/history-substring-search"
        "ohmyzsh/ohmyzsh path:plugins/jira"
        "ohmyzsh/ohmyzsh path:plugins/man"
        "ohmyzsh/ohmyzsh path:plugins/node"
        "ohmyzsh/ohmyzsh path:plugins/npm"
        "ohmyzsh/ohmyzsh path:plugins/pip"
        "ohmyzsh/ohmyzsh path:plugins/pyenv"
        "ohmyzsh/ohmyzsh path:plugins/python"
        "ohmyzsh/ohmyzsh path:plugins/rsync"
        "ohmyzsh/ohmyzsh path:plugins/ssh-agent"
        "ohmyzsh/ohmyzsh path:plugins/sudo"
        "ohmyzsh/ohmyzsh path:plugins/tmux"
        # "ohmyzsh/ohmyzsh path:plugins/tmux-cssh"
        "ohmyzsh/ohmyzsh path:plugins/tmuxinator"
        "ohmyzsh/ohmyzsh path:plugins/vagrant"
        "ohmyzsh/ohmyzsh path:plugins/virtualenv"
        "ohmyzsh/ohmyzsh path:plugins/yarn"
        "ohmyzsh/ohmyzsh path:plugins/z"
        "ohmyzsh/ohmyzsh path:plugins/zsh-interactive-cd"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
      ];
    };
  };

  home.packages = [ chtCompletionScript ];

  home.activation = {
    zlcompile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.zsh}/bin/zsh -c "for f in $HOME/.zshrc $HOME/.zshenv; do zcompile -R -- \$f.zwc \$f; done"
    '';
  };
}
