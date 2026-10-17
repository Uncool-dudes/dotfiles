{ inputs, pkgs, ... }:
let
  # NOTE: keep in sync with modules/ai/packages.nix override - patches bar chars
  # in compiled bundle by literal string match, likely to break on version bump.
  ccstatusline =
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline.overrideAttrs
      (old: {
        # upstream package.nix only copies dist/ccstatusline.js, but that
        # entry file dynamically imports sibling chunks in the same dir -
        # copy the whole dist/ so those resolve.
        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp $src/dist/*.js $out/bin/
          chmod +x $out/bin/ccstatusline.js
          mv $out/bin/ccstatusline.js $out/bin/ccstatusline
          substituteInPlace $out/bin/ccstatusline \
            --replace-quiet "#!/usr/bin/env node" "#!${pkgs.nodejs}/bin/node"
          runHook postInstall
        '';
        postInstall = ''
          substituteInPlace $out/bin/ccstatusline-tgzfz3x2.js $out/bin/index-wzd62dxf.js \
            --replace-quiet '▓' '-' \
            --replace-quiet '░' '·'
        '';
      });

  caveman = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "d262ab3882952a59312ff3537cd86d894523c5ab";
    hash = "sha256-2xZHdWkWJrPAJ8++qW0Xmb3eORZ41e+GsZjIphqTtlI=";
  };

  cc-skills-golang-src = pkgs.fetchFromGitHub {
    owner = "samber";
    repo = "cc-skills-golang";
    rev = "8e899e20ff0cd4dc524af3993e4c62d8ee8c5717";
    hash = "sha256-GYayraudW1jRetezgPZe3BUOSAc7N94HH/hlAGNXjzc=";
  };

  # Dropped: unused in this stack (graphql, wire/dig DI, cobra/viper CLI,
  # oops/do/slog samber libs not adopted here).
  cc-skills-golang-droppedSkills = [
    "golang-graphql"
    "golang-google-wire"
    "golang-samber-oops"
    "golang-samber-do"
    "golang-samber-slog"
    "golang-uber-dig"
    "golang-spf13-cobra"
    "golang-spf13-viper"
  ];

  cc-skills-golang = pkgs.runCommand "cc-skills-golang-trimmed" { } (
    ''
      cp -r ${cc-skills-golang-src} $out
      chmod -R u+w $out
    ''
    + pkgs.lib.concatMapStrings (skill: ''
      rm -rf $out/skills/${skill}
    '') cc-skills-golang-droppedSkills
  );

  mattpocock-skills = pkgs.fetchFromGitHub {
    owner = "mattpocock";
    repo = "skills";
    rev = "49dd158d1076134a641b33efb035946536778336";
    hash = "sha256-NljCSZNI3sZ+vbCw7pRdrwR7try4BxOFp4gdjuWYtzs=";
  };

  obra-superpowers = pkgs.fetchFromGitHub {
    owner = "obra";
    repo = "superpowers";
    rev = "bb92a77741419a4ab5f06e711a283343f1ada0c3";
    hash = "sha256-UCVI+T7j1Xh1LDkrvnJduis7eHFqrizCyGTWAGW5d6U=";
  };

  claude-overkill = pkgs.fetchFromGitHub {
    owner = "santiago-vargas-de-kruijf";
    repo = "claude-overkill";
    rev = "60c7bbbab99669e3fc39e60cdf4f05d473ab194c";
    hash = "sha256-Ovm5dgeOPa0o0t+mjmp9idVGsGFWx24Y3H7UOAquxxw=";
  };
in
{
  programs.claude-code = {
    enable = true;
    mutableSettings = true;
    # nixpkgs' claude-code lags upstream releases by several patch versions;
    # llm-agents.nix rebuilds daily against the actual latest release.
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.claude-code;
    context = ./claude/CLAUDE.md;
    rulesDir = ./claude/instructions;
    # Deploys the plugin's own hook scripts declaratively instead of the
    # hand-copied files that were sitting in ~/.claude/hooks/ untracked -
    # single source of truth, and whole-directory deploy keeps sibling
    # requires (caveman-config.js, cavecrew-model-overrides.js, etc) intact.
    hooksDir = "${caveman}/src/hooks";

    # dash0 is NOT here - it carries a live bearer token, and mcpServers
    # values land in the world-readable Nix store. Keep it unmanaged
    # (`claude mcp add`), only migrate servers with no secrets.
    mcpServers = {
      MCP_DOCKER = {
        command = "docker";
        args = [
          "mcp"
          "gateway"
          "run"
          "--profile"
          "ai_coding"
        ];
      };
    };
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

    skills = {
      "test-driven-development" = "${obra-superpowers}/skills/test-driven-development";
      "overkill" = "${claude-overkill}/plugins/overkill/skills/overkill";
      "commit" = ./claude/skills/commit;
      "pr" = ./claude/skills/pr;
      "worktree" = ./claude/skills/worktree;
      "resolve" = ./claude/skills/resolve;
    }
    // (
      let
        engineeringSkills = [
          "code-review"
          "codebase-design"
          "diagnosing-bugs"
          "domain-modeling"
          "implement"
          "implement-spec"
          "improve-codebase-architecture"
          "research"
          "setup-matt-pocock-skills"
          "to-spec"
          "to-tickets"
        ];
      in
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value = "${mattpocock-skills}/skills/engineering/${name}";
        }) engineeringSkills
      )
    );
  };

  home.file = {
    ".config/ccstatusline/settings.json".source = ./claude/ccstatusline-settings.json;
  };
}
