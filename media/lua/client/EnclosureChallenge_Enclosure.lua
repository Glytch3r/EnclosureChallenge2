
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




function EnclosureChallenge.getEnclosureMidXY(x, y, targ)
    local size = EnclosureChallenge.EnclosureSize
    local pl = getPlayer()
    if pl then
        x = x or pl:getX()
        y = y or pl:getY()
    end
    if targ and targ ~= pl then
        x = targ:getX()
        y = targ:getY()
    end
    if not x or not y then return nil end
    local encX = math.floor(x / size)
    local midX = encX * size + (math.floor(size / 2))

    local encY = math.floor(y / size)
    local midY = ( encY * size) + (math.floor(size / 2))
    return midX , midY

--[[
    if x == nil or y == nil then
        local pl = getPlayer()
        if not pl then return nil end
        x = pl:getX()
        y = pl:getY()
    end

    return (x / size * size) + (size / 2), (y / size * size) + (size / 2) ]]
end


function EnclosureChallenge.getEnclosureStrXY(x, y)
    local enc = EnclosureChallenge.getEnclosureXY(x, y)
    return tostring(round(enc.x)) .. "_" .. tostring(round(enc.y))
end


function EnclosureChallenge.getEnclosureXY(x, y)
    local size = EnclosureChallenge.EnclosureSize
    if not size or not x or not y then return nil end
    local gridX = math.floor((x - 1) / size)
    local gridY = math.floor((y - 1) / size)
    return { x = gridX, y = gridY, z = 0 }
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
--[[ function EnclosureChallenge.getEnclosure(targ)

    targ = targ or getPlayer()
    if not targ then return nil end

    local size = EnclosureChallenge.EnclosureSize
    if not size then return nil end
    local x, y = round(targ:getX()),  round(targ:getY())

    local x = math.floor((x - 1) / size)
    local y = math.floor((y - 1) / size)
    return { x = x, y = y , z = 0}
end ]]

--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]


