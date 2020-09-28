function SteamDetails()
    ModBase.SetSteamWorkshopDetails("ModLib", "Experimental mod utilities library.", {"utility"}, "ModImage.png")
end

function ResetBotScript()
    local botUID = ModBot.GetAllBotUIDs()[0]

    -- usage example
    ModLib.SetScript(
        botUID,
        {
            Repeat.Forever(
                {
                    Repeat.Until.Hands.Full(
                        {
                            Instruction.FindNearestObject(Item.Coal),
                            Instruction.Move(Target),
                            Instruction.Pickup(Target)
                        }
                    ),
                    Instruction.Move(storageUID),
                    Repeat.Until.Hands.Empty(
                        {
                            Instruction.AddResource(storageUID)
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
