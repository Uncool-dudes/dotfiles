{ inputs, pkgs, ... }:
let
  sources = import ./skill-sources.nix { inherit pkgs; };

  # Plugins stay for what only a plugin can carry: hooks, commands, MCP
  # servers. Their skills are picked one at a time through loadout, and a plugin
  # skill cannot be toggled individually, so the plugin's own copies are
  # switched off here; leaving them on would list every description twice.
  # The files stay in place because caveman's hooks read their ruleset from
  # skills/<mode>/SKILL.md.
  withSkillsOff =
    name: src:
    pkgs.runCommand "${name}-skills-off" { nativeBuildInputs = [ pkgs.yq-go ]; } ''
      cp -r ${src} $out
      chmod -R u+w $out
      find "$out/skills" -name SKILL.md | while read -r file; do
        header=$(awk 'NR==1 && /^---$/{h=1; next} h==1 && /^---$/{exit} h==1' "$file")
        body=$(awk 'NR==1 && /^---$/{h=1; next} h==1 && /^---$/{h=2; next} h==2' "$file")
        header=$(echo "$header" | yq -p yaml -o yaml '."user-invocable" = false | ."disable-model-invocation" = true')
        { printf -- '---\n%s\n---\n' "$header"; printf '%s\n' "$body"; } > "$file.new"
        mv "$file.new" "$file"
      done
    '';

  caveman = withSkillsOff "caveman" sources.caveman;
  claude-mem = withSkillsOff "claude-mem" "${sources.claude-mem}/plugin";
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
    #
    # Skills are not declared here: loadout owns them, from the library built
    # in skill-library.nix.

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
      # The attribute name is the directory under ~/.claude/skills, so it must
      # not be "caveman": loadout links the skill of that name there, and the
      # hooks read its ruleset from ~/.claude/skills/caveman/SKILL.md.
      caveman-plugin = caveman;
      inherit claude-mem;
      # Command-only plugin (no SKILL.md), so it cannot live in the loadout
      # library, which indexes skills.
      insecure-defaults = "${sources.trailofbits}/plugins/insecure-defaults";
    };
  };
}
