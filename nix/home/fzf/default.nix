{ ... }:

let
  fdOptions = "--follow --exclude .git --exclude node_modules";
in
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    defaultCommand = "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l ${fdOptions}";
    defaultOptions = [ "--no-height" ];

    changeDirWidgetCommand = "fd --type d ${fdOptions} --color=never --hidden";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -50'" ];

    fileWidgetCommand = "git ls-files --cached --others --exclude-standard | fd --hidden --type f --type l ${fdOptions}";
    fileWidgetOptions = [
      "--preview 'bat --color=always --style=numbers {}'"
      "--bind shift-up:preview-page-up,shift-down:preview-page-down"
    ];

    historyWidgetOptions = [ "--reverse" ];

    tmux.enableShellIntegration = true;
    tmux.shellIntegrationOptions = [ "-p" ];
  };
}
