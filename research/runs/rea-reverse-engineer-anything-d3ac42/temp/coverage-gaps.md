# Coverage gaps — wave 1 + orchestrator primary fetch

Environment constraint: the session's network policy blocks most hosts (403 at proxy / DNS failure). Only raw.githubusercontent.com and registry.npmjs.org are reachable, and the crawl4ai browser binary is missing, so the builtin provider was used. All 20 secondary URLs (reviews, directories, alternatives) failed. The corpus is 18 primary sources from the morluto/rea repo and the npm registry.

| Atomic item | Sources | Status |
|---|---|---|
| Sub-Q1 What REA is | readmemd, packagejson, latest (npm), roadmapmd | well-covered |
| Sub-Q2 Features/capabilities | readmemd, climd, mcp-contractsmd, mcp-promptsmd, reverse-engineering-toolsmd | well-covered |
| Sub-Q3 Supported targets | readmemd, native-investigationmd, javascript-application-workflowsmd, browser-observationmd, android-analysismd, managed-code-analysismd, firmware-analysismd, desktop-applicationsmd | well-covered |
| Sub-Q4 Install/use | installationmd, climd, readmemd, latest | well-covered |
| Sub-Q5 Limitations/responsible use | securitymd, disclaimermd, readmemd | adequate (primary only) |

GAP (flag for drafter): no independent third-party evaluations made it into the vault. Popularity numbers (star counts) are unverifiable; do not report them as fact. Limitations rely on the project's own docs.
Escalation queue: n/a (browser lane unavailable in this cloud session).
