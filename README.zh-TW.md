# MindForge

[![Version](https://img.shields.io/badge/version-0.1.0-blue)](https://github.com/adlerlei/MindForge)
[![GitHub](https://img.shields.io/badge/GitHub-adlerlei%2FMindForge-181717?logo=github)](https://github.com/adlerlei/MindForge)

**把公開人物的思維方式，鍛造成可運行的 Agent Skill。**  
**版本：** `0.1.0` · **倉庫：** https://github.com/adlerlei/MindForge

你輸入一個人名（或主題）。MindForge 會調研公開資料、提煉對方真正怎麼思考，並寫成你的 AI 工具能載入的 Skill——之後就能用「那個人的鏡片」來問問題。

---

## 你會得到什麼

| 項目 | 意思 |
|------|------|
| **引擎（Engine）** | MindForge 本體（鍛造爐） |
| **鍛造結果（Forged skills）** | 每鍛造一個人，就多一個人物資料夾（成品） |

安裝完成後，在 Agent 對話裡可以這樣說：

- `Forge <name>`
- `Distill <name>`
- `幫我鍛造 <名字> 的思維視角`

引擎檔案本身是**英文**。對話與互動會**自動跟隨你使用的語言**。

---

## 環境需求

- macOS、Linux 或 Windows  
- 會載入 Agent Skills 的工具（Claude Code、Grok Build、Codex、Gemini CLI 等）  
- macOS/Linux 需要 `bash`；Windows 用 PowerShell  
- 可選：`python3`（品質檢查指令用）  
- 可選：`git`（若用 clone 安裝）

---

## 怎麼安裝

### 方式 A — 從本專案資料夾安裝（開發時建議）

用終端機進入 **MindForge 專案根目錄**，然後：

**macOS / Linux**

```bash
bash scripts/install.sh
```

**Windows（PowerShell）**

```powershell
.\scripts\install.ps1
```

之後若更新了專案原始碼，重新安裝：

```bash
bash scripts/install.sh --force
```

```powershell
.\scripts\install.ps1 -Force
```

### 方式 B — 讓 `mindforge` 指令可直接打

安裝腳本會把 CLI 連到：

```text
~/.local/bin/mindforge
```

若出現 `command not found`，把下面這行加進 `~/.zshrc` 或 `~/.bashrc`：

```bash
export PATH="$HOME/.local/bin:$PATH"
```

存檔後開新終端機（或執行 `source ~/.zshrc`）。

### 確認是否安裝成功

```bash
mindforge doctor
```

引擎與你常用的工具（Claude、Grok 等）應顯示通過。

---

## 安裝目錄在哪裡？

| 項目 | macOS / Linux | Windows |
|------|---------------|---------|
| **引擎 MindForge** | `~/.agents/skills/MindForge/` | `%USERPROFILE%\.agents\skills\MindForge\` |
| **鍛造出的人物** | `~/.agents/skills/distilled/<名稱>/` | `%USERPROFILE%\.agents\skills\distilled\<名稱>\` |
| **CLI** | `~/.local/bin/mindforge` | 可直接執行安裝目錄內的 scripts |

`~` 代表家目錄（Mac 上多半是 `/Users/你的名字`）。

安裝時會自動在各 Agent 工具下建立**捷徑（符號連結）**，例如：

- `~/.claude/skills/MindForge` → 指向引擎  
- `~/.grok/skills/MindForge` → 指向引擎  
- `~/.claude/skills/distilled` → 指向鍛造人物目錄  

不必為每個軟體手動複製一份。

---

## 安裝之後怎麼使用？

### 1. 打開支援的 Agent（Claude Code、Grok Build 等）

連結成功後，MindForge 應可被載入為 Skill。

### 2. 開始鍛造

隨便用你習慣的語言：

```text
Forge <name>
Distill <name>
鍛造 <名字>
幫我鍛造一個 <主題或人名> 的視角
我想找一個能提升決策品質的思維顧問
```

MindForge 會：

1. 辨識你的語言並用該語言與你互動  
2. 確認鍛造對象（需求模糊時會先推薦）  
3. 調研公開來源  
4. 寫入 `distilled/` 下的 Skill  
5. 告訴你如何啟用  

### 3. 使用已鍛造的人物

啟用**只有四種動詞**，再接名字別名（本地常用名／英文全名／短名）：

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

句式形狀：`呼叫 <本地名>` · `hello <Full Name>` · `hi <short>` · `@ <本地名>`

### 4. 之後要更新某人

在 Agent 對話中：

```text
Update <name>
更新 <slug>
```

### 5. 刪除某人

在 Agent 對話中（**只用**這兩種）：

```text
delete <name>
remove <name>
```

CLI 等價：

```bash
mindforge delete <name>
mindforge remove <name>
```

---

## 鍛造的人物會在哪裡？

```text
~/.agents/skills/distilled/<slug>/
├── SKILL.md          ← Agent 會載入的主檔
└── research/         ← 鍛造過程的調研筆記
    ├── 01-writings.md
    ├── 02-conversations.md
    ├── 03-voice.md
    ├── 04-external.md
    ├── 05-decisions.md
    └── 06-timeline.md
```

資料夾名稱（slug）規則：全小寫英文字母與連字號（例如 `first-last`）。

---

## 有哪些指令可以用？

完整列表：`mindforge help`

| 指令 | 作用 |
|------|------|
| `mindforge install` | 安裝／更新引擎並建立連結 |
| `mindforge install --force` | 強制從本專案重裝引擎 |
| `mindforge link` | 重新偵測 Agent 工具並建立捷徑 |
| `mindforge doctor` | 健康檢查（路徑、連結、必要檔案） |
| `mindforge list` | 列出 `distilled/` 裡已鍛造的人物 |
| `mindforge remove <名稱>` | 刪除某位鍛造人物（會要求確認） |
| `mindforge delete <名稱>` | 同 `remove` |
| `mindforge quality <路徑>` | 對某份 `SKILL.md` 做自動品質檢查 |
| `mindforge path` | 印出引擎與 distilled 路徑 |
| `mindforge version` | 印出版本號與 GitHub 網址 |
| `mindforge help` | 顯示說明 |

範例：

```bash
mindforge version
mindforge list
mindforge quality ~/.agents/skills/distilled/<slug>/SKILL.md
mindforge delete <name>
mindforge link
```

---

## 怎麼用指令更新？

### 更新「引擎」MindForge 本身

1. 取得最新專案檔案  
2. 在專案根目錄執行：

```bash
bash scripts/install.sh --force
mindforge doctor
```

**不會**刪除 `distilled/` 裡已鍛造的人物。

### 更新「某位已鍛造人物」

在 Agent 裡說「更新某某」即可（只補新公開資料，不整份亂重寫）。  
品質檢查：

```bash
mindforge quality ~/.agents/skills/distilled/<slug>/SKILL.md
```

---

## 疑難排解

| 狀況 | 建議 |
|------|------|
| `mindforge: command not found` | 把 `~/.local/bin` 加進 `PATH`，或在專案內執行 `bash scripts/mindforge doctor` |
| Agent 找不到 MindForge | 執行 `mindforge link`，然後重開 Agent |
| `doctor` 失敗 | `bash scripts/install.sh --force` |
| 想重裝引擎 | 同上；`distilled/` 人物會保留 |

---

## 專案結構（本倉庫）

```text
MindForge/
├── SKILL.md                 # 引擎說明（英文）
├── README.md                # 英文說明
├── README.zh-TW.md          # 本繁中說明
├── LICENSE                  # MIT
├── package.json
├── references/
│   ├── harvest-guide.md
│   ├── synthesis-rules.md
│   ├── skill-blueprint.md
│   └── quality-gate.md
└── scripts/
    ├── install.sh / install.ps1
    ├── link-agents.sh / link-agents.ps1
    ├── mindforge
    └── quality_check.py
```

---

## 授權

MIT — 見 [LICENSE](LICENSE)。
