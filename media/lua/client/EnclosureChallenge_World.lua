if not isIngameState() then return  end

--[[
local mapAPI = ISWorldMap_instance.javaObject:getAPIv1()
print(round((mapAPI:getWidthInSquares()-1)/189)) -- this should be the max number of enclosure x
print(round((mapAPI:getHeightInSquares()-1)/189)) -- this should be the max number of enclosure y

local mapAPI = ISWorldMap_instance.javaObject:getAPIv1()
print(round((mapAPI:getWidthInSquares()-1)))  -- this should be the worlds width
print(round((mapAPI:getHeightInSquares()-1))) -- this should be the worlds height ]]
--[[
EnclosureChallenge = EnclosureChallenge or {}

local function cb(num)
    print("You entered: " .. tostring(num))
end

EnclosureChallenge.TextInputDialog = function(pl, promptText, title, defaultText, callbackFn, callbackArg)
    pl = pl or getPlayer()
    if not pl or not promptText then return end

    getSoundManager():playUISound("EnclosureChallenge_Prompt")

    local plNum = pl:getPlayerNum()
    local width, height = 300, 150
    local x = getCore():getScreenWidth() / 2 - width / 2
    local y = getCore():getScreenHeight() / 2 - height / 2

    title = title or "Input Required"
    promptText = promptText:gsub("\\n", "\n")
    defaultText = tostring(defaultText or "")

    local function onInputEntered(dialog, button)
        if button.internal == "OK" then
            local input = dialog.entry:getText()
            local num = tonumber(input)
            if num then
                if callbackFn then callbackFn(num, callbackArg) end
            else
                print("Invalid input: not a number")
            end
        end

        dialog:setVisible(false)
        dialog:removeFromUIManager()
    end

    local inputDialog = ISTextBox:new(x, y, width, height, promptText, defaultText, nil, onInputEntered, plNum)
    inputDialog.noEmpty = false
    inputDialog.target = inputDialog
    inputDialog.ok = "OK"
    inputDialog.cancel = "Cancel"
    inputDialog:setTitle(title)
    inputDialog:initialise()
    inputDialog:addToUIManager()

    inputDialog.entry:ignoreFirstInput()
    local originalChange = inputDialog.entry.onTextChange
    inputDialog.entry.onTextChange = function(self)
        local filtered = self:getText():gsub("[^%d]", "")
        if self:getText() ~= filtered then
            self:setText(filtered)
        end
        if originalChange then originalChange(self) end
    end
end
 ]]
--EnclosureChallenge.TextInputDialog(getPlayer(), "Enter a number:", "Number Input", 100, cb)
