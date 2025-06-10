
EnclosureChallenge = EnclosureChallenge or {}

--[[ function EnclosureChallenge.getCurrentEnclosure(pl)
    pl = pl or getPlayer()
    if not pl then return nil end
    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end
    return math.ceil(pl:getX() / size)
end
 ]]
function EnclosureChallenge.getCurrentEnclosure(targ, isTab)
    pl = pl or getPlayer()
    if not pl then return nil end
    targ = targ or pl
    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end

    local x = round(targ:getX() - 1 ) / size
    local y = round(targ:getX() - 1 ) / size

    if isTab then
        return  {x=x, y=y}
    end
    return x, y
end



function EnclosureChallenge.getEnclosure(targ)
    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end
    targ = targ or getPlayer()

    local x = targ:getX()
    x = math.floor((x - 1) / size)

    local y = targ:getY()
    y = math.floor((y - 1) / size)
    if not x or not y then return nil end

    return { x=x, y=y}
end


function EnclosureChallenge.sfx(isStart)
    if isStart then
        getSoundManager():playUISound("EnclosureChallenge_In")
    else
        getSoundManager():playUISound("EnclosureChallenge_Out")
    end
end

function EnclosureChallenge.parseColor(str)
    str = str or SandboxVars.EnclosureChallengeGUI.MarkerColor or "0.64;0.13;0.04;0.7"
    local r, g, b, a = str:match("^([^;]+);([^;]+);([^;]+);?([^;]*)$")
    return {
        r = tonumber(r) or 1,
        g = tonumber(g) or 1,
        b = tonumber(b) or 1,
        a = tonumber(a) or 1,
    }
end



function EnclosureChallenge.getEnclosureColor(targ)
    if not isIngameState() then return end

    local colStr = SandboxVars.EnclosureChallengeGUI.BadColor

    targ = targ or getPlayer()
    if not targ then return EnclosureChallenge.parseColor(colStr) end
    local status = EnclosureChallenge.getEnclosureStatus(targ)
    if not status then return EnclosureChallenge.parseColor(colStr) end
    if status == "Neutral" then
        colStr = SandboxVars.EnclosureChallengeGUI.NeutralColor
    elseif status == "Conquered" then
        colStr = SandboxVars.EnclosureChallengeGUI.GoodColor
    end

    return EnclosureChallenge.parseColor(colStr) or {  r = 1,  g = 1,   b = 1,  a = 1}
end

function EnclosureChallenge.getEnclosureStatus(targ)
    if not isIngameState() then return end

    local str = "Neutral"
    local targ = targ or getPlayer()
    if not targ then return str end


    if EnclosureChallenge.isConquered(targ) then
        str = "Conquered"
    elseif EnclosureChallenge.isUnlocked(targ) then
        str = "Unlocked"
    end

    return str
end



-----------------------            ---------------------------
function EnclosureChallenge.checkDist(pl, sq)
	local dist = pl:DistTo(sq:getX(), sq:getY())
    return math.floor(dist)
end

function EnclosureChallenge.isWithinRange(pl, sq, range)
	local dist = pl:DistTo(sq:getX(), sq:getY())
    return dist <= range
end


function EnclosureChallenge.doRoll(percent)
	if percent <= 0 then return false end
	if percent >= 100 then return true end
	return percent >= ZombRand(1, 101)
end

-----------------------            ---------------------------

table.insert(keyBinding, {value = "[Enclosure Challenge]"})
table.insert(keyBinding, {value = "Adjust_Enclosure_GUI_Opacity", key = Keyboard.KEY_O})
table.insert(keyBinding, {value = "Adjust_Enclosure_GUI_Position", key = Keyboard.KEY_P})

table.insert(keyBinding, {value = "Toggle_Enclosure_MouseTip", key = Keyboard.KEY_N})


-----------------------            ---------------------------


require "Definitions/MapSymbolDefinitions"
MapSymbolDefinitions.getInstance():addTexture("Enclosure_Challenge", "media/ui/LootableMaps/Enclosure_Challenge.png")
MapSymbolDefinitions.getInstance():addTexture("Enclosure_Conquered", "media/ui/LootableMaps/Enclosure_Conquered.png")
MapSymbolDefinitions.getInstance():addTexture("Enclosure_Edge", "media/ui/LootableMaps/Enclosure_Edge.png")

MapSymbolDefinitions.getInstance():addTexture("EnclosureEdge", "media/ui/LootableMaps/EnclosureEdge.png")

--[[
-----------------------            ---------------------------
function EnclosureChallenge.anyToXYZ(input)
    local pl = getPlayer()
    if not input then
        local sq = pl and pl:getCurrentSquare()
        if sq then
            return sq:getX(), sq:getY(), sq:getZ()
        else
            return nil, nil, nil
        end
    end

    if type(input) == "table" then
        if input.x and input.y then
            return input.x, input.y, input.z or 0
        end
    elseif instanceof(input, "IsoGridSquare") then
        return input:getX(), input:getY(), input:getZ()
    elseif instanceof(input, "IsoPlayer") or instanceof(input, "IsoMovingObject") then
        local sq = input:getCurrentSquare()
        if sq then
            return sq:getX(), sq:getY(), sq:getZ()
        end
    end
    if pl then
        local sq = pl:getCurrentSquare()
        if sq then
            return sq:getX(), sq:getY(), sq:getZ()
        end
    end
    return nil, nil, nil
end

function EnclosureChallenge.anyToSq(input)
    local pl = getPlayer()
    if not input then
        if pl then
            return pl:getCurrentSquare()
        else
            return nil
        end
    end

    if instanceof(input, "IsoGridSquare") then
        return input
    elseif instanceof(input, "IsoPlayer") or instanceof(input, "IsoMovingObject") then
        return input:getCurrentSquare()
    elseif type(input) == "table" and input.x and input.y then
        local z = input.z or 0
        return getCell():getGridSquare(input.x, input.y, z)
    end

    if pl then
        return pl:getCurrentSquare()
    end

    return nil
end

function EnclosureChallenge.anyToTable(input)
    local pl = getPlayer()
    if not input then
        if pl then
            local sq = pl:getCurrentSquare()
            if sq then
                return { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
            end
        end
        return nil
    end

    if type(input) == "table" then
        if input.x and input.y then
            return { x = input.x, y = input.y, z = input.z or 0 }
        end
    elseif instanceof(input, "IsoGridSquare") then
        return { x = input:getX(), y = input:getY(), z = input:getZ() }
    elseif instanceof(input, "IsoPlayer") or instanceof(input, "IsoMovingObject") then
        local sq = input:getCurrentSquare()
        if sq then
            return { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
        end
    end

    if pl then
        local sq = pl:getCurrentSquare()
        if sq then
            return { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
        end
    end

    return nil
end
 ]]