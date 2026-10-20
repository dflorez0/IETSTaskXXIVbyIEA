-- {{< model-viewer JSON/Model.json view="streams" >}}
--
-- Places one view of a model on its page; template_files/model-viewer.html
-- renders it from the model's JSON description (path relative to the page).
-- Views: card, summary, flows, equations, variables, unit, streams, cc, gcc,
-- references; without `view` a compact tabbed widget is rendered.
--
-- The JSON is inlined at render time rather than fetched by the browser, so the
-- page also works when opened straight from disk. It is embedded once per page:
-- the other views of the same file read that copy.

local embedded = {}

local function read(path)
  local f = io.open(path, "rb")
  if not f then return nil end
  local content = f:read("a")
  f:close()
  return content
end

local function note(text)
  return pandoc.Para({ pandoc.Emph({ pandoc.Str(text) }) })
end

local function attr(s)
  return (s:gsub("&", "&amp;"):gsub('"', "&quot;"):gsub("<", "&lt;"))
end

return {
  ["model-viewer"] = function(args, kwargs)
    local rel = pandoc.utils.stringify(args[1] or "")
    if rel == "" then
      return note("model-viewer: no JSON file given.")
    end
    if not quarto.doc.is_format("html:js") then
      return note("An interactive view of this model is available in the HTML version.")
    end

    local view = pandoc.utils.stringify(kwargs["view"] or "")
    local open = '<div class="model-viewer" data-src="' .. attr(rel) .. '"' ..
                 (view ~= "" and (' data-view="' .. attr(view) .. '"') or "") .. ">"

    local key = (quarto.doc.input_file or "") .. "\0" .. rel
    if embedded[key] then
      return pandoc.RawBlock("html", open .. "</div>")
    end

    local dir = pandoc.path.directory(quarto.doc.input_file)
    local content = read(pandoc.path.join({ dir, rel }))
    if not content then
      return note("model-viewer: could not read " .. rel .. ".")
    end
    embedded[key] = true
    content = content:gsub("^\239\187\191", "")   -- UTF-8 byte-order mark
    content = content:gsub("</", "<\\/")          -- keep "</script>" out of the payload

    return pandoc.RawBlock("html",
      open .. '<script type="application/json">' .. content .. "</script></div>")
  end
}
