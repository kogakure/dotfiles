{ ... }:

{
  editorconfig = {
    enable = true;
    settings = {
      "*" = {
        charset = "utf-8";
        end_of_line = "lf";
        indent_style = "tab";
        insert_final_newline = true;
        trim_trailing_whitespace = true;
      };
      "*.{md,markdown,pandoc}" = {
        trim_trailing_whitespace = false;
      };
      "Makefile" = {
        indent_style = "tab";
      };
    };
  };
}
