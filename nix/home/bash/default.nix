{ pkgs, ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
    sessionVariables = {
      SSH_AUTH_SOCK = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      FD_OPTIONS = "--follow --exclude .git --exclude node_modules";
      KEYTIMEOUT = 1;
      GIT_EDITOR = "nvim";
      EDITOR = "nvim";
      FZF_DEFAULT_COMMAND = "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l $FD_OPTIONS";
      FZF_DEFAULT_OPTS = "--no-height";
      FZF_CTRL_T_COMMAND = "$FZF_DEFAULT_COMMAND";
      FZF_CTRL_T_OPTS = "--preview 'bat --color=always --style=numbers {}' --bind shift-up:preview-page-up,shift-down:preview-page-down";
      FZF_CTRL_R_OPTS = "--reverse";
      FZF_TMUX_OPTS = "-p";
      FZF_ALT_C_COMMAND = "fd --type d $FD_OPTIONS --color=never --hidden";
      FZF_ALT_C_OPTS = "--preview 'tree -C {} | head -50'";
    };
    shellAliases = {
      ".." = "cd ..";
    };
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    historyControl = [
      "erasedups"
      "ignorespace"
    ];
    historyFileSize = 100000;
    historySize = 10000;
  };
}
