# Packages considered and explicitly dropped. Not imported anywhere -
# this file is a record, not a module. Re-add to the relevant role file
# if one of these becomes useful again.
#
# grex       - regex generator from examples, zero usage
# csvlens    - CSV pager, zero usage
# gitlogue   - unclear what it does / never used
# hadolint   - Dockerfile linter, zero usage
# act        - forgot what it did, zero usage
# lnav       - duplicate of hl-log-viewer
# oha        - load-test tool, zero usage
# whosthere  - zero usage
# tig        - git TUI, redundant with lazygit
# miller     - zero usage
# onefetch   - zero usage
# croc       - file transfer, zero usage
# graphviz   - dot, zero usage
# hurl       - scripted HTTP test files (.hurl), none in use
# jujutsu    - zero usage
# virtualenv - redundant, programs.uv already manages python venvs
# topgrade   - brew upgrade already runs on darwin switch; removed as unused tool
# alloydb-auth-proxy - needs direct GCP VPC/IAM access, use ssh tunnel via dev-api.ratch.ai instead
# difftastic   - no real multi-hue syntax highlighting, only bold/dim/red/green;
#                tried as git diff.external + difftool + lazygit diffRenderer, reverted to delta
# toolong      - no config/theme support at all (confirmed via --help + README),
#                replaced hl-log-viewer with it, looked bad with default styling, ditched
# ov           - themed as $PAGER replacement for less, but its real advantages
#                (column mode, multi-highlight) are already owned by mlr/lnav/fx/jq;
#                for plain man/diff paging it added complexity with no functional win.
#                swapped to moor (walles/moor, formerly "moar") instead
# age, sops    - never wired up; every secret goes through chezmoi's
#                onepasswordRead. Bring back with sops-nix if secrets ever
#                need to live in the Nix config
# kitty        - redundant with ghostty; config was modules/darwin-desktop/kitty.nix
#                (git history has it)
# nvd          - nh already prints package diffs on switch
# balenaetcher - replaced by caligula (TUI ISO flasher)
# renamer      - Finder batch rename / vidir cover it
# adobe-creative-cloud - only Acrobat was needed; adobe-acrobat-pro cask instead
# qview        - cask disabled upstream (fails Gatekeeper); EdgeView 3 from
#                the Mac App Store replaces it as the image viewer
# MCP_DOCKER   - docker mcp gateway was a Docker Desktop plugin; dropped
#                with the switch to OrbStack
{ }
