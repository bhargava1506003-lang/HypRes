## Coverage Matrix — query phrase → atomic item mapping

| Query phrase (verbatim) | Mapped atomic item(s) | Scope check | Gap? |
|---|---|---|---|
| "REA (Reverse Engineer Anything" | Sub-Q1, Entity REA, section 1 | OK | No |
| "open-source reverse-engineering CLI/MCP server" | Sub-Q1 (license), Sub-Q2 (CLI + MCP) | OK: both CLI and MCP covered | No |
| "for AI coding agents" | Sub-Q4, Entity AI coding agents | OK | No |
| "github.com/morluto/rea" | Entity, domain_notes primary source | OK | No |
| "quick overview" | required_formats, light tier, structured format | OK | No |
| "what it is" | Sub-Q1, section 1 | OK | No |
| "main features" | Sub-Q2, section 2 | OK | No |
| "supported targets" | Sub-Q3, section 3 | OK: full target list, not just binaries | No |
| "how to use it" | Sub-Q4, section 4 | OK: install + configure + agent integration | No |
| (implicit) limitations / safe use | Sub-Q5, section 5 | Added for completeness | No |
