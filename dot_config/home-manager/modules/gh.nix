{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "https";
      prompt = "enabled";
      color_labels = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
    extensions = [
      pkgs.gh-dash

      (pkgs.writeShellApplication {
        name = "gh-delete-repo";
        derivationArgs.pname = "gh-delete-repo";
        runtimeInputs = [ pkgs.gh ];
        text = ''
          confirm=
          pattern=

          while [ $# -gt 0 ]; do
            case "$1" in
            -y|--yes) confirm=1 ;;
            -h|--help)
              echo "Usage: gh delete-repo [-y] <owner>/<name>"
              exit 0 ;;
            *) pattern="$1" ;;
            esac
            shift 1
          done

          if [[ $pattern != */* ]]; then
            echo "error: argument must be prefixed with \`<owner>/\`" >&2
            exit 1
          fi

          owner="''${pattern%/*}"
          pattern="''${pattern#*/}"
          exact=1
          [[ $pattern == *"*"* ]] && exact=

          if [[ -n $confirm && -z $exact ]]; then
            echo "error: cannot use \`--yes\` with name pattern" >&2
            exit 1
          fi

          repos=()
          if [ -n "$exact" ]; then
            repos=( "$owner/$pattern" )
          else
            pattern="$(sed 's/\./\\./g; s/\*/.\\{0,\\}/g' <<<"''${pattern}")"
            while IFS=$'\t' read -r repo _; do
              if grep -q "^''${pattern}$" <<<"''${repo#*/}"; then
                repos+=( "$repo" )
              fi
            done < <(gh repo list "$owner" --limit 999)
          fi

          for repo in "''${repos[@]}"; do
            if [ -z "$confirm" ]; then
              read -p "Delete repository ''${repo}? (y/N) " -n 1 -r
              echo
              [[ $REPLY =~ ^[Yy]$ ]] || continue
            fi
            gh api -X DELETE "repos/$repo" -i
          done
        '';
      })

      (pkgs.writeShellApplication {
        name = "gh-repo-collab";
        derivationArgs.pname = "gh-repo-collab";
        runtimeInputs = [ pkgs.gh ];
        text = ''
          usage() {
            echo "Usage: gh repo-collab list [<repo>]"
            echo "       gh repo-collab add <repo> <handle> [--permission {pull|triage|push|maintain|admin}]"
            echo "       gh repo-collab remove <repo> <handle>"
          }

          list() {
            local repo='{owner}/{repo}'
            [ $# -eq 0 ] || repo="$1"
            gh api --paginate "repos/$repo/collaborators" --template \
              '{{- range . -}}{{- tablerow .login "" -}}{{- end -}}'
          }

          add() {
            local repo user
            local args=(--silent)
            while [ $# -gt 0 ]; do
              case "$1" in
                --permission) args+=(-f permission="$2"); shift 2 ;;
                *)
                  if [ -z "$repo" ]; then repo="$1"; shift 1
                  elif [ -z "$user" ]; then user="$1"; shift 1
                  else echo "invalid argument: $1" >&2; return 1; fi ;;
              esac
            done
            [ -n "$repo" ] || { usage >&2; return 1; }
            if [[ $user == */* ]]; then
              gh api --method=PUT "orgs/''${repo%/*}/teams/''${user#*/}/repos/$repo" "''${args[@]}"
            else
              gh api --method=PUT "repos/$repo/collaborators/$user" "''${args[@]}"
            fi
          }

          remove() {
            local repo="$1" user="$2"
            if [[ $user == */* ]]; then
              gh api --method=DELETE "orgs/''${repo%/*}/teams/''${user#*/}/repos/$repo" --silent
            else
              gh api --method=DELETE "repos/$repo/collaborators/$user" --silent
            fi
          }

          cmd="$1"; [ $# -eq 0 ] || shift 1
          case "$cmd" in
            -h|--help) usage ;;
            add)    add "$@" ;;
            remove) remove "$@" ;;
            list)   list "$@" ;;
            *)      usage >&2; exit 1 ;;
          esac
        '';
      })
    ];
  };
}
