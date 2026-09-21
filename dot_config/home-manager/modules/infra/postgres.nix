{ lib, pkgs, ... }:
let
  services = {
    "alloydb" = { host = "localhost"; user = "postgres"; };
    "alloydb-read" = { host = "localhost"; user = "alloy_read"; };
    "alloydb-staging-ddl-legacy" = { host = "localhost"; user = "staging-ddl"; };
    "alloydb-staging-dml-legacy" = { host = "localhost"; user = "staging-dml"; };
    "alloydb-staging-ro" = { host = "localhost"; user = "staging_read"; };
    "alloydb-prod-ddl-legacy" = { host = "localhost"; user = "prod-ddl"; };
    "alloydb-prod-dml-legacy" = { host = "localhost"; user = "prod-dml"; };
    "alloydb-prod-ro" = { host = "localhost"; user = "prod_read"; };
    "alloydb-staging-ddl" = { host = "localhost"; user = "staging_ddl"; };
    "alloydb-staging-dml" = { host = "localhost"; user = "staging_dml"; };
    "alloydb-prod-ddl" = { host = "localhost"; user = "prod_ddl"; };
    "alloydb-prod-dml" = { host = "localhost"; user = "prod_dml"; };
    "alloydb-direct" = { host = "10.8.87.2"; user = "postgres"; };
    "alloydb-staging-ddl-direct-legacy" = { host = "10.8.87.2"; user = "staging-ddl"; };
    "alloydb-staging-dml-direct-legacy" = { host = "10.8.87.2"; user = "staging-dml"; };
    "alloydb-staging-ro-direct" = { host = "10.8.87.2"; user = "staging_read"; };
    "alloydb-prod-ddl-direct-legacy" = { host = "10.8.87.2"; user = "prod-ddl"; };
    "alloydb-prod-dml-direct-legacy" = { host = "10.8.87.2"; user = "prod-dml"; };
    "alloydb-prod-ro-direct" = { host = "10.8.87.2"; user = "prod_read"; };
    "alloydb-staging-ddl-direct" = { host = "10.8.87.2"; user = "staging_ddl"; };
    "alloydb-staging-dml-direct" = { host = "10.8.87.2"; user = "staging_dml"; };
    "alloydb-prod-ddl-direct" = { host = "10.8.87.2"; user = "prod_ddl"; };
    "alloydb-prod-dml-direct" = { host = "10.8.87.2"; user = "prod_dml"; };
  };

  mkStanza = name: { host, user }: ''
    [${name}]
    host=${host}
    port=5432
    user=${user}
    application_name=cli-${name}
  '';
in
{
  home.packages = with pkgs; [ pspg ];

  home.sessionVariables = {
    PGCONNECT_TIMEOUT = "10";
    PGSSLMODE = "prefer";
    PSQL_PAGER = "pspg";
  };

  home.file.".pg_service.conf".text = lib.concatStringsSep "\n" (
    lib.mapAttrsToList mkStanza services
  );

  programs.pgcli = {
    enable = true;
    settings.main = {
      multi_line = false;
      less_chatty = true;
      auto_expand = true;
      destructive_warning = true;
      table_format = "psql";
    };
  };

  home.file.".psqlrc".text = ''
    \set QUIET 1
    \timing
    \pset null '∅'
    \pset linestyle unicode
    \set HISTFILE ~/.psql_history- :DBNAME
    \set HISTCONTROL ignoredups
    \set COMP_KEYWORD_CASE upper
    \unset QUIET
  '';
}
