"""Writes the overview table of each section page (1-EnergyTechnologies/index.qmd,
...) from the tables of its category pages, so the two never disagree.

Runs before every render (project: pre-render in _quarto.yml). Categories are
listed in the order of the sidebar. A category page's table has the columns
Model type | Model | Status; a row counts as documented when its Status is
"Documented". The overview replaces the text between the two markers of the
section page, and the file is only rewritten when that text changes.
"""
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
START, END = "<!-- category-overview:start -->", "<!-- category-overview:end -->"
LINK = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")


def title(qmd):
    m = re.search(r"^# (.+?)(?: \{[^}]*\})?\s*$", qmd.read_text(encoding="utf-8"), re.M)
    return m.group(1) if m else qmd.parent.name


def rows(qmd):
    """(model cell, status) of each row of the category table."""
    text = qmd.read_text(encoding="utf-8")
    m = re.search(r"^\| Model type \| Model \| Status \|\n\|[:|-]+\|\n((?:\|.*\|\n?)+)", text, re.M)
    if not m:
        raise SystemExit(f"{qmd}: no 'Model type | Model | Status' table")
    out = []
    for line in m.group(1).strip().splitlines():
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        out.append((cells[1], cells[2]))
    return out


def overview(section):
    sidebar = (ROOT / "_quarto.yml").read_text(encoding="utf-8")
    cats = re.findall(rf"\b{re.escape(section.name)}/(\w+)/index\.qmd", sidebar)
    cats = list(dict.fromkeys(cats))            # sidebar order, each once
    lines = ["| Category | Documented | Work in progress |", "|:--|:--|--:|"]
    for cat in cats:
        qmd = section / cat / "index.qmd"
        r = rows(qmd)
        done = [LINK.sub(lambda m: f"[{m.group(1)}]({cat}/{m.group(2)})", model)
                for model, status in r if status == "Documented"]
        wip = sum(1 for _, status in r if status != "Documented")
        lines.append(f"| [{title(qmd)}]({cat}/index.qmd) | {', '.join(done) or '—'} | {wip} |")
    return "\n".join(lines)


for section in sorted(ROOT.glob("[0-9]-*")):
    page = section / "index.qmd"
    text = page.read_text(encoding="utf-8")
    if START not in text:
        continue
    head, rest = text.split(START, 1)
    tail = rest.split(END, 1)[1]
    new = f"{head}{START}\n{overview(section)}\n{END}{tail}"
    if new != text:
        page.write_text(new, encoding="utf-8")
        print(f"category_overview: updated {page.relative_to(ROOT)}")
