local Dispatcher = require("src.dispatcher")
local gma2Workers = {}

---@param config {tasks: WorkerTask[], onComplete: fun(response: WorkerResponse)?, mode: WorkerMode?}
function gma2Workers.Dispatch(config)
    Dispatcher.dispatch(config or {})
end

return gma2Workers