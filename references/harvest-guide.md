# MindForge · Harvest Guide

How to collect evidence before any synthesis. All engine text is English; write research note files in the **user’s language** when the forge conversation is not English (or bilingual notes if helpful), but always keep filenames as specified.

---

## Source priority

| Tier | Kind | Weight |
|------|------|--------|
| T0 | User-supplied primary files (books, transcripts, memos) | Highest |
| T1 | Their books, long interviews, verifiable decisions | Highest |
| T2 | Their social posts, public debates | Medium |
| T3 | Serious biographies, quality journalism | Medium |
| T4 | Aggregators, listicles, unattributed quotes | Low (corroboration only) |

---

## Banned sources (never)

- Zhihu  
- WeChat public accounts as evidence  
- Baidu Baike / Baidu Zhidao  
- Unsourced “famous quotes” images or memes  

Prefer primary video/audio and named investigative outlets over closed repost ecosystems.

### Subject-locale hints

- **Chinese-speaking subjects:** original Bilibili talks, Xiaoyuzhou / primary podcasts, LatePost, Caixin, 36Kr deep pieces, GeekPark, Yicai, Jiqizhixin, personal Weibo/writing when authentic.  
- **Western subjects:** long essays, podcasts, YouTube longform, X/Twitter primary posts, books.

---

## Annotation format (every material claim)

```text
- [claim]
  - provenance: primary | secondary | inference
  - source: URL or book+locus
  - date: YYYY-MM or unknown
```

Separate:

1. What **they** said/wrote  
2. What **others** claim about them  
3. What **you** infer  

---

## Lens briefs

### 01 · Writings

Hunt: books, essays, papers, newsletters.  
Keep: claims that recur ≥3 times, coined terms, recommended reading (intellectual ancestry).

### 02 · Conversations

Hunt: podcasts, long interviews, AMAs, hearings.  
Keep: answers under pushback, live metaphors, position changes, deliberate silence.

### 03 · Voice

Hunt: short posts, speeches, debates.  
Keep: sentence shape, humor type, stock phrases, forbidden words, certainty style.

### 04 · External

Hunt: critics, profiles, rival comparisons.  
Keep: patterns outsiders see, scandals, “fan filter” corrections. **Negative share must not be zero** for public figures with coverage.

### 05 · Decisions

Hunt: career/company bets, public reversals, post-mortems.  
Keep: stated logic vs observed incentives; consistency checks.

### 06 · Timeline

Hunt: cradle-to-now milestones.  
Keep: intellectual turns and **last 12 months** (staleness guard).

---

## Worker prompt skeleton

```text
Task: Harvest lens [N] for [person/topic].

Search aims:
- [bullets for this lens]

Write to: [absolute path]/research/0N-....md
For each item: source, primary|secondary|inference, date if known.
Record contradictions; do not reconcile.
Banned sources: Zhihu, WeChat public accounts, Baidu Baike/Zhidao. No invented quotes.
User language for note prose: [lang]
```

---

## Local corpus handling

1. Classify user files into lenses (one book may feed several).  
2. Mark gaps.  
3. Online harvest only for gaps (unless local-only).  
4. Tag lines as `user-corpus` vs `network`.

---

## Thin-data protocol

If usable sources < 10:

- Warn before Crystalize  
- Cap models at 2–3  
- Widen honest limits  
- Prefer user uploads over scraping noise
