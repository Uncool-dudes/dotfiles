# Little Snitch

Rules live here; Little Snitch pulls them by URL. Nothing in Nix wires this
up: subscriptions and profiles exist only inside Little Snitch, so a fresh
machine needs the one-time setup below. The license is restored by
`restore-licenses` (see `../licenses.nix`).

## Subscriptions (Rules -> Rule Groups -> "+" -> Subscribe)

Rule group, pre-allows known-good traffic to cut down prompts. Edit
`allow.lsrules`, push to `main`, and Little Snitch picks it up on its next
refresh:

    https://raw.githubusercontent.com/Uncool-dudes/dotfiles/main/home-manager/modules/darwin-desktop/little-snitch/allow.lsrules

Blocklists (Rules -> Blocklists -> "+"), all from
[HaGeZi](https://github.com/hagezi/dns-blocklists):

| List | Blocks | URL |
|---|---|---|
| Multi PRO | ads, trackers, metrics, telemetry, malware | `https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro-onlydomains.txt` |
| Native Windows/Office | Microsoft Office telemetry | `https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/native.winoffice-onlydomains.txt` |
| Threat Intelligence mini | active phishing and malware hosts | `https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.mini-onlydomains.txt` |

Blocklists apply to every app, Chrome included. If a site or app breaks,
check the connection in Network Monitor and add an exception rather than
dropping the whole list.

## Profiles

- **Default**: alert mode, with the rule group and blocklists above.
- **Untrusted**: for networks that aren't home. Same rule group and
  blocklists, but anything without a rule is denied instead of prompting.
  Set it to activate automatically when joining any network other than
  home Wi-Fi.

## Known gaps

- `tailscaled` is a Nix binary. Its control-plane traffic is pre-allowed by
  domain, but direct peer connections go to arbitrary IPs and its path
  changes on every Nix update, so expect a prompt after updates.
- Rules for Chromium/Electron apps match the app's code ID. If Little
  Snitch attributes a connection to a helper process instead, allow it
  once from the prompt.
