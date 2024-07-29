{ pkgs, ... }:

{
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-copilot # Ask for assistance right in your terminal
      gh-dash # Display a dashboard with pull requests and issues
      gh-eco # Explore the ecosystem
      gh-f # Ultimate FZF extension
      gh-markdown-preview # Preview Markdown looking like on GitHub
      gh-notify # Display GitHub notifications
      gh-poi # Safely clean up your local branches
      gh-s # Search github repositories interactively
    ];
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
        me = "pr list --assignee @me";
        pv = "pr view";
        xds = "pr list --label='team: design-system'";
      };
    };
  };
}
