#!/usr/bin/env zsh
# Worktree manager for this user's layout: <repo>.worktrees/<name>,
# sibling to the repo, flat branch names (no feature/ prefix).
set -euo pipefail

usage() {
  gum log -l error "usage: wt add <name> [base-branch] | wt pr <number> | wt rm <name> [--force] | wt list | wt run <name|all> <cmd...> | wt pull | wt clean | wt status | wt path <name>" >&2
  exit 1
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || { gum log -l error "not inside a git repo" >&2; exit 1; }
}

wt_dir() {
  local root; root=$(repo_root)
  echo "$(dirname "$root")/$(basename "$root").worktrees"
}

wt_path() {
  echo "$(wt_dir)/$1"
}

cmd_add() {
  local name="${1:-}" base="${2:-}"
  [[ -n "$name" ]] || usage
  local target; target=$(wt_path "$name")

  if [[ -e "$target" ]]; then
    gum log -l error "target already exists: $target" >&2
    exit 1
  fi
  mkdir -p "$(dirname "$target")"

  if git show-ref --verify --quiet "refs/heads/$name"; then
    gum log -l info "branch '$name' exists locally - attaching worktree"
    git worktree add "$target" "$name"
  elif git show-ref --verify --quiet "refs/remotes/origin/$name"; then
    gum log -l info "branch '$name' exists on origin - tracking it"
    git worktree add --track -b "$name" "$target" "origin/$name"
  else
    base="${base:-main}"
    gum log -l info "branch '$name' doesn't exist - creating from '$base'"
    git worktree add -b "$name" "$target" "$base"
  fi
  (( $+commands[zoxide] )) && zoxide add "$target"

  # machine-parsed by the `worktree` Claude skill - keep as plain stdout, not gum.
  echo "WORKTREE_PATH: $target"
}

cmd_pr() {
  local num="${1:-}"
  [[ -n "$num" ]] || usage
  (( $+commands[gh] )) || { gum log -l error "gh not found" >&2; exit 1; }
  local branch; branch=$(gh pr view "$num" --json headRefName -q .headRefName 2>/dev/null) \
    || { gum log -l error "pr #$num not found" >&2; exit 1; }
  git fetch origin "$branch" 2>/dev/null || true
  gum log -l info "pr #$num -> branch '$branch'"
  cmd_add "$branch"
}

cmd_rm() {
  local name="${1:-}" force="${2:-}"
  [[ -n "$name" ]] || usage
  local target; target=$(wt_path "$name")

  if [[ ! -e "$target" ]]; then
    gum log -l error "no worktree at: $target" >&2
    git worktree list
    exit 1
  fi

  if [[ "$force" == "--force" ]]; then
    git worktree remove --force "$target"
  else
    git worktree remove "$target"
  fi
  git worktree prune
  gum log -l info "removed: $target"
}

cmd_run() {
  local name="${1:-}"; shift || true
  [[ -n "$name" && $# -gt 0 ]] || usage

  if [[ "$name" == "all" ]]; then
    local wtdir; wtdir=$(wt_dir)
    [[ -d "$wtdir" ]] || { gum log -l error "no $wtdir" >&2; exit 1; }
    for d in "$wtdir"/*/; do
      gum log -l info "running in: ${d%/}"
      (cd "$d" && "$@")
    done
  else
    local target; target=$(wt_path "$name")
    [[ -e "$target" ]] || { gum log -l error "no worktree at: $target" >&2; exit 1; }
    (cd "$target" && "$@")
  fi
}

cmd_pull() { cmd_run all git pull origin main }

cmd_clean() {
  (( $+commands[gh] )) || { gum log -l error "gh not found" >&2; exit 1; }
  local wtdir; wtdir=$(wt_dir)
  [[ -d "$wtdir" ]] || { gum log -l error "no $wtdir" >&2; exit 1; }

  # gh poi can't delete a branch checked out in a worktree, so remove the
  # worktree first for any branch whose PR already merged or closed.
  for d in "$wtdir"/*/; do
    local name; name=$(basename "${d%/}")
    local state; state=$(gh pr view "$name" --json state -q .state 2>/dev/null) || continue
    if [[ "$state" == "MERGED" || "$state" == "CLOSED" ]]; then
      gum log -l info "removing worktree for $state pr: $name"
      git worktree remove "$d" 2>/dev/null || git worktree remove --force "$d"
    fi
  done
  git worktree prune
  gh poi --state merged,closed
}

cmd_status() {
  local wtdir; wtdir=$(wt_dir)
  [[ -d "$wtdir" ]] || { gum log -l error "no $wtdir" >&2; exit 1; }
  for d in "$wtdir"/*/; do
    local name; name=$(basename "${d%/}")
    if [[ -n "$(git -C "$d" status -s)" ]]; then
      echo "$name: dirty"
    else
      echo "$name: clean"
    fi
  done
}

cmd_path() {
  local name="${1:-}"
  [[ -n "$name" ]] || usage
  local target; target=$(wt_path "$name")
  [[ -e "$target" ]] || { gum log -l error "no worktree at: $target" >&2; exit 1; }
  echo "$target"
}

case "${1:-}" in
  add) shift; cmd_add "$@" ;;
  pr) shift; cmd_pr "$@" ;;
  rm) shift; cmd_rm "$@" ;;
  list) git worktree list ;;
  run) shift; cmd_run "$@" ;;
  pull) cmd_pull ;;
  clean) cmd_clean ;;
  status) cmd_status ;;
  path) shift; cmd_path "$@" ;;
  *) usage ;;
esac
