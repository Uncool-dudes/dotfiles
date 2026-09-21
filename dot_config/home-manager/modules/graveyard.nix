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
{ }
