# career-ops (github.com/career-ops-hq/career-ops) launcher.
#
# Home-manager owns only the entrypoint. The checkout stays a writable clone:
# node_modules, the updater and the user's job-search data all live in it.
# The toolchain comes from upstream's own flake via its .envrc, not from this
# nixpkgs: the npm playwright pin must match the browser revision of the
# nixpkgs that upstream locks, and the upstream shellHook already owns that
# rule. nix-direnv (modules/core/direnv.nix) caches the shell and roots it
# against GC, so the ~3 GiB toolchain is not refetched after a collect.
{ config, pkgs, ... }:
let
  checkout = "${config.home.homeDirectory}/career-ops";

  career-ops = pkgs.writeShellApplication {
    name = "career-ops";
    runtimeInputs = [
      pkgs.git
      pkgs.direnv
    ];
    text = ''
      dir=${checkout}
      if [ ! -d "$dir" ]; then
        git clone --depth 1 https://github.com/career-ops-hq/career-ops.git "$dir"
        direnv allow "$dir"
      fi
      # .envrc runs `dotenv`, which warns on every launch until .env exists.
      # It is gitignored and holds optional API keys, so an empty one is safe.
      [ -e "$dir/.env" ] || touch "$dir/.env"
      cd "$dir"
      # Same entry as the zsh `claude` function: loadout settings and MCP
      # servers, and DO_NOT_TRACK unset so feature flags (advisor) still load.
      exec direnv exec "$dir" env -u DO_NOT_TRACK loadout exec --optional -- "$@"
    '';
  };
in
{
  home.packages = [ career-ops ];
}
