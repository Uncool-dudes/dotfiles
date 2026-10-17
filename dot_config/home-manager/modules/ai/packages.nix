{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    abtop
    bun
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.clauth
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills-installer
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.mcporter
    # NOTE: patches bar chars in compiled bundle by literal string match - upstream
    # version bump or bundle rewrite can silently break this substitution.
    (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline.overrideAttrs (old: {
      postInstall = ''
        substituteInPlace $out/bin/ccstatusline \
          --replace-quiet '▓' '-' \
          --replace-quiet '░' '·'
      '';
    }))
  ];
}
