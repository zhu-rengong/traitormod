if CLIENT then return end

local function t_select(t, f)
    local _t = {}
    for k, v in pairs(t) do if f(v, k) then _t[#_t + 1] = v end end
    return _t
end

---@param msgtype string
---@param text string
---@param color userdata
local function log(msgtype, text, color)
    text = text or type(nil)
    local logtype = ("[ItemBuilder-%s] "):format(msgtype)
    for i = 1, #text, 1024 do
        local block = text:sub(i, math.min((i + 1023), #text))
        local msg = logtype .. block
        for _, client in pairs(Client.ClientList) do
            if client.HasPermission(ClientPermissions.All) then
                local chatMessage = ChatMessage.Create("",
                    msg, ChatMessageType.Console, nil, nil, nil,
                    color and color or Color.MediumPurple)
                Game.SendDirectChatMessage(chatMessage, client)
            end
        end
        Game.Log(msg, ServerLogMessageType.ServerMessage)
    end
end

local function log_info(msg) log("Info", msg, Color.White) end
local function log_debug(msg) log("Debug", msg, Color.Blue) end
local function log_warn(msg) log("Warn", msg, Color.Orange) end
local function log_error(msg) log("Error", msg, Color.Red) end

if not CSActive then
    log_error("C# is not activated!")
    return
end

LuaUserData.RegisterType("ItemBuilder.Utils")
local utils = LuaUserData.CreateStatic("ItemBuilder.Utils")

---@class itbublock
---@field _prefab userdata
---@field _pool_weights? number[]
---@field _pool_objects? (itbublock|itbublock[])[]
---@field _amount? number
---@field _stacks? number
---@field _getamount? fun(self:itbublock, context:itbuspawnctx)
---@field ref itembuilder
---@field identifier string
---@field tags? string
---@field quality? integer
---@field equip? boolean
---@field install? boolean
---@field amount? number|{[1]:number,[2]:number}
---@field amountround? boolean # default is `true`
---@field stacks? number|{[1]:number,[2]:number}
---@field fillinventory? boolean
---@field properties? table<string|{[1]:string,[2]:string,[3]:integer?},boolean|integer|number|string>
---@field serverevents? string|{[1]:string,[2]:integer?}|string[]|{[1]:string,[2]:integer?}[]
---@field onspawned? fun(item:userdata)
---@field inventory? itbublock[]
---@field pool? {[1]:number,[2]:itbublock|itbublock[]}[]

---@class itbuspawnctx
---@field inventory? userdata
---@field atinventory boolean
---@field atiteminventory boolean
---@field worldpos? userdata
---@field _character? userdata

---@param itembuilds itbublock[]
---@param context itbuspawnctx
local function spawn(itembuilds, context)
    ---@param item userdata
    ---@param itemblock itbublock
    ---@param context itbuspawnctx
    local function onspawned(item, itemblock, context)
        if itemblock.tags then
            item.Tags = itemblock.tags
        end

        if context.atinventory then
            if context.atiteminventory then
                if itemblock.tags and (item.ParentInventory ~= context.inventory) then
                    context.inventory.TryPutItem(item, nil)
                end
            else
                if context._character == nil then
                    context._character = context.inventory.Owner
                end

                if itemblock.equip then
                    utils.Equip(context._character, item)
                end
            end
        end

        if itemblock.properties then
            for indexer, value in pairs(itemblock.properties) do
                local propertyName
                local entity
                if type(indexer) ~= "table" then
                    propertyName = indexer
                    entity = item
                else
                    propertyName = indexer[2]
                    indexer[3] = indexer[3] or 1
                    entity = utils.GetComponent(item, indexer[1], indexer[3])
                end

                if entity then
                    local serializableProperty = entity.SerializableProperties[propertyName]
                    if serializableProperty then
                        if utils.TrySetValue(serializableProperty, entity, value) then
                            if utils.IsEditable(serializableProperty) then
                                Networking.CreateEntityEvent(item,
                                    Item.ChangePropertyEventData(serializableProperty, entity))
                            end
                        else
                            if entity == item then
                                log_error(("Failed to set SP(%s) to '%s' for item(%s)!"):format(propertyName.Value,
                                    tostring(value), item.Prefab.Identifier.Value))
                            else
                                log_error(("Failed to set SP(%s) to '%s' for '%s->%s[%i]'!"):format(propertyName.Value,
                                    tostring(value), item.Prefab.Identifier.Value, indexer[1], indexer[3]))
                            end
                        end
                    else
                        if entity == item then
                            log_error(("Could not find any SP with the given name(%s) in item(%s)!"):format(
                                propertyName.Value, item.Prefab.Identifier.Value))
                        else
                            log_error(("Could not find any SP with the given name(%s) in '%s->%s[%i]'!"):format(
                                propertyName.Value, item.Prefab.Identifier.Value, indexer[1], indexer[3]))
                        end
                    end
                else
                    log_error(("Could not find any entity matching '%s[%i]' in '%s'!"):format(indexer[1], indexer[3],
                        item.Prefab.Identifier.Value))
                end
            end
        end

        if itemblock.inventory then
            local itemContainer = utils.GetComponent(item, "ItemContainer")
            if itemContainer then
                spawn(itemblock.inventory, {
                    atinventory = true,
                    atiteminventory = true,
                    character = context._character,
                    inventory = itemContainer.Inventory
                })
            else
                log_error(("Cannot spawn items in item(%s)'s inventory since it has no inventory!"):format(item.Prefab
                    .Identifier.Value))
            end
        end

        if itemblock.serverevents then
            for _, serverevent in ipairs(itemblock.serverevents) do
                local index = 0
                for _, component in ipairs(item.Components) do
                    if component.Name:lower() == serverevent[1]:lower() then
                        index = index + 1
                        if serverevent[2] == nil or serverevent[2] == index then
                            item.CreateServerEvent(component, component)
                        end
                    end
                end
            end
        end

        if itemblock.onspawned then
            itemblock.onspawned(item)
        end
    end

    for _, itemblock in ipairs(itembuilds) do
        if itemblock.ref then
            local amount = itemblock:_getamount(context)
            local num = math.floor(amount)
            for _ = 1, num, 1 do
                spawn(itemblock.ref._itembuilds, context)
            end
        elseif itemblock.pool then
            local amount = itemblock:_getamount(context)
            local num = math.floor(amount)
            for _ = 1, num, 1 do
                local object = utils.GetPoolItemBlockRandom(itemblock._pool_objects, itemblock._pool_weights)
                spawn(object, context)
            end
        else
            local amount = itemblock:_getamount(context)
            local num = math.ceil(amount)
            for i = 1, num, 1 do
                local condition = nil
                if i == num and amount < num then
                    condition = table.pack(math.modf(amount))[2] * itemblock._prefab.Health
                end
                if context.worldpos then
                    local shouldspawn = true
                    if itemblock.install then
                        for _, sub in pairs(Submarine.MainSubs) do
                            local borders, worldpos = sub.Borders, sub.WorldPosition
                            local worldrect = Rectangle(worldpos.X - borders.Width / 2, worldpos.Y + borders.Height / 2,
                                borders.Width, borders.Height)
                            if sub.RectContains(worldrect, context.worldpos, true) then
                                shouldspawn = false
                                Entity.Spawner.AddItemToSpawnQueue(itemblock._prefab, context.worldpos - sub.Position,
                                    sub, condition, itemblock.quality, function(item)
                                        onspawned(item, itemblock, context)
                                    end)
                                break
                            end
                        end
                    end
                    if shouldspawn then
                        Entity.Spawner.AddItemToSpawnQueue(itemblock._prefab, context.worldpos, condition,
                            itemblock.quality, function(item)
                                onspawned(item, itemblock, context)
                            end)
                    end
                elseif context.inventory then
                    Entity.Spawner.AddItemToSpawnQueue(itemblock._prefab, context.inventory, condition, itemblock
                        .quality, function(item)
                            onspawned(item, itemblock, context)
                        end)
                end
            end
        end
    end
end

---@class itembuilder
---@overload fun(itembuilds:itbublock[]):itembuilder
---@field _invalid boolean
---@field _itembuilds itbublock[]
local itembuilder = {}

---@param worldpos userdata
function itembuilder:spawnat(worldpos)
    spawn(self._itembuilds, {
        atinventory = false,
        atiteminventory = false,
        worldpos = worldpos
    })
end

---@param character userdata
function itembuilder:give(character)
    if character.Inventory then
        spawn(self._itembuilds, {
            atinventory = true,
            atiteminventory = false,
            inventory = character.Inventory
        })
    else
        self:spawnat(character.WorldPosition)
    end
end

itembuilder.__index = itembuilder
setmetatable(itembuilder, {
    ---@param itembuilds itbublock[]
    __call = function(_, itembuilds)
        ---@param itblds itbublock[]
        local function construct(itblds)
            local _itblds = t_select(itblds, function(itemblock)
                if itemblock.amount then
                    if type(itemblock.amount) == "number" and itemblock.amount > 0 then
                        itemblock._amount = itemblock.amount
                    elseif type(itemblock.amount) ~= "table"
                        or type(itemblock.amount[1]) ~= "number"
                        or type(itemblock.amount[2]) ~= "number"
                    then
                        itemblock._amount = 1
                    else
                        itemblock._amount = nil
                    end
                else
                    itemblock.amount, itemblock._amount = 1, 1
                end
                if itemblock.ref then
                    if itemblock.ref._invalid then
                        log_error(("itemblock is referenced to an invalid itembuilder!"))
                        return false
                    end
                    function itemblock:_getamount()
                        if self.amount then
                            local amount = self._amount or
                                self.amount[1] + math.random() * (self.amount[2] - self.amount[1])
                            if self.amountround then amount = math.round(amount, 0) end
                            return amount
                        end
                    end

                    return true
                elseif itemblock.pool then
                    local num = #itemblock.pool
                    if num > 0 then
                        itemblock._pool_weights = {}
                        itemblock._pool_objects = {}
                        for i = 1, num, 1 do
                            local tuple = itemblock.pool[i]
                            if type(tuple[1]) == "number" and tuple[1] > 0 and tuple[2] then
                                itemblock._pool_weights[i] = tuple[1]
                                itemblock._pool_objects[i] = tuple[2]
                            else
                                log_error(("itemblock's pool exists invalid datas!"))
                                return false
                            end
                        end
                        for i, object in ipairs(itemblock._pool_objects) do
                            itemblock._pool_objects[i] = construct(type(next(object)) == "number" and object or
                                { object })
                        end
                        function itemblock:_getamount()
                            if self.amount then
                                local amount = self._amount or
                                    self.amount[1] + math.random() * (self.amount[2] - self.amount[1])
                                if self.amountround then amount = math.round(amount, 0) end
                                return amount
                            end
                        end

                        return true
                    end
                    log_error(("itemblock's pool is empty!"))
                    return false
                elseif itemblock.identifier and ItemPrefab.Prefabs.ContainsKey(itemblock.identifier) then
                    itemblock.identifier = Identifier(itemblock.identifier)
                    itemblock._prefab = ItemPrefab.Prefabs[itemblock.identifier]
                    if itemblock.stacks then
                        if type(itemblock.stacks) == "number" and itemblock.stacks > 0 then
                            itemblock._stacks = itemblock.stacks
                        elseif type(itemblock.stacks) ~= "table"
                            or type(itemblock.stacks[1]) ~= "number"
                            or type(itemblock.stacks[2]) ~= "number"
                        then
                            itemblock.stacks = nil
                        end
                    end
                    function itemblock:_getamount(context)
                        if self.fillinventory and context.atinventory then
                            return context.inventory.HowManyCanBePut(self._prefab)
                        elseif self.stacks then
                            local stacks = self._stacks or
                                self.stacks[1] + math.random() * (self.stacks[2] - self.stacks[1])
                            local amount = self._prefab.MaxStackSize * stacks
                            if self.amountround then amount = math.round(amount, 0) end
                            return amount
                        elseif self.amount then
                            local amount = self._amount or
                                self.amount[1] + math.random() * (self.amount[2] - self.amount[1])
                            if self.amountround then amount = math.round(amount, 0) end
                            return amount
                        else
                            -- code never covering here since `self.amount` is defined
                            log_warn(("Cannot spawn item(%s) since the amount calculated by itub is not more then 0!")
                                :format(itemblock.identifier.Value))
                            return 0
                        end
                    end

                    if itemblock.properties then
                        local replace = {}
                        for indexer, value in pairs(itemblock.properties) do
                            if type(indexer) == "table" then
                                if type(indexer[1]) == "string" and type(indexer[2]) == "string" then
                                    indexer[2] = Identifier(indexer[2])
                                else
                                    log_warn(("Field properties has an invalid indexer(table) that its #1 or #2 element type is not string!")
                                        :format(itemblock.identifier.Value))
                                    return false
                                end
                            else
                                itemblock.properties[indexer] = nil
                                replace[indexer] = value
                            end
                        end
                        for indexer, value in pairs(replace) do
                            itemblock.properties[Identifier(indexer)] = value
                        end
                    end
                    if itemblock.serverevents then
                        if type(itemblock.serverevents) == "string" then
                            itemblock.serverevents = { { itemblock.serverevents } }
                        elseif type(itemblock.serverevents) == "table" then
                            if #itemblock.serverevents > 0 then
                                local k1, v1 = next(itemblock.serverevents)
                                local _, v2 = next(itemblock.serverevents, k1)
                                if type(v1) == "string" then
                                    if v2 == nil or type(v2) == "string" then
                                        local _t = {}
                                        for _, eventstr in ipairs(itemblock.serverevents) do
                                            table.insert(_t, { eventstr })
                                        end
                                        itemblock.serverevents = _t
                                    elseif type(v2) == "number" then
                                        itemblock.serverevents = {
                                            { itemblock.serverevents[1], itemblock.serverevents[2] } }
                                    else
                                        log_error("itemblock's ServerEvents's secondary data is invalid!")
                                        itemblock.serverevents = nil
                                    end
                                end
                            else
                                log_error("Table(itemblock's ServerEvents)'s length is not more then 0!")
                                itemblock.serverevents = nil
                            end
                        else
                            log_error(("Field(itemblock's ServerEvents) has invalid type, expected 'string' or 'table', but got %s")
                                :format(tostring(itemblock.serverevents)))
                            itemblock.serverevents = nil
                        end
                    end
                    if itemblock.inventory then
                        itemblock.inventory = construct(itemblock.inventory)
                    end
                    return true
                else
                    log_error(("Could not found any prefab with given identifier(%s)"):format(itemblock.identifier or
                        type(nil)))
                    return false
                end
            end)
            return _itblds
        end

        ---@type itembuilder
        local inst = setmetatable({ _itembuilds = construct(itembuilds) }, itembuilder)

        if #inst._itembuilds == 0 then
            inst._invalid = true
            log_error("itembuilds is invalid!")
        end

        return inst
    end,
})

return itembuilder
