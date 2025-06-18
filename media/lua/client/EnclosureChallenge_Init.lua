--[[██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|                        				 Custom  PZ  Mod  Developer  for  Hire													  |
|‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾|
|                       	Portfolio:  https://steamcommunity.com/id/glytch3r/myworkshopfiles/							          |
|                       		                                    														 	  |
|                       	Discord:    Glytch3r#1337 / glytch3r															      |
|                       		                                    														 	  |
|                       	Support:    https://ko-fi.com/glytch3r														    	  |
|_______________________________________________________________________________________________________________________________-]]
if not isIngameState() then return  end

require "lua_timers"

EnclosureChallenge = EnclosureChallenge or {}

EnclosureChallenge.encTick = 0
EnclosureChallenge.EnclosureSize = 189
EnclosureChallenge.MarkerCache = {}

function EnclosureChallenge.getStartingUnlockPoints()
    local def = 1
    if SandboxVars
        and SandboxVars.EnclosureChallenge
        and type(SandboxVars.EnclosureChallenge.StartingUnlockPoints) == "number"
    then
        return SandboxVars.EnclosureChallenge.StartingUnlockPoints
    end
    return def
end

-----------------------    init*        ---------------------------
--local  ec = EnclosureChallenge.getData()

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
    ec.GUI.textGap       = ec.GUI.textGap       or 42
    ec.GUI.posGUI        = ec.GUI.posGUI        or 3
    ec.GUI.xPercentPos   = ec.GUI.xPercentPos   or 80
    ec.GUI.yPercentPos   = ec.GUI.yPercentPos   or 80

    return ec
end




Events.OnCreatePlayer.Add(function()
    if not isIngameState() then return end

    local pl = getPlayer()
    if not pl then return end

    EnclosureChallenge.initChallengeData(pl)

    local encStr = EnclosureChallenge.getEnclosureStr(pl)
    EnclosureChallenge.PreviousEnclosure = ""
    EnclosureChallenge.updateMarkers(encStr)

    local ec = EnclosureChallenge.getData()
    if ec and EnclosureChallenge.isChallenger() then

        EnclosureChallenge.setReturnPointMarker()

        if EnclosureChallenge.isRemoteMode() and ec.RemoteTime <= 0 then
            EnclosureChallenge.doWin()
        else
            Events.EveryHours.Add(EnclosureChallenge.RemoteTimer)
        end

        if EnclosureChallenge.isAdditiveMode() then
            Events.EveryHours.Add(EnclosureChallenge.AdditiveTimer)
        end
    end
end)


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
   EnclosureChallenge.drawEnclosureGrid(midX, midY)
   EnclosureChallenge.drawEnclosureGridOverlay(minimap, midX, midY)

end
Events.OnEnclosureChange.Add(EnclosureChallenge.updateMarkers)


function EnclosureChallenge.OutOfBoundHandler()
	local pl = getPlayer()
	if not EnclosureChallenge.isChallenger() then return end

	if EnclosureChallenge.isOutOfBounds(pl) and pl:isAlive() then
		timer:Simple(2, function()
			EnclosureChallenge.rebound()
		end)
		pl:setHaloNote("OUT OF BOUNDS!", 255, 50, 50, 150)
	end
end
Events.OnEnclosureChange.Add(EnclosureChallenge.OutOfBoundHandler)




function EnclosureChallenge.EnclosureChange(pl)
    if not isIngameState() or not pl then return end

    EnclosureChallenge.encTick = EnclosureChallenge.encTick + 1
    if EnclosureChallenge.encTick % 10 ~= 0 then return end

    local encStr = EnclosureChallenge.getEnclosureStr(pl)
    if EnclosureChallenge.PreviousEnclosure == nil then
        EnclosureChallenge.PreviousEnclosure = ""
    end

    if not encStr then return end

    if EnclosureChallenge.PreviousEnclosure ~= encStr then
        triggerEvent("OnEnclosureChange", encStr)
        EnclosureChallenge.PreviousEnclosure = encStr
    end
end
Events.OnPlayerUpdate.Add(EnclosureChallenge.EnclosureChange)



--[[ Events.OnCreatePlayer.Add(function()
    if isIngameState() then
        local pl = getPlayer()
        if not pl then return end

        EnclosureChallenge.initChallengeData(pl)
        EnclosureChallenge.setMarkers(pl)

        local encStr  = EnclosureChallenge.getEnclosureStr(pl)
        EnclosureChallenge.PreviousEnclosure = encStr
        triggerEvent("OnEnclosureChange", EnclosureChallenge.PreviousEnclosure,  encStr)

	end
end)
 ]]
-----------------------       ---------------------------


