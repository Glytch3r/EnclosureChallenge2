
--client/EnclosureChallenge_Boundary.lua

EnclosureChallenge = EnclosureChallenge or {}

function EnclosureChallenge.isOutOfBounds(targ)
	if not isIngameState() or not targ then return false end

	local pl = getPlayer()
	if not pl or not pl:isAlive() or not EnclosureChallenge.isChallenger() then return false end

	local encStr = EnclosureChallenge.getEnclosureStr(targ)
	if not encStr then return false end

	local ec = EnclosureChallenge.getData()
	if not ec then return false end

	if EnclosureChallenge.isRemoteMode() then
		return encStr ~= ec.RemoteChallenge

	elseif EnclosureChallenge.isAdditiveMode() then
		local csq = pl:getCurrentSquare()
		if csq and (EnclosureChallenge.isUnlocked(csq) or EnclosureChallenge.getEnclosureStatus(csq) == "Unlocked") then
			return false
		end

		ec.Challenges = ec.Challenges or {}
		return not ec.Challenges[encStr]
	end

	return false
end

function EnclosureChallenge.isSameEnclosure(targ)
	targ = targ or EnclosureChallenge.getPointer()
	local pl = getPlayer()
	if not targ or not pl then return false end

	local plEncStr = EnclosureChallenge.getEnclosureStr(pl)
	local targEncStr = EnclosureChallenge.getEnclosureStr(targ)
	if not plEncStr or not targEncStr then return false end

	return plEncStr == targEncStr
end

function EnclosureChallenge.rebound()
	local pl = getPlayer()
	local ec = EnclosureChallenge.getData()
	local p = ec and ec.Rebound

	if p and p.x and p.y and p.z then
		EnclosureChallenge.tp(pl, p.x, p.y, p.z)
	end
end

function EnclosureChallenge.isReboundSq(sq)
	return sq and EnclosureChallenge.getReboundSq() == sq
end

function EnclosureChallenge.getRebound()
	local ec = EnclosureChallenge.getData()
	if not ec or not ec.Rebound then return nil end
	return ec.Rebound.x, ec.Rebound.y, ec.Rebound.z or 0
end
function EnclosureChallenge.getReboundSq()
	local x, y, z = EnclosureChallenge.getRebound()
	if not x or not y then return nil end
	return getCell():getOrCreateGridSquare(x, y, z or 0)
end

EnclosureChallenge.Rebound = setmetatable({}, {
	__index = {
		tick = 0,
		pl = nil,
		staggered = false,
		inTransit = false,

		reset = function(self)
			self.tick = 0
			self.pl = nil
			self.staggered = false
			self.inTransit = false
		end,

		start = function(self, player)
			if self.inTransit then return end
			self.inTransit = true

			player = player or getPlayer()
			local ec = player:getModData().EnclosureChallenge
			local p = ec and ec.Rebound

			if not (p and p.x and p.y) then
				self:reset()
				return
			end

			if isClient() then
				sendClientCommand("EnclosureChallenge", "send", {})
			else
				EnclosureChallenge.tp(player, p.x, p.y, p.z or 0)
			end

			self.pl = player
			self.tick = 0
			self.staggered = false

			if SandboxVars.EnclosureChallenge.ReturnStaggered then
				Events.OnTick.Add(self.handler)
			else
				self:reset()
			end
		end,

		handler = function()
			local rebound = EnclosureChallenge.Rebound
			local pl = getPlayer()
			if not pl then
				Events.OnTick.Remove(rebound.handler)
				return
			end

			rebound.tick = rebound.tick + 1
			local csq = pl:getCurrentSquare()

			if rebound.tick % 4 == 0 or (csq and EnclosureChallenge.isReboundSq(csq)) then
				if not rebound.staggered and rebound.pl then
					rebound.staggered = true

					if isClient() then
						sendClientCommand("EnclosureChallenge", "stagger", {})
					else
						EnclosureChallenge.stag(pl)
					end

					Events.OnTick.Remove(rebound.handler)
					rebound:reset()
				end
			end
		end
	}
})

