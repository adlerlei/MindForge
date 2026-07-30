---
name: mindforge
description: |
  Forge a runnable cognitive skill from any public thinker or topic.
  Deep research → proven mental models → decision heuristics → voice DNA → honest limits.
  Triggers: forge, MindForge, distill, build a perspective on X, how does X think,
  update X skill, thinking advisor, mental model skill.
  Also fuzzy needs: "I want better decisions", "I need a thinking partner for product calls".
---

# MindForge

MindForge builds **runnable cognitive operating systems** from public records—not costume roleplay, not quote scrapbooks.

Engine docs and templates are **English**.  
**User language:** detect the user’s language from their messages and run the whole conversation (questions, progress, delivery) in that language. Write the forged skill’s *body prose* in the user’s language so they can use it naturally; keep YAML `name` as an English kebab-case slug; structural headings may follow the English blueprint for machine checks, with user-language content underneath.

---

## Core idea

A forged skill answers five questions:

| Question | Artifact |
|----------|----------|
| What lenses does this mind use? | **Mental models** (3–7) |
| What fast rules does it apply? | **Decision heuristics** (5–10) |
| How does it sound? | **Voice DNA** |
| What does it refuse? | **Anti-patterns** |
| Where does this skill break? | **Honest limits** |

Capture **how they think**, not a collage of what they once said.

---

## Paths and naming

| Role | Location |
|------|----------|
| Engine | `~/.agents/skills/MindForge/` |
| Forged skills | `~/.agents/skills/distilled/<slug>/` |
| Research notes | `distilled/<slug>/research/` |

**Slug:** lowercase English letters and hyphens only (pattern: `first-last`).  
Display names in the user’s language live inside `SKILL.md`.

CLI (optional):

```bash
mindforge install | link | list | remove <slug> | doctor | quality <path>
```

---

## Language policy (mandatory)

1. **Detect** language from the user’s latest messages (and stick to it unless they switch).  
2. **Interact** only in that language: confirmations, research summaries, errors, delivery.  
3. **Forge body text** in that language (models, examples, voice rules, limits).  
4. **Engine files** you read (`references/*`, this file) stay English—do not translate them on disk.  
5. If mixed languages appear, prefer the language of the forging request.

---

## Pipeline overview

| Stage | Name | Purpose |
|-------|------|---------|
| 1 | **Listen** | Intent + language + route |
| 2 | **Scope** | Who/what, depth, local sources |
| 3 | **Scaffold** | Create `distilled/<slug>/` |
| 4 | **Harvest** | Multi-lens research, write files |
| 5 | **Audit** | Source quality checkpoint with user |
| 6 | **Crystalize** | Prove models, heuristics, voice, limits |
| 7 | **Lock** | Crystalize summary checkpoint |
| 8 | **Assemble** | Write `SKILL.md` from blueprint |
| 9 | **Prove** | Quality gate + spot tests |
| 10 | **Ship** | Paths, triggers, how to update |

Failure rule: a partial, honest skill beats a polished fiction.

---

## Stage 1 · Listen

Classify the request:

| Input | Route |
|-------|--------|
| Clear person or topic | → Scope (direct) |
| Vague goal (“better decisions”) | → Scope (advisor match) |
| “Update X” | → Incremental update (see below) |

Set `user_language` and keep it for the rest of the run.

---

## Stage 2 · Scope

### Direct target

Confirm only what matters; default aggressively so delivery is not blocked:

1. **Identity** — disambiguate names / transliterations  
2. **Focus** — full portrait (default) vs one slice  
3. **Use** — thinking advisor (default)  
4. **New vs update** — scan `~/.agents/skills/distilled/` and linked skill trees  
5. **Local corpus** — books, transcripts, exports the user can drop in  
6. **Depth band:**

| Band | Research load | When |
|------|---------------|------|
| Quick | 3 lenses, ≤5 sources each | Trial / obscure / budget |
| **Standard (default)** | 6 lenses, full pass | Most cases |
| Deep | 6 lenses + archive primary sources | Publish-grade |

