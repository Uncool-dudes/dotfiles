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

    [alloydb-prod-ro]
    host=localhost
    port=5432
    user=prod_read

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

    [alloydb-prod-ro-direct]
    host=10.8.87.2
    port=5432
    user=prod_read
  '';

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
