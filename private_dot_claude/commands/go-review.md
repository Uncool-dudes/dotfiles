---
description: Run the 5-agent Go review workflow (security, safety, performance, concurrency, naming) against the diff since a base ref.
argument-hint: "[base-branch, default main]"
arguments: [base]
---

Call the Workflow tool with `name: "go-review"` and `args: {base: "$base"}` (use `"main"` if `$base` is empty). Report the returned findings grouped by severity, most severe first.
