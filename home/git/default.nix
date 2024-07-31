{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    delta.enable = true;
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
      br = "branch";
      rb = "rebase";
      cp = "cherry-pick";
      dt = "difftool";
      hist = "log --color --graph --decorate --abbrev-commit --date=short --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(blue)[%an]%Creset' --abbrev-commit --";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
      "local-branches" = "!git branch -vv | cut -c 3- | awk '$3 !~/\\[/ { print $1 }'";
      stats = "shortlog -sn --all --no-merges";
      today = "log --since=00:00:00 --all --no-merges --oneline";
      prune = "fetch --prune";
      undo = "reset --soft HEAD^";
      "stash-all" = "stash save --include-untracked";
      "app-status" = "!git remote update >/dev/null && git --no-pager log origin/production..origin/master --pretty=oneline >&2 | pbcopy";
      unstage = "reset HEAD --";
      merged = "branch --merged";
      unmerged = "branch --no-merge";
      branches = "for-each-ref --sort=-committerdate --format=\"%(color:blue)%(authordate:relative)\t%(color:red)%(authorname)\t%(color:white)%(color:bold)%(refname:short)\" refs/remotes";
      ignored = "ls-files --others --directory";
      # Assume workflow
      assume = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed = "!git ls-files -v | grep ^h | cut -c 3-";
      unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged";
      assumeall = "!git st -s | awk {'print $2'} | xargs git assume";
      # Rebase workflow
      mainbranch = "!git remote show origin | sed -n '/HEAD branch/s/.*: //p'";
      synced = "!git pull origin $(git mainbranch) --rebase";
      update = "!git pull origin $(git rev-parse --abbrev-ref HEAD) --rebase";
      squash = "!git rebase -v -i $(git mainbranch)";
      publish = "push origin HEAD --force-with-lease";
      pub = "publish";
      # GitHub
      hub = "!gh repo view --web";
    };
    ignores = [
      "*.lnk"
      "*.pyc"
      "*.pyo"
      "*.session"
      "*.sw[nop]"
      ".BridgeSort"
      ".DS_Store"
      "._*"
      ".agignore"
      ".bundle/"
      "m~"
      "tags"
      ".worktrees"
      ".tool-versions"
    ];
    lfs.enable = true;
    includes = [
      { path = "~/.gitconfig.local"; }
    ];
    extraConfig = {
      user = {
        useConfigOnly = true;
      };
      core = {
        editor = "code --wait";
        legacyheaders = false;
      };
      help = {
        autocorrect = 1;
      };
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Dracula";
      };
      add = {
        interactive = {
          useBuildtin = true;
        };
      };
      apply = {
        whitespace = "fix";
      };
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        ui = 1;
      };
      commit = {
        gpgsign = true;
      };
      branch = {
        autosetupmerge = true;
        sort = "-authordate";
      };
      push = {
        default = "upstream";
        followTags = true;
        autoSetupRemote = true;
      };
      pull = {
        ff = "only";
      };
      fetch = {
        prune = true;
        fsckobjects = false;
      };
      rebase = {
        autosquash = true;
      };
      status = {
        showUntrackedFiles = "all";
      };
      diff = {
        tool = "Kaleidoscope";
        algorithm = "patience";
        colorMoved = "default";
      };
      difftool = {
        prompt = false;
        Kaleidoscope.cmd = "ksdiff --partial-changeset --relative-path \"$MERGED\" -- \"$LOCAL\" \"$REMOTE\"";
      };
      merge = {
        conflictstyle = "diff3";
        tool = "Kaleidoscope";
      };
      mergetool = {
        prompt = false;
        keepBackup = false;
        Kaleidoscope = {
          cmd = "ksdiff --merge --output \"$MERGED\" --base \"$BASE\" -- \"$LOCAL\" --snapshot \"$REMOTE\" --snapshot";
          trustexitcode = true;
          trustExitCode = true;
        };
        nvim.cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
        code = {
          cmd = "\"code $MERGED\"";
          keepBackup = false;
          trustexitcode = true;
        };
      };
      rerere.enabled = true;
      transfer = {
        fsckObjects = true;
      };
      i18n = {
        commitencoding = "UTF-8";
        logoutputencoding = "UTF-8";
      };
      repack = {
        usedeltabaseoffset = true;
      };
      "filter \"lfs\"" = {
        required = true;
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        clean = "git-lfs clean -- %f";
      };
      web.browser = "open";
      hub.host = "source.xing.com";
    };
  };

  home.packages = with pkgs; [
    commitizen # Tool to create committing rules for projects, auto bump versions, and generate changelogs
    delta # Syntax-highlighting pager for git
    gh # GitHub CLI tool
    git-crypt # Transparent file encryption in git
    git-extras # GIT utilities -- repo summary, repl, changelog population, author commit percentages and more
    git-fixup # Fighting the copy-paste element of your rebase workflow
    git-lfs # Git extension for versioning large files
    git-quick-stats # Simple and efficient way to access various statistics in git repository
    gitleaks # Scan git repos (or files) for secrets
    soft-serve # Tasty, self-hosted Git server for the command line
  ];
}
