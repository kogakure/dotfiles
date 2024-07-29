{ ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      log = {
        enabled = false;
      };
      manager = {
        ratio = [ 1 4 3 ];
        show_hidden = false;
        sort_by = "natural";
        sort_dir_first = true;
        sort_sensitive = false;
        sort_reverse = false;
        show_symlink = true;
      };
      opener = {
        edit = [
          {
            run = "nvim \"$@\"";
            block = true;
          }
        ];
      };
    };
  };
}
