{ pkgs, ... }:

{
  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Needs My Review";
          filters = "is:open review-requested:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
      ];
      issuesSections = [
        {
          title = "My Issues";
          filters = "is:open author:@me";
        }
        {
          title = "Assigned";
          filters = "is:open assignee:@me";
        }
        {
          title = "Involved";
          filters = "is:open involves:@me -author:@me";
        }
      ];
      defaults = {
        preview = {
          open = true;
          width = 50;
        };
        prsLimit = 20;
        issuesLimit = 20;
        view = "prs";
        layout = {
          prs = {
            updatedAt.width = 7;
            repo.width = 15;
            author.width = 15;
            assignees = {
              width = 20;
              hidden = true;
            };
            base = {
              width = 15;
              hidden = true;
            };
            lines.width = 16;
          };
          issues = {
            updatedAt.width = 7;
            repo.width = 15;
            creator.width = 10;
            assignees = {
              width = 20;
              hidden = true;
            };
          };
        };
        refetchIntervalMinutes = 30;
      };
      keybindings = {
        issues = [ ];
        prs = [ ];
      };
      repoPaths = {
        "kogakure/*" = "~/Code/GitHub/*";
        "work/*" = "~/Code/XING/*";
      };
      theme = {
        ui.table.showSeparator = true;
      };
      pager.diff = "";
    };
  };

  home.packages = with pkgs; [
    git
    gh-dash
  ];
}
