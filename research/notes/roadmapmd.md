---
title: roadmap.md
id: roadmapmd
tags:
- rea-reverse-engineer-anything-d3ac42
created: '2026-10-21T19:21:31.951908Z'
source: https://raw.githubusercontent.com/morluto/rea/main/docs/roadmap.md
source_domain: raw.githubusercontent.com
fetched_at: '2026-10-21T19:21:31.951373Z'
fetch_provider: builtin
status: draft
type: note
tier: ground_truth
content_type: docs
deprecated: false
---

# REA roadmap

The [platform tracker](https://github.com/morluto/rea/issues/32),
[process/Hopper tracker](https://github.com/morluto/rea/issues/48), and
[browser tracker](https://github.com/morluto/rea/issues/39) track capability and
verification work. Available tools and setup are documented in the
[investigation guides](https://rea.tools/guides/),
[installation guide](installation.md), and
[generated catalog](mcp-contracts.md#generated-catalog).

## Priorities

- Expand native architecture, type, and indirect-call verification.
- Connect static findings and runtime observations across application layers.
- Improve obfuscated managed-code comparisons and verified native links.
- Extend process, protocol, filesystem, reconnect, and build-comparison coverage.
- Evaluate additional providers and targets when an analyst workflow demonstrates
  a capability gap.

## Admission criteria

New capabilities must return useful evidence through shared CLI/MCP workflows,
preserve observations and unknowns, and declare actual authority and lifecycle
constraints. Agents compose experiments using ordinary commands, scripts, and
fixture servers; custom orchestration needs a demonstrated requirement.

Provider and platform claims require their corresponding
[real verification lanes](testing.md#real-toolchain-verification-lanes).
See [tool design](tool-design.md) for choosing a tool boundary and
[Ghidra semantics](ghidra-provider.md) for the existing deep-provider contract.

Setup remains additive, reuses existing tools, and requires approval for disclosed
configuration and Hopper installation changes. Additional installer choices need
an implemented toolchain and explicit scope; setup does not install or upgrade
unrelated runtimes or dependencies.