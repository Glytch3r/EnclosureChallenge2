--client/EnclosureChallenge_Enclosure.lua
EnclosureChallenge = EnclosureChallenge or {}


function EnclosureChallenge.tp(pl, x, y, z)
    pl = pl or getPlayer()
    z = z or 0
    if not x or not y then
        return
    end

    local vehicle = pl:getVehicle()
    if vehicle and EnclosureChallenge.getVehicleSeat(pl, vehicle) == 0 then
        if EnclosureChallenge.reboundVehicle(pl, x, y, z) then return true end
    end

    EnclosureChallenge.forceExitCar(pl)
    if luautils.stringStarts(getCore():getVersion(), "42") then
        pl:teleportTo(tonumber(x), tonumber(y), tonumber(z))
        return true
    else
        pl:setX(x)
        pl:setY(y)
        pl:setZ(z)
        if pl.setLx then
            pl:setLx(x)
        end
        if pl.setLy then
            pl:setLy(y)
        end
        if pl.setLz then
            pl:setLz(z)
    end
    return true
end

end

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
