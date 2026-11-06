{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      shown_boxes = "proc cpu";
      proc_sorting = "memory";
      cpu_bottom = true;
      save_config_on_exit = false;
    };
  };
}
