# MindForge · Quality Gate

Short, hard, automatable. If critical checks fail, the forge is **not** done.

---

## Critical pass table

| # | Check | Pass bar | Fail signals |
|---|-------|----------|--------------|
| 1 | Mental model count | 3–7, each with evidence | <3 or >7; titles only |
| 2 | Failure modes | **Every** model states when it fails | Strengths-only writing |
| 3 | Voice DNA | ~100 words feels like them | Generic assistant sludge / parody |
| 4 | Honest limits | ≥3 **specific** limits | Only “not the real person” |
| 5 | Inference rule | Unstated topics must be labeled inference | Fake certainty off-corpus |

## Strongly recommended

| # | Check | Pass bar |
|---|-------|----------|
| 6 | Research date | Researched / cutoff present |
| 7 | Model timestamps | `Last public signal` on models |
| 8 | Tensions | ≥2 real pulls |
| 9 | Agentic protocol | Classify + person-specific research angles |
| 10 | Refusals | Clear anti-patterns |

---

## Human / worker spot tests

Use separate answer vs grade workers when possible.

1. **Stance** — 3 known public positions → direction match  
2. **Edge** — 1 never-public related question → inference label + uncertainty  
3. **Voice** — ~100 words → recognizable, not paste of quotes  

---

## Automation

```bash
python3 scripts/quality_check.py ~/.agents/skills/distilled/<slug>/SKILL.md
# or
mindforge quality ~/.agents/skills/distilled/<slug>/SKILL.md
```

Exit codes:

- `0` — critical clear (shippable)  
- `1` — critical failed  
- `2` — bad usage  

Critical set: model count, failure modes, voice DNA, honest limits, inference labeling.

---

## Iteration budget

- Crystalize ↔ Prove: **max 2** loops  
- After that: document remaining soft gaps in honest limits and ship  
- Never invent sources to please the gate  

---

## Deliverable layout

```text
~/.agents/skills/distilled/<slug>/
├── SKILL.md
└── research/
    ├── 01-writings.md
    ├── 02-conversations.md
    ├── 03-voice.md
    ├── 04-external.md
    ├── 05-decisions.md
    └── 06-timeline.md
```

Ship message must include: path, activation triggers (`呼叫` / `hello` / `hi` / `@` + name aliases), gate summary, weak spots, update phrase.
