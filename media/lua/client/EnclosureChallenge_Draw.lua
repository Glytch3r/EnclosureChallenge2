EnclosureChallenge = EnclosureChallenge or {}



-----------------------    keys*         ---------------------------
EnclosureChallenge.showDraw = 1
EnclosureChallenge.showMouseTip = true
function EnclosureChallenge.toggle(key)
    if not isIngameState() then return end
    local core = getCore()
    if key == core:getKey("Toggle_Enclosure_MouseTip") then
        EnclosureChallenge.showMouseTip = not EnclosureChallenge.showMouseTip
        if core:getDebug() then
            print("EnclosureChallenge.showMouseTip: " .. tostring(EnclosureChallenge.showMouseTip))
        end
        return true
    elseif key == core:getKey("Toggle_Enclosure_GUI") then
        EnclosureChallenge.showDraw = EnclosureChallenge.showDraw == 0 and 1 or 0
        if core:getDebug() then
            print("EnclosureChallenge.showDraw: " .. tostring(EnclosureChallenge.showDraw))
        end
        return true
    end
    return false
end

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
            local markerSize = 0.3
            local sq = getCell():getOrCreateGridSquare(x, y, z)
            if sq then
                local stamp = "EnclosureChallenge_Bounds"
                if EnclosureChallenge.isReboundSq(sq) then
                    stamp = "EnclosureChallenge_Return"
                elseif EnclosureChallenge.isConquered(sq) then
                    stamp = "EnclosureChallenge_Conquered"
                elseif EnclosureChallenge.isOutOfBounds(sq) then
                    stamp = "EnclosureChallenge_Challenger"
                end

                EnclosureChallenge.checkMark = getWorldMarkers():addGridSquareMarker(stamp, stamp, sq, r, g, b, false, markerSize)
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

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    if not (x and y and z) then return end

    local status = EnclosureChallenge.getEnclosureStatus(sq)
    if not status then return end

    local col = EnclosureChallenge.getEnclosureColor(sq)
    local encStr = EnclosureChallenge.getEnclosureStr(sq)

    local info = string.format("%d : %d\nEnclosure: %s\n%s", x, y, tostring(encStr), tostring(status))

    local reboundSq = EnclosureChallenge.getReboundSq()
    if reboundSq and reboundSq == sq then
        info = "RETURN POINT\n" .. info
    elseif EnclosureChallenge.isOutOfBounds(sq) then
        info = "OUT OF BOUNDS!\n" .. info
    end

    EnclosureChallenge.DrawMouseTip(x, y, z, info, col.r, col.g, col.b)
end


Events.OnPlayerUpdate.Add(EnclosureChallenge.MouseTip)




function EnclosureChallenge.GUI()
    if not isIngameState() or not EnclosureChallenge.showDraw then return end

    local pl = getPlayer()
    if not pl then return end

    local scrW = getCore():getScreenWidth()
    local scrH = getCore():getScreenHeight()
    local xPos = (scrW / 8) - 12
    local yPos = (scrH / 2) - 12

    local sq = pl:getCurrentSquare()
    if not sq then return end

    local x, y, z = sq:getX(), sq:getY(), sq:getZ()
    if not (x and y and z) then return end

    local encStr = EnclosureChallenge.getEnclosureStr(sq)
    local status = EnclosureChallenge.getEnclosureStatus(pl)
    local isChallenger = EnclosureChallenge.isChallenger(pl)
    local isOutOfBounds = EnclosureChallenge.isOutOfBounds(pl)
    local isRemoteMode = EnclosureChallenge.isRemoteMode(pl)

    local col = EnclosureChallenge.getEnclosureColor(pl)
    local alpha = EnclosureChallenge.showDraw

    if isOutOfBounds and isChallenger then
        col = EnclosureChallenge.parseColor(SandboxVars.EnclosureChallengeColor.BadColor)
    end

    local ec = EnclosureChallenge.getData()
    if not ec then
        EnclosureChallenge.initChallengeData(pl)
        ec = EnclosureChallenge.getData()
    end

    local fontSizes = {
        [1] = UIFont.Small,
        [2] = UIFont.Medium,
        [3] = UIFont.Large,
    }
    local timeSizes = {
        [1] = UIFont.Medium,
        [2] = UIFont.Large,
        [3] = UIFont.NewLarge,
    }

    local optSizes = tonumber(SandboxVars.EnclosureChallenge.FontSize) or 1
    local fSize = fontSizes[optSizes] or UIFont.Small
    local timeSize = timeSizes[optSizes] or UIFont.Small

    if isChallenger then
        local modeStr = isRemoteMode and "Remote Mode" or "Additive Mode"
        local timeStr = EnclosureChallenge.getChallengeTimeStr()

        local headerStr = string.format("%s\n%s", modeStr, timeStr)

        getTextManager():DrawStringCentre(timeSize, xPos + 24, yPos - 32, tostring(encStr).."\n"..tostring(headerStr), col.r, col.g, col.b, alpha)
    end

    local encInfo = {

        string.format("X: %d   Y: %d", round(x), round(y)),
        tostring(status),
    }

    if ec then
        table.insert(encInfo, "")
        table.insert(encInfo, tostring(#ec.Conquered) .. " : Conquered")
        table.insert(encInfo, tostring(ec.RemoteWins) .. " : RemoteWins")
        table.insert(encInfo, tostring(#ec.Challenges) .. " : Unlocked")
        table.insert(encInfo, tostring(ec.UnlockPoints) .. " : Points")
        table.insert(encInfo, "\nRewardChoice:\n" .. tostring(EnclosureChallenge.getRewardTitle(ec.RewardChoice)))
    else
        table.insert(encInfo, "\nNo Enclosure Data")
    end

    getTextManager():DrawStringCentre(fSize, xPos-12, yPos + 52, table.concat(encInfo, '\n'), col.r, col.g, col.b, alpha)
end

Events.OnPostUIDraw.Add(EnclosureChallenge.GUI)
