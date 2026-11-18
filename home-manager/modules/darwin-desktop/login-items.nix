{ lib, pkgs, ... }:
let
  # Launch agents instead of System Settings login items, so the list lives in
  # the repo. Karabiner, Little Snitch and Hazel start their own services and
  # need no entry here.
  apps = [
    "Alfred 5"
    "BetterTouchTool"
    "CleanShot X"
    "Mullvad VPN"
    "PopClip"
    "TG Pro"
  ];

  agentName = app: "open-" + lib.toLower (lib.replaceStrings [ " " ] [ "-" ] app);

  openAtLogin = app: {
    name = agentName app;
    value = {
      enable = true;
      config = {
        # -g: launch in the background without stealing focus at login.
        ProgramArguments = [
          "/usr/bin/open"
          "-g"
          "-a"
          app
        ];
        RunAtLoad = true;
      };
    };
  };
in
{
  launchd.agents = lib.listToAttrs (map openAtLogin apps);

  # Setting the HTTP handler makes macOS show a confirmation dialog, so only
  # ask when Chrome isn't already the default.
  home.activation.defaultBrowser = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.defaultbrowser}/bin/defaultbrowser | grep -q '^\* chrome$'; then
      run ${pkgs.defaultbrowser}/bin/defaultbrowser chrome
    fi
  '';
}
