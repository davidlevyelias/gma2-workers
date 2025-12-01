local Registry = require("src.registry")
local Executor = require("src.executor")
local Utils = require("src.utils")

local Dispatcher = {}

---@param jobId string
---@param workerCount integer
local function dispatchTimerWorkers(jobId, workerCount)
    for workerId = 1, workerCount do
        local wrapper = function()
            Executor.run(jobId, workerId)
        end
        gma.timer(wrapper, 0, 1)
    end
end

---@param jobId string
---@param workerCount integer
local function dispatchCmdWorkers(jobId, workerCount)
    local aliasName = Utils.generateAliasName("Exec_")
    _G[aliasName] = Executor.run
    Registry.setAlias(jobId, aliasName)

    for workerId = 1, workerCount do
        gma.cmd(string.format('LUA "%s(\'%s\', %d)"', aliasName, jobId, workerId))
    end
end

---@param config {tasks: WorkerTask[], onComplete: fun(response: WorkerResponse)?, mode: WorkerMode?}
function Dispatcher.dispatch(config)
    local tasks = config.tasks or {}
    local mode = config.mode or "timer"
    local onComplete = config.onComplete
    local workerCount = #tasks

    if workerCount == 0 then
        return
    end

    local jobId = Registry.createJob(tasks, mode, onComplete)

    gma.echo(string.format("GMA2 Workers: Spawning %d workers (Mode: %s)", workerCount, mode))

    if mode == "timer" then
        dispatchTimerWorkers(jobId, workerCount)
    elseif mode == "cmd" then
        dispatchCmdWorkers(jobId, workerCount)
    else
        gma.echo(string.format("GMA2 Workers: Unknown mode '%s'", tostring(mode)))
    end

    gma.sleep(0.01)
end

return Dispatcher
