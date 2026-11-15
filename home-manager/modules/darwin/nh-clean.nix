{ pkgs, ... }:
{
  # Root daemon instead of home-manager's per-user agent: `nh clean user` cannot
  # touch darwin system generations or root-owned /nix/var/nix/gcroots/auto
  # entries, so those kept every old build alive. nix-darwin's own
  # programs.nh.clean is unusable here - it asserts nix.enable, which
  # Determinate requires to be false.
  #
  # --no-gc: determinate-nixd owns garbage collection (disk-pressure driven);
  # this job only drops old generations and stale roots so that GC can reclaim
  # them. Determinate's docs advise against stacking a second GC schedule.
  launchd.daemons.nh-clean = {
    # Determinate installs nix outside the nix-darwin system profile.
    path = [
      "/nix/var/nix/profiles/default/bin"
      "/usr/bin"
      "/bin"
    ];
    command = "${pkgs.nh}/bin/nh clean all --keep 5 --keep-since 14d --no-gc";
    serviceConfig = {
      RunAtLoad = false;
      StartCalendarInterval = [
        {
          Weekday = 1;
          Hour = 12;
          Minute = 0;
        }
      ];
      WorkingDirectory = "/var/root";
      StandardOutPath = "/var/log/nh-clean.log";
      StandardErrorPath = "/var/log/nh-clean.log";
      LowPriorityIO = true;
      ProcessType = "Background";
    };
  };
}
