local itbu = require "utilbelt.itbu"
local itbat = require "utilbelt.itbat"

local event = {}

event.Name = "Prisoner"
event.MinRoundTime = 0
event.MaxRoundTime = 5
event.MinIntensity = 0
event.MaxIntensity = 0.3
event.ChancePerMinute = 0.07
event.OnlyOncePerRound = true
event.Award = 1500

event.Start = function()
    local position = nil

    for key, value in pairs(Submarine.MainSub.GetWaypoints(true)) do
        if value.AssignedJob and value.AssignedJob.Identifier == "securityofficer" then
            position = value.WorldPosition
            break
        end
    end

    if position == nil then
        position = Submarine.MainSub.WorldPosition
    end

    local info = CharacterInfo(Identifier("human"))
    info.Name = "Prisoner " .. info.Name
    info.Job = Job(JobPrefab.Get("assistant"))

    local character = Character.Create(info, position, info.Name, 0, false, true)

    event.Character = character

    character.TeamID = CharacterTeamType.Team2
    character.GiveJobItems(nil)

    itbat {
        slottype = { InvSlotType.InnerClothes, InvSlotType.Any },
        drop = true,
        remove = true
    }:runforinv(character.Inventory)

    itbu {
        { identifier = "prisonerclothes", equip = true },
        { identifier = "handcuffs", tags = "fakehandcuffs", equip = true },
    }:give(character)

    local text = string.format(Traitormod.Language.PrisonerAboard, event.Award)
    Traitormod.RoundEvents.SendEventMessage(text, "GameModeIcon.sandbox", Color.Yellow)

    Traitormod.GhostRoles.Ask("Prisoner", function(client)
        Traitormod.LostLivesThisRound[client.SteamID] = false
        client.SetClientCharacter(character)

        Traitormod.SendMessageCharacter(character, string.format(Traitormod.Language.PrisonerYou, event.Award), "InfoFrameTabButton.Mission")
    end, character)

    Hook.Add("think", "Prisoner.Think", function()
        if character.IsDead then
            event.End()
            return
        end

        if event.Character.Submarine == Submarine.MainSub then return end
        if Vector2.Distance(event.Character.WorldPosition, Submarine.MainSub.WorldPosition) < 5000 then return end

        local client = Traitormod.FindClientCharacter(event.Character)
        if client then
            Traitormod.AwardPoints(client, event.Award)
            Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.Award), "InfoFrameTabButton.Mission")
            Entity.Spawner.AddEntityToRemoveQueue(event.Character)
        end

        event.End()
    end)
end


event.End = function(isEndRound)
    Hook.Remove("think", "Prisoner.Think")

    if event.Character and event.Character.IsDead then
        return
    end

    if isEndRound and Traitormod.EndReached(event.Character, 8000) then
        local text = string.format(Traitormod.Language.PrisonerSuccess, event.Award)

        Traitormod.RoundEvents.SendEventMessage(text, "CrewWalletIconLarge")

        for _, client in pairs(Client.ClientList) do
            if client.Character and not client.Character.IsDead and client.Character.TeamID == CharacterTeamType.Team1 then
                if not Traitormod.RoleManager.IsAntagonist(client.Character) then
                    Traitormod.AwardPoints(client, event.Award)
                    Traitormod.SendMessage(client, string.format(Traitormod.Language.ReceivedPoints, event.Award), "InfoFrameTabButton.Mission")
                end
            end
        end
    else
        local text = Traitormod.Language.PrisonerFail
        Traitormod.RoundEvents.SendEventMessage(text, "InfoFrameTabButton.Mission", Color.Yellow)
    end
end

return event
