function SteamDetails()
    ModBase.SetSteamWorkshopDetails("ModLib", "Experimental mod utilities library.", {"utility"}, "ModImage.png")
end

function ResetBotScript()
    local botUID = ModBot.GetAllBotUIDs()[1]
    ModDebug.Log("botUID " .. botUID)

    -- usage example
    ModLib.SetScript(
        botUID,
        {
            Repeat.Forever(
                {
                    Repeat.Until.Hands.Full(
                        {
                            FindNearestObject(Item.Coal, "85 89 102 106"),
                            MoveToObject(Item.Coal),
                            PickObject(Item.Coal)
                        }
                    )
                }
            )
        }
    )
end

function AfterLoad_LoadedWorld()
    if ModBase.GetGameVersionMajor() >= 137 or ModBase.GetGameVersionMinor() >= 29 then
        ResetBotScript()
    else
        ModDebug.Log("ModLib requires Autonauts 137.29 or higher")
    end
end
