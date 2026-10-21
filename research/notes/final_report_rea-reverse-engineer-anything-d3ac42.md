# REA (Reverse Engineer Anything): A Quick Overview

REA is an open-source, MIT-licensed toolkit that gives AI coding agents reverse-engineering tools [1]. It runs as a local MCP (Model Context Protocol) server that your agent calls, and the same workflows are available from a terminal CLI named `rea` [1]. Its pitch is simple: "See a feature you like. Understand how it works, down to the binary level." [1] You point it at an app, binary, website or file. Your agent asks it questions, and REA returns findings together with the evidence and the limits behind each conclusion [1].

At the time of writing, the current npm release is `rea-agents` 6.7.0 [8]. It needs Node.js 22.19+, 24.11+ or 26+ [1, 8].

## 1. What REA Is

**The short version:** REA coordinates analysis. It is not a decompiler of its own. It connects an agent such as Claude Code, Codex or Cursor to a large set of analysis engines and file parsers. It then packages their output as structured Evidence records that the agent can reason over [1, 3].

Key facts:

| Item | Detail |
|---|---|
| Repository | `github.com/morluto/rea` [1] |
| Package | `rea-agents` on npm; the CLI binary is `rea` (also `rea-agents`) [1, 8] |
| MCP registry name | `io.github.morluto/rea` [8] |
| License | MIT for REA's own code; third-party tools keep their own licenses [1] |
| Interfaces | Local MCP server over stdio (default) or streamable HTTP, plus a CLI with the same workflows [1, 3] |
| Where analysis runs | Locally on your machine. Your agent's model provider still sees the tool results under its own data policy [1] |
| Official channels | The morluto/rea repo, rea.tools, and the `rea-agents` npm package. The README warns that "a similar repository name or copied README does not establish that a download is official." [1] |

**How a session works.** Your agent calls REA through MCP to inspect the target and trace the relevant code. REA returns findings with their evidence. The agent uses them to ask follow-up questions, explain the behaviour, or write and test its own implementation [1]. The intended loop is to see a feature in an app, understand it, and build your own version. The README's example asks the agent to work out how search works in the Notes app, show the evidence, and build a similar feature for your project [1].

**A note on popularity figures.** The README carries a banner celebrating "300,000 GitHub stars" [1]. That number was not checked against GitHub, so treat it as unverified.

## 2. Main Features and Capabilities

**One tool surface, two front ends.** Every workflow is exposed both as an MCP tool (for agents) and as a CLI command (for people and scripts), with the same names. For example, `analyze_javascript_application` in MCP is `rea analyze-javascript-application` in the CLI [3, 11].

**Evidence records.** Results are packaged as Evidence records that keep the artifact's identity, source locations, observations, inferences and unresolved findings separate [3]. You can import, export and compare Evidence bundles (`rea evidence-import`, `rea evidence-export`, `rea compare`) [3]. Large results can be saved to a file and then viewed in slices. The docs give an example where a 334 MB Evidence file for the Obsidian app reduces to a summary of about 10 KB [3].

**Snapshots.** A snapshot keeps successful analysis results. A repeated query with the same target bytes, operation, parameters and provider then reuses the saved answer instead of re-running the engine [3].

**Pluggable analysis engines (providers).** For deep native-binary work, REA drives an engine you already have [1]:
- **Hopper, Ghidra or IDA** for full analysis. Setup can install Hopper with your approval; Ghidra and IDA must already be installed [1].
- **GNU objdump, GDB and Rizin** if you supply them. GDB's persistent debugger sessions are Linux-only [15].
- **Kuna decompiler, JEB** (through a JEB client you start, selected with `REA_JEB_MCP_URL`), experimental **Windows Ghidra**, and **Ghidra 16-bit DOS** analysis [1].

`rea providers --json` and `rea capabilities --json` list what is available. If several providers fit a target, you pick one with `--provider` or the `REA_ANALYSIS_PROVIDER` variable [3]. Once a provider is configured, the native-binary workflow is to list functions, search symbols, then pull a function dossier, assembly (`rea instructions`) or pseudocode (`rea decompile`) [10].

**Guided investigation prompts.** The MCP server ships six workflow prompts. They suggest starting points and don't run tools by themselves [5]:

| Prompt | Purpose |
|---|---|
| `investigate_feature` | Trace a feature from discovery to the relevant functions |
| `compare_application_versions` | Compare two shipped builds |
| `verify_reconstruction` | Check a re-implementation against recorded comparison Evidence |
| `trace_crash` | Connect a crash symptom to code paths and optional process capture |
| `audit_residual_unknowns` | Review what remains unexplained |
| `prepare_bounded_process_capture` | Plan a controlled runtime experiment before running it |

The prompts ask agents to keep observations, inferences and unknowns distinct [5].

**Prompt-injection labelling.** Strings, decompiled code, page text and logs come from the target, and a target can hide text that reads like instructions to the agent. REA marks such results as untrusted (`"untrusted_content": true` in the result metadata). Its server instructions tell the agent never to follow directives found in tool output and to report them as injection attempts [4].

