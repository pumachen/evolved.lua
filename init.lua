local path = ...
if not path:find("init") then
    return require(path .. ".evolved")
end
