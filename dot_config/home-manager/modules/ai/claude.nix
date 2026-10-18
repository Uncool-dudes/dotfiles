{ inputs, pkgs, ... }:
let
  # Copies a plugin source tree and flips the `user-invocable` /
  # `disable-model-invocation` frontmatter flags on named skills, instead of
  # deleting them - reversible and inspectable (`cat $out/skills/<name>/SKILL.md`)
  # rather than a silent `rm -rf`. Setting both false+true fully neutralizes a
  # skill (no slash command, no auto-trigger) without touching its content.
  #
  # overrides: list of { skill, userInvocable ? null, disableModelInvocation ? null }
  # - userInvocable = false          -> hidden from `/` list, auto-trigger still works
  # - disableModelInvocation = true  -> no auto-trigger, slash command still works
  # - both set                       -> skill fully off, equivalent to the old trim
  # dropCommands: commands/*.toml have no invocation-flag equivalent (that
  # frontmatter schema is skills-only) - the only off switch is deleting the file.
  setSkillInvocation =
    {
      name,
      src,
      overrides,
      dropCommands ? [ ],
    }:
    pkgs.runCommand "${name}-patched" { nativeBuildInputs = [ pkgs.yq-go ]; } (
      ''
        cp -r ${src} $out
        chmod -R u+w $out
      ''
      + pkgs.lib.concatMapStrings (cmd: ''
        rm -f "$out/commands/${cmd}.md" "$out/commands/${cmd}.toml"
      '') dropCommands
      + ''
        patch_field() {
          local file="$1" key="$2" value="$3"
          [ -f "$file" ] || { echo "setSkillInvocation: missing $file" >&2; exit 1; }
          local fm body
          fm=$(awk '/^---$/{c++; next} c==1' "$file")
          body=$(awk '/^---$/{c++; next} c>=2' "$file")
          fm=$(echo "$fm" | yq -p yaml -o yaml ".\"$key\" = $value")
          { printf -- '---\n%s\n---\n' "$fm"; printf '%s\n' "$body"; } > "$file.new"
          mv "$file.new" "$file"
        }
      ''
      + pkgs.lib.concatMapStrings (
        o:
        pkgs.lib.optionalString (o.userInvocable or null != null) ''
          patch_field "$out/skills/${o.skill}/SKILL.md" "user-invocable" "${
            if o.userInvocable then "true" else "false"
          }"
        ''
        + pkgs.lib.optionalString (o.disableModelInvocation or null != null) ''
          patch_field "$out/skills/${o.skill}/SKILL.md" "disable-model-invocation" "${
            if o.disableModelInvocation then "true" else "false"
          }"
        ''
      ) overrides
    );

  # Two shapes every setSkillInvocation overrides list reduces to:
  # off entirely, or hidden from `/` with auto-trigger kept.
  fullyOff = map (skill: {
    inherit skill;
    userInvocable = false;
    disableModelInvocation = true;
  });
  hideKeepAuto = map (skill: {
    inherit skill;
    userInvocable = false;
  });

  caveman-src = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "bad48a0e1df55e05e3f52249afa35ecc1909ee76";
    hash = "sha256-G2i54t+5fFCRI3lXP6fXV9oPWwIKklmx6F3EfrqntBY=";
  };

  caveman = setSkillInvocation {
    name = "caveman";
    src = caveman-src;
    # Discarded in the full command-trim pass - a one-off repo-setup action,
    # not used after initial activation.
    dropCommands = [ "caveman-init" ];
    overrides =
      # Caveman Cloud gateway/billing skills - unrelated product behind the
      # same plugin name as the text-compression mode we actually use, plus
      # two discards from the full command-trim pass. Fully off.
      fullyOff [
        "caveman-setup"
        "caveman-discover"
        "caveman-evidence-review"
        "caveman-manage"
        "caveman-optimize"
        "caveman-commit"
        "megacave"
      ]
      ++ hideKeepAuto [
        # Daily-driver text mode - keep auto-triggering on natural-language
        # cues, just stop cluttering the `/` list as their own commands.
        "caveman"
        "caveman-review"
        # Internal methodology/decision-aid skills - meant to be adopted from
        # context, never typed by hand.
        "cavecrew"
        "caveman-explore"
        "investigate-first"
        "lean-build"
        "migration"
        "safe-refactor"
        "surgical-patch"
        "verify-and-stop"
      ];
    # caveman-help/-learn/-stats stay visible: deliberate explicit actions
    # with no reliable natural-language trigger, not worth a command wrapper.
  };

  cc-skills-golang-src = pkgs.fetchFromGitHub {
    owner = "samber";
    repo = "cc-skills-golang";
    rev = "8e899e20ff0cd4dc524af3993e4c62d8ee8c5717";
    hash = "sha256-GYayraudW1jRetezgPZe3BUOSAc7N94HH/hlAGNXjzc=";
  };

  cc-skills-golang = setSkillInvocation {
    name = "cc-skills-golang";
    src = cc-skills-golang-src;
    # Unused in this stack: graphql, wire/dig DI, cobra/viper CLI,
    # oops/do/slog samber libs not adopted here, plus discards from the full
    # command-trim pass. Fully off.
    overrides =
      fullyOff [
        "golang-graphql"
        "golang-google-wire"
        "golang-samber-oops"
        "golang-samber-do"
        "golang-samber-slog"
        "golang-uber-dig"
        "golang-spf13-cobra"
        "golang-spf13-viper"
        "golang-cli"
        "golang-continuous-integration"
        "golang-stay-updated"
      ]
      # Contextual guidance applied automatically during Go work - none of
      # these are deliberate user-typed actions, unlike caveman-stats.
      # Hide from `/`, keep auto-trigger.
      ++ hideKeepAuto [
        "golang-benchmark"
        "golang-code-style"
        "golang-concurrency"
        "golang-context"
        "golang-data-structures"
        "golang-database"
        "golang-dependency-injection"
        "golang-dependency-management"
        "golang-design-patterns"
        "golang-documentation"
        "golang-error-handling"
        "golang-gopls"
        "golang-grpc"
        "golang-how-to"
        "golang-lint"
        "golang-modernize"
        "golang-naming"
        "golang-observability"
        "golang-performance"
        "golang-pkg-go-dev"
        "golang-popular-libraries"
        "golang-project-layout"
        "golang-refactoring"
        "golang-safety"
        "golang-samber-hot"
        "golang-samber-lo"
        "golang-samber-mo"
        "golang-samber-ro"
        "golang-security"
        "golang-stretchr-testify"
        "golang-structs-interfaces"
        "golang-swagger"
        "golang-testing"
        "golang-troubleshooting"
        "golang-uber-fx"
      ];
  };

  claude-mem-src = pkgs.fetchFromGitHub {
    owner = "thedotmack";
    repo = "claude-mem";
    rev = "b85cd123daf8e5bd59edb2d1c7b98e0bba28b3a0";
    hash = "sha256-Gily9VzCtRT1+t2Z1pKLLR8WoW0EPX/250vBmLY/iZE=";
  };

  claude-mem = setSkillInvocation {
    name = "claude-mem";
    # The plugin itself lives under plugin/ in this monorepo, not the repo root.
    src = "${claude-mem-src}/plugin";
    # Discarded in the full command-trim pass - never used.
    overrides =
      fullyOff [
        "version-bump"
        "wowerpoint"
      ]
      # Explicit actions with distinctive, phrase-matchable triggers -
      # hide from `/`, keep auto-trigger.
      ++ hideKeepAuto [
        "agent-cost-report"
        "babysit"
        "ccs-align"
        "cloud-sync"
        "design-is"
        "do"
        "handoff"
        "how-it-works"
        "knowledge-agent"
        "make-plan"
        "mem-search"
        "mode-creator"
        "oh-my-issues"
        "screenpipe"
        "smart-explore"
        "standup"
        "timeline-report"
        "what-the"
      ];
    # learn-codebase, pathfinder, weekly-digests stay visible: each runs a
    # full-codebase scan or multi-agent fan-out, expensive enough to want a
    # deliberate `/` invocation rather than risk an accidental auto-fire.
  };

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
    # Deploys the plugin's own hook scripts declaratively instead of the
    # hand-copied files that were sitting in ~/.claude/hooks/ untracked -
    # single source of truth, and whole-directory deploy keeps sibling
    # requires (caveman-config.js, cavecrew-model-overrides.js, etc) intact.
    hooksDir = "${caveman}/src/hooks";

    # context/rulesDir/commandsDir/settings/mcpServers moved to chezmoi
    # (~/.claude/CLAUDE.md, rules/, commands/, settings.json,
    # skills/hm-mcp/) - mutable runtime config, not reproducible-build
    # material. ccstatusline itself stays a nix package, on PATH, so
    # chezmoi's settings.json can reference it by bare command name.

    # Without this, settings.json's enabledPlugins references to
    # gopls-lsp@claude-plugins-official / rust-analyzer-lsp@claude-plugins-official
    # dangle after a config wipe - the marketplace registration itself was only
    # ever imperative state in ~/.claude/plugins/known_marketplaces.json.
    marketplaces = {
      claude-plugins-official = pkgs.fetchFromGitHub {
        owner = "anthropics";
        repo = "claude-plugins-official";
        rev = "ea10b213686c90bb1984b2016937310e05336cf3";
        hash = "sha256-Tfs8Ig1rzLvaAuTZwqGUzKCK0TMWE2SddYss+H/04ug=";
      };
    };

    plugins = {
      caveman = caveman;
      cc-skills-golang = cc-skills-golang;
      claude-mem = claude-mem;
    };

    skills = {
      "test-driven-development" = "${obra-superpowers}/skills/test-driven-development";
      "overkill" = "${claude-overkill}/plugins/overkill/skills/overkill";
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

}
