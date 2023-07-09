local itbu = require "utilbelt.itbu"

local event = {}

event.Name = "WreckPirate"
event.MinRoundTime = 1
event.MaxRoundTime = 15
event.MinIntensity = 0
event.MaxIntensity = 1
event.ChancePerMinute = 0.15
event.OnlyOncePerRound = true

event.AmountPoints = 800
event.AmountPointsPirate = 500

local sonarmarkitbu = itbu {
    {
        identifier = "weaponholder",
        install = true,
        properties = {
            noninteractable = true,
            hiddeningame = true
        },
        inventory = {
            {
                identifier = "sonarbeacon",
                tags = "mountableweapon",
                properties = {
                    noninteractable = true,
                    [{ "custominterface", "elementstates" }] = "true,",
                    [{ "custominterface", "signals" }] = ";Last known pirate position",
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

local pirateitbu = itbu {
    { identifier = "pirateclothes", equip = true },
    {
        identifier = "pucs",
        equip = true,
        inventory = {
            { identifier = "combatstimulantsyringe" },
            { identifier = "oxygenitetank" }
        }
    },
    {
        identifier = "shotgun",
        inventory = {
            { identifier = "shotgunshell", fillinventory = true }
        }
    },
    { identifier = "shotgunshell", stacks = true },
    {
        identifier = "smg",
        inventory = {
            { identifier = "smgmagazinedepletedfuel" }
        }
    },
    { identifier = "smgmagazine", stacks = 1 },
    { identifier = "antibiotics", amount = 4 },
    { identifier = "antiparalysis", amount = 2 },
    { identifier = "oxygenitetank", amount = 4 },
    {
        identifier = "toolbelt",
        inventory = {
            { identifier = "antidama1", amount = 2 },
            { identifier = "antibleeding1", amount = 6 },
            { identifier = "alienblood" },
            { identifier = "fuelrod" },
            {
                identifier = "underwaterscooter",
                inventory = {
                    { identifier = "batterycell" }
                }
            },
            {
                identifier = "handheldsonar",
                inventory = {
                    { identifier = "batterycell" }
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
    event.EnteredMainSub = false

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

    sonarmarkitbu:spawnat(wreck.WorldPosition)
    pirateitbu:give(character)

    local text = string.format(Traitormod.Language.WreckPirate, event.AmountPoints)
    Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

    Traitormod.GhostRoles.Ask("Wreck Pirate", function(client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)
    end, character)

    Hook.Add("think", "WreckPirate.Think", function()
        if character.IsDead then
            event.End()
        end

        if character.Submarine == Submarine.MainSub and not event.EnteredMainSub then
            event.EnteredMainSub = true
            Traitormod.RoundEvents.SendEventMessage(Traitormod.Language.PirateInside)
        end
    end)
end


event.End = function(isEndRound)
    Hook.Remove("think", "WreckPirate.Think")

    if isEndRound then
        if event.Character and not event.Character.IsDead and event.Character.Submarine == event.Wreck then
            local client = Traitormod.FindClientCharacter(event.Character)
            if client then
                Traitormod.AwardPoints(client, event.AmountPointsPirate)
                Traitormod.SendMessage(client,
                    string.format(Traitormod.Language.ReceivedPoints, event.AmountPointsPirate),
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
