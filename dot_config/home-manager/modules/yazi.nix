{ ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      mgr.show_hidden = false;
      preview = {
        image_filter = "triangle";
        max_width = 1000;
        max_height = 800;
      };
      tasks = {
        preload_workers = 15;
        fetch_workers = 10;
      };
    };
  };
}
