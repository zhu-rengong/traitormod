local logtbl = {
    ['i'] = { "Info", color = Color.LightGreen },
    ['d'] = { "Debug", color = Color.Blue },
    ['w'] = { "Warn", color = Color.Orange },
    ['e'] = { "Error", color = Color.Red, showtrace = true }
}

local showtrace = false

---@param name string
---@return fun(text:string, pattern?:'i'|'d'|'w'|'e')
local logger = function(name)
    return function(text, pattern)
        text = text or type(nil)
        local logtype = logtbl[pattern and pattern:lower() or 'i'] or logtbl['i']
        local msgpref = ("[%s-%s] "):format(name, logtype[1])
        if showtrace and logtype.showtrace then
            text = debug.traceback(nil, 2) .. text
        end
        for i = 1, #text, 1024 do
            local block = text:sub(i, math.min((i + 1023), #text))
            local msg = msgpref .. block
            for _, client in pairs(Client.ClientList) do
                if client.HasPermission(ClientPermissions.All) then
                    local chatMessage = ChatMessage.Create("",
                        msg, ChatMessageType.Console, nil, nil, nil,
                        logtype.color and logtype.color or Color.MediumPurple)
                    Game.SendDirectChatMessage(chatMessage, client)
                end
            end
            Game.Log(msg, ServerLogMessageType.ServerMessage)
        end
    end
end

return logger
