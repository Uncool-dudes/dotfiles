{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    abtop
    bun
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.clauth
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.mcporter
    # NOTE: patches bar chars in compiled bundle by literal string match - upstream
    # bundle rewrite can silently break this substitution.
    (inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.ccstatusline.overrideAttrs (old: {
      # $out/bin/ccstatusline is just the wrapper; the bar chars live in the
      # dist chunk files it dynamically imports from libexec. Globbed because
      # chunk names carry a content hash that changes every version.
      postInstall = ''
        substituteInPlace $out/libexec/ccstatusline/dist/*.js \
          --replace-quiet '▓' '-' \
          --replace-quiet '░' '·'
      '';
    }))
  ];
}
