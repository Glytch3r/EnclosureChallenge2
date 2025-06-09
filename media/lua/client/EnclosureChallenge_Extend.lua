
EnclosureChallenge = EnclosureChallenge or {}


function EnclosureChallenge.isExtended()
    local data = EnclosureChallenge.getData()
    if data and data.Challenges then
        return #EnclosureChallenge.getData().Challenges > 1
    end
    return false
end




function EnclosureChallenge.ExtendedChallenge()
    if isStart == nil then isStart = false end
    if isQuit == nil then isQuit = false end

    local pl = getPlayer()
    if not pl then return end

    local ec = EnclosureChallenge.getData()
    if not ec then return end

    if not isStart then
        --EnclosureChallenge.delSideSymbols()
    else
        --EnclosureChallenge.storeRebound()
    end


    if not isStart and not isQuit and pl:isAlive() then

    else
        EnclosureChallenge.sfx(isStart)
    end
end

function EnclosureChallenge.ContinueDialog(pl, text, title, onClickCallback)
    pl = pl or getPlayer()
    if not pl or not text then return end
    local isChallenger = EnclosureChallenge.isChallenger(pl)
    if not isChallenger then return end
    EnclosureChallenge.disabler(true)
    title = title or "Confirm"
    text = text:gsub("\\n", "\n")

    getSoundManager():playUISound("EnclosureChallenge_Prompt")

    local width, height = 300, 150
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2
    local plNum = pl:getPlayerNum()

    local dialog
    local function onClick(target, button)
        EnclosureChallenge.disabler(false)
        if onClickCallback then
            onClickCallback(button)
        end
        dialog:setVisible(false)
        dialog:removeFromUIManager()
    end

    dialog = ISModalDialog:new(x, y, width, height, text, true, nil, onClick, plNum, 0, title)
    dialog.backgroundColor = { r = 0.6, g = 0.1, b = 0.1, a = 0.6 }
    dialog.borderColor = { r = 0, g = 0, b = 0, a = 1 }
    dialog:initialise()
    dialog:addToUIManager()
end

-----------------------            ---------------------------


function EnclosureChallenge.getEnclosureSideSquares(startX, startY, dir)
    local edgeSquares = {}
    local size = EnclosureChallenge.EnclosureSize
    local validDirs = { N = true, S = true, E = true, W = true }

    if type(dir) ~= "string" or not validDirs[dir] then
        local randDirs = { "N", "S", "E", "W" }
        dir = randDirs[ZombRand(1, 5)]
    end

    if dir == "N" then
        for x = startX, startX + size - 1 do
            table.insert(edgeSquares, { x = x, y = startY })
        end
    elseif dir == "S" then
        for x = startX, startX + size - 1 do
            table.insert(edgeSquares, { x = x, y = startY + size - 1 })
        end
    elseif dir == "W" then
        for y = startY, startY + size - 1 do
            table.insert(edgeSquares, { x = startX, y = y })
        end
    elseif dir == "E" then
        for y = startY, startY + size - 1 do
            table.insert(edgeSquares, { x = startX + size - 1, y = y })
        end
    end

    return edgeSquares
end
function EnclosureChallenge.getAdjacentEnclosureXY(dir, pl)
    pl = pl or getPlayer()
    local x = EnclosureChallenge.getCurrentEnclosureX(pl)
    local y = EnclosureChallenge.getCurrentEnclosureY(pl)

    if dir == "N" then
        y = y - 1
    elseif dir == "S" then
        y = y + 1
    elseif dir == "W" then
        x = x - 1
    elseif dir == "E" then
        x = x + 1
    else
        return nil
    end

    return x, y
end

-----------------------            ---------------------------
function EnclosureChallenge.getDirection(x1, y1, x2, y2)
    if x2 == x1 and y2 == y1 - 1 then
        return "N"
    elseif x2 == x1 and y2 == y1 + 1 then
        return "S"
    elseif x2 == x1 - 1 and y2 == y1 then
        return "W"
    elseif x2 == x1 + 1 and y2 == y1 then
        return "E"
    end
    return nil
