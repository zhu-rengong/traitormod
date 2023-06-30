local l10nmgr = require "l10n"
local itbu = require "itbu"
local spedit = require "spedit"
local think = require "think"

local event = {}

event.Name = "AbyssMadClown"
event.MinRoundTime = 1
event.MaxRoundTime = 15
event.MinIntensity = 0.000
event.MaxIntensity = 0.666
event.ChancePerMinute = 0.15
event.OnlyOncePerRound = true

event.AmountPoints = 600
event.AmountPointsClownAlive = 80
event.AmountPointsClownEscape = 400
event.EscapeDistance = 5000
event.SurvivalInterval = 30
event.AwardClownLimit = 5

local clownitbu = itbu { "AbyssMadClown",
    { identifier = "clowncostume", equip = true },
    {
        identifier = "chitinhelmet",
        equip = true,
        properties = {
            spritecolor = "0.2,0.2,1.0,1.0",
            inventoryiconcolor = "0.2,0.2,1.0,1.0",
        }
    },
    {
        identifier = "safetyharness",
        equip = true,
        properties = {
            spritecolor = "0.5,0.5,1.0,0.8",
            inventoryiconcolor = "0.5,0.5,1.0,0.8",
        },
    },
    { identifier = "cymbals" },
    {
        identifier = "harpoongun",
        quality = 3,
        properties = {
            spritecolor = "0.666,0.998,0.250,1.0",
            inventoryiconcolor = "0.666,0.998,0.250,1.0",
        },
        inventory = {
            {
                identifier = "spear",
                tags = "burn",
                quality = 1,
                fillinventory = true,
                properties = {
                    spritecolor = "1.0,0.4,0.3,1.0",
                    inventoryiconcolor = "1.0,0.4,0.3,1.0",
                    [{ "projectile", "launchimpulse" }] = "40",
                }
            },
        }
    },
    { identifier = "ruinscanner" },
    {
        identifier = "clowndivingmask",
        inventory = {
            { identifier = "oxygenitetank", quality = 3 }
        }
    },
    {
        identifier = "toolbelt",
        equip = true,
        properties = { noninteractable = true, nonplayerteaminteractable = true, hiddeningame = true, },
        inventory = {
            {
                identifier = "psychosisartifact",
                tags = "smallitem",
                properties = { noninteractable = true }
            },
            {
                identifier = "alienvent",
                tags = "smallitem",
                properties = { noninteractable = true }
            },
            {
                identifier = "guardianpod",
                amount = 3,
                tags = "smallitem",
                properties = { noninteractable = true, condition = 10 }
            },
        }
    },
    { identifier = "bikehorn", amount = 2, properties = { scale = "1.0" } },
    { identifier = "honkmotherianscriptures1", slotindex = 7 + 8, properties = { noninteractable = true } },
    { identifier = "honkmotherianscriptures2", slotindex = 7 + 9, properties = { noninteractable = true } },
    { identifier = "honkmotherianscriptures3", slotindex = 7 + 10, properties = { noninteractable = true } },
}

