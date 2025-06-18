
EnclosureChallenge = EnclosureChallenge or {}
--[[
function EnclosureChallenge.unlockContext(playerIndex, context, worldObjects, test)
    local pl = getSpecificPlayer(playerIndex)
    if not pl or not pl:isAlive() then return end

    if not clickedSquare or not EnclosureChallenge.isOutOfBounds(clickedSquare) then return end

    context:addOption("Unlock Enclosure", worldObjects, function()
        local modal = ISModalDialog:new(0, 0, 250, 120, "Unlock this enclosure?", true, nil, EnclosureChallenge.confirmUnlock)
        modal:initialise()
        modal:addToUIManager()
        modal.moveWithMouse = true
        modal.pl = pl
        modal.sq = clickedSquare
    end)
end

function EnclosureChallenge.confirmUnlock(button)
    local dialog = button.parent
    if button.internal == "YES" then
        local pl = dialog.pl
        local sq = dialog.sq

        if pl and sq then
            local encStr = EnclosureChallenge.getEnclosureStr(sq)
            if encStr then
                local ec = pl:getModData().EnclosureChallenge or {}
                ec.Challenges = ec.Challenges or {}
                ec.Challenges[encStr] = true
                pl:setHaloNote("Enclosure Unlocked!", 0, 255, 0, 255)
            end
        end
    end

    dialog:removeFromUIManager()
end
Events.OnFillWorldObjectContextMenu.Remove(EnclosureChallenge.unlockContext)

Events.OnFillWorldObjectContextMenu.Add(EnclosureChallenge.unlockContext)
 ]]


-----------------------            ---------------------------
function EnclosureChallenge.ContinueDialog(pl, text, title, onClickCallback)
    pl = pl or getPlayer()
    if not pl or not text then return end
    local isChallenger = EnclosureChallenge.isChallenger()
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