end
-----------------------            ---------------------------
--[[
function EnclosureChallenge.setMarkSide(enc, dir)
    if not enc or type(enc.x) ~= "number" or type(enc.y) ~= "number" then return end
    local size = EnclosureChallenge.EnclosureSize
    if not size then return end

    local startX = enc.x * size
    local startY = enc.y * size
    if not dir or not ({N=true,S=true,E=true,W=true})[dir] then return end

    EnclosureChallenge.edgeMarkers = EnclosureChallenge.edgeMarkers or {}

    for _, marker in ipairs(EnclosureChallenge.edgeMarkers) do
        if marker then marker:remove() end
    end
    EnclosureChallenge.edgeMarkers = {}

    local MarkerColor = SandboxVars.EnclosureChallengeColor.MarkerColor
    local col = EnclosureChallenge.parseColor(MarkerColor)
    local r, g, b, a = col.r, col.g, col.b, col.a

    local edgeSquares = EnclosureChallenge.getEnclosureSideSquares(startX, startY, dir)
    local wm = getWorldMarkers()
    if not wm then return end

    for _, sqCoord in ipairs(edgeSquares) do
        local sq = getCell():getOrCreateGridSquare(sqCoord.x, sqCoord.y, 0)
        if sq then
            local marker = wm:addGridSquareMarker("EnclosureChallenge_Edge", "EnclosureChallenge_Circle", sq, r, g, b, true, 1)
            table.insert(EnclosureChallenge.edgeMarkers, marker)
        end
    end
end
 ]]
 --[[
function EnclosureChallenge.setMarkExpansions()
    EnclosureChallenge.edgeMarkers = EnclosureChallenge.edgeMarkers or {}
    local pl = getPlayer()
    if not pl then return end

    local size = EnclosureChallenge.EnclosureSize
    if not size then return end

    local x, y, z = round(pl:getX()), round(pl:getY()), 0
    local enc = EnclosureChallenge.getCurrentEnclosure(pl)
    if not enc then return end

    local startX = math.floor(x / size) * size
    local startY = math.floor(y / size) * size

    local dirs = { "N", "S", "E", "W" }
    local wm = getWorldMarkers()
    if not wm then return end



    for _, dir in ipairs(dirs) do
        local adjX, adjY = EnclosureChallenge.getAdjacentEnclosureXY(dir, pl)
        if adjX and adjY then
            local adjEnc = { x = adjX, y = adjY }

            local isUnlocked = EnclosureChallenge.isUnlocked(adjEnc)
            local isConquered = EnclosureChallenge.isConquered(adjEnc)

            local colStr = SandboxVars.EnclosureChallengeColor.NeutralColor


            colStr = SandboxVars.EnclosureChallengeColor.GoodColor
            colStr = SandboxVars.EnclosureChallengeColor.BadColor

            local col = EnclosureChallenge.parseColor(colStr)
            local r, g, b, a = col.r, col.g, col.b, col.a




            local sideSquares = EnclosureChallenge.getEnclosureSideSquares(startX, startY, dir)
            for _, sqData in ipairs(sideSquares) do
                local sq = getCell():getOrCreateGridSquare(sqData.x, sqData.y, z)
                if sq then
                    local stamp = "EnclosureChallenge_Bounds"
                    if EnclosureChallenge.isChallenger(pl) and isUnlocked  then
                        stamp = "EnclosureChallenge_Edge"
                    end
                    local marker = wm:addGridSquareMarker(stamp, stamp, sq, r, g, b, true, 0.5)
                    table.insert(EnclosureChallenge.edgeMarkers, marker)
                end
            end

        end
    end
end
 ]]
-----------------------            ---------------------------
--[[
function EnclosureChallenge.addSideSymbols(dir)
    if not ISWorldMap_instance then return end

    local pl = getPlayer()
    local size = EnclosureChallenge.EnclosureSize
    local ec = EnclosureChallenge.getData()
    if not ec or not ec.Rebound then return end

    local reboundX = ec.Rebound.x or round(pl:getX())
    local reboundY = ec.Rebound.y or round(pl:getY())
    local startX = math.floor(reboundX / size) * size
    local startY = math.floor(reboundY / size) * size

    local edgeSquares = EnclosureChallenge.getEnclosureSideSquares(startX, startY, dir)
    if not edgeSquares then return end

    for _, sq in ipairs(edgeSquares) do
        EnclosureChallenge.addMapSymbol(sq.x, sq.y, "X")
    end
end
 ]]

--[[
function EnclosureChallenge.ExtendMarkers(excludeDir)
    local pl = getPlayer()
    if not pl then return end

    local size = EnclosureChallenge.EnclosureSize
    local x, y, z = round(pl:getX()), round(pl:getY()), 0
    local startX, startY = math.floor(x / size) * size, math.floor(y / size) * size

    EnclosureChallenge.edgeMarkers = EnclosureChallenge.edgeMarkers or {}

    local col = EnclosureChallenge.parseColor()
    local r, g, b, a = col.r, col.g, col.b, col.a

    local guideSq = getCell():getOrCreateGridSquare(x, y, z)
    if guideSq then
        EnclosureChallenge.dirGuide(guideSq, x, y, z)
    end

    local edgeSquaresByDir = {
        N = EnclosureChallenge.getEnclosureSideSquares(startX, startY, "N"),
        S = EnclosureChallenge.getEnclosureSideSquares(startX, startY, "S"),
        E = EnclosureChallenge.getEnclosureSideSquares(startX, startY, "E"),
        W = EnclosureChallenge.getEnclosureSideSquares(startX, startY, "W"),
    }

    local wm = getWorldMarkers()
    if not wm then return end

    for dir, edgeSquares in pairs(edgeSquaresByDir) do
        if dir ~= excludeDir then
            for _, eSq in ipairs(edgeSquares) do
                local sq = getCell():getOrCreateGridSquare(eSq.x, eSq.y, z)
                if sq then
                    local marker = wm:addGridSquareMarker("EnclosureChallenge_Edge", "EnclosureChallenge_Circle", sq, r, g, b, true, 1)
                    table.insert(EnclosureChallenge.edgeMarkers, marker)
                end
            end
        end
    end
end

 ]]
