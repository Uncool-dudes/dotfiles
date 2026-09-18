{ inputs, pkgs, ... }:
let
  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "ef6050c5e1848b6880ff47c32ade1a608a64f85e";
    hash = "sha256-LlyBlFsKUHKzsOXEwENoVSsZHtKENVY4vFMRf08vzoU=";
  };

  claude-hud-src = pkgs.fetchFromGitHub {
    owner = "jarrodwatts";
    repo = "claude-hud";
    rev = "b83b44593af24de1db6183788a51d08715501c02";
    hash = "sha256-AfFJY6Ts5qzeECFCyevrnMWcZtwQxcCjZS73k8/PQf8=";
  };

  cc-skills-golang = pkgs.fetchFromGitHub {
    owner = "samber";
    repo = "cc-skills-golang";
    rev = "19a0626ae8565d27a7b7bdf59d8d99d94d7e284c";
    hash = "sha256-owdNtWmTwxzzrmS0XwU/8GKbJmDKl0uqi9VpiBhemps=";
  };
in
{
  programs.claude-code = {
    enable = true;
    # nixpkgs' claude-code lags upstream releases by several patch versions;
    # llm-agents.nix rebuilds daily against the actual latest release.
    package = inputs.llm-agents.packages.${pkgs.system}.claude-code;
    context = ./claude/CLAUDE.md;
    settings = builtins.fromJSON (builtins.readFile ./claude/settings.json) // {
      # claude-hud is just a statusLine script - run it directly from the nix
      # store instead of installing it as a plugin (avoids depending on the
      # plugins/cache/*/claude-hud/*/ glob the upstream setup command wires up).
      statusLine = {
        type = "command";
        command = ''bash -c 'cols=''${COLUMNS:-}; case "$cols" in ""|*[!0-9]*) cols=$(stty size </dev/tty 2>/dev/null | awk '"'"'{ print $2 }'"'"');; esac; case "$cols" in ""|*[!0-9]*) cols=120;; esac; export COLUMNS=$(( cols > 4 ? cols - 4 : 1 )); exec node "${claude-hud-src}/dist/index.js"' '';
      };
    };

    # Official plugins (gopls-lsp, rust-analyzer-lsp) have no external repo -
    # bundled with the CLI itself, kept as enabledPlugins in settings.json instead.
    # claude-hud is invoked directly via statusLine above, not as a plugin.
    plugins = {
      caveman = caveman;
      cc-skills-golang = cc-skills-golang;
    };
  };

  home.file = {
    ".claude/RTK.md".source = ./claude/RTK.md;
    ".claude/plugins/claude-hud/config.json".source = ./claude/plugins/claude-hud/config.json;
  };
}
