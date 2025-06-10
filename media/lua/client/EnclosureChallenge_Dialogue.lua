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

-----------------------            ---------------------------
function EnclosureChallenge.isShouldAnnounce()
	return SandboxVars.EnclosureChallenge.StatusChat
end
function EnclosureChallenge.disabler(bool)
	local pl = getPlayer()
    pl:setBlockMovement(bool)
	pl:setAllowRun(not bool);
	pl:setAllowSprint(not bool);
	pl:setIgnoreInputsForDirection(bool)
	pl:setIgnoreMovement(bool)
	pl:setIgnoreContextKey(bool);
	pl:setIgnoreAimingInput(bool);
	pl:setIgnoreAutoVault(bool);
    pl:setBannedAttacking(bool)
	pl:setAuthorizeMeleeAction(not bool)
    pl:setAuthorizeShoveStomp(not bool)
	pl:setCanShout(not bool)
	--pl:setZombiesDontAttack(bool)
	--pl:setAvoidDamage(bool)
	--pl:setBlockMovement(bool)
    --pl:setAllChatMuted(bool)
	JoypadState.disableClimbOver = bool
	JoypadState.disableSmashWindow = bool
	JoypadState.disableReload = bool
	JoypadState.disableGrab = bool
	JoypadState.disableInvInteraction = bool
	JoypadState.disableYInventory = bool
	JoypadState.disableControllerPrompt = bool
	JoypadState.disableMovement = bool
	ISBackButtonWheel.disablePlayerInfo = bool
	ISBackButtonWheel.disableCrafting = bool
	ISBackButtonWheel.disableTime = bool
	ISBackButtonWheel.disableMoveable = bool
	ISBackButtonWheel.disableZoomOut = bool
	ISBackButtonWheel.disableZoomIn = bool
end

function EnclosureChallenge.onYes(isQuit, isRemote)
	local pl = getPlayer()
	if not pl then return end
	local isStart = not isQuit
	EnclosureChallenge.sfx(isStart)

	local encStr = EnclosureChallenge.getEnclosureStr(pl)
	isRemote = isRemote or EnclosureChallenge.isRemoteMode(pl)

	EnclosureChallenge.clearCoord()
    local ec = EnclosureChallenge.getData()
	--EnclosureChallenge.clearRebound()
	if not encStr or not ec then return end

	if isQuit then
		EnclosureChallenge.setChallenge(false, isRemote)
		EnclosureChallenge.delReturnPointMarker()
		EnclosureChallenge.clearRebound()
	else
		EnclosureChallenge.storeRebound(pl)
		EnclosureChallenge.setChallenge(true, isRemote)
		if isRemote then
			ec.RemoteChallenge = encStr
			ec.AdditiveChallenge = ""
		else
			ec.RemoteChallenge =  ""
			ec.AdditiveChallenge = encStr
		end
		EnclosureChallenge.setReturnPointMarker()
	end

	if EnclosureChallenge.isShouldAnnounce() then
		local user = tostring(pl:getUsername())
		local posStr = (encStr and SandboxVars.EnclosureChallenge.CoordNotif) and ": [" .. tostring(encStr).. "]" or ""
		local msg = user .. " " .. (isQuit and getText("ContextMenu_EnclosureChallenge_ChallengeWithdrawn") or getText("ContextMenu_EnclosureChallenge_ChallengeAccepted")) .. posStr
		if isClient() then
			processGeneralMessage(msg)
		else
			pl:setHaloNote(msg, 150, 250, 150, 900)
		end
	end
end

function EnclosureChallenge.onNo(isRemote, isQuit, pl)
    if isQuit then

        EnclosureChallenge.sfx(isQuit)
	else
		if isRemote then
			EnclosureChallenge.goBack()
			EnclosureChallenge.clearCoord()
		end
    end

end


function EnclosureChallenge.ConfirmDialog(pl, text, title, isQuit, isRemote, unlockTarg)
	pl = pl or getPlayer()
	if not pl or not text then return end
	local isChallenger = EnclosureChallenge.isChallenger(pl)
	if not isQuit and isChallenger then return end

	title = title or "Enclosure Challenge"
	text = text:gsub("\\n", "\n")

	EnclosureChallenge.disabler(true)
	getSoundManager():playUISound("EnclosureChallenge_Prompt")

	local width, height = 300, 150
	local x = getCore():getScreenWidth() / 2 - width / 2
	local y = getCore():getScreenHeight() / 2 - height / 2
	local plNum = pl:getPlayerNum()

	local dialog

    local function cleanup()
        if dialog then
            dialog:setVisible(false)
            dialog:removeFromUIManager()
			EnclosureChallenge.disabler(false)
        end
    end


	local function onClick(target, button)
		EnclosureChallenge.disabler(false)
		if button.internal == "YES" then
			if unlockTarg then
				EnclosureChallenge.doUnlock(unlockTarg)
			else
				EnclosureChallenge.onYes(isQuit, isRemote)

			end
		elseif button.internal == "NO" then
			EnclosureChallenge.onNo(isRemote, isQuit, pl)
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

--[[_____________________________________________________________________________________________________________________________
   ░▒▓██████▓▒░    ░▒▓████████▓▒░    ░▒▓█▓▒░         ░▒▓█▓▒░      ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░           ░▒▓█▓▒░         ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▓▒░  ░▒▓▒░
  ░▒▓█▓▒▒▓███▓▒░   ░▒▓█▓▒░         ░▒▓██████▓▒░      ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█████████▓▒░     ░▒▓███▓▒░     ░▒▓███████▓▒░
  ░▒▓█▓▒░          ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░         ░▒▓█▓▒░ ░▒▓█▓▒░         ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
  ░▒▓█▓▒░░▒▓█▓▒░   ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░     ░▒▓█▓▒░     ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓█▓▒░ ░▒▓█▓▒░  ▒▓░    ░▒▓█▓▒░   ░▒▓█▒░  ░▒▓█▒░
   ░▒▓█████▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░  ░▒▓███████▓▒░   ░▒▓██████▓▒░   ░▒▓█▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░    ░▒▓███████▓▒░
█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████--]]

