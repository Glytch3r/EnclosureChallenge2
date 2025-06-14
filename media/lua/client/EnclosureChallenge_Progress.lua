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

LuaEventManager.AddEvent("OnEnclosureChange")

EnclosureChallenge.encTick = 0

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


function EnclosureChallenge.updateMarkers(encStr)

	if getCore():getDebug() then
        print('OnEnclosureChange ' .. tostring(encStr))
	end

   local pl = getPlayer()
   if not pl then return end

   --local enc =  EnclosureChallenge.getEnclosure(pl)
   --EnclosureChallenge.EnclosureChange(pl)
   EnclosureChallenge.setMarkers(pl, SandboxVars.EnclosureChallenge.KeepMarkers)

   EnclosureChallenge.addChallengeSymbols(pl)

   local x = pl:getX()
   local y = pl:getY()
   local  midX, midY = EnclosureChallenge.getEnclosureMidXY(x, y, pl)
   EnclosureChallenge.drawEnclosureGrid(midX, midY)
   EnclosureChallenge.drawEnclosureGridOverlay(minimap, midX, midY)

   if  EnclosureChallenge.isChallenger() then
      EnclosureChallenge.setReturnPointMarker()
      if EnclosureChallenge.isOutOfBounds(pl) and pl:isAlive() then
         timer:Simple(2, function()
               EnclosureChallenge.rebound(pl)
         end)
         pl:setHaloNote("OUT OF BOUNDS", 255, 50, 50, 150)
      end
   end
end
Events.OnEnclosureChange.Add(EnclosureChallenge.updateMarkers)



-----------------------            ---------------------------
function EnclosureChallenge.doQuit(isRemote)
	EnclosureChallenge.setChallenge(false, isRemote)
	EnclosureChallenge.clearChallengeData()

end



function EnclosureChallenge.setChallenge(isStart, isRemote)
   local pl = getPlayer(); if not pl then return end

   local ec = EnclosureChallenge.getData()


   if isStart and ec then
      ec.ChallengeTime = SandboxVars.EnclosureChallenge.ChallengeHours or 168


      local encStr = EnclosureChallenge.getEnclosureStr(pl)
      if encStr then
         if isRemote then
            ec.RemoteChallenge = tostring(encStr)
            ec.AdditiveChallenge = ""
            Events.EveryHours.Add(EnclosureChallenge.RemoteTimer)

         else
            ec.RemoteChallenge = ""
            if not ec.AdditiveWins then ec.AdditiveWins = 0 end
            ec.AdditiveChallenge = tostring(encStr)
            Events.EveryHours.Add(EnclosureChallenge.AdditiveTimer)

         end
      end

      EnclosureChallenge.addChallengeSymbols(pl)
      EnclosureChallenge.storeRebound(pl)
      EnclosureChallenge.setReturnPointMarker()

   else
      ec.ChallengeTime = 0
   end
end



function EnclosureChallenge.clearChallengeData()
   local ec = EnclosureChallenge.getData();
       local ec = EnclosureChallenge.getData()
   if not ec then return end
   ec.ChallengeTime = 0
   Events.EveryHours.Remove(EnclosureChallenge.AdditiveTimer)
   Events.EveryHours.Remove(EnclosureChallenge.RemoteTimer)
   ec.RemoteChallenge = ""
   ec.AdditiveChallenge = ""
   EnclosureChallenge.delReturnPointMarker()
   EnclosureChallenge.clearRebound()



end
function EnclosureChallenge.doWin()
   local pl = getPlayer(); if not pl then return end
   local ec = EnclosureChallenge.getData()
   --isRemote = isRemote or EnclosureChallenge.isRemoteMode()
   if not ec then return end
   EnclosureChallenge.doReward()


   if (ec.AdditiveChallenge and ec.AdditiveChallenge ~= "") then
      local reward = SandboxVars.EnclosureChallenge.UnlockPointsReward or 1
      HaloTextHelper.addTextWithArrow(pl, "Unlock Points + " .. tostring(reward), true, HaloTextHelper.getColorGreen())
      ec.UnlockPoints = ec.UnlockPoints or 0
      local reward = ec.UnlockPoints + reward
      ec.UnlockPoints = reward


      return
   end

   if ec.RemoteChallenge then
      EnclosureChallenge.storeConquered(ec.RemoteChallenge)
      EnclosureChallenge.clearChallengeData()
      EnclosureChallenge.setMarkers(pl, false)
   end





end

-----------------------            ---------------------------
function EnclosureChallenge.clearRebound() -- also removes markers
    local ec = EnclosureChallenge.getData()
    if not ec or not ec.Rebound then return end
    ec.Rebound = {}
    EnclosureChallenge.delReturnPointMarker()
end

function EnclosureChallenge.storeRebound(targ) -- also sets markers
   local pl = getPlayer()
   targ = targ or pl
   if not targ then return end

   EnclosureChallenge.clearRebound()

   local ec = EnclosureChallenge.getData()
   if not ec then return end
   local encStr =  EnclosureChallenge.getEnclosureStr(targ)

   ec.Rebound = {
      x = round(targ:getX()),
      y = round(targ:getY()),
      z = targ:getZ() or 0,
   }
   EnclosureChallenge.setReturnPointMarker()

end
-----------------------            ---------------------------
--[[
function EnclosureChallenge.PromptChallenge(pl) -- accepted 1st challenge
   -- spawn markers symbol
end
function EnclosureChallenge.startChallenge(pl) -- accepted 1st challenge
   -- keep markers
  -- EnclosureChallenge.clearEdgeMarkers()
   --EnclosureChallenge.setMarkExpansions()
   --EnclosureChallenge.setReturnPointMarker(guideSq, x, y, z)
   --EnclosureChallenge.delReturnPointMarker()
end
function EnclosureChallenge.declinedChallenge(pl)  -- declined initial prompt
   -- despawn markers
end

end
function EnclosureChallenge.quitChallenge(pl) -- rage quit
function EnclosureChallenge.failedChallenge(pl) -- died
end

function EnclosureChallenge.cancelChallenge(pl) -- declined extend prompt
end

function EnclosureChallenge.respawnChallenge(pl) -- has a challenge then reconnected
end



function EnclosureChallenge.countdownChallenge(pl) -- countdown 0
end
 ]]
--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]
