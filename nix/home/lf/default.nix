{ pkgs, ... }:

{
  programs.lf =
    {
      enable = true;
      settings = {
        number = true;
        icons = true;
        promptfmt = "\033[34;1m%d\033[0m\033[1m%f\033[0m";
        shell = "bash";
        shellopts = "-eu";
        ifs = "\\n";
        scrolloff = 10;
      };
      keybindings = {
        "<c-f>" = ":fzf_jump";
        "<delete>" = "delete";
        "<enter>" = "shell";
        O = "$mimeopen --ask $f";
        X = "!$f";
        f = "$nvim $(fzf)";
        gb = ":git_branch";
        gl = "$\{{clear; git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit}}";
        gp = "$\{{clear; git pull --rebase || true; echo 'press ENTER'; read ENTER}}";
        gs = "$\{{clear; git status; echo 'press ENTER'; read ENTER}}";
        o = "&mimeopen $f";
        x = "$$f";
      };
      previewer = {
        source = pkgs.writeShellScript "pv.sh" ''
          #!/usr/bin/env bash

          case "$1" in
          *) bat --force-colorization --paging=never --style=changes,numbers \
          	--terminal-width $(($2 - 3)) "$1" && false ;;
          esac
        '';
      };
      commands = {
        delete = ''
          ''${{
            set -f
            printf "$fx\n"
            printf "delete? [y/n]"
            read ans
            [ $ans = "y" ] && rm -rf $fx
          }}
        '';
        # extract the current file with the right command
        extract = ''
          ''${{
            set -f
            case $f in
                *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) tar xjvf $f;;
                *.tar.gz|*.tgz) tar xzvf $f;;
                *.tar.xz|*.txz) tar xJvf $f;;
                *.zip) unzip $f;;
                *.rar) unrar x $f;;
                *.7z) 7z x $f;;
            esac
          }}
        '';
        # compress current file or selected files with tar and gunzip
        tar = ''
          ''${{
            set -f
            mkdir $1
            cp -r $fx $1
            tar czf $1.tar.gz $1
            rm -rf $1
          }}
        '';
        # define a custom 'open' command
        # This command is called when current file is not a directory. You may want to
        # use either file extensions and/or mime types here. Below uses an editor for
        # text files and a file opener for the rest.
        open = ''
          ''${{
            case $(file --mime-type $f -b) in
                text/*) $EDITOR $fx;;
                *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
            esac
          }}
        '';
        # compress current file or selected files with zip
        zip = ''
          ''${{
            set -f
            mkdir $1
            cp -r $fx $1
            zip -r $1.zip $1
            rm -rf $1
          }}
        '';
        fzf_jump = ''
          ''${{
            res="$(find . -maxdepth 1 | fzf-tmux -p --reverse --header='Jump to location' | sed 's/\\/\\\\/g;s/"/\\"/g')"
            if [ -d "$res" ] ; then
                cmd="cd"
            elif [ -f "$res" ] ; then
                cmd="select"
            else
                exit 0
            fi
            lf -remote "send $id $cmd \"$res\""
          }}
        '';
        z = ''
          %{{
            result="$(zoxide query --exclude "$PWD" -- "$@")"
            lf -remote "send $id cd \"$result\""
          }}
        '';
        git_branch = ''
          ''${{
            git branch | fzf-tmux -p --reverse | xargs git checkout
            pwd_shell=$(pwd)
            lf -remote "send $id updir"
            lf -remote "send $id cd \"$pwd_shell\""
          }}
        '';
      };
      extraConfig = '''';
    };

  home.packages = with pkgs; [
    lf
    bat
    fzf
    zoxide # z
    git
    gnutar # tar
    unzip
    unrar
    p7zip # 7z
    file # for mime-type detection
    findutils # find
    gnused # sed
    xdg-utils
    shared-mime-info
    tmux
  ];
}
