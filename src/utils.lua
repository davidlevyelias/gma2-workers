local Utils = {}

---@param t table
---@return integer count
function Utils.getTableCount(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

---@return string jobId
function Utils.generateJobId()
    return string.format(
        "Job_%d_%03d",
        math.floor(os.clock() * 10000),
        math.random(100, 999)
    )
end

---@param prefix string?
---@return string alias
function Utils.generateAliasName(prefix)
    prefix = prefix or "Exec_"
    return string.format("%s%d", prefix, math.random(10000, 99999))
end

return Utils
