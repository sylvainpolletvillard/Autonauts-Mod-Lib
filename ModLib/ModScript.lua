-- ModScript
ModScript = {}

ModScript.AddInstruction = function(Type, ArgName, Args, Children1, Children2)
    ModDebug.Log(
        "AddInstruction " .. (Type or "nil") .. " - " .. (ArgName or "nil") .. " - " .. json.serialize(Args or {})
    )
    local instruction = {}

    instruction.Type = Type
    instruction.Line = -1
    instruction.OT = "Total"
    instruction.UID = 0
    instruction.X = 0
    instruction.Y = 0
    instruction.V1 = ""
    instruction.V2 = ""
    instruction.A = "Total"
    instruction.R = ""
    instruction.AT = 4
    instruction.AOT = "Total"

    if (ArgName ~= nil) then
        instruction.ArgName = ArgName
    end

    if (Args ~= nil) then
        if (Args.OT ~= nil) then
            instruction.OT = Args.OT
        end
        if (Args.UID ~= nil) then
            instruction.UID = Args.UID
        end
        if (Args.X ~= nil) then
            instruction.X = Args.X
        end
        if (Args.Y ~= nil) then
            instruction.Y = Args.Y
        end
        if (Args.A ~= nil) then
            instruction.A = Args.A
        end
        if (Args.R ~= nil) then
            instruction.R = Args.R
        end
        if (Args.AT ~= nil) then
            instruction.AT = Args.AT
        end
        if (Args.AOT ~= nil) then
            instruction.AOT = Args.AOT
        end
    end

    if (Children1 ~= nil) then
        instruction.Children = Children1
    end
    if (Children2 ~= nil) then
        instruction.Children2 = Children2
    end

    return instruction
end

ModScript.Instruction = {
    Forever = "InstructionForever",
    Repeat = "InstructionRepeat",
    Wait = "InstructionWait",
    If = "InstructionIf",
    IfElse = "InstructionIfElse",
    ExitRepeat = "InstructionExitRepeat",
    Move = "InstructionMove",
    MoveLessOne = "InstructionMoveLessOne",
    MoveRange = "InstructionMoveRange",
    MoveForwards = "InstructionMoveForwards",
    MoveBackwards = "InstructionMoveBackwards",
    TurnAt = "InstructionTurnAt",
    StopAt = "InstructionStopAt",
    DropAll = "InstructionDropAll",
    Pickup = "InstructionPickup",
    TakeResource = "InstructionTakeResource",
    AddResource = "InstructionAddResource",
    StowObject = "InstructionStowObject",
    RecallObject = "InstructionRecallObject",
    CycleObject = "InstructionCycleObject",
    SwapObject = "InstructionSwapObject",
    UseInHands = "InstructionUseInHands",
    Make = "InstructionMake",
    Recharge = "InstructionRecharge",
    Shout = "InstructionShout",
    EngageObject = "InstructionEngageObject",
    DisengageObject = "InstructionDisengageObject",
    SetValue = "InstructionSetValue",
    FindNearestTile = "InstructionFindNearestTile",
    FindNearestObject = "InstructionFindNearestObject"
}

ModScript.Action = {
    Hide = "Hide",
    Show = "Show",
    Move = {
        To = "MoveTo",
        ToLessOne = "MoveToLessOne",
        ToRange = "MoveToRange",
        Forwards = "MoveForwards",
        Backwards = "MoveBackwards",
        Forward = "MoveForward",
        Direction = "MoveDirection"
    },
    Turn = "Turn",
    TurnAt = "TurnAt",
    Stop = "Stop",
    StopAt = "StopAt",
    LookAt = "LookAt",
    SetTool = "SetTool",
    UseInHands = "UseInHands",
    DropAll = "DropAll",
    Pickup = "Pickup",
    Make = "Make",
    TakeResource = "TakeResource",
    AddResource = "AddResource",
    ReserveResource = "ReserveResource",
    UnreserveResource = "UnreserveResource",
    StowObject = "StowObject",
    RecallObject = "RecallObject",
    CycleObject = "CycleObject",
    SwapObject = "SwapObject",
    BeingHeld = "BeingHeld",
    Dropped = "Dropped",
    Stowed = "Stowed",
    Recalled = "Recalled",
    Poke = "Poke",
    EngageObject = "EngageObject",
    DisengageObject = "DisengageObject",
    Engaged = "Engaged",
    Disengaged = "Disengaged",
    SetValue = "SetValue",
    GetValue = "GetValue",
    SetBagged = "SetBagged",
    SetUnbagged = "SetUnbagged",
    Recharge = "Recharge",
    Refresh = "Refresh",
    RefreshFirst = "RefreshFirst",
    Bump = "Bump",
    Whistle = "Whistle",
    Shout = "Shout",
    UpdateLights = "UpdateLights",
    SpawnEnd = "SpawnEnd",
    Fail = "Fail",
    Total = "Total"
}

ModScript.FindNearestObject = function(ItemType, Zone)
    return ModScript.AddInstruction(
        ModScript.Instruction.FindNearestObject,
        Zone .. " Full",
        {
            OT = ItemType,
            AT = 0,
            A = ModScript.Action.Pickup
        }
    )
