{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    abtop
    inputs.llm-agents.packages.${pkgs.system}.clauth
    inputs.llm-agents.packages.${pkgs.system}.claude-plugins
    inputs.llm-agents.packages.${pkgs.system}.mcporter
    # NOTE: patches bar chars in compiled bundle by literal string match - upstream
    # version bump or bundle rewrite can silently break this substitution.
    (inputs.llm-agents.packages.${pkgs.system}.ccstatusline.overrideAttrs (old: {
      postInstall = ''
        substituteInPlace $out/bin/ccstatusline \
          --replace-quiet '▓' '-' \
          --replace-quiet '░' '·'
      '';
    }))
  ];
}
