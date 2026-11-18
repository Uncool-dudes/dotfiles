{ config, lib, ... }:
let
  # Finder hands documents to apps as Apple Events, not argv, so the app has
  # to be an AppleScript applet with an `on open` handler. Each file opens in
  # its own Ghostty window running nvim.
  nvim = "${config.home.profileDirectory}/bin/nvim";
  script = ''
    on open theFiles
      repeat with f in theFiles
        do shell script "/usr/bin/open -na Ghostty --args -e ${nvim} " & quoted form of POSIX path of f
      end repeat
    end open

    on run
      do shell script "/usr/bin/open -na Ghostty --args -e ${nvim}"
    end run
  '';

  bundleId = "dev.ananthp.nvim-opener";
  # Content types the app claims, so LaunchServices accepts it as a handler
  # for them. file-associations.nix picks which of these it actually gets.
  contentTypes = [
    "public.plain-text"
    "public.json"
    "public.yaml"
  ];

  app = "${config.home.homeDirectory}/Applications/Nvim Opener.app";
  plistBuddy = "/usr/libexec/PlistBuddy";
  infoPlist = "${app}/Contents/Info.plist";
  lsregister = "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister";
  # Rebuild only when the script or claimed types change: recompiling on every
  # switch would re-register the app and reset its Finder permissions.
  stamp = builtins.hashString "sha256" (script + bundleId + lib.concatStrings contentTypes);
in
{
  home.activation.nvimOpener = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # Kept outside the bundle: writing into it would break the code signature.
    stampFile=${lib.escapeShellArg "${config.xdg.stateHome}/nvim-opener.stamp"}
    if [ "$(cat "$stampFile" 2>/dev/null)" != ${stamp} ]; then
      run rm -rf ${lib.escapeShellArg app}
      run mkdir -p ${lib.escapeShellArg "${config.home.homeDirectory}/Applications"}
      run /usr/bin/osacompile -o ${lib.escapeShellArg app} -e ${lib.escapeShellArg script}
      run ${plistBuddy} -c "Add :CFBundleIdentifier string ${bundleId}" ${lib.escapeShellArg infoPlist}
      # osacompile claims every file type ("*") for applets with `on open`;
      # replace that with only the types this app is meant to handle.
      run ${plistBuddy} -c "Delete :CFBundleDocumentTypes" ${lib.escapeShellArg infoPlist}
      run ${plistBuddy} -c "Add :CFBundleDocumentTypes array" ${lib.escapeShellArg infoPlist}
      run ${plistBuddy} -c "Add :CFBundleDocumentTypes:0 dict" ${lib.escapeShellArg infoPlist}
      run ${plistBuddy} -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Editor" ${lib.escapeShellArg infoPlist}
      run ${plistBuddy} -c "Add :CFBundleDocumentTypes:0:LSHandlerRank string Alternate" ${lib.escapeShellArg infoPlist}
      run ${plistBuddy} -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" ${lib.escapeShellArg infoPlist}
      ${lib.concatImapStrings (i: t: ''
        run ${plistBuddy} -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:${toString (i - 1)} string ${t}" ${lib.escapeShellArg infoPlist}
      '') contentTypes}
      # Editing Info.plist invalidates osacompile's ad-hoc signature.
      run /usr/bin/codesign --force --sign - ${lib.escapeShellArg app}
      run ${lsregister} -f ${lib.escapeShellArg app}
      [ -n "''${DRY_RUN:-}" ] || { mkdir -p "$(dirname "$stampFile")"; echo ${stamp} > "$stampFile"; }
    fi
  '';
}
