EnclosureChallenge = EnclosureChallenge or {}



-----------------------    keys*         ---------------------------
EnclosureChallenge.showDraw = 1
EnclosureChallenge.showMouseTip = true
function EnclosureChallenge.toggle(key)
    if not isIngameState() then return end
    if key == getCore():getKey("Toggle_Enclosure_MouseTip") then
        EnclosureChallenge.showMouseTip = not EnclosureChallenge.showMouseTip
        EnclosureChallenge.sfx(EnclosureChallenge.showMouseTip)
        if getCore():getDebug()  then
            print("EnclosureChallenge.showMouseTip "..tostring(EnclosureChallenge.showMouseTip))

        end
    end

    if key == getCore():getKey("Toggle_Enclosure_GUI") then

        EnclosureChallenge.showDraw = EnclosureChallenge.showDraw + 0.1
        if EnclosureChallenge.showDraw > 1 then
            EnclosureChallenge.showDraw = 0
        end
        EnclosureChallenge.sfx(EnclosureChallenge.showDraw)
        if getCore():getDebug()  then
            print("EnclosureChallenge.showDraw "..tostring(EnclosureChallenge.showDraw))
        end
    end

    return key
end
Events.OnKeyPressed.Add(EnclosureChallenge.toggle)
-----------------------            ---------------------------
function EnclosureChallenge.getPointer()
    if not isIngameState() then return nil end
    local pl = getPlayer()
    if not pl then return nil end

    local z = pl:getZ()
    local x, y = ISCoordConversion.ToWorld(getMouseXScaled(), getMouseYScaled(), z)
    if not x or not y then return nil end
    return getCell():getOrCreateGridSquare(math.floor(x), math.floor(y), z)
end
-----------------------     mouse*       ---------------------------
function EnclosureChallenge.DrawMouseTip(x, y, z, str, r, g, b)
    if not isIngameState() then return end
    local tag = TextDrawObject.new()
    if not EnclosureChallenge.showMouseTip then return end

    if not EnclosureChallenge.isActive then
        EnclosureChallenge.isActive = true

        tag:setDefaultFont(UIFont.Small)
        tag:ReadString(UIFont.Small, str, -1)
        tag:setDefaultColors(r, g, b)
        tag:setVisibleRadius(360)

        local yOffset = 0
        local xOffset = 0
        local function drawFunc()
            local zoom = getCore():getZoom(0)
            local screenX = (IsoUtils.XToScreen(x + xOffset, y, z, 0) - IsoCamera.getOffX()) / zoom
            local screenY = (IsoUtils.YToScreen(x + yOffset, y, z, 0) - IsoCamera.getOffY()) / zoom
            tag:AddBatchedDraw(screenX, screenY-48, r,g,b,1, false)
        end
        if EnclosureChallenge.checkMark ~= nil then
            EnclosureChallenge.checkMark:remove()
            EnclosureChallenge.checkMark = nil
        end
        if EnclosureChallenge.checkMark == nil then
            local sq = getCell():getOrCreateGridSquare(x, y, z)
            if sq then
                EnclosureChallenge.checkMark = getWorldMarkers():addGridSquareMarker("circle_only_highlight", "", sq, r, g, b, false, 0.3)
            end
        end
        Events.OnPostRender.Add(drawFunc)

        timer:Simple(0.1, function()
            EnclosureChallenge.isActive = nil
            Events.OnPostRender.Remove(drawFunc)
        end)
    end
end

function EnclosureChallenge.MouseTip()
    if not isIngameState() then return end
    if not EnclosureChallenge.showMouseTip then return end

    local sq = EnclosureChallenge.getPointer()
    if not sq then return end

    local col = EnclosureChallenge.getEnclosureColor(sq)
    local status = EnclosureChallenge.getEnclosureStatus(sq)
    if not status then return end

    local encStr = EnclosureChallenge.getEnclosureStr(sq)

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    if not (x and y and z) then return end

    local info = "Enclosure: " .. tostring(encStr) .. "\n" .. tostring(status)
    info = tostring(x).." : "..tostring(y) .. "\n".. tostring(info)

    if EnclosureChallenge.isRebound(sq) then
        info = "RETURN POINT\n"..info
    elseif EnclosureChallenge.isOutOfBounds(sq) then
        info = "OUT OF BOUNDS!\n"..info
    end

    EnclosureChallenge.DrawMouseTip(x, y, z, info, col.r, col.g, col.b)
end

Events.OnPlayerUpdate.Add(EnclosureChallenge.MouseTip)

function EnclosureChallenge.GUI()
    if not isIngameState() then return end
    if not EnclosureChallenge.showDraw then return end


    local pl = getPlayer()
    if not pl then return end
    local xPos = (getCore():getScreenHeight() / 8)
    local yPos = (getCore():getScreenHeight()) / 2 - 12



    local sq = pl:getCurrentSquare()
    if not sq then return end

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    if not (x and y and z) then return end

    local encStr = EnclosureChallenge.getEnclosureStr(sq)
    local status = EnclosureChallenge.getEnclosureStatus(pl)
    local isChallenger = EnclosureChallenge.isChallenger(pl)
    local isOutOfBounds = EnclosureChallenge.isOutOfBounds(pl)
    local isRemoteMode =  EnclosureChallenge.isRemoteMode(pl)

    local encInfo = {}
    table.insert(encInfo, '')

    local info = "X: " .. tostring(round(x)) .. "   Y: " .. tostring(round(y)) .. "\n" .. tostring(encStr).."\n".. tostring(status)

    if isChallenger then
        info = "X: " .. tostring(round(x)) .. "   Y: " .. tostring(round(y)) .. "\n" .. tostring(encStr).."\n" .. "Additive Challenge"
        if isRemoteMode then
            info = "X: " .. tostring(round(x)) .. "   Y: " .. tostring(round(y)) .. "\n" .. tostring(encStr).."\n" .. "Remote Challenge"
        end
    end


    local col = EnclosureChallenge.getEnclosureColor(pl)

    if isOutOfBounds and isChallenger then
        info = "OUT OF BOUNDS!\n" .. info
        col = EnclosureChallenge.parseColor(SandboxVars.EnclosureChallengeColor.BadColor)
    end

    table.insert(encInfo, info)
    table.insert(encInfo, '')

    local ec = EnclosureChallenge.getData()
    if ec then

        table.insert(encInfo, tostring(#ec.Conquered) .. " : Conquered")
        table.insert(encInfo, tostring(ec.RemoteWins) .. " : RemoteWins")
        table.insert(encInfo, tostring(#ec.Challenges) .. " : Unlocked")
        table.insert(encInfo, tostring(ec.UnlockPoints) .. " : Points")
        table.insert(encInfo, tostring(ec.RewardChoice) .. " : RewardChoice")



        if isChallenger and ec.ChallengeTime and ec.ChallengeTime > 0 then
            local t = tonumber(ec.ChallengeTime) or 0
            if t == 1 then
                table.insert(encInfo, "1 : Final Hour")
            else
                table.insert(encInfo, tostring(t) .. " : Hours Remaining")
            end
        end
    else
        table.insert(encInfo, 'No Enclosure Data')
    end
    local alpha = EnclosureChallenge.showDraw
    getTextManager():DrawStringCentre(UIFont.Medium, xPos, yPos, table.concat(encInfo, '\n'), col.r, col.g, col.b, alpha)
end


Events.OnPostUIDraw.Add(EnclosureChallenge.GUI)

