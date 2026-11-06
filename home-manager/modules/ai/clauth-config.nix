# clauth mutates active_profile/credentials on every switch, so these
# files can't be nix-managed symlinks - seeded once on first setup only,
# left alone afterward. Re-delete the file on disk to reseed.
{ lib, ... }:
let
  profilesToml = ''
    active_profile = "Work"
    profiles = [
        "Work",
        "Personal",
    ]
    fallback_chain = []
    wrap_off = false
    theme = "compatible"
    reset_display = "relative"
    clock_format = "12h"
    refresh_interval_ms = 90000
  '';

  workConfigToml = ''
    auto_start = true

    [models]
    default = "sonnet"
  '';

  personalConfigToml = ''
    [models]
    default = "sonnet"
  '';

  seedFile = path: contentVar: ''
    if [ ! -e "${path}" ]; then
      mkdir -p "$(dirname "${path}")"
      cat > "${path}" <<'CLAUTH_SEED_EOF'
    ${contentVar}
    CLAUTH_SEED_EOF
    fi
  '';
in
{
  home.activation.seedClauthConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${seedFile "$HOME/.clauth/profiles.toml" profilesToml}
    ${seedFile "$HOME/.clauth/profiles/Work/config.toml" workConfigToml}
    ${seedFile "$HOME/.clauth/profiles/Personal/config.toml" personalConfigToml}
  '';
}
