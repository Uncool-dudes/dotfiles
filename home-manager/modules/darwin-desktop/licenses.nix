{ pkgs, ... }:
let
  littlesnitch = "/Applications/Little Snitch.app/Contents/Components/littlesnitch";

  # Run once by hand after a fresh install and 1Password sign-in. Not part of
  # activation: `op` needs an unlocked 1Password and may prompt for Touch ID,
  # which a non-interactive switch can't answer.
  restore-licenses = pkgs.writeShellApplication {
    name = "restore-licenses";
    runtimeInputs = [ pkgs._1password-cli ];
    text = ''
      support="$HOME/Library/Application Support"

      mkdir -p "$support/Alfred" "$support/BetterTouchTool" "$support/Hazel" "$support/Soulver 3"

      # Alfred may tie this file to the Mac it was activated on; if Alfred
      # still shows "Activate Powerpack", re-enter the code from 1Password.
      op document get "Alfred Powerpack license file" --vault Private \
        --out-file "$support/Alfred/powerpack6.NJ4QLC4T0X.dat" --force
      echo "Alfred Powerpack license restored"

      op document get "BetterTouchTool license file" --vault Private \
        --out-file "$support/BetterTouchTool/bettertouchtool.bttlicense" --force
      echo "BetterTouchTool license restored"

      op document get "Hazel license file" --vault Private \
        --out-file "$support/Hazel/license" --force
      echo "Hazel license restored"

      /usr/bin/defaults write pl.maketheweb.cleanshotx activationKey \
        "$(op read --no-newline "op://Private/Cleanshot X/license key")"
      echo "CleanShot license restored"

      # Paddle activation files are tied to this Mac's hardware; on other
      # hardware Soulver asks for the license key again instead.
      for f in 558418.padl 558418.spadl; do
        op document get "Soulver license file $f" --vault Private \
          --out-file "$support/Soulver 3/$f" --force
      done
      echo "Soulver license restored"

      # Root-owned. The encoded fields may be keyed to this Mac's "Little
      # Snitch Encryption Key" in the System keychain; if Little Snitch still
      # shows as unregistered, enter the key from the "Little Snitch" item.
      ls_registration="$(mktemp)"
      op document get "Little Snitch registration file" --vault Private \
        --out-file "$ls_registration" --force
      sudo install -m 644 -o root -g wheel "$ls_registration" \
        "/Library/Application Support/Objective Development/Little Snitch/registration.xpl"
      rm -f "$ls_registration"
      echo "Little Snitch license restored"

      # Profiles, subscriptions, network triggers and app-approved rules live
      # only in Little Snitch's model; backup-little-snitch snapshots it.
      # The CLI refuses until "Allow access via Terminal" is on (Settings ->
      # Security), which a fresh install leaves off.
      ls_model="$(mktemp)"
      op document get "Little Snitch model backup" --vault Private \
        --out-file "$ls_model" --force
      sudo "${littlesnitch}" restore-model "$ls_model"
      rm -f "$ls_model"
      echo "Little Snitch rules, profiles and subscriptions restored"

      # Every login registers a new device and accounts cap out at 5, so skip
      # when this Mac is already logged in.
      if /usr/local/bin/mullvad account get | grep -q '^Mullvad account:'; then
        echo "Mullvad already logged in"
      else
        /usr/local/bin/mullvad account login \
          "$(op read --no-newline "op://Private/Mullvad VPN/account number")"
        echo "Mullvad logged in"
      fi

      echo "Restart Alfred, BetterTouchTool, Hazel, CleanShot, Soulver and Little Snitch to pick up the licenses."
    '';
  };

  # Re-run after changing anything in Little Snitch itself (profiles,
  # subscriptions, rules approved from prompts). Goes to 1Password, not the
  # repo: the model includes the home Wi-Fi trigger with street address and
  # coordinates.
  backup-little-snitch = pkgs.writeShellApplication {
    name = "backup-little-snitch";
    runtimeInputs = [ pkgs._1password-cli ];
    text = ''
      title="Little Snitch model backup"
      model="$(mktemp -d)/little-snitch-model.json"
      trap 'rm -rf "$(dirname "$model")"' EXIT

      # The redirect deliberately runs as the user: only the export needs
      # root, and op must be able to read the file afterwards.
      # shellcheck disable=SC2024
      sudo "${littlesnitch}" export-model > "$model"

      if op document get "$title" --vault Private > /dev/null 2>&1; then
        op document edit "$title" "$model" --vault Private
      else
        op document create "$model" --title "$title" --vault Private
      fi
      echo "Little Snitch model backed up to 1Password"
    '';
  };
in
{
  home.packages = [
    restore-licenses
    backup-little-snitch
  ];
}
