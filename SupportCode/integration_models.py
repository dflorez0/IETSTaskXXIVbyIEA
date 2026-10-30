"""Writes the list of models the system integration page (integration.qmd) can
combine: every page that shows a model with {{< model-viewer JSON/... >}}, in
sidebar order, with its title and the path of its JSON description.

Runs before every render (project: pre-render in _quarto.yml), like
category_overview.py. The list replaces the text between the two markers of
integration.qmd, and the file is only rewritten when that text changes. The
integration view loads the JSON of a model when the reader picks it.
"""
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
PAGE = ROOT / "integration.qmd"
START, END = "<!-- integration-models:start -->", "<!-- integration-models:end -->"
VIEWER = re.compile(r"\{\{<\s*model-viewer\s+(\S+\.json)")
TITLE = re.compile(r"^# (.+?)(?: \{[^}]*\})?\s*$", re.M)


def pages():
    """The sidebar's index.qmd pages in order, each with the titles of the sections it sits in."""
    sidebar = (ROOT / "_quarto.yml").read_text(encoding="utf-8")
    open_sections, seen = [], set()                  # (indent, title) of the sections around the line
    for line in sidebar.splitlines():
        indent = len(line) - len(line.lstrip())
        open_sections = [s for s in open_sections if s[0] < indent]
        section = re.match(r'\s*-\s+section:\s*"(.+)"', line)
        page = re.match(r"\s*-\s+([\w/-]+/index\.qmd)\s*$", line)
        if section:
            open_sections.append((indent, section.group(1)))
        elif page and page.group(1) not in seen:
            seen.add(page.group(1))
            yield page.group(1), [title for _, title in open_sections]


def models():
    out = []
    for rel, sections in pages():
        qmd = ROOT / rel
        text = qmd.read_text(encoding="utf-8") if qmd.exists() else ""
        m = VIEWER.search(text)
        if not m:
            continue                                 # a category or placeholder page
        folder = qmd.parent.relative_to(ROOT).as_posix()
        title = TITLE.search(text)
        try:                                         # the model's own keywords help the search
            data = json.loads((qmd.parent / m.group(1)).read_text(encoding="utf-8-sig"))
            keywords = data.get("header", {}).get("keywords") or str(data.get("METADATA", {}).get("Keywords", "")).split(",")
            keywords = [str(k).strip() for k in keywords if str(k).strip()]
        except (OSError, ValueError):
            keywords = []
        out.append({"title": title.group(1) if title else qmd.parent.name,
                    "page": f"{folder}/index.html",
                    "json": f"{folder}/{m.group(1)}",
                    "category": " · ".join(sections),
                    "keywords": keywords})
    return out


text = PAGE.read_text(encoding="utf-8")
if START in text:
    head, rest = text.split(START, 1)
    tail = rest.split(END, 1)[1]
    block = ('```{=html}\n<div class="model-integration"><script type="application/json">'
             + json.dumps(models(), ensure_ascii=False) + "</script></div>\n```")
    new = f"{head}{START}\n{block}\n{END}{tail}"
    if new != text:
        PAGE.write_text(new, encoding="utf-8")
        print(f"integration_models: updated {PAGE.relative_to(ROOT)}")
