
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

EnclosureChallenge = EnclosureChallenge or {}


function EnclosureChallenge.tp(pl, x, y, z)
    pl = pl or getPlayer()
    z = z or 0
    if not x or not y then
        return
    end

    EnclosureChallenge.forceExitCar()

  	pl:setX(x)
	pl:setY(y)
	pl:setZ(z)
	pl:setLx(x)
	pl:setLy(y)
	pl:setLz(z)

end
-----------------------            ---------------------------
--[[
function EnclosureChallenge.resolveEnclosure(targ)
    if not targ then
        return getPlayer():getCurrentSquare()
    elseif instanceof(targ, "IsoPlayer") or instanceof(targ, "IsoMovingObject") then
        return targ:getCurrentSquare()
    elseif instanceof(targ, "IsoGridSquare") then
        return targ
    elseif type(targ) == "table" and targ.x and targ.y then
        local z = targ.z or 0
        return getCell():getGridSquare(targ.x, targ.y, z)
    end
    return nil
end
 ]]


function EnclosureChallenge.getEnclosurePoint(XorY)
    return tonumber(XorY) / EnclosureChallenge.EnclosureSize
end


function EnclosureChallenge.getEnclosureXY(x, y)
    local size = EnclosureChallenge.EnclosureSize
    if not size or not x or not y then return nil end

    x = math.floor((x - 1) / size)
    y = math.floor((y - 1) / size)

    return { x = x, y = y, z = 0 }
end

function EnclosureChallenge.getEnclosureStrXY(x, y)
    local enc = EnclosureChallenge.getEnclosureXY(x, y)
    if not enc then return nil end
    return tostring(enc.x) .. "_" .. tostring(enc.y)
end

--[[
function EnclosureChallenge.getEnclosureXY(x, y)
    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end
    local x = math.floor((x - 1) / size)
    local y = math.floor((y - 1) / size)
    return { x = x, y = y , z = 0}
end ]]
function EnclosureChallenge.getEnclosure(targ)

    targ = targ or getPlayer()
    if not targ then return nil end

    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end
    local x, y = round(targ:getX()),  round(targ:getY())

    local x = math.floor((x - 1) / size)
    local y = math.floor((y - 1) / size)
    return { x = x, y = y , z = 0}
end

function EnclosureChallenge.getEnclosureStr(targ)
    targ = targ or getPlayer()
    local enc = EnclosureChallenge.getEnclosure(targ)
    if not enc then return nil end
    if enc.x and enc.y then
        return tostring(enc.x).."_"..tostring(enc.y)
    end
    return nil
end

--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]
--[[
AdditiveChallenge: can only challenge enclosure that are inside ec.Challenges {}
dialog yes = store rebound, add "return" markers and symbol, add RemoteTime , store data ec.AdditiveChallenge = encStr
dialog no = cancels challenge
quit= clear data: ec.AdditiveChallenge = "", ec.RemoteTime = 0 ec.Rebound = {}
out of bounds during challenge = check using ec.Challenges[encStr]
if out of bounds, teleport to return point using ec.Rebound
win when RemoteTime hits 0, clear rebound data,  Conquered[ec.AdditiveChallenge]=true, ec.AdditiveChallenge = ""
win reward item based on RewardChoice, RemoteWins + 1
win ec.UnlockPoints = ec.UnlockPoints + SandboxVars.EnclosureChallenge.UnlockPointsReward


RemoteChallenge:
store OriginCoordss data
teleport random mid sq
dialog yes = clear OriginCoordss, store rebound, add "return" markers and symbol, set RemoteTime,  store data ec.RemoteChallenge = encStr
dialog no = cancels challenge, goback OriginCoordss function
quit= clear rebound, ec.RemoteChallenge = "", RemoteTime = 0
out of bounds during challenge = check using ec.RemoteChallenge ~= encStr
if out of bounds, teleport to return point using ec.Rebound
win when RemoteTime hits 0, clear rebound data, ec.RemoteChallenge = ""
win reward item based on RewardChoice, RemoteWins + 1


 ]]