end

ModScript.MoveToObject = function(ItemType)
    return ModScript.AddInstruction(
        ModScript.Instruction.Move,
        nil,
        {
            OT = ItemType,
            AT = 0,
            A = ModScript.Action.Pickup
        }
    )
end

ModScript.PickObject = function(ItemType)
    return ModScript.AddInstruction(
        ModScript.Instruction.Pickup,
        nil,
        {
            OT = ItemType,
            AT = 0,
            A = ModScript.Action.Pickup
        }
    )
end

local function ScriptBlock(Type, ArgName, Args)
    return function(Children, Children2)
        return ModScript.AddInstruction(Type, ArgName, Args, Children, Children2)
    end
end

local function RepeatInstruction(UntilArg, Args)
    return ScriptBlock(Instruction.Repeat, UntilArg, Args)
end

local function RepeatInstructionUID(UntilArg)
    return function(UID)
        return RepeatInstruction(UntilArg, {UID = UID})
    end
end

ModScript.Repeat = {
    Forever = RepeatInstruction("RepeatForever"),
    Times = RepeatInstruction("RepeatTimes"),
    Until = {
        Hands = {
            Full = RepeatInstruction("RepeatHandsFull"),
            NotFull = RepeatInstruction("RepeatHandsNotFull"),
            Empty = RepeatInstruction("RepeatHandsEmpty"),
            NotEmpty = RepeatInstruction("RepeatHandsNotEmpty")
        },
        Inventory = {
            Full = RepeatInstruction("RepeatInventoryFull"),
            NotFull = RepeatInstruction("RepeatInventoryNotFull"),
            Empty = RepeatInstruction("RepeatInventoryEmpty"),
            NotEmpty = RepeatInstruction("RepeatInventoryNotEmpty")
        },
        Building = {
            Full = RepeatInstructionUID("RepeatBuildingFull"),
            NotFull = RepeatInstructionUID("RepeatBuildingNotFull"),
            Empty = RepeatInstructionUID("RepeatBuildingEmpty"),
            NotEmpty = RepeatInstructionUID("RepeatBuildingNotEmpty")
        },
        HeldObject = {
            Full = RepeatInstruction("RepeatHeldObjectFull"),
            NotFull = RepeatInstruction("RepeatHeldObjectNotFull"),
            Empty = RepeatInstruction("RepeatHeldObjectEmpty"),
            NotEmpty = RepeatInstruction("RepeatHeldObjectNotEmpty")
        },
        Hear = RepeatInstruction("RepeatHear")
    }
}

local function IfInstruction(ConditionArg, Args)
    return function(Children, ElseChildren)
        if (ElseChildren ~= nil) then
            return AddInstruction(Instruction.IfElse, ConditionArg, Args, Children, ElseChildren)
        else
            return AddInstruction(Instruction.If, ConditionArg, Args, Children)
        end
    end
end

local function IfInstructionUID(ConditionArg)
    return function(UID)
        return IfInstruction(ConditionArg, {UID = UID})
    end
end

ModScript.If = {
    Hands = {
        Full = IfInstruction("IfHandsFull"),
        NotFull = IfInstruction("IfHandsNotFull"),
        Empty = IfInstruction("IfHandsEmpty"),
        NotEmpty = IfInstruction("IfHandsNotEmpty")
    },
    Inventory = {
        Full = IfInstruction("IfInventoryFull"),
        NotFull = IfInstruction("IfInventoryNotFull"),
        Empty = IfInstruction("IfInventoryEmpty"),
        NotEmpty = IfInstruction("IfInventoryNotEmpty")
    },
    Building = {
        Full = IfInstructionUID("IfBuildingFull"),
        NotFull = IfInstructionUID("IfBuildingNotFull"),
        Empty = IfInstructionUID("IfBuildingEmpty"),
        NotEmpty = IfInstructionUID("IfBuildingNotEmpty")
    },
    HeldObject = {
        Full = IfInstruction("IfHeldObjectFull"),
        NotFull = IfInstruction("IfHeldObjectNotFull"),
        Empty = IfInstruction("IfHeldObjectEmpty"),
        NotEmpty = IfInstruction("IfHeldObjectNotEmpty")
    },
    Hear = "IfHear"
}

ModScript.SetBotScript = function(botUID, script)
    ModDebug.Log("SetScript " .. botUID)
    local serialized_script = json.serialize(script)
    local botName = ModBot.GetName(botUID)
    ModDebug.Log("serialized_script " .. serialized_script)
    if serialized_script ~= "" then
        ModDebug.Log(
            "About to attempt to overwrite bot (" .. botName .. ") script: " .. ModBot.GetScriptSavegameFormat(botUID)
        )
        if ModBot.SetScriptSavegameFormat(botUID, serialized_script, true) then
            ModDebug.Log("ModBot.SetScriptSavegameFormat DONE : Bot (" .. botName .. ") re-programmed!")
            ModBot.RechargeBot(botUID)
            ModBot.StartScript(botUID)
        end
    end
end
