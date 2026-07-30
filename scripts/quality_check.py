#!/usr/bin/env python3
"""
MindForge quality gate for forged SKILL.md files.

Critical: model count, failure modes, voice DNA, honest limits, inference labels.
Also checks: research date, tensions, agentic protocol, anti-patterns, frontmatter.

Usage:
    python3 quality_check.py <path-to-SKILL.md>
    python3 quality_check.py <path-to-skill-dir>
"""

from __future__ import annotations

import re
import sys
from pathlib import Path


def load_skill(path: Path) -> str:
    if path.is_dir():
        path = path / "SKILL.md"
    if not path.exists():
        raise FileNotFoundError(path)
    return path.read_text(encoding="utf-8")


def section(content: str, *titles: str) -> str | None:
    for title in titles:
        pat = rf"(?ms)^##\s+.*{re.escape(title)}.*?\n(.*?)(?=^##\s+|\Z)"
        m = re.search(pat, content, re.IGNORECASE)
        if m:
            return m.group(1)
    return None


def check_frontmatter(content: str) -> tuple[bool, str]:
    if not content.startswith("---"):
        return False, "missing YAML frontmatter"
    m = re.match(r"(?s)^---\n(.*?)\n---", content)
    if not m:
        return False, "invalid frontmatter"
    fm = m.group(1)
    ok = bool(re.search(r"(?m)^name:\s*\S+", fm)) and bool(
        re.search(r"(?m)^description:\s*", fm)
    )
    return ok, "name + description OK" if ok else "frontmatter missing name/description"


def check_mental_models(content: str) -> tuple[bool, str]:
    body = section(content, "Mental models", "Mental Models", "核心心智模型", "心智模型")
    if body:
        count = len(re.findall(r"(?m)^###\s+", body))
    else:
        count = len(re.findall(r"(?m)^###\s+(?:Model|模型)\s*\d", content))
    if count == 0:
        return False, "no mental models found"
    ok = 3 <= count <= 7
    return ok, f"{count} models" + ("" if ok else " (need 3–7)")


def check_model_sources(content: str) -> tuple[bool, str]:
    body = section(content, "Mental models", "Mental Models", "核心心智模型", "心智模型") or content
    blocks = re.split(r"(?m)^###\s+", body)[1:]
    blocks = [b for b in blocks if b.strip()]
    if not blocks:
        return False, "no model blocks"
    with_src = sum(
        1
        for b in blocks
        if re.search(r"Evidence|证据|來源|来源|source|\d{4}|interview|book|essay", b, re.I)
    )
    ok = with_src == len(blocks)
    return ok, f"{with_src}/{len(blocks)} models have evidence"


def check_model_failures(content: str) -> tuple[bool, str]:
    body = section(content, "Mental models", "Mental Models", "核心心智模型", "心智模型") or content
    blocks = re.split(r"(?m)^###\s+", body)[1:]
    blocks = [b for b in blocks if b.strip()]
    if not blocks:
        return False, "no model blocks"
    with_f = sum(
        1
        for b in blocks
        if re.search(
            r"Fails when|失效|局限|不适用|盲区|limitation|fail(?:s|ure)?\s+when",
            b,
            re.I,
        )
    )
    ok = with_f == len(blocks) and len(blocks) >= 3
    return ok, f"{with_f}/{len(blocks)} models have failure modes"


def check_voice_dna(content: str) -> tuple[bool, str]:
    body = section(content, "Voice DNA", "Expression DNA", "表达DNA", "表達DNA")
    if not body:
        return False, "missing Voice DNA section"
    markers = [
        "Syntax",
        "Lexicon",
        "Rhythm",
        "Humor",
        "Certainty",
        "句式",
        "词汇",
        "詞彙",
        "节奏",
        "節奏",
        "幽默",
        "确定性",
        "確定性",
        "taboo",
        "禁忌",
    ]
    hits = sum(1 for m in markers if re.search(m, body, re.I))
    ok = hits >= 4
    return ok, f"voice markers {hits}" + ("" if ok else " (need ≥4)")


