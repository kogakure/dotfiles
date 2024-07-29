{ lib, pkgs, ... }:

let
  chtCompletionScript = pkgs.writeTextFile {
    name = "_cht";
    text = builtins.readFile ./_cht;
    destination = "/share/zsh/site-functions/_cht";
  };
in
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      # ZSH
      zshconfig = "vim $HOME/.zshrc";
      reload = "source $HOME/.zshrc";

      # Folders
      "..." = "cd ../..";
      ".." = "cd ..";
      "cd.." = "cd ..";
      ls = "eza --git --group-directories-first --icons";
      ll = "eza -l --git --group-directories-first --icons";
      lla = "ll -a";
      mkdir = "mkdir -p";

      # Git aliases
      ga = "git add";
      gb = "git branch";
      gba = "git branch -a";
      gc = "git commit -v";
      gca = "git commit -v -a";
      gcam = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gd = "git diff -- . ':(exclude)yarn.lock'";
      gdc = "git diff --cached";
      gdh = "git diff head";
      gdt = "git difftool";
      gfa = "git fetch --all";
      gg = "git log";
      ghi = "git hist";
      gl = "git pull";
      glr = "git pull --rebase";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "git push -u origin HEAD";
      gpv = "git push --no-verify";
      grb = "git rebase master";
      grbc = "git rebase --continue";
      grbi = "git rebase -i ";
      grbs = "git rebase --skip";
      gru = "git remote update";
      gsb = "git show-branch";
      gsl = "git submodule foreach git pull";
      gst = "git status -sb";
      gsu = "git submodule update";
      gu = "git up";
      gw = "git whatchanged";
      gwp = "git whatchanged -p";
      lg = "lazygit";

      # Vim
      v = "vim";
      vim = "nvim";

      # Tmux
      t = "tmux";
      tn = "tmux new -s $(pwd | sed 's/.*\///g')";

      # Bat
      cat = "bat";

      # TLDR
      tldrf = "tldr --list --single-column | fzf --preview \"tldr --color=always {1}\" --preview-window=right,70% | xargs tldr";

      # iA Writer
      ia = "open $1 -a /Applications/iA\\ Writer.app";

      # Dotfiles folder
      dotfiles = "cd $HOME/.dotfiles";

      # iCloud
      icloud = "cd $HOME/Library/Mobile\\ Documents/com~apple~CloudDocs";

      # Get week number
      week = "date +%V";

      # Stopwatch
      timer = "echo \"Timer started. Stop with Ctrl-D.\" && date && time cat && date";

      # IP addresses
      ip = "dig +short myip.opendns.com @resolver1.opendns.com";

      # Flush Directory Service cache
      flush = "dscacheutil -flushcache && killall -HUP mDNSResponder";

      # Recursively delete `.DS_Store` files
      cleanup = "find . -type f -name '*.DS_Store' -ls -delete";

      # Clear the screen
      c = "clear";

      # Empty the Trash on all mounted volumes and the main HDD
      # Also, clear Apple’s System Logs to improve shell startup speed
      emptytrash = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl";
    };
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
