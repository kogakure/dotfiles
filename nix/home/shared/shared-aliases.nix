{ lib, ... }:

let
  mkAliases = lib.mapAttrs (name: value: lib.mkForce value);
in
{
  shellAliases = mkAliases {
    # Folders/Lists
    "..." = "cd ../..";
    ".." = "cd ..";
    "cd.." = "cd ..";
    ls = "eza --git --group-directories-first --icons";
    ll = "eza -l --git --group-directories-first --icons";
    lt = "eza --git --group-directories-first --icons --tree";
    lla = "ll -a";
    mkdir = "mkdir -p";
    pn = "pnpm";
    px = "pnpx";

    # Git
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
    glu = "git config user.name 'Stefan Imhoff' && git config user.email 'gpg@kogakure.8shield.net' && git config user.signingkey '7A7253E8!'";
    glx = "git config user.name 'Stefan Imhoff' && git config user.email 'stefan.imhoff@xing.com' && git config user.signingkey '73C3E2E3!'";
    gmb = "git merge-base master HEAD";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gpp = "PATCHNAME=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`-`date '+%Y-%m-%d-%H%M.patch'`; git diff --full-index master > ../patches/$PATCHNAME";
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
    gwa = "git worktree add"; # <folder> <branch/hash>
    gwl = "git worktree list";
    gwr = "git worktree remove"; # <path/name>
    lg = "lazygit";

    # Vim
    v = "vim";
    vim = "nvim";

    # Tmux
    t = "tmux";
    ta = "tmux attach";

    # Nix
    nxs = "darwin-rebuild switch --flake ~/.dotfiles/nix";

    # Bat
    cat = "bat";

    # TLDR
    tldrf = "tldr --list --single-column | fzf --preview \"tldr --color=always {1}\" --preview-window=right,70% | xargs tldr";

    # Can't remember the fork name
    youtube-dl = "yt-dlp";

    # Dotfiles folder
    dotfiles = "cd ~/.dotfiles";

    # iCloud
    icloud = "cd ~/Library/Mobile\\ Documents/com~apple~CloudDocs";

    # Recursively delete `.DS_Store` files
    cleanup = "find . -type f -name '*.DS_Store' -ls -delete";

    # Clear the screen
    c = "clear";

    # Empty the Trash on all mounted volumes and the main HDD
    # Also, clear Apple's System Logs to improve shell startup speed
    emptytrash = "sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl";
  };
}
