-- No Cap v1.1 by Wumbo
-- Special thanks to Rumia1, whose implementation in Classic.wad provided some guidance for my own
-- speedinc, originalspeed, speedcap toggle and uhhh i forgot by ME!! IHTK!!! Hopefully you can't tell what was and wasn't mine...:eyes:
freeslot("sfx_mwresr")
sfxinfo[sfx_mwresr].caption = "Item Reserved"
local MS_NOCAP = 1
local MS_PEELOUT = 2
rawset(_G, "kombiwhoignoresmaxspeed", { -- Characters who get to switch normalspeed on the fly
	["kombi"] = MS_NOCAP|MS_PEELOUT, -- 2 == Peelout Sprites Allowed
	["stryke"] = MS_NOCAP|MS_PEELOUT,
	["tynker"] = MS_NOCAP|MS_PEELOUT,
	["trez"] = MS_NOCAP|MS_PEELOUT,
	["shayde"] = MS_NOCAP|MS_PEELOUT,
})

addHook("ThinkFrame", do
	for player in players.iterate do
		local skin = player.realmo.skin
		local skinData = skins[skin]
		local heistSign = FangsHeist and FangsHeist.playerHasSign(player)

		if (not kombiwhoignoresmaxspeed[skin] or not (kombiwhoignoresmaxspeed[skin] & MS_NOCAP)) and not player.kombispeedcap or heistSign return
		else
			-- Get movement speed of player proportional to scale
			player.realspeed = FixedDiv(FixedHypot(player.rmomx, player.rmomy), player.mo.scale)
			-- Get the character's default normalspeed
			if player.originalspeed == nil then
				player.originalspeed = skins[player.mo.skin].normalspeed
			end

			-- Temporarily negate effects of speed-increasing powerups to avoid disrupting later calculations
			if player.powers[pw_sneakers] or player.powers[pw_super] then
				if not player.fast then
					player.fast = true
					player.originalspeed = ($1 * 3) / 5
					player.normalspeed = (skins[player.mo.skin].normalspeed * 3) / 5
				end
				player.realspeed = ($1 * 3) / 5
			elseif player.fast then
				player.fast = false
				player.originalspeed = skins[player.mo.skin].normalspeed
				player.normalspeed = skins[player.mo.skin].normalspeed
			end

			-- Prevent the movement speed value from exceeding normalspeed when the player is airborne
			-- The first tic after touching the ground is also taken into account
			if player.airborne or not P_IsObjectOnGround(player.mo) then
				player.realspeed = FixedMul($1, player.mo.friction)
			end
			player.airborne = not P_IsObjectOnGround(player.mo)

			-- Allow conservation of speed underwater by bringing movement speed value closer to normalspeed
			if player.mo.eflags & MFE_UNDERWATER and P_IsObjectOnGround(player.mo) then
				player.realspeed = $1 * 2
			end

			-- Make sure underwater speed adjustments don't carry over when the player exits water
			if player.underwater and not (player.mo.eflags & MFE_UNDERWATER) and player.realspeed > player.originalspeed then
				player.realspeed = $1 / 2
			end
			player.underwater = player.mo.eflags & MFE_UNDERWATER

			if player.realmo.headbashing then
				player.speedinc = player.speedinc + FRACUNIT / 36
			else
				player.speedinc = 0
			end

			-- Disable speed cap when movement speed value exceeds normalspeed
			-- This is done by adjusting the normalspeed to match the movement speed value on the fly
			local nuspeed = player.originalspeed + player.speedinc
			if player.dashspeedinc
				nuspeed = $ + player.dashspeedinc
			end
			if player.realspeed > player.normalspeed then
				player.normalspeed = player.realspeed
			elseif player.realspeed <= nuspeed
				player.normalspeed = nuspeed
			end

			-- Re-apply effects of speed-increasing powerups now that calculations are complete
			if player.fast then
				player.normalspeed = max($1, skins[player.mo.skin].normalspeed)
			end
		end
	end
end)

local function UpdatePlayerPowerUp(player)
	local currentShield = player.powers[pw_shield]
	local selectedItem = nil

	if currentShield == SH_ARMAGEDDON -- we probably don't need this in actuality but i'm not fucking touching this
		selectedItem = "fireflower"
	else
		if (currentShield & SH_FORCE) != 0
			currentShield = $&!SH_FORCEHP -- don't use your SH_FORCEHP to give power-ups you can't have kthxbai
		end
		for shieldFlag, curItem in pairs(kombiShieldToSMW) do
			if (currentShield & shieldFlag) != 0 and currentShield == shieldFlag
				selectedItem = curItem
				break
			end
		end
	end
	if selectedItem
		K_PushPowerUp(player, selectedItem) -- you can handle it i believe in you
	end
end

local function K_RunShieldCheck(player)
	if not (player.mo and player.mo.skin == "shayde" and player.powers[pw_shield] and cv_wl4hp.value) return end
	UpdatePlayerPowerUp(player)
	player.powers[pw_shield] = 0
	P_RemoveShield(player)
end

local function PausedThinker(player)
	if not player.paused return end
	player.mo.momx = 0 -- Don't move an INCH.
	player.mo.momy = 0
	player.mo.momz = 0
	player.drawangle = player.oldvel.angle
	player.cmd.forwardmove = 0 -- stinkeye.png
	player.cmd.sidemove = 0
	player.cmd.buttons = 0 -- make 'em RESPECT stasis.
	if player.wl4kombitime >= 0 -- wanna make sure these values are actually valid.
		player.wl4kombitime = $-1
	end
	if player.realmo.punchtime > 0
		player.realmo.punchtime = $+1
	end
end

addHook("PreThinkFrame", function(player)
	for player in players.iterate do
		if not player.mo continue end
		PausedThinker(player)
		if player.incollectanim
			if not kombiSMWItems[player.kombismwpowerupstate].collectfunc(player, player.kombiclock)
				player.kombiclock = $ + 1
			else
				K_ResumeMomentum(player)
				player.incollectanim = nil
			end
		end
		if player.dashmode > 3*TICRATE-1
			if player.dashspeedinc < skins[player.realmo.skin].normalspeed
				player.dashspeedinc = ($ or 0)+FRACUNIT/5
			end
		else
			player.dashspeedinc = 0
		end
	end
end)

addHook("PostThinkFrame", function(player)
	for player in players.iterate do
		if not player.mo continue end
		if player.paused
			if player.incollectanim and kombiSMWItems[player.kombismwpowerupstate].forcespr2
				player.mo.sprite2 = kombiSMWItems[player.kombismwpowerupstate].forcespr2
			else
				player.mo.sprite2 = player.freezesprite2
			end
			if player.incollectanim and not kombiSMWItems[player.kombismwpowerupstate].collectionanimatesplayer
				player.mo.frame = player.freezeframe
			end
		end
	end
end)

addHook("ShieldSpawn", function(player)
	if not player.mo return end
	K_RunShieldCheck(player)
end)

addHook("TouchSpecial", function(mobj,toucher)
	K_PushPowerUp(toucher, "fireflower")
	mobj.state = S_NULL
	return true
end, MT_FIREFLOWER)