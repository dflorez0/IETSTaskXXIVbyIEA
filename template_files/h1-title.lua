-- Makes a page's leading level-1 heading its title, as a Quarto book does:
-- the heading becomes the title block and the browser tab title. Pages that
-- set `title` in their front matter (index.qmd) are left as they are.

function Pandoc(doc)
  if doc.meta.title then return nil end
  local first = doc.blocks[1]
  if first and first.t == "Header" and first.level == 1 then
    doc.meta.title = pandoc.MetaInlines(first.content)
    doc.meta.pagetitle = pandoc.utils.stringify(first.content)
    doc.blocks:remove(1)
    return doc
  end
end
