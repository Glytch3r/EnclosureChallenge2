----------------------------------------------------------------
-----  ▄▄▄   ▄    ▄   ▄  ▄▄▄▄▄   ▄▄▄   ▄   ▄   ▄▄▄    ▄▄▄  -----
----- █   ▀  █    █▄▄▄█    █    █   ▀  █▄▄▄█  ▀  ▄█  █ ▄▄▀ -----
----- █  ▀█  █      █      █    █   ▄  █   █  ▄   █  █   █ -----
-----  ▀▀▀▀  ▀▀▀▀   ▀      ▀     ▀▀▀   ▀   ▀   ▀▀▀   ▀   ▀ -----
----------------------------------------------------------------
--                                                            --
--   Project Zomboid Modding Commissions                      --
--   https://steamcommunity.com/id/glytch3r/myworkshopfiles   --
--                                                            --
--   ▫ Support  ꞉   https://ko-fi.com/glytch3r                --
--   ▫ Youtube  ꞉   https://www.youtube.com/@glytch3r         --
--   ▫ Github   ꞉   https://github.com/Glytch3r               --
--                                                            --
----------------------------------------------------------------
----- ▄   ▄   ▄▄▄   ▄   ▄   ▄▄▄     ▄      ▄   ▄▄▄▄  ▄▄▄▄  -----
----- █   █  █   ▀  █   █  ▀   █    █      █      █  █▄  █ -----
----- ▄▀▀ █  █▀  ▄  █▀▀▀█  ▄   █    █    █▀▀▀█    █  ▄   █ -----
-----  ▀▀▀    ▀▀▀   ▀   ▀   ▀▀▀   ▀▀▀▀▀  ▀   ▀    ▀   ▀▀▀  -----
----------------------------------------------------------------
--client/EnclosureChallenge_Init.lua
EnclosureChallenge = EnclosureChallenge or {}

EnclosureChallenge.encTick = 0
EnclosureChallenge.EnclosureSize = 189
EnclosureChallenge.MarkerCache = {}

function EnclosureChallenge.spawnPlayer()
    local pl = getPlayer()
    if not pl then return end


    if EnclosureChallenge.isChallenger() then
        EnclosureChallenge.setReturnPointMarker()
    else
        EnclosureChallenge.initChallengeData(pl)
    end
    
end
Events.OnCreatePlayer.Add(EnclosureChallenge.spawnPlayer)


function EnclosureChallenge.initChallengeData(pl)
    if not isIngameState() then return  end

    if not SandboxVars then return end
    pl = pl or getPlayer()
    if not pl then return nil end

    local md = pl:getModData()
    md.EnclosureChallenge = md.EnclosureChallenge or {}
    local ec = md.EnclosureChallenge

    ec.UnlockPoints      = ec.UnlockPoints      or EnclosureChallenge.getStartingUnlockPoints()
    ec.RewardChoice      = ec.RewardChoice      or 0
    ec.Challenges        = ec.Challenges        or {}
    ec.Conquered         = ec.Conquered         or {}
    ec.OriginCoords      = ec.OriginCoords      or {}
    ec.Rebound           = ec.Rebound           or {}
    ec.AdditiveWins      = ec.AdditiveWins      or 0
    ec.RemoteTime        = ec.RemoteTime        or 0
    ec.AdditiveTime      = ec.AdditiveTime      or 0
    ec.RemoteChallenge   = ec.RemoteChallenge   or ""
    ec.AdditiveChallenge = ec.AdditiveChallenge or ""

    ec.GUI               = ec.GUI               or {}
    ec.GUI.posGUI        = ec.GUI.posGUI        or 1
    ec.GUI.textGap       = ec.GUI.textGap       or 42
    ec.GUI.xPercentPos   = ec.GUI.xPercentPos   or 85
    ec.GUI.yPercentPos   = ec.GUI.yPercentPos   or 85
    if ec.DrawGrid == nil then ec.DrawGrid = true end

    return ec
end
function EnclosureChallenge.getStartingUnlockPoints()
    if not isIngameState() then return end

    local def = 1
    if SandboxVars
        and SandboxVars.EnclosureChallenge
        and type(SandboxVars.EnclosureChallenge.StartingUnlockPoints) == "number"
    then
        return SandboxVars.EnclosureChallenge.StartingUnlockPoints
    end
    return def
end

LuaEventManager.AddEvent("OnEnclosureChange")
function EnclosureChallenge.updateMarkers(encStr)
	if getCore():getDebug() then
        print('OnEnclosureChange ' .. tostring(encStr))
	end

   local pl = getPlayer()
   if not pl then return end

   EnclosureChallenge.setMarkers(pl, SandboxVars.EnclosureChallenge.KeepMarkers)
   EnclosureChallenge.addChallengeSymbols(pl)
    
   local x = pl:getX()
   local y = pl:getY()
   local midX, midY = EnclosureChallenge.getEnclosureMidXY(x, y, pl)

end
Events.OnEnclosureChange.Add(EnclosureChallenge.updateMarkers)


function EnclosureChallenge.OutOfBoundHandler()
	local pl = getPlayer()
	if not EnclosureChallenge.isChallenger() then return end

	if EnclosureChallenge.isOutOfBounds(pl) and pl:isAlive() and not EnclosureChallenge.Rebound.inTransit then
		EnclosureChallenge.outOfBoundsPending = true
		EnclosureChallenge.rebound()
		pl:setHaloNote("OUT OF BOUNDS!", 255, 50, 50, 150)
	end
end
Events.OnEnclosureChange.Add(EnclosureChallenge.OutOfBoundHandler)

function EnclosureChallenge.EnforceBoundary(pl)
    if not isIngameState() or not pl or not pl:isAlive() then return end
    if not EnclosureChallenge.isChallenger() then return end
    if EnclosureChallenge.outOfBoundsPending then return end
    if EnclosureChallenge.Rebound and EnclosureChallenge.Rebound.inTransit then return end
    if EnclosureChallenge.isOutOfBounds(pl) then
        EnclosureChallenge.outOfBoundsPending = true
        EnclosureChallenge.rebound()
        pl:setHaloNote("OUT OF BOUNDS!", 255, 50, 50, 150)
    else
        local ec = EnclosureChallenge.getData()
        if ec and EnclosureChallenge.isSafeLastValid(pl) then
            local vehicle = pl:getVehicle()
            ec.LastValid = {
                x = vehicle and vehicle:getX() or pl:getX(),
                y = vehicle and vehicle:getY() or pl:getY(),
                z = pl:getZ(),
            }
        end
    end
end
Events.OnPlayerUpdate.Add(EnclosureChallenge.EnforceBoundary)

function EnclosureChallenge.EnclosureChange(pl)
    if not isIngameState() or not pl then return end

    EnclosureChallenge.OutOfBoundHandler()

    EnclosureChallenge.encTick = EnclosureChallenge.encTick + 1
    if EnclosureChallenge.encTick % 10 ~= 0 then return end

    local encStr = EnclosureChallenge.getEnclosureStr(pl)
    if not encStr then return end

    if  EnclosureChallenge.PreviousEnclosure == nil or EnclosureChallenge.PreviousEnclosure == ""  then
        EnclosureChallenge.PreviousEnclosure = encStr
    end

    if EnclosureChallenge.PreviousEnclosure ~= encStr then
        triggerEvent("OnEnclosureChange", encStr)
        EnclosureChallenge.PreviousEnclosure = encStr
    end
end
Events.OnPlayerUpdate.Add(EnclosureChallenge.EnclosureChange)

