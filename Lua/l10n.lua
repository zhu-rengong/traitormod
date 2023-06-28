---@class l10nstr
---@field value string
---@field format fun(self:l10nstr, ...:any):string

---@class l10nmgr
---@overload fun(keys:string|string[]):l10nstr
local l10nmgr = {}
l10nmgr.__index = l10nmgr

local lang = {}

---@param value table
l10nmgr.setlang = function(value)
    lang = value
end

setmetatable(l10nmgr, {
    __call = function(_, ...)
        local keys = ...
        if type(keys) == "string" then keys = { keys } end

        local result, size = nil, #keys
        for i = 1, size, 1 do
            local key = keys[i]
            result = result and result[key] or lang[key]
            if result then
                if i == size then
                    if type(result) == "string" then
                        return {
                            value = result,
                            format = function(lstr, ...)
                                local str = lstr.value
                                for ph, repl in ipairs(table.pack(...)) do
                                    str = str:gsub('{' .. ph .. '}', repl)
                                end
                                return str
                            end
                        }
                    else
                        break
                    end
                elseif type(result) ~= "table" then
                    break
                end
            else
                break
            end
        end

        return { value = table.concat(keys, '.'), format = function(lstr) return lstr.value end }
    end
})

return l10nmgr
