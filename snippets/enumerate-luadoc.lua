--- recursive enumeration into emmylua annotations
--- @param tbl table @table to enumerate (_G for globals)
--- @param name string @table name
--- @param maxLvl number @maximum recursive depth level
--- @param lvl number @current depth level
--- @param visited table @visited tables to avoid infinite recursion
function enumerate(tbl, name, maxLvl, lvl, visited)
    lvl = lvl or 1
    visited = visited or {}
    if visited[tbl] then return "" end
    visited[tbl] = true

    local lines = {}
    local displayName = name:gsub("^_G%.", "")
    table.insert(lines, ("--- @class %s"):format(displayName))

    local keys = {}
    for k in pairs(tbl) do
        table.insert(keys, k)
    end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

    local subTables = {}
    for _, k in ipairs(keys) do
        local v = tbl[k]
        local formattedKey = tostring(k)
        if type(k) == "string" then
            if not k:match("^[A-Za-z_][A-Za-z0-9_]*$") then
                formattedKey = string.format('["%s"]', k)
            end
        end

        local fieldLine = ""
        if type(v) == "function" then
            fieldLine = ("--- @field %s fun()"):format(formattedKey)
        elseif type(v) == "table" then
            fieldLine = ("--- @field %s table"):format(formattedKey)
            table.insert(subTables, k)
        else
            fieldLine = ("--- @field %s %s @%s"):format(formattedKey, type(v), tostring(v))
        end
        table.insert(lines, fieldLine)
    end

    table.insert(lines, "")
    local result = table.concat(lines, "\n")
    if lvl >= maxLvl then return result end

    for _, k in ipairs(subTables) do
        if type(k) == "string" and k ~= "_G" and k:sub(1,2) ~= "__" then
            result = result .. "\n" .. enumerate(tbl[k], name .. "." .. k, maxLvl, lvl + 1, visited)
        end
    end
    return result
end

function saveToFile(filename, content)
    local file = io.open(filename, "w")
    if file then
        file:write(content)
        file:close()
    end
end

-- output via error (for plugin env)
-- if declare_plugin then
--     for line in output:gmatch("([^\n]+)") do
--         dofile(line)
--     end
-- end

-- local output = enumerate(_G, "_G", 2)
--local output = enumerate(DCS, "DCS", 2)
