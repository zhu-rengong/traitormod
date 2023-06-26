---@overload fun(args:{identifier:string,func:function,interval?:integer,ingame?:boolean})
local think = {}

think.__index = think
setmetatable(think, {
    __call = function(_, args, interval)
        assert(type(args) == "table", ("Missing arguments on think(). Expected #1 to be table, but got %s"):format(type(args)))
        assert(type(args.identifier) == "string", ("Missing arguments on think(). Expected a field(identifier) to be string, but got %s"):format(type(args.identifier)))
        assert(type(args[1]) == "function", ("Missing arguments on think(). Expected args[1] to be function, but got %s"):format(type(args.func)))
        local identifier = args.identifier
        local func = args[1]
        local interval = args.interval or 1
        local ticks = 0
        local ingame = args.ingame == nil and true or args.ingame
        Hook.Add("think", identifier, function()
            if ingame and Game.RoundStarted then
                ticks = ticks + 1
                if ticks == interval then
                    ticks = 0
                    interval = func()
                end
            else
                Hook.Remove("think", identifier)
            end
        end)
    end
})

return think
