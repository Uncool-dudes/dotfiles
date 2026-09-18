{ ... }:
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
    defaultCommand = "fd --type f --follow";
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
    fileWidget = {
      command = "fd --type f --follow";
      options = [ "--preview" "'bat -n --color=always {}'" ];
    };
    changeDirWidget = {
      command = "fd --type d --follow";
      options = [ "--preview" "'eza --tree --level=2 --icons --color=always {}'" ];
    };
  };
}
