{ ... }:

{
  programs.lsd =
    {
      enable = true;
      enableAliases = false;
      settings = {
        classic = false;
        blocks = [
          "permission"
          "user"
          "group"
          "size"
          "date"
          "name"
        ];
        date = "date";
        dereference = false;
        icons = {
          when = "auto";
          theme = "fancy";
          separator = " ";
        };
        indicators = false;
        layout = "grid";
        recursion = {
          enabled = false;
        };
        size = "default";
        permission = "rwx";
        sorting = {
          column = "name";
          reverse = false;
          dir-grouping = "none";
        };
        no-symlink = false;
        total-size = false;
        hyperlink = "never";
        symlink-arrow = "⇒";
        header = false;
      };
      colors = {
        user = 230;
        group = 187;
        permission = {
          read = "dark_green";
          write = "dark_yellow";
          exec = "dark_red";
          exec-sticky = 5;
          no-access = 245;
          octal = 6;
          acl = "dark_cyan";
          context = "cyan";
        };
        date = {
          hour-old = 40;
          day-old = 42;
          older = 36;
        };
        size = {
          none = 245;
          small = 229;
          medium = 216;
          large = 172;
        };
        inode = {
          valid = 13;
          invalid = 245;
        };
        links = {
          valid = 13;
          invalid = 245;
        };
        tree-edge = 245;
        git-status = {
          default = 245;
          unmodified = 245;
          ignored = 245;
          new-in-index = "dark_green";
          new-in-workdir = "dark_green";
          typechange = "dark_yellow";
          deleted = "dark_red";
          renamed = "dark_green";
          modified = "dark_yellow";
          conflicted = "dark_red";
        };
      };
    };
}
