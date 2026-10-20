-- {{< model-viewer JSON/Model.json >}}
--
-- Embeds a model's JSON description (path relative to the page) in the HTML
-- output, where template_files/model-viewer.html renders it as key figures, a
-- block flow diagram and the composite / grand composite curves. The JSON is
-- inlined at render time rather than fetched by the browser, so the page also
-- works when opened straight from disk.

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

return {
  ["model-viewer"] = function(args)
    local rel = pandoc.utils.stringify(args[1] or "")
    if rel == "" then
      return note("model-viewer: no JSON file given.")
    end
    -- PDF and EPUB get a pointer instead of an empty box.
    if not quarto.doc.is_format("html:js") then
      return note("An interactive view of this model is available in the HTML version.")
    end

    local dir = pandoc.path.directory(quarto.doc.input_file)
    local content = read(pandoc.path.join({ dir, rel }))
    if not content then
      return note("model-viewer: could not read " .. rel .. ".")
    end
    content = content:gsub("^\239\187\191", "")   -- UTF-8 byte-order mark
    content = content:gsub("</", "<\\/")          -- keep "</script>" out of the payload

    return pandoc.RawBlock("html",
      '<div class="model-viewer" data-src="' .. rel .. '">' ..
      '<script type="application/json">' .. content .. '</script></div>')
  end
}