event.Start = function()
    ---@type Barotrauma.Level.InterestingPosition[]
    local interestingPositions = {}
    for _, p in ipairs(Level.Loaded.PositionsOfInterest) do
        if p.PositionType == Level.PositionType.MainPath
            or p.PositionType == Level.PositionType.SidePath then
            local isPointInsideWall = false
            for _, levelWall in ipairs(Level.Loaded.ExtraWalls) do
                if levelWall.IsPointInside(p.Position.ToVector2()) then
                    isPointInsideWall = true
                    break
                end
            end
            if not isPointInsideWall and Submarine.FindContaining(p.Position.ToVector2()) == nil then
                table.insert(interestingPositions, p)
            end
        end
    end
    if #interestingPositions == 0 then return end
    local closestDist, closestPos, closestPos2 = math.huge, nil, nil
    for _, p in ipairs(interestingPositions) do
        local dist = Vector2.DistanceSquared(p.Position.ToVector2(), Submarine.MainSub.WorldPosition)
        if dist < closestDist then
            if closestPos then closestPos2 = closestPos end
            closestDist = dist
            closestPos = p.Position
        end
    end
    if closestPos == nil then return end
    if closestPos2 then
        if Submarine.PickBody(
                ConvertUnits.ToSimUnits(closestPos2.ToVector2()),
                ConvertUnits.ToSimUnits(Submarine.MainSub.WorldPosition),
                nil, Physics.CollisionLevel) == nil then
            closestPos = closestPos2
        end
    end
    local spawnPosition = closestPos.ToVector2()

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Clown " .. info.Name
    info.Job = Job(JobPrefab.Get("mechanic"))

    local character = Character.Create(info, spawnPosition, info.Name, 0, false, true)

    event.Character = character
    event.Wreck = wreck

    character.CanSpeak = false
    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    for item in character.Inventory.AllItemsMod do
        if not character.Inventory.IsInLimbSlot(item, InvSlotType.Card)
            and not character.Inventory.IsInLimbSlot(item, InvSlotType.Headset) then
            item.Drop()
            Entity.Spawner.AddEntityToRemoveQueue(item)
        end
    end

    local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if idCard then
        spedit {
            nonplayerteaminteractable = true
        }:apply(idCard)
    end

    local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
    if headset then
        spedit {
            [{ "WifiComponent", "TeamID" }] = CharacterTeamType.Team1
        }:apply(headset)
    end

    clownitbu:give(character)

    character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["pressurestabilized"].Instantiate(math.huge))
    character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["durationincrease"].Instantiate(math.huge))
    character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["combatstimulant"].Instantiate(20))
    character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["strengthen"].Instantiate(120))
    character.CharacterHealth.ApplyAffliction(character.AnimController.MainLimb, AfflictionPrefab.Prefabs["haste"].Instantiate(120))

    character.GiveTalent("enrollintoclowncollege")
    character.GiveTalent("waterprankster")
    character.GiveTalent("chonkyhonks")
    character.GiveTalent("daringdolphin")
    character.GiveTalent("easyturtle")
    character.GiveTalent("ballastdenizen")

    character.SetStun(5)

    Traitormod.RoundEvents.SendEventMessage(l10nmgr { "RandomEvents", "AbyssMadClown", "Start" }:format(event.AmountPoints), "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Abyss Mad Clown", function(client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)
        Traitormod.SendMessageCharacter(character, l10nmgr { "RandomEvents", "AbyssMadClown", "Role" }:format(event.SurvivalInterval, event.AmountPointsClownAlive, event.AwardClownLimit), "InfoFrameTabButton.Mission")
    end, character)

    local survivalTime = 0
    local clownAwardTimes = 0
    local subBorder = Submarine.MainSub.GetDockedBorders()
    think {
        identifier = "AbyssMadClown.think", interval = 60,
        function()
            if character.IsDead then
                local isHandcuffedAndNaked = false
                if character.HasEquippedItem("handcuffs") then
                    isHandcuffedAndNaked = true
                    for _, slot in pairs({ InvSlotType.OuterClothes, InvSlotType.InnerClothes, InvSlotType.Head }) do
                        if character.Inventory.GetItemInLimbSlot(slot) then
                            isHandcuffedAndNaked = false
                            break
                        end
                    end
                end
                local amountPoints = isHandcuffedAndNaked and event.AmountPoints or event.AmountPoints / 3
                if isHandcuffedAndNaked then
                    itbu {
                        {
                            identifier = "empgrenade",
                            properties = { condition = 0 }
                        }
                    }:spawnat(character.WorldPosition)
                    for _, limb in ipairs(character.AnimController.Limbs) do
                        character.TrySeverLimbJoints(limb, 1, 114514, true)
                    end
                    Traitormod.RoundEvents.SendEventMessage(l10nmgr { "RandomEvents", "AbyssMadClown", "KilledCruelly" }:format(amountPoints), "CrewWalletIconLarge")
                else
                    Traitormod.RoundEvents.SendEventMessage(l10nmgr { "RandomEvents", "AbyssMadClown", "KilledNormally" }:format(amountPoints), "CrewWalletIconLarge")
                end
                for item in character.Inventory.AllItemsMod do
                    if item.Prefab.Identifier.value == "toolbelt" and item.NonInteractable == true then
                        item.Drop()
                        Entity.Spawner.AddEntityToRemoveQueue(item)
                    end
                end
                for _, client in pairs(Client.ClientList) do
                    if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
                        Traitormod.AwardPoints(client, amountPoints)
                        Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, amountPoints), "InfoFrameTabButton.Mission")
                    end
                end
                event.End()
            elseif clownAwardTimes < event.AwardClownLimit then
                if character.Submarine == Submarine.MainSub then
                    survivalTime = survivalTime + 1
                    if survivalTime % event.SurvivalInterval == 0 then
                        local client = Traitormod.FindClientCharacter(event.Character)
                        if client then
                            clownAwardTimes = clownAwardTimes + 1
                            Traitormod.AwardPoints(client, event.AmountPointsClownAlive)
                            Traitormod.SendChatMessage(client,
                                l10nmgr { "RandomEvents", "AbyssMadClown", "PointsAwardedPerSurvivalInterval" }
                                :format(
                                    event.SurvivalInterval, event.AmountPointsClownAlive,
                                    clownAwardTimes, event.AwardClownLimit
                                ),
                                Color.LightGreen
                            )

                            if clownAwardTimes == event.AwardClownLimit then
                                Traitormod.RoundEvents.SendEventMessage(l10nmgr { "RandomEvents", "AbyssMadClown", "Escape2Crews" }.value, "InfoFrameTabButton.Mission", Color.Yellow)
                                Traitormod.SendMessageCharacter(character, l10nmgr { "RandomEvents", "AbyssMadClown", "Escape2Clown" }:format(event.EscapeDistance / 100, event.AmountPointsClownEscape), "InfoFrameTabButton.Mission")
                            end
                        end
                    end
                end
            else
                local subPosition = Submarine.MainSub.WorldPosition
                if not Submarine.RectContains(
                        Rectangle(
                            subPosition.X - event.EscapeDistance, subPosition.Y + event.EscapeDistance,
                            subBorder.Width + event.EscapeDistance * 2, subBorder.Height + event.EscapeDistance * 2), character.WorldPosition) then
                    local client = Traitormod.FindClientCharacter(event.Character)
                    Traitormod.RoundEvents.SendEventMessage(l10nmgr { "RandomEvents", "AbyssMadClown", "EscapeComplete2Crews" }.value, "InfoFrameTabButton.Mission", Color.Yellow)
                    if client then
                        Traitormod.AwardPoints(client, event.AmountPointsClownEscape)
                        Traitormod.SendChatMessage(client, l10nmgr { "RandomEvents", "AbyssMadClown", "EscapeComplete2Clown" }:format(event.AmountPointsClownEscape), Color.LightGreen)
                    end
                    Entity.Spawner.AddEntityToRemoveQueue(event.Character)
                    event.End()
                end
            end
        end
    }
end


event.End = function(isEndRound)
    Hook.Remove("think", "AbyssMadClown.think")
end

return event
