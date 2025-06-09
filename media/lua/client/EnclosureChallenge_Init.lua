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

EnclosureChallenge = EnclosureChallenge or {}


EnclosureChallenge.EnclosureSize = 189
EnclosureChallenge.MarkerCache = {}
-----------------------    init*        ---------------------------

function EnclosureChallenge.initChallengeData(pl)
    pl = pl or getPlayer()
    if not pl then return end

    local md = pl:getModData()
    md.EnclosureChallenge = md.EnclosureChallenge or {}
    local ec = md.EnclosureChallenge

    if ec.EnclosureX or ec.EnclosureY then
        EnclosureChallenge.resetData()
        return
    end

    ec.UnlockPoints     = ec.UnlockPoints     or SandboxVars.EnclosureChallenge.StartingUnlockPoints or 1
    ec.RewardChoice     = ec.RewardChoice     or 0
    ec.ChallengeTime    = ec.ChallengeTime    or 0
    ec.RemoteWins       = ec.RemoteWins       or 0
    ec.Challenges       = ec.Challenges       or {}
    ec.Conquered        = ec.Conquered        or {}
    ec.PrevCoord        = {}
    ec.Rebound          = ec.Rebound          or {}
    ec.RemoteChallenge  = ec.RemoteChallenge  or ""
    ec.Stage            = ec.Stage            or ""
end

Events.OnCreatePlayer.Add(function()
    if not isIngameState() then return end

    local pl = getPlayer()
    if not pl then return end

    EnclosureChallenge.initChallengeData(pl)
    EnclosureChallenge.setMarkers(pl)

    local encStr = EnclosureChallenge.getEnclosureStr(pl)
    EnclosureChallenge.PreviousEnclosure = encStr
	if not EnclosureChallenge.isChallenger(pl)  then

        EnclosureChallenge.setReturnPointMarker()
    end
    triggerEvent("OnEnclosureChange", encStr, encStr)

    EnclosureChallenge.showDraw = true
end)

Events.OnPlayerDeath.Add(function()
	local pl = getPlayer()
	local user = pl:getUsername()
	if not EnclosureChallenge.isChallenger(pl)  then return end
	if EnclosureChallenge.isShouldAnnounce() then



	    local enc = EnclosureChallenge.getEnclosureXY(  pl:getX(),   pl:getY())
        if not enc then return end

        local encStr = EnclosureChallenge.getEnclosureStr(pl)
		local posStr = (enc.x and enc.y) and ": [" .. tostring(encStr) .. "]" or ""
		if not SandboxVars.EnclosureChallenge.CoordNotif then
			posStr = ""
		end

		local msg = tostring(user) .. " " .. getText("ContextMenu_EnclosureChallenge_Fail").. "  ".. tostring(posStr)
		if isClient() then
			processGeneralMessage(msg)
		else
			pl:setHaloNote(msg, 150, 250, 150, 900)
		end
	end
	--EnclosureChallenge.setChallenge(false, false)
end)



--[[ Events.OnCreatePlayer.Add(function()
    if isIngameState() then
        local pl = getPlayer()
        if not pl then return end

        EnclosureChallenge.initChallengeData(pl)
        EnclosureChallenge.setMarkers(pl)

        local encStr  = EnclosureChallenge.getEnclosureStr(pl)
        EnclosureChallenge.PreviousEnclosure = encStr
        triggerEvent("OnEnclosureChange", EnclosureChallenge.PreviousEnclosure,  encStr)
		EnclosureChallenge.showDraw = true
	end
end)
 ]]
-----------------------       ---------------------------
LuaEventManager.AddEvent("OnEnclosureChange")
function EnclosureChallenge.updateMarkers()


	if getCore():getDebug() then
        print('OnEnclosureChange')
	end

    local pl = getPlayer()
    if not pl then return end

    local enc =  EnclosureChallenge.getEnclosure(pl)
    EnclosureChallenge.setMarkers(pl, false)

    EnclosureChallenge.addChallengeSymbols(pl)

    local x = pl:getX()
    local y = pl:getY()
    local  midX, midY = EnclosureChallenge.getEnclosureMidXY(x, y, pl)
    EnclosureChallenge.drawEnclosureGrid(midX, midY)
    EnclosureChallenge.drawEnclosureGridOverlay(minimap, midX, midY)
end
Events.OnEnclosureChange.Add(EnclosureChallenge.updateMarkers)

--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]