If the user only says “Forge X”, assume full portrait + advisor + no local files + Standard, and proceed.

### Advisor match (vague need)

At most **two** clarifying turns. Map need → 2–3 candidates (people or themes). For each:

- Core lens (one line)  
- Why it fits **this** user need  
- Blind spots  

Prefer already-forged skills when they fit. On choice → continue Scope → Scaffold.

---

## Stage 3 · Scaffold

Create before any research:

```text
~/.agents/skills/distilled/<slug>/
├── SKILL.md                 # written in Assemble
└── research/
    ├── 01-writings.md
    ├── 02-conversations.md
    ├── 03-voice.md
    ├── 04-external.md
    ├── 05-decisions.md
    └── 06-timeline.md
```

Optional: `sources/{books,transcripts,articles}/` for user files.

Rules:

- Every harvest worker **must** write its file. Unwritten work does not count.  
- The folder is self-contained (copy = portable).  
- Chinese-language subjects → prioritize reputable Chinese primary/media channels (see Harvest guide).  
- Update mode → read existing `SKILL.md`, note refresh targets and timestamps.

---

## Stage 4 · Harvest

Read `references/harvest-guide.md`.

### Modes

| Mode | When | Behavior |
|------|------|----------|
| Network | No user files | All lenses online |
| Local-first | User provided corpus | Local first; fill gaps online |
| Local-only | User requires it / non-public figure | No web search |

### Six lenses

| # | Lens | Extract | File |
|---|------|---------|------|
| 1 | Writings | Recurring claims (≥3×), coined terms, reading lists | 01-writings.md |
| 2 | Conversations | Under pressure, improvisation, reversals, refusals | 02-conversations.md |
| 3 | Voice | Cadence, humor, fights, stock phrases | 03-voice.md |
| 4 | External | Critics, biographers, peer contrast | 04-external.md |
| 5 | Decisions | High-stakes choices, post-mortems, say/do gaps | 05-decisions.md |
| 6 | Timeline | Milestones, intellectual turns, **last 12 months** | 06-timeline.md |

### Per-lens requirements

- Source + credibility + date when known  
- Label: primary / secondary / inference  
- Keep contradictions; never smooth them away  
- Never use banned sources (harvest guide)

Prefer parallel workers when the runtime allows; otherwise run lenses **serially** and flush to disk after each.

### Runtime stress map

| Trigger | First fix | Fallback |
|---------|-----------|----------|
| No parallel agents | Serial harvest | Single agent, six passes |
| Context blow-up | End stage → files are checkpoint | Split sessions; reload files |
| Cost spike | Honor depth band from Scope | Stop; keep notes as intermediate |
| Empty search | Mark thin lens | Expand honest limits |
| Tools down | Alternate fetch tools | Local-only if possible |
| <10 usable sources | Warn in Scaffold/Audit | 2–3 models max, wider limits |

---

## Stage 5 · Audit 🔴

After harvest, show a compact table **in the user language**:

- Sources per lens · standout findings · primary share  
- Contradictions · thin lenses · whether last-12-months covered  

User OK → Crystalize. Thin lens → re-harvest that lens only.

---

## Stage 6 · Crystalize

Read `references/synthesis-rules.md`.

1. **Mental models (3–7)** — candidates from harvest → **Proof triad** (recurrence · predictive power · distinctive signature). 3 passes = model; 1–2 = heuristic; 0 = drop. Each model needs evidence, **failure mode**, **last public signal** (date), confidence.  
2. **Heuristics (5–10)** — if/then + real case + last seen.  
3. **Voice DNA** — syntax, lexicon, rhythm, humor, certainty, taboos; ~100-word blind ID test.  
4. **Values, refusals, tensions** — ≥2 real tensions (do not erase).  
5. **Lineage** — influences in / out.  
6. **Honest limits** — ≥3 concrete limits + research date + thin areas.

