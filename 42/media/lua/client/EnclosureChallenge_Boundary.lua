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

--client/EnclosureChallenge_Boundary.lua

EnclosureChallenge = EnclosureChallenge or {}

function EnclosureChallenge.isOutOfBounds(targ)
	if not isIngameState() or not targ then return false end

	local pl = getPlayer()
	if not pl or not pl:isAlive() or not EnclosureChallenge.isChallenger() then return false end

	local vehicle = targ == pl and pl:getVehicle() or nil
	local boundaryTarget = vehicle or targ
	local encStr = EnclosureChallenge.getEnclosureStr(boundaryTarget)
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
	if EnclosureChallenge.Rebound and EnclosureChallenge.Rebound.start then
		EnclosureChallenge.Rebound:start(pl)
	end
end

function EnclosureChallenge.getBoundaryRebound(pl)
	pl = pl or getPlayer()
	local ec = EnclosureChallenge.getData()
	if not pl or not ec then return nil end
	local encStr = EnclosureChallenge.isRemoteMode() and ec.RemoteChallenge or ec.AdditiveChallenge
	local encX, encY = encStr and tostring(encStr):match("^(-?%d+)_(-?%d+)$")
	encX, encY = tonumber(encX), tonumber(encY)
	if not encX or not encY then return nil end
	local size = EnclosureChallenge.EnclosureSize or 189
	local minX, minY = encX * size, encY * size
	local maxX, maxY = minX + size, minY + size
	local vehicle = pl:getVehicle()
	local margin = vehicle and 2.0 or 0.5
	local x, y = vehicle and vehicle:getX() or pl:getX(), vehicle and vehicle:getY() or pl:getY()
	return { x = math.max(minX + margin, math.min(x, maxX - margin)), y = math.max(minY + margin, math.min(y, maxY - margin)), z = pl:getZ() }
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
		target = nil,

		reset = function(self)
			self.tick = 0
			self.pl = nil
			self.staggered = false
			self.inTransit = false
			self.pending = false
			self.target = nil
			EnclosureChallenge.outOfBoundsPending = false
		end,

		start = function(self, player)
			if self.inTransit then return end
			self.inTransit = true
			self.pending = true

			player = player or getPlayer()
			local ec = player:getModData().EnclosureChallenge
			local p = SandboxVars.EnclosureChallenge.ReboundToBoundary ~= false
				and (EnclosureChallenge.getBoundaryRebound(player) or (ec and ec.Rebound))
				or (ec and ec.Rebound)

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
			self.target = { x = tonumber(p.x), y = tonumber(p.y), z = tonumber(p.z or 0) }
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

			if rebound.tick > 300 then
				Events.OnTick.Remove(rebound.handler)
				rebound:reset()
				return
			end

			local target = rebound.target
			local arrived = target and math.abs(pl:getX() - target.x) <= 2.5 and math.abs(pl:getY() - target.y) <= 2.5
			if arrived or (csq and EnclosureChallenge.isReboundSq(csq)) then
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

