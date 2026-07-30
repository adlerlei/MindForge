# MindForge

[![Version](https://img.shields.io/badge/version-0.1.0-blue)](https://github.com/adlerlei/MindForge)
[![GitHub](https://img.shields.io/badge/GitHub-adlerlei%2FMindForge-181717?logo=github)](https://github.com/adlerlei/MindForge)

**Turn a public thinker’s mind into a runnable Agent Skill.**  
**Version:** `0.1.0` · **Repo:** https://github.com/adlerlei/MindForge

You type a person’s name (or a topic). MindForge researches their public record, extracts how they actually reason, and writes a skill your AI tools can load—so you can ask questions *through that lens*.

---

## What you get

| Piece | Meaning |
|-------|---------|
| **Engine** | The MindForge skill itself (the forge) |
| **Forged skills** | One folder per person you create (the products) |

After install, in your Agent chat, say something like:

- `Forge <name>`
- `Distill <name>`
- `幫我鍛造 <名字> 的思維視角` ← interaction follows **your** language

The engine files are English. Conversation and forged output follow the language you use.

---

## Requirements

- macOS, Linux, or Windows
- An Agent CLI that loads skills (Claude Code, Grok Build, Codex, Gemini CLI, …)
- `bash` (macOS/Linux) or PowerShell (Windows)
- Optional: `python3` for the quality-check command
- Optional: `git` only if you install by cloning

---

## How to install

### Option A — from this folder (recommended while developing)

Open a terminal **inside the MindForge project folder**, then:

**macOS / Linux**

```bash
bash scripts/install.sh
```

**Windows (PowerShell)**

```powershell
.\scripts\install.ps1
```

Reinstall / refresh after you pull updates:

```bash
bash scripts/install.sh --force
```

```powershell
.\scripts\install.ps1 -Force
```

### Option B — put the CLI on your PATH

Install already creates a `mindforge` command here (if the folder exists):

```text
~/.local/bin/mindforge
```

If `mindforge` is “command not found”, add this to your shell config (`~/.zshrc` or `~/.bashrc`):

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then open a new terminal (or run `source ~/.zshrc`).

### Check that install worked

```bash
mindforge doctor
```

You want green checks for the engine and for the tools you use (Claude, Grok, …).

---

## Where things live on disk

| What | Path (macOS / Linux) | Path (Windows) |
|------|----------------------|----------------|
| **Engine (MindForge)** | `~/.agents/skills/MindForge/` | `%USERPROFILE%\.agents\skills\MindForge\` |
| **Forged people** | `~/.agents/skills/distilled/<name>/` | `%USERPROFILE%\.agents\skills\distilled\<name>\` |
| **CLI helper** | `~/.local/bin/mindforge` | (use the scripts under the install folder) |

`~` means your home directory (e.g. `/Users/you` on Mac).

Each tool gets a **shortcut link** into its own skills folder, for example:

- `~/.claude/skills/MindForge` → engine  
- `~/.grok/skills/MindForge` → engine  
- `~/.claude/skills/distilled` → forged people  

You do **not** need to copy files by hand for each app.

---

## How to use after install

### 1. Open any supported Agent (Claude Code, Grok Build, …)

MindForge should appear as an available skill once links are in place.

### 2. Start a forge

Examples (any language you prefer):

```text
Forge <name>
Distill <name>
鍛造 <名字>
幫我鍛造一個 <主題或人名> 的視角
I need a thinking advisor for hard product decisions
```

MindForge will:

1. Detect your language and talk to you in it  
2. Confirm who/what to forge (or suggest options if the request is vague)  
3. Research public sources  
4. Write a skill under `distilled/`  
5. Tell you how to activate it  

### 3. Use a forged person

Activation uses **four verbs only**, plus name aliases (local name / English full name / short name):

```text
呼叫 <本地名>
呼叫 <English Full Name>
呼叫 <short>
hello <English Full Name>
hello <short>
hi <本地名>
hi <English Full Name>
hi <short>
@ <本地名>
@ <English Full Name>
@ <short>
```

Examples of shape (placeholders): `呼叫 <本地名>` · `hello <Full Name>` · `hi <short>` · `@ <本地名>`

### 4. Update someone later

In the Agent chat:

```text
Update <name>
更新 <slug>
```

### 5. Delete someone

In the Agent chat (only these two forms):

```text
delete <name>
remove <name>
```

CLI equivalents:

```bash
mindforge delete <name>
mindforge remove <name>
```

---

## Folder layout of a forged person

```text
~/.agents/skills/distilled/<slug>/
├── SKILL.md          ← the skill your Agent loads
└── research/         ← source notes from the forge run
    ├── 01-writings.md
    ├── 02-conversations.md
    ├── 03-voice.md
    ├── 04-external.md
    ├── 05-decisions.md
    └── 06-timeline.md
```

---

## CLI commands

Run `mindforge help` for the full list. Common ones:

| Command | What it does |
|---------|----------------|
| `mindforge install` | Install / refresh the engine + links |
| `mindforge install --force` | Reinstall from this repo |
| `mindforge link` | Rebuild shortcuts for detected Agent apps |
| `mindforge doctor` | Health check (paths, links, files) |
| `mindforge list` | List forged people under `distilled/` |
| `mindforge remove <name>` | Delete one forged person (asks for confirm) |
| `mindforge delete <name>` | Same as `remove` |
| `mindforge quality <path>` | Run automated quality checks on a `SKILL.md` |
| `mindforge path` | Print engine and distilled paths |
| `mindforge version` | Print version + GitHub URL |
| `mindforge help` | Show help |

Examples:

```bash
mindforge version
mindforge list
mindforge quality ~/.agents/skills/distilled/<slug>/SKILL.md
mindforge delete <name>
mindforge link
```

**Slug rule:** lowercase English letters and hyphens only (e.g. `first-last`).

---

## Updating MindForge itself (the engine)

1. Pull or download the latest project files  
2. From the project folder:

```bash
bash scripts/install.sh --force
mindforge doctor
```

Forged people in `distilled/` are **not** deleted when you update the engine.

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `mindforge: command not found` | Add `~/.local/bin` to `PATH` (see above), or run `bash scripts/mindforge doctor` from the repo |
| Agent does not see MindForge | Run `mindforge link`, restart the Agent app |
| `doctor` fails | Run `bash scripts/install.sh --force` |
| Want a clean reinstall | `bash scripts/install.sh --force` — forged skills stay in `distilled/` |

---

## Project layout (this repo)

```text
MindForge/
├── SKILL.md                 # Engine instructions (English)
├── README.md                # This file (English)
├── README.zh-TW.md          # Traditional Chinese guide
├── LICENSE                  # MIT
├── package.json
├── references/
│   ├── harvest-guide.md     # How research is gathered
│   ├── synthesis-rules.md   # How models are proven and extracted
│   ├── skill-blueprint.md   # Template for forged SKILL.md files
│   └── quality-gate.md      # Pass / fail rules
└── scripts/
    ├── install.sh / install.ps1
    ├── link-agents.sh / link-agents.ps1
    ├── mindforge
    └── quality_check.py
```

---

## License

MIT — see [LICENSE](LICENSE).