def check_honest_limits(content: str) -> tuple[bool, str]:
    body = section(content, "Honest limits", "Honest Limits", "诚实边界", "誠實邊界", "局限")
    if not body:
        return False, "missing Honest limits section"
    items = re.findall(r"(?m)^(?:[-*]|\d+[.)])\s+\S+", body)
    n = len(items)
    ok = n >= 3
    return ok, f"{n} limits" + ("" if ok else " (need ≥3)")


def check_inference_label(content: str) -> tuple[bool, str]:
    patterns = [
        r"framework inference",
        r"not a documented stance",
        r"This is (?:a )?framework",
        r"这是推[断斷]",
        r"這是推[断斷]",
        r"框架推断",
        r"框架推斷",
        r"非本人",
        r"Unstated topics",
        r"未表态",
        r"未表態",
    ]
    hits = sum(1 for p in patterns if re.search(p, content, re.I))
    ok = hits >= 1
    return ok, "inference labeling present" if ok else "missing inference labeling rule"


def check_research_date(content: str) -> tuple[bool, str]:
    if re.search(
        r"Researched|Knowledge cutoff|调研时间|調研時間|信息截止|資訊截止|last[_ -]?updated",
        content,
        re.I,
    ):
        return True, "research date / cutoff found"
    return False, "missing research date or cutoff"


def check_tensions(content: str) -> tuple[bool, str]:
    body = section(content, "Values", "Tensions", "价值观", "價值觀", "反模式") or content
    markers = re.findall(
        r"tension|paradox|矛盾|张力|張力|vs\.?|一方面|另一方面|both",
        body,
        re.I,
    )
    n = len(markers)
    ok = n >= 2
    return ok, f"tension signals {n}" + ("" if ok else " (need ≥2)")


def check_agentic(content: str) -> tuple[bool, str]:
    has = bool(
        re.search(
            r"Answer protocol|Agentic|Step\s*1|Classify|Fact-heavy|先研究|问题分类|問題分類",
            content,
            re.I,
        )
    )
    return has, "agentic protocol present" if has else "missing answer protocol"


def check_anti_patterns(content: str) -> tuple[bool, str]:
    has = bool(
        re.search(r"Anti-examples|Anti-pattern|I refuse|拒绝|拒絕|绝不|絕不|黑名单|黑名單", content, re.I)
    )
    return has, "refusals / anti-examples present" if has else "missing refusals"


CHECKS = [
    ("Frontmatter", check_frontmatter),
    ("Model count", check_mental_models),
    ("Model evidence", check_model_sources),
    ("Failure modes", check_model_failures),
    ("Voice DNA", check_voice_dna),
    ("Honest limits", check_honest_limits),
    ("Inference rule", check_inference_label),
    ("Research date", check_research_date),
    ("Tensions", check_tensions),
    ("Agentic protocol", check_agentic),
    ("Refusals", check_anti_patterns),
]

CRITICAL = {
    "Model count",
    "Failure modes",
    "Voice DNA",
    "Honest limits",
    "Inference rule",
}


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: python3 quality_check.py <SKILL.md|skill-dir>")
        return 2

    path = Path(sys.argv[1]).expanduser()
    try:
        content = load_skill(path)
    except FileNotFoundError as e:
        print(f"ERROR: not found: {e}")
        return 1

    display = path if path.name == "SKILL.md" else path / "SKILL.md"
    print(f"MindForge quality · {display}")
    print("=" * 56)

    passed = 0
    critical_fail = 0
    for name, fn in CHECKS:
        ok, detail = fn(content)
        icon = "PASS" if ok else "FAIL"
        mark = "OK" if ok else "X"
        flag = " [CRITICAL]" if (not ok and name in CRITICAL) else ""
        print(f"  [{mark}] {name:<18} {icon}  {detail}{flag}")
        if ok:
            passed += 1
        elif name in CRITICAL:
            critical_fail += 1

    total = len(CHECKS)
    print("=" * 56)
    print(f"Result: {passed}/{total} · critical fails: {critical_fail}")

    if critical_fail == 0 and passed >= total - 1:
        print("SHIP: critical clear")
        return 0
    if critical_fail == 0:
        print("SHIP with notes: critical clear; soft items remain")
        return 0
    print("BLOCKED: fix critical items (Crystalize again, max 2 loops)")
    return 1


if __name__ == "__main__":
    sys.exit(main())
