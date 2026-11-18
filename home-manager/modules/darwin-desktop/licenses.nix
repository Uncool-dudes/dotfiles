{ pkgs, ... }:
let
  # Run once by hand after a fresh install and 1Password sign-in. Not part of
  # activation: `op` needs an unlocked 1Password and may prompt for Touch ID,
  # which a non-interactive switch can't answer.
  restore-licenses = pkgs.writeShellApplication {
    name = "restore-licenses";
    runtimeInputs = [ pkgs._1password-cli ];
    text = ''
      support="$HOME/Library/Application Support"

      mkdir -p "$support/BetterTouchTool" "$support/Hazel" "$support/Soulver 3"

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

      echo "Restart BetterTouchTool, Hazel, CleanShot and Soulver to pick up the licenses."
    '';
  };
in
{
  home.packages = [ restore-licenses ];
}
