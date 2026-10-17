#!/usr/bin/env zsh
# Worktree manager for this user's layout: <repo>.worktrees/<name>,
# sibling to the repo, flat branch names (no feature/ prefix).
set -euo pipefail

usage() {
  gum log -l error "usage: wt add <name> [base-branch] | wt rm <name> [--force] | wt list" >&2
  exit 1
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || { gum log -l error "not inside a git repo" >&2; exit 1; }
}

wt_path() {
  local root; root=$(repo_root)
  echo "$(dirname "$root")/$(basename "$root").worktrees/$1"
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
  # machine-parsed by the `worktree` Claude skill - keep as plain stdout, not gum.
  echo "WORKTREE_PATH: $target"
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

case "${1:-}" in
  add) shift; cmd_add "$@" ;;
  rm) shift; cmd_rm "$@" ;;
  list) git worktree list ;;
  *) usage ;;
esac
