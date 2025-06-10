EnclosureChallenge = EnclosureChallenge or {}

-----------------------    keys*         ---------------------------
EnclosureChallenge.posGUI = 1
EnclosureChallenge.alphaGUI = 1
EnclosureChallenge.MouseTip = true

EnclosureChallenge.posTab = {}
EnclosureChallenge.posTab[6] = "Position: Preset",
EnclosureChallenge.posTab[5] = "Position: BottomRight",
EnclosureChallenge.posTab[4] = "Position: Pixel Based",
EnclosureChallenge.posTab[3] = "Position: Off Center",
EnclosureChallenge.posTab[2] = "Position: Center Screen",
EnclosureChallenge.posTab[1] = "Position: Screen Percent",



function EnclosureChallenge.toggle(key)
    if not isIngameState() then return end
    local core = getCore()
    local msg = nil
    if key == core:getKey("Toggle_Enclosure_MouseTip") then
        EnclosureChallenge.MouseTip = not EnclosureChallenge.MouseTip
        msg = "Enclosure Mouse ToolTip: Off"
        if EnclosureChallenge.MouseTip then msg = "Enclosure Mouse ToolTip: On" end

    elseif key == core:getKey("Adjust_Enclosure_GUI_Opacity") then
        EnclosureChallenge.alphaGUI = EnclosureChallenge.alphaGUI + 0.2
        if EnclosureChallenge.alphaGUI >= 1 then
            EnclosureChallenge.alphaGUI = 0
        end
        msg = math.floor((EnclosureChallenge.alphaGUI or 0) * 100 + 0.5)

    elseif key == core:getKey("Adjust_Enclosure_GUI_Position") then
        EnclosureChallenge.posGUI = EnclosureChallenge.posGUI + 1
        if EnclosureChallenge.posGUI >= 7 then
            EnclosureChallenge.posGUI = 1
            msg = tostring(EnclosureChallenge.posTab[EnclosureChallenge.posGUI])
        end
    end

    if msg then
        getPlayer():setHaloNote(tostring(opacity),255,250,255,255)
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


    if not EnclosureChallenge.isActive then
        EnclosureChallenge.isActive = true

        tag:setDefaultFont(UIFont.Small)
        tag:ReadString(UIFont.Small, str, -1)
        tag:setDefaultColors(r, g, b)
        tag:setVisibleRadius(360)

        local yOffset = 0
        local xOffset = 0
        local function drawFunc()
            if not EnclosureChallenge.MouseTip then
                Events.OnPostRender.Remove(drawFunc)
                return
            end
            local zoom = getCore():getZoom(0)
            local screenX = (IsoUtils.XToScreen(x + xOffset, y, z, 0) - IsoCamera.getOffX()) / zoom
            local screenY = (IsoUtils.YToScreen(x + yOffset, y, z, 0) - IsoCamera.getOffY()) / zoom
            if EnclosureChallenge.MouseTip then tag:AddBatchedDraw(screenX, screenY-48, r,g,b,1, false) end
        end
        if EnclosureChallenge.checkMark ~= nil then
            EnclosureChallenge.checkMark:remove()
            EnclosureChallenge.checkMark = nil
        end
        if EnclosureChallenge.checkMark == nil then
            local markerSize = ZombRand(0.2, 1)
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
                if EnclosureChallenge.MouseTip then
                    EnclosureChallenge.checkMark = getWorldMarkers():addGridSquareMarker(stamp, stamp, sq, r, g, b, false, markerSize)
                end
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
    if not EnclosureChallenge.MouseTip then return end

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
    if not isIngameState() then return end

    local pl = getPlayer()
    if not pl then return end
    local xOffset = SandboxVars.EnclosureChallengeGUI.xPercentPos or 4
    local yOffset = SandboxVars.EnclosureChallengeGUI.yPercentPos or 55

    local xOffset = SandboxVars.EnclosureChallengeGUI.xOffset or 50
    local yOffset = SandboxVars.EnclosureChallengeGUI.yOffset or 50
    local textGap = SandboxVars.EnclosureChallengeGUI.textGap or 42

    local scrW = getCore():getScreenWidth()
    local scrH = getCore():getScreenHeight()

    local pos = EnclosureChallenge.posGUI
    local xPos, yPos
    if pos == 6 then -- preset
        xPos = (scrW / 8) + 55
        yPos = (scrH / 2) + 24
    elseif pos == 5 then -- bot right - offset
        xPos = scrW - xOffset
        yPos = scrH - yOffset
    elseif pos == 4 then -- pixel pos
        xPos = xOffset
        yPos = yOffset
    elseif pos == 3 then -- center + offset
        xPos = (scrW / 2) + xOffset
        yPos = (scrH / 2) + yOffset
    elseif pos == 2 then -- center no offset
        xPos = scrW / 2
        yPos = scrH / 2
    else -- percent position
        xPos = math.floor((xPercentPos / 100) * scrW)
        yPos = math.floor((yPercentPos / 100) * scrH)
    end

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
    local alpha = EnclosureChallenge.alphaGUI

    if isOutOfBounds and isChallenger then
        col = EnclosureChallenge.parseColor(SandboxVars.EnclosureChallengeGUI.BadColor)
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

    local optSizes = tonumber(SandboxVars.EnclosureChallengeGUI.FontSize) or 1
    local fSize = fontSizes[optSizes] or UIFont.Small
    local timeSize = timeSizes[optSizes] or UIFont.Medium

    if isChallenger then
        local modeStr = isRemoteMode and "Remote Mode" or "Additive Mode"
        local timeStr = EnclosureChallenge.getChallengeTimeStr()
        local headerStr = string.format("%s\n%s", modeStr, timeStr)
        getTextManager():DrawString(timeSize, xPos, yPos - textGap, headerStr, col.r, col.g, col.b, alpha)
    end

    local encInfo = {
        string.format("X: %d   Y: %d", round(x), round(y)),
        tostring(encStr),
        tostring(status),
        "",
    }


    if ec then
        table.insert(encInfo, tostring(#ec.Conquered) .. " : Conquered")
        table.insert(encInfo, tostring(ec.RemoteWins) .. " : RemoteWins")
        table.insert(encInfo, tostring(#ec.Challenges) .. " : Unlocked")
        table.insert(encInfo, tostring(ec.UnlockPoints) .. " : Points")
        table.insert(encInfo, "\nRewardChoice:\n" .. tostring(EnclosureChallenge.getRewardTitle(ec.RewardChoice)))
    else
        table.insert(encInfo, "\nNo Enclosure Data")
    end

    getTextManager():DrawString(fSize, xPos, yPos, table.concat(encInfo, '\n'), col.r, col.g, col.b, alpha)
end

Events.OnPostUIDraw.Add(EnclosureChallenge.GUI)