**Compact schemas.** To save agent context, MCP tools advertise compact input schemas by default. Set `REA_MCP_INPUT_SCHEMA_PROFILE=full` when you need every field described [1].

## 3. Supported Targets and Formats

REA's README lists roughly 30 target types [1]. Grouped:

| Group | Targets | What you get | Extra requirements |
|---|---|---|---|
| **Native code** | Executables and libraries (Mach-O, ELF, PE); offline ELF layout | Pseudocode, assembly, strings, symbols, calls and references | Hopper, Ghidra or IDA; pwntools for ELF layout [1, 10] |
| **Language-specific binaries** | Go, Rust, PyInstaller executables | Build info, modules and crate dependencies; Python archive members and bytecode | None (built-in static parsing) [1] |
| **JavaScript / Electron** | Extracted app directories, ASAR archives | Modules, imports, source maps, routes, IPC, native add-ons; feature traces and version comparisons | Node.js; on Linux, a procps-compatible `ps` [1, 11] |
| **Websites** | Live pages in your own Chrome-family browser | DOM, scripts, resources, network and console metadata, bundle analysis | A Chrome-family browser REA can attach to [1, 9] |
| **Network data** | HAR, Fiddler SAZ, packet captures | Requests, responses, endpoints, DNS, TLS SNI, protocol stats | TShark or tshark/capinfos for packet captures [1] |
| **.NET** | Managed assemblies | Metadata, CIL instructions, native-call boundaries, build comparisons | None: static only, never executes the code [1, 13] |
| **Android** | APKs, connected devices, resources, Flutter apps | Manifest, classes, decompiled methods; device processes and logs; resources; Flutter engine provenance | JADX and a full JDK; adb; Apktool [1, 12] |
| **Firmware and embedded** | Firmware images, logic-signal recordings | Regions and extraction, then handoff of found ELFs to native analysis; decoded signal annotations | Binwalk 3.1 / Unblob 26.6 on Linux; sigrok-cli [1, 14] |
| **Other formats** | SQLite databases, WASM, EVM bytecode, Unity IL2CPP metadata, Godot PCK, GPU code (CUDA/HIP/PTX), GGUF/safetensors model files | Schema and rows, decoded modules, contract selectors, type names, archive contents, kernel metadata, tensor declarations | Mostly built-in; WABT for WASM [1] |
| **Runtime behaviour** | Processes, recorded Linux crashes, desktop installation folders | Terminal output, interactions and file effects; crash registers; runtime candidates for an unknown app folder | Linux/macOS PTY; pwntools; none for desktop folders [1, 16] |

Two practical points:
- **No engine needed for many targets.** Static JavaScript and .NET inspection need no native analysis engine, and several formats (Go, Rust, PyInstaller, Godot, IL2CPP, model files) are decoded by REA itself [1].
- **Static vs runtime.** Static workflows read files without running them. Runtime workflows run or interact with the target using your user permissions [1]. The website tools attach passively to a browser you own; REA describes this as "not a general browser automation or remote-control surface." [9]

## 4. How to Install and Use It

**1. Requirements.** Node.js 22.19+, 24.11+ or 26+ and npm [1]. For native binaries you also need Hopper, Ghidra or IDA [1]. On Linux, several workflows need a procps-compatible `ps` on the PATH [1].

**2. Register REA with your agent.**

```bash
npx rea-agents setup
```

Setup asks which agents to configure and shows the planned changes. It then backs up existing configuration and adds REA's MCP server and matching workflow instructions. Restart your agent afterwards [1, 2]. It supports about two dozen clients, including Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI, Windsurf, VS Code, GitHub Copilot CLI, OpenCode, Qwen Code and Devin [2].

**Claude Code specifics.** Setup registers REA for the whole client. It writes `mcpServers.rea` to `~/.claude.json` and installs the skill under `~/.claude/skills`, so every project can call it [2]. To limit REA to one project instead, register it at local scope [2]:

```bash
claude mcp add --scope local rea -- npx -y rea-agents@6.7.0 mcp
```

This route does not install the bundled skill. The docs advise against `--scope project` because it writes `.mcp.json` into the repository, where it can be committed [2].

**The skills.sh skill alone isn't enough.** The skill on skills.sh only supplies investigation instructions for your agent. You still need `npx rea-agents setup` to register the MCP server [1].

**3. Ask your agent.** Describe the target and the feature, as in the Notes-app search example in section 1 [1].

**4. Or use the CLI directly.**

```bash
# One-off, no install: analyze an Electron app directory or ASAR
npx -y rea-agents@latest analyze-javascript-application /absolute/path/to/app --json

# Install for regular use
npm install --global rea-agents
rea --help

# Native binary with Ghidra
rea inspect /absolute/path/to/program --provider ghidra --json
rea decompile ...   # pseudocode for a chosen function
```

[1, 3, 10]

