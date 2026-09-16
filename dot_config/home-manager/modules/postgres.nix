{ pkgs, ... }:
{
  home.packages = with pkgs; [ pspg ];

  home.sessionVariables = {
    PGCONNECT_TIMEOUT = "10";
    PGSSLMODE = "prefer";
    PSQL_PAGER = "pspg";
  };

  home.file.".pg_service.conf".text = ''
    [alloydb]
    host=localhost
    port=5432
    user=postgres

    [alloydb-staging-ddl]
    host=localhost
    port=5432
    user=staging_ddl

    [alloydb-staging-dml]
    host=localhost
    port=5432
    user=staging_dml

    [alloydb-staging-ro]
    host=localhost
    port=5432
    user=staging_read

    [alloydb-prod-ddl]
    host=localhost
    port=5432
    user=prod_ddl

    [alloydb-prod-dml]
    host=localhost
    port=5432
    user=prod_dml

    [alloydb-direct]
    host=10.8.87.2
    port=5432
    user=postgres

    [alloydb-staging-ddl-direct]
    host=10.8.87.2
    port=5432
    user=staging_ddl

    [alloydb-staging-dml-direct]
    host=10.8.87.2
    port=5432
    user=staging_dml

    [alloydb-staging-ro-direct]
    host=10.8.87.2
    port=5432
    user=staging_read

    [alloydb-prod-ddl-direct]
    host=10.8.87.2
    port=5432
    user=prod_ddl

    [alloydb-prod-dml-direct]
    host=10.8.87.2
    port=5432
    user=prod_dml
  '';

  home.file.".config/pgcli/config".text = ''
    [main]
    multi_line = False
    less_chatty = True
    auto_expand = True
    destructive_warning = True
    table_format = psql
  '';

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
