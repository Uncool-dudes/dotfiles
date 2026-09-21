{ inputs, pkgs, ... }:
let
  # NOTE: keep in sync with modules/ai/packages.nix override - patches bar chars
  # in compiled bundle by literal string match, likely to break on version bump.
  ccstatusline = inputs.llm-agents.packages.${pkgs.system}.ccstatusline.overrideAttrs (old: {
    postInstall = ''
      substituteInPlace $out/bin/ccstatusline \
        --replace-quiet '▓' '-' \
        --replace-quiet '░' '·'
    '';
  });

  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "ef6050c5e1848b6880ff47c32ade1a608a64f85e";
    hash = "sha256-LlyBlFsKUHKzsOXEwENoVSsZHtKENVY4vFMRf08vzoU=";
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
      statusLine = {
        type = "command";
        command = "${ccstatusline}/bin/ccstatusline";
      };
    };

    # Official plugins (gopls-lsp, rust-analyzer-lsp) have no external repo -
    # bundled with the CLI itself, kept as enabledPlugins in settings.json instead.
    plugins = {
      caveman = caveman;
      cc-skills-golang = cc-skills-golang;
    };
  };

  home.file = {
    ".claude/RTK.md".source = ./claude/RTK.md;
    ".config/ccstatusline/settings.json".source = ./claude/ccstatusline-settings.json;
  };
}