---

## Stage 7 · Lock 🔴

Show crystalize summary in the user language (model names, heuristic count, voice fingerprints, tension count, limits).  
OK → Assemble; else return to Crystalize.

---

## Stage 8 · Assemble

1. Load `references/skill-blueprint.md`  
2. Fill every section—no empty shells  
3. **Agentic protocol:** research angles must be **derived from this mind’s models**, not generic “search the web”  
4. Keep YAML `description` roughly ≤300 words, clear triggers, low false-fire  
5. Write:

```text
~/.agents/skills/distilled/<slug>/SKILL.md
```

6. Footer credits **MindForge** only  

Then run:

```bash
python3 ~/.agents/skills/MindForge/scripts/quality_check.py \
  ~/.agents/skills/distilled/<slug>/SKILL.md
```

---

## Stage 9 · Prove

Read `references/quality-gate.md`.

**Automated critical checks must pass.**

Spot tests (prefer a separate worker for answers vs grading):

| Test | Method | Pass |
|------|--------|------|
| Stance | 3 questions with known public positions | Direction matches |
| Edge | 1 never-public but related question | Marked as framework inference |
| Voice | ~100 words | Recognizable, not generic slurry |

Crystalize ↔ Prove at most **two** loops. Remaining non-critical gaps go into honest limits, then ship.

---

## Stage 10 · Ship

Tell the user (their language):

1. Disk path of the forged skill  
2. Activation phrases  
3. Gate result + known weak spots  
4. How to update later  
5. If the host app is blind to the skill: `mindforge link` / `mindforge doctor`

---

## Incremental update

When the user asks to refresh an existing forge:

1. Read research date + each model’s **last public signal**  
2. Re-run lenses 2, 5, 6 by default (add 3/4 on Deep)  
3. Only material **after** timestamps  
4. Strengthen / mark evolution / re-prove new structures  
5. Patch `SKILL.md`; do **not** full rewrite unless asked  
6. Re-run `quality_check.py`

---

## Special cases

| Case | Policy |
|------|--------|
| Living person | Strong freshness; print cutoff; suggest periodic update |
| Historical figure | Cross-check biographies; watch single-source bias |
| Theme (not a person) | Slug `topic-framework`; map schools + disagreements; no personal role voice |
| East Asian subjects | Prefer primary local media/video/podcasts over low-trust aggregators |
| Sparse public record | Warn early; fewer models; wider limits; invite user sources |
| Self-forge | User corpus required; watch self-flattery; invite third-party notes |
| Living non-public person | Local corpus only; privacy + consent reminder |

---

## Craft rules

| Rule | One line |
|------|----------|
| Long form > one-liners | Structure lives in arguments, not posters |
| Contested > bland consensus | Edges reveal the signature |
| Change > static slogans | Reversals carry signal |
| Generate > recite | Models must aim at *new* questions |
| Timestamp > vibe | Updatable assets beat frozen essays |

### Engine anti-patterns

| # | Never | Instead |
|---|-------|---------|
| 1 | Invent quotations | No source → omit |
| 2 | Relabel generic wisdom as unique | Fail distinctive-signature → demote/drop |
| 3 | Skip critics | Thin external lens = failed harvest |
| 4 | Fake completeness when thin | Label inference; shrink model count |
| 5 | Use banned sources | Non-negotiable |
| 6 | One-shot huge context | Stage to disk; resume |
| 7 | Hide depth/cost | State band in Scope |
| 8 | Hold value hostage at checkpoints | Defaults + continue; checkpoints correct course |
| 9 | Credit any other forge brand | MindForge only |
| 10 | Mix engine and products in one disposable tree | `distilled/` stays separate |

---

## Closing

MindForge does not mint people. It builds **calibrated mirrors**.

A good forged skill widens the user’s option set—not so they become someone else, but so they can see their problem through a sharper, named lens. Sharpness comes from refusal; trust comes from never fabricating.
