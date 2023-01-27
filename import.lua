local modules = setmetatable({}, {
    __index = function(self, path)
        self[path] = false
        local scriptPath = ('server/%s.lua'):format(path:gsub('%.', '/'))
        local resourceFile = LoadResourceFile('eden_logs', scriptPath)

        if not resourceFile then
            self[path] = nil
            return error(("^1unable to load module at path '%s^0"):format(scriptPath), 3)
        end

        scriptPath = ('@@eden_logs/%s'):format(scriptPath)
        local chunk, err = load(resourceFile, scriptPath)

        if err or not chunk then
            self[path] = nil
            return error(err or ("^1unable to load module at path '%s^0"):format(scriptPath), 3)
        end

        self[path] = chunk() or true
        return self[path]
    end
})

---@param modname string
---@return unknown
---@diagnostic disable-next-line: lowercase-global
function import(modname)
    local module = modules[modname]

    if module == false then
        error(("^1circular-dependency occurred when loading module '%s'^0"):format(modname), 2)
    end

    return module
end