{ ... }:

{
  programs.bash = {
    enable = true;
    enableCompletion = true;
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