**5. Check readiness, update and remove.**

| Task | Command |
|---|---|
| Full diagnosis (read-only) | `rea doctor --json` [2] |
| Check one engine | `rea doctor --provider ghidra --json` (or `hopper`, `ida`) [2] |
| Check one agent | `rea doctor --client codex --json` [2] |
| Update a global install | `rea update` [1, 2] |
| Refresh agent registrations | `npx rea-agents@latest setup` [1] |
| Remove | `rea uninstall` (add `--purge-data` to delete caches) [2] |

The project releases often and says that "new releases include frequent bug fixes," so updating is the first thing to try when you hit a bug [1].

**Serving over HTTP.** `rea mcp --http --port 8765` serves the same tools over streamable HTTP for one local client at a time [3].

## 5. Limitations and Responsible Use

**Output is evidence, not original source.** Native analysis returns pseudocode and assembly, and JavaScript analysis recovers modules and their relationships [1]. The project's disclaimer says decompilation, reconstruction and AI-assisted analysis "may be incomplete or incorrect" [7]. It advises verifying consequential conclusions before relying on them [7].

**Heavy lifting depends on other tools.** Deep native work needs Hopper, Ghidra or IDA [1]. Several targets need specific external tools: JADX with a JDK, Binwalk/Unblob, TShark, pwntools or WABT [1]. Some workflows are verified only on Linux x64, such as the first firmware milestone [14].

**Not a sandbox.** REA's security policy states that its bridges are "not a sandbox." Opening an untrusted binary hands parsing to the chosen engine with your user's permissions [6]. The disclaimer recommends an appropriate environment for untrusted targets [7]. In practice, analyze malware or unknown software in an isolated VM or container.

**Privacy.** Analysis runs locally, but the results pass through your agent's model provider, which has its own data policy [1].

**Scoping access.** Setup makes REA available to every project in a client by default [2]. The installation guide notes that limiting the MCP registration still leaves shell, filesystem and network access open. Real clean-room separation needs a separate account or container [2].

**Legal and licensing.** REA is meant for lawful work: security and malware research, vulnerability disclosure, CTFs and education, interoperability, preservation, and software you own or are authorized to examine [7]. The project explicitly refuses to help with [7]:
- circumventing DRM, license checks or anti-cheat;
- game cheats;
- bypassing authentication or access controls;
- copying proprietary code or assets.

Reverse engineering may also be restricted by your jurisdiction or by the target's license [7]. Commercial engines (IDA/Hex-Rays, Hopper, JEB) must be legally licensed, and REA grants no license or key for them [1, 7].

**Fast-moving project.** Features differ between the npm release and the main branch; the docs advise checking release availability before relying on a newly added feature [1]. The roadmap prioritizes broader native-architecture verification and linking static and runtime findings [17].

## Sources

[1] REA README (morluto/rea). https://raw.githubusercontent.com/morluto/rea/main/README.md
[2] REA docs: Installation and setup. https://raw.githubusercontent.com/morluto/rea/main/docs/installation.md
[3] REA docs: CLI and Evidence. https://raw.githubusercontent.com/morluto/rea/main/docs/cli.md
[4] REA docs: MCP runtime contracts. https://raw.githubusercontent.com/morluto/rea/main/docs/mcp-contracts.md
[5] REA docs: Guided MCP prompts and completion. https://raw.githubusercontent.com/morluto/rea/main/docs/mcp-prompts.md
[6] REA Security Policy (SECURITY.md). https://raw.githubusercontent.com/morluto/rea/main/SECURITY.md
[7] REA Disclaimer (DISCLAIMER.md). https://raw.githubusercontent.com/morluto/rea/main/DISCLAIMER.md
[8] npm registry: rea-agents, latest version metadata. https://registry.npmjs.org/rea-agents/latest
[9] REA docs: Website observation with CDP. https://raw.githubusercontent.com/morluto/rea/main/docs/browser-observation.md
[10] REA docs: Native binary investigation. https://raw.githubusercontent.com/morluto/rea/main/docs/native-investigation.md
[11] REA docs: Cross-layer JavaScript application workflows. https://raw.githubusercontent.com/morluto/rea/main/docs/javascript-application-workflows.md
[12] REA docs: Static Android APK analysis. https://raw.githubusercontent.com/morluto/rea/main/docs/android-analysis.md
[13] REA docs: Managed-code analysis. https://raw.githubusercontent.com/morluto/rea/main/docs/managed-code-analysis.md
[14] REA docs: Firmware analysis. https://raw.githubusercontent.com/morluto/rea/main/docs/firmware-analysis.md
[15] REA docs: Reverse-engineering tool integrations. https://raw.githubusercontent.com/morluto/rea/main/docs/reverse-engineering-tools.md
[16] REA docs: Desktop installation directories. https://raw.githubusercontent.com/morluto/rea/main/docs/desktop-applications.md
[17] REA docs: Roadmap. https://raw.githubusercontent.com/morluto/rea/main/docs/roadmap.md
