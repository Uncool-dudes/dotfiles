#!/usr/bin/env bash
# Bumps rev+hash for every pkgs.fetchFromGitHub pin in this repo to latest HEAD.
#
# Skip convention: if the rev line has a trailing `#` comment (e.g. pinning to
# a specific release on purpose), the pin is left alone. No comment = assumed
# HEAD-tracking and gets bumped.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

python3 - <<'PYEOF'
import re
import subprocess
import sys
from pathlib import Path

BLOCK_RE = re.compile(
    r'(?P<attr>[\w-]+)\s*=\s*pkgs\.fetchFromGitHub\s*\{\s*'
    r'owner\s*=\s*"(?P<owner>[^"]+)";\s*'
    r'repo\s*=\s*"(?P<repo>[^"]+)";\s*'
    r'rev\s*=\s*"(?P<rev>[^"]+)";(?P<revcomment>[^\n]*)\n\s*'
    r'hash\s*=\s*"(?P<hash>[^"]+)";\s*\}',
)

SKIP_DIRS = {".git", "result"}


def find_nix_files(root: Path):
    for path in root.rglob("*.nix"):
        if any(part in SKIP_DIRS for part in path.parts):
            continue
        yield path


def latest_rev(owner: str, repo: str) -> str:
    out = subprocess.run(
        ["git", "ls-remote", f"https://github.com/{owner}/{repo}", "HEAD"],
        capture_output=True, text=True, check=True,
    ).stdout
    return out.split()[0]


def prefetch_hash(owner: str, repo: str, rev: str) -> str:
    result = subprocess.run(
        ["nix", "flake", "prefetch", f"github:{owner}/{repo}/{rev}"],
        capture_output=True, text=True, check=True,
    )
    out = result.stdout + result.stderr
    m = re.search(r"sha256-[A-Za-z0-9+/=]+", out)
    if not m:
        raise RuntimeError(f"no hash in prefetch output for {owner}/{repo}/{rev}")
    return m.group(0)


def main():
    root = Path(__file__).resolve().parent
    bumped, skipped, unchanged = [], [], []

    for path in find_nix_files(root):
        content = path.read_text()
        new_content = content
        for m in BLOCK_RE.finditer(content):
            attr, owner, repo, rev, revcomment, old_hash = (
                m["attr"], m["owner"], m["repo"], m["rev"], m["revcomment"], m["hash"],
            )
            label = f"{path.relative_to(root)}:{attr} ({owner}/{repo})"

            if revcomment.strip().startswith("#"):
                skipped.append(f"{label} -- pinned on purpose: {revcomment.strip()}")
                continue

            new_rev = latest_rev(owner, repo)
            if new_rev == rev:
                unchanged.append(label)
                continue

            new_hash = prefetch_hash(owner, repo, new_rev)
            new_content = new_content.replace(
                f'rev = "{rev}";{revcomment}\n', f'rev = "{new_rev}";{revcomment}\n', 1,
            ).replace(f'hash = "{old_hash}";', f'hash = "{new_hash}";', 1)
            bumped.append(f"{label}: {rev[:12]} -> {new_rev[:12]}")

        if new_content != content:
            path.write_text(new_content)

    for line in bumped:
        print(f"BUMPED  {line}")
    for line in unchanged:
        print(f"CURRENT {line}")
    for line in skipped:
        print(f"SKIPPED {line}")


if __name__ == "__main__":
    sys.exit(main())
PYEOF
