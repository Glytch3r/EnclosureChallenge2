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
--client/EnclosureChallenge_Remote.lua

EnclosureChallenge = EnclosureChallenge or {}
-----------------------   remote challenge        ---------------------------
function EnclosureChallenge.goBack()
    local pl = getPlayer()
    if not pl then return end

    local x, y, z = EnclosureChallenge.getCoords()
    if x and y and z then
        print("goBack() to:".. tostring(x)..", ".. tostring(y)..", ".. tostring(z))
        EnclosureChallenge.tp(pl, x, y, z)
    end

    EnclosureChallenge.clearCoord()
end

function EnclosureChallenge.clearCoord()
    local ec = EnclosureChallenge.getData()
    if ec then
        ec.OriginCoords = {}
    end
end

function EnclosureChallenge.saveCoord()
    local pl = getPlayer()
    if not pl then return end

    local csq = pl:getCurrentSquare()
    if not csq then return end

    local ec = EnclosureChallenge.getData()
    if ec then
        if ec.OriginCoords  and ec.OriginCoords.x == nil and ec.OriginCoords.y == nil then
            ec.OriginCoords = {
                x = round(csq:getX()),
                y = round(csq:getY()),
                z = csq:getZ()
            }
            if isClient() and pl.transmitModData then pl:transmitModData() end
        end
        print("saveCoord()"..tostring(ec.OriginCoords.x)..",  "..tostring(ec.OriginCoords.y))

    end
end
function EnclosureChallenge.getCoords()
    local ec = EnclosureChallenge.getData()
    if not ec then return nil, nil, nil end
    ec.OriginCoords = ec.OriginCoords or {}
    if ec.OriginCoords then
        return ec.OriginCoords.x, ec.OriginCoords.y, ec.OriginCoords.z
    end
    return nil, nil, nil
end
-----------------------            ---------------------------

function EnclosureChallenge.isValidSq(sq)
    sq = sq or getPlayer():getCurrentSquare()
    if EnclosureChallenge.isConquered(sq) then return false end
    return sq and sq:connectedWithFloor() and sq:getFloor() ~= nil
end

-----------------------            ---------------------------
function EnclosureChallenge.getEnclosureMidXY(x, y, targ)
    local size = EnclosureChallenge.EnclosureSize or 189
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
    local midX = encX * size + math.floor(size / 2)

    local encY = math.floor(y / size)
    local midY = encY * size + math.floor(size / 2)

    return midX, midY
end

function EnclosureChallenge.getRandMidCoord()
    local size = EnclosureChallenge.EnclosureSize or 189
    local version = getCore():getVersion()
    local is42 = luautils.stringStarts(version, "42")

    local maxX, maxY

    local mapAPI = ISWorldMap_instance and ISWorldMap_instance.javaObject and ISWorldMap_instance.javaObject:getAPIv1()
    if mapAPI then
        maxX = mapAPI:getWidthInSquares() - 1
        maxY = mapAPI:getHeightInSquares() - 1
    end

    if not maxX or not maxY or maxX <= 0 or maxY <= 0 then
        local cell = getCell()
        if cell then
            maxX = cell:getWidthInTiles() - 1
            maxY = cell:getHeightInTiles() - 1
        end
    end

    if not maxX or not maxY or maxX <= 0 or maxY <= 0 then
        maxX = 16348
        maxY = 15683
    end

    local boundLimitX = math.max(0, maxX - size)
    local boundLimitY = math.max(0, maxY - size)
    if boundLimitX <= 0 or boundLimitY <= 0 then return nil, nil, nil, nil end

    local EnclosureX = ZombRand(0, boundLimitX + 1)
    local EnclosureY = ZombRand(0, boundLimitY + 1)

    if is42 then
        EnclosureX = math.max(0, math.min(EnclosureX, 16348))
        EnclosureY = math.max(0, math.min(EnclosureY, 15683))
    end

    local midX, midY = EnclosureChallenge.getEnclosureMidXY(EnclosureX, EnclosureY)
    return midX, midY, EnclosureX, EnclosureY
end


function EnclosureChallenge.tpRandMidSq()
    local pl = getPlayer()
    if not pl then return end
    if EnclosureChallenge.remoteTeleportPending then return end
    EnclosureChallenge.remoteTeleportPending = true

    local rTick = 0
    local waitTicks = 60
    local maxTicks = 300
    local maxAttempts = math.floor(maxTicks / waitTicks)
    local attemptCount = 0

    local midX, midY, enclosureX, enclosureY = EnclosureChallenge.getRandMidCoord()
    if not midX then
        EnclosureChallenge.remoteTeleportPending = false
        midX, midY = EnclosureChallenge.getEnclosureMidXY(pl:getX(), pl:getY(), pl)
        if not midX then return end
    end


    EnclosureChallenge.tp(pl, midX, midY)

    local function tpHandler()
        rTick = rTick + 1
        if rTick % waitTicks == 0 then
            local sq = pl:getSquare()
            if not EnclosureChallenge.isValidSq(sq) then
                attemptCount = attemptCount + 1
                if attemptCount >= maxAttempts then
                    pl:Say("Unable to find valid location.")
                    EnclosureChallenge.goBack()
                    EnclosureChallenge.remoteTeleportPending = false
                    Events.OnTick.Remove(tpHandler)
                    return
                end

                midX, midY, enclosureX, enclosureY = EnclosureChallenge.getRandMidCoord()
                if not midX then
                    pl:Say("Retry failed.")
                    EnclosureChallenge.remoteTeleportPending = false
                    Events.OnTick.Remove(tpHandler)
                    return
                end

                EnclosureChallenge.tp(pl, midX, midY)
                rTick = 0
                return
            end

            EnclosureChallenge.ConfirmDialog(pl, "Accept Remote Challenge?", "Enclosure Challenge", false, true)
            EnclosureChallenge.remoteTeleportPending = false
            Events.OnTick.Remove(tpHandler)
        end
    end

    Events.OnTick.Add(tpHandler)
end


