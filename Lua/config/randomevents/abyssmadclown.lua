local itbu = require "itbu"
local think = require "think"

local event = {}

event.Name = "AbyssMadClown"
event.MinRoundTime = 1
event.MaxRoundTime = 15
event.MinIntensity = 0.000
event.MaxIntensity = 0.666
event.ChancePerMinute = 0.15
event.OnlyOncePerRound = true

event.AmountPoints = 800
event.AmountPointsClown = 500

local clownitbu = itbu {
    { identifier = "clowncostume", equip = true },
    {
        identifier = "clowndivingmask",
        equip = true,
        inventory = {
            { identifier = "oxygenitetank", quality = 3 }
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
    {
        identifier = "toolbelt",
        equip = true,
        properties = { noninteractable = true },
        inventory = {
            {
                identifier = "sonarbeacon",
                properties = {
                    noninteractable = true,
                    [{ "custominterface", "elementstates" }] = "true,",
                    [{ "custominterface", "signals" }] = ";铙钹声",
                },
                serverevents = "custominterface",
                inventory = {
                    {
                        identifier = "batterycell",
                        properties = { indestructible = true }
                    }
                }
            },
        }
    }
}

event.Start = function()
    if #Level.Loaded.Wrecks == 0 then
        return
    end

    local wreck = Level.Loaded.Wrecks[1]

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Pirate " .. info.Name
    info.Job = Job(JobPrefab.Get("mechanic"))

    local character = Character.Create(info, wreck.WorldPosition, info.Name, 0, false, true)

    event.Character = character
    event.Wreck = wreck

    character.CanSpeak = false
    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    local idCard = character.Inventory.GetItemInLimbSlot(InvSlotType.Card)
    if idCard then
        idCard.NonPlayerTeamInteractable = true
        local prop = idCard.SerializableProperties[Identifier("NonPlayerTeamInteractable")]
        Networking.CreateEntityEvent(idCard, Item.ChangePropertyEventData(prop, idCard))
    end

    local headset = character.Inventory.GetItemInLimbSlot(InvSlotType.Headset)
    if headset then
        local wifi = headset.GetComponentString("WifiComponent")
        if wifi then
            wifi.TeamID = CharacterTeamType.Team1
        end
    end

    local oldClothes = character.Inventory.GetItemInLimbSlot(InvSlotType.InnerClothes)
    oldClothes.Drop()
    Entity.Spawner.AddEntityToRemoveQueue(oldClothes)

    clownitbu:give(character)

    local text = string.format(Traitormod.Language.AbyssMadClown, event.AmountPoints)
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Abyss Mad Clown", function(client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)
    end, character)

    think {
        identifier = "AbyssMadClown.think", interval = 60,
        function()
            if character.IsDead then
                event.End()
            end
        end
    }
end


event.End = function(isEndRound)
    Hook.Remove("think", "AbyssMadClown.think")

    if isEndRound then
        if event.Character and not event.Character.IsDead and event.Character.Submarine == event.Wreck then
            local client = Traitormod.FindClientCharacter(event.Character)
            if client then
                Traitormod.AwardPoints(client, event.AmountPointsClown)
                Traitormod.SendMessage(client,
                    string.format(Traitormod.Language.ReceivedPoints, event.AmountPointsClown),
                    "InfoFrameTabButton.Mission")
            end
        end

        return
    end

    local text = string.format(Traitormod.Language.PirateKilled, event.AmountPoints)

    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    for _, client in pairs(Client.ClientList) do
        if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
            Traitormod.AwardPoints(client, event.AmountPoints)
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.AmountPoints),
                "InfoFrameTabButton.Mission")
        end
    end
end

return event
