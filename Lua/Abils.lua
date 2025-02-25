freeslot("S_PLAY_SLAM","S_PLAY_SPINJUMP","S_FLUDDWATER","MT_FLUDDWATER","SPR2_SLAM","SPR2_WAL1",
"sfx_ptslam","sfx_ptstsl",
"sfx_swsjmp","sfx_kmspin","sfx_kmwkik","sfx_kwskid","sfx_kswtch",
"sfx_m64unh","sfx_m64doh","sfx_m64oof",
"sfx_kmbip0","sfx_kmbip1",
"sfx_lbmenu",
"sfx_wlslid","sfx_wlroll",
"sfx_hlfal1","sfx_hlfal2","sfx_hlfal3")

mobjinfo[MT_FLUDDWATER] = {
	spawnstate = S_FLUDDWATER,
	spawnhealth = 1000,
	deathstate = S_FLUDDWATER,
	radius = mobjinfo[MT_RING].radius,
	height = mobjinfo[MT_RING].height,
	dispoffset = 4,
	flags = MF_SCENERY|MF_MISSILE|MF_SLIDEME,
}

states[S_FLUDDWATER] = {
	sprite = SPR_RING,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 3,
	var2 = 2,
	nextstate = S_FLUDDWATER,
}

states[S_PLAY_SLAM] = {
	sprite = SPR_PLAY,
	frame = SPR2_SLAM,
	tics = -1,
	nextstate = S_PLAY_SLAM,
}
spr2defaults[SPR2_SLAM] = SPR2_ROLL
states[S_PLAY_SPINJUMP] = {
	sprite = SPR_PLAY,
	frame = SPR2_STND,
	tics = -1,
	nextstate = S_PLAY_SPINJUMP,
}

addHook("PlayerSpawn", function(player)
		player.slamstate = 0
		player.spinangle = 0
		player.instad = false
		player.spinjumping = false
		player.realmo.walljumps = 0
end)


rawset(_G, "kombiallowsquashnstretch", { -- Which characters get to utilize squash and stretch from abilities, made specifically to ensure other mods using spritexscale and spriteyscale act as intended
	["kombi"] = true, -- Acts as a "is this part of OUR mod?" because WHO WOULD WANT TO ADD THEIR CHARACTER INTO THIS??
	["shayde"] = true,
	["trez"] = true,
})

local spinangle = 0

sfxinfo[sfx_ptstsl].caption = "Groundslam Starting"
sfxinfo[sfx_ptslam].caption = 'Groundslam'
sfxinfo[sfx_swsjmp].caption = 'Spinjump'
sfxinfo[sfx_kswtch].caption = 'Mode Switch'
sfxinfo[sfx_kmspin].caption = 'Boosted Spinjump'
sfxinfo[sfx_kmwkik].caption = 'Wallkick'
sfxinfo[sfx_m64unh].caption = "Unh!"
sfxinfo[sfx_m64doh].caption = "D'oh!"
sfxinfo[sfx_m64oof].caption = "Oof!"
sfxinfo[sfx_kmbip0].caption = "Eh..!"
sfxinfo[sfx_kmbip1].caption = "Hup!"

addHook("AbilitySpecial", function(player)
	if not (player.valid and player.realmo and player.realmo.valid) return end
	if (player.pflags & PF_THOKKED) return end
	if player.realmo.collidewall and srb2p return false end
	if player.realmo.skin == "tynker"
		return true
	end
	if player.realmo.skin == "kombi" and player.charability == CA_DOUBLEJUMP
		if player.realmo.collidewall return true end
		player.pflags = $|PF_THOKKED
		if not srb2p
			player.powers[pw_strong] = STR_STOMP|STR_ANIM
		end
		player.spinjumping = true
		player.kombispinabil = nil -- reset this
		player.realmo.state = S_PLAY_SPINJUMP
		if not ((player.powers[pw_shield] & SH_NOSTACK) & SH_ARMAGEDDON == 2)
			P_SetObjectMomZ(player.realmo, 12*FRACUNIT, (player.realmo.momz*P_MobjFlip(player.mo) > 0))
			S_StartSound(player.realmo,sfx_swsjmp)
		else
			P_SetObjectMomZ(player.realmo, 20*FRACUNIT, (player.realmo.momz*P_MobjFlip(player.mo) > 0))
			S_StartSound(player.realmo,sfx_kmspin)
		end
		return true
	end
end)

local maxaerialspin = 2*TICRATE

addHook("ShieldSpecial", function(player)
	if player.mo.skin != "kombi" return end
	print((player.powers[pw_shield] & SH_NOSTACK))
	if (player.powers[pw_shield] & SH_NOSTACK) == SH_PITY|SH_PROTECTFIRE
		player.kombicustomshieldabil = maxaerialspin
		player.pflags = $|PF_SPINNING|PF_STARTDASH
		if VERSION >= 202 or (VERSION == 202 and SUBVERSION >= 14)
			player.cmd.buttons = $|BT_SPIN
		end
		player.charability2 = 0 -- Don't even fight the default CHARABILITY2 here. We aren't gonna win.
		player.realmo.state = S_PLAY_SPINDASH
		player.drawangle = player.realmo.angle
		player.kombifirespinangle = player.realmo.angle
		player.lightspeedhold = leveltime
		player.kombipreuseangle = nil
		player.storemom = FixedHypot(player.mo.momx, player.mo.momy)
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		S_StartSound(player.realmo, sfx_spndsh)
	elseif (player.powers[pw_shield] & SH_NOSTACK) == SH_ATTRACT
		player.kombicustomshieldabil = TICRATE/3
		player.homingtarget = P_LookForEnemies(player) or $
	elseif (player.powers[pw_shield] & SH_NOSTACK) == SH_WHIRLWIND
		player.storemom = FixedHypot(player.mo.momx, player.mo.momy)
		player.kombicustomshieldabil = TICRATE
	end
	return true
end)

addHook("PlayerCanEnterSpinGaps", function(player)
	if player.mo.kombislopetimer and player.mo.kombislopetimer >= 10
		return true
	end
end)

/*
player.mo.angle = player.wl2slopeangle
player.mo.kombislopetimer = ($ or 0)+1
player.currentzdelta = player.mo.standingslope.zdelta
player.kombislopespeed = FixedMul(abs(player.currentzdelta),cos(player.mo.angle-slopeang))*48
P_InstaThrust(player.mo,player.mo.angle,player.kombislopespeed)
*/

rawset(_G, "kombiwhocanslide", { -- Characters who get to utilize the environment
	["kombi"] = BT_CUSTOM2,
	["trez"] = BT_CUSTOM2,
	-- ["shayde"] = BT_SPIN,
})

local function setsloperoll(thing,tmthing)
	if tmthing.type == MT_PLAYER
		if tmthing.z + tmthing.height > thing.z and tmthing.z < thing.z + thing.height -- are we *actually* touching this, or is the game pulling our leg? Please god why does the game have to do this to me
			tmthing.player.kombislopespeed = 5*thing.info.damage/6
		end
	end
end

local function dospringshit(thing,tmthing)
	if tmthing.type == MT_PLAYER
		if tmthing.z + tmthing.height > thing.z and tmthing.z < thing.z + thing.height + 2*FRACUNIT
			tmthing.player.kombispringtwirl = true
		end
	end
end

local function undospringshit(thing,tmthing)
	if tmthing.type == MT_PLAYER
		if tmthing.z + tmthing.height > thing.z and tmthing.z < thing.z + thing.height + 2*FRACUNIT
			tmthing.player.kombispringtwirl = nil
		end
	end
end

addHook("MobjCollide", dospringshit, MT_REDSPRING)
addHook("MobjCollide", dospringshit, MT_YELLOWSPRING)
addHook("MobjCollide", dospringshit, MT_BLUESPRING)
addHook("MobjCollide", dospringshit, MT_SPRINGSHELL)
addHook("MobjCollide", dospringshit, MT_YELLOWSHELL)
addHook("MobjCollide", dospringshit, MT_YELLOWSPRINGBALL)
addHook("MobjCollide", dospringshit, MT_REDSPRINGBALL)
addHook("MobjCollide", undospringshit, MT_REDDIAG)
addHook("MobjCollide", undospringshit, MT_YELLOWDIAG)
addHook("MobjCollide", undospringshit, MT_BLUEDIAG)

addHook("MobjCollide", setsloperoll, MT_REDHORIZ)
addHook("MobjCollide", setsloperoll, MT_YELLOWHORIZ)
addHook("MobjCollide", setsloperoll, MT_BLUEHORIZ)

local function P_SmokeRing(player, rings, cmomz, spawncenter)
	local kombiburstang = player.realmo.angle
	if rings -- "You can't do anything, so don't even try." ("Sonic, dead or alive, is m-m-mine.")
		local zoffset = spawncenter and player.mo.height or 0 -- offset by playerheight always brings it to our center
		for i = 1, rings do
			local ringburst = P_SpawnMobjFromMobj(player.realmo, 0, 0, zoffset, MT_ARIDDUST)
			ringburst.angle = kombiburstang
			ringburst.fuse = 1*TICRATE
			ringburst.momx = FixedMul(cos(ringburst.angle),FixedMul(FixedMul(2*FRACUNIT, FRACUNIT + FixedDiv(player.losstime<<FRACBITS, 10*TICRATE<<FRACBITS)), player.mo.scale))
			if not (twodlevel or (player.mo.flags2 & MF2_TWOD))
				ringburst.momy = FixedMul(sin(ringburst.angle),FixedMul(FixedMul(2*FRACUNIT, FRACUNIT + FixedDiv(player.losstime<<FRACBITS, 10*TICRATE<<FRACBITS)), player.mo.scale))
			end
			ringburst.momz = cmomz or 0
			kombiburstang = $+FixedAngle(FRACUNIT*360/rings)
		end
	end
end

addHook("PlayerThink", function(player)
	if not player.mo return end
	if player.mo.skin == "tynker" and not (player.cmd.buttons & BT_SPIN)
		player.kombismsrocketcharge = nil
		player.kombidontusefludd = nil
	end
	if player.kombispringtwirl
		if player.mo.state != S_PLAY_SPRING
			player.kombispringtwirl = nil
			player.kombitwirlangle = nil
		return end
		player.kombitwirlangle = ($ or player.drawangle)+ANG10 -- SCD's twirl anim probably comes out to this value but i ain't checkin' allat
		player.drawangle = player.kombitwirlangle
	end
end)

rawset(_G, 'L_FixedDecimal', function(str,maxdecimal)
	if str == nil or tostring(str) == nil
		return '<invalid FixedDecimal>'
	end
	local number = tonumber(str)
	maxdecimal = ($ != nil) and $ or 3
	if tonumber(str) == 0 return '0' end
	local polarity = abs(number)/number
	local str_polarity = (polarity < 0) and '-' or ''
	local str_whole = tostring(abs(number/FRACUNIT))
	if maxdecimal == 0
		return str_polarity..str_whole
	end
	local decimal = number%FRACUNIT
	decimal = FRACUNIT + $
	decimal = FixedMul($,FRACUNIT*10^maxdecimal)
	decimal = $>>FRACBITS
	local str_decimal = string.sub(decimal,2)
	return str_polarity..str_whole..'.'..str_decimal
end)

local function handle_slope_sliding(player)
	local slopenormal = player.mo.standingslope.normal
	local slope_angle = R_PointToAngle2(0,0,slopenormal.x, slopenormal.z)
	local slidethreshold_angle = FixedAngle(45*FRACUNIT)
	local slopesteepness = player.mo.standingslope.zdelta

	print(
		"Our slope is at an angle of "..L_FixedDecimal(AngleFixed(slope_angle)).."...",
		"We require an angle greater than "..L_FixedDecimal(AngleFixed(slidethreshold_angle)).." to slide...",
		slope_angle > slidethreshold_angle
	)

	if slope_angle > slidethreshold_angle
		local slidefactor = FixedMul(abs(slopesteepness), 17*FRACUNIT/2) -- physics dictate that we should pull ourselves down when on a slope, so throw out the sign of our Z Delta.
		local slopexyangle = R_PointToAngle2(0,0,slopenormal.x,slopenormal.y)
		player.slidingx = ($ or 0)+FixedMul(slidefactor,cos(slopexyangle)) -- defer to a variable because i don't feel up to managing SRB2's tomfoolery
		player.slidingy = ($ or 0)+FixedMul(slidefactor,sin(slopexyangle)) -- unfortunately this means making two since the goblin living in my macine can't automatically know what i want out of this script
		player.mo.momx = player.slidingx -- now that we know how fast to slide down, we should probably give our actual momentum those same variables to not get our momentum killed when we hit a flat surface
		player.mo.momy = player.slidingy -- ^ ...But SRB2 doesn't allow us to InstaThrust this way, so plug our sliding variables into the company-branded InstaThrust function.
		-- P_InstaThrust(player.mo, R_PointToAngle2(0,0,player.slidingx,player.slidingy), FixedHypot(player.slidingx,player.slidingy))
		-- player.slidingx = FixedMul($, player.mo.friction)
		-- player.slidingy = FixedMul($, player.mo.friction)
	end
end

local kombigroundhittimer = TICRATE/5

local dontswitch = {
	[S_PLAY_GLIDE] = true,
	[S_PLAY_PAIN] = true,
	[S_PLAY_DEAD] = true,
	[S_PLAY_DRWN] = true,
	[S_PLAY_ROLL] = true,
	[S_PLAY_JUMP] = true
}

addHook("PlayerThink", function(player)
	if not player.mo return end
	if P_IsObjectOnGround(player.realmo)
		player.spinjumping = false
		player.instad = false
		player.kombigrounded = true
	else
		if kombiwhogetswl4stuff[player.mo.skin]
			if not (player.pflags & PF_JUMPED) and not player.powers[pw_carry]
				player.pflags = $|PF_JUMPED|PF_NOJUMPDAMAGE
				if not dontswitch[player.mo.state]
					if player.mo.momz > 0
						player.mo.state = S_PLAY_SPRING
					else
						player.mo.state = S_PLAY_FALL
					end
				end
			end
		end
		player.kombigrounded = false
	end
	if player.mo.skin == "stryke" and player.mo.state == S_PLAY_GLIDE and player.skidtime
		player.skidtime = -1
		player.glidetime = -1
		player.mo.state = S_PLAY_WALK
	end
	if (FixedHypot(player.rmomx, player.rmomy)  >= 40*FRACUNIT)
	and (FixedDiv(player.mo.momz, player.mo.scale) == 0*FRACUNIT)
	or player.mo.skin == "kombi" and "\$gamemap\ \$G_BuildMapTitle(gamemap)\" == "746 mindscape zone"
	   player.charflags = $|SF_RUNONWATER
	elseif not (skins[player.mo.skin].flags & SF_RUNONWATER) -- We're using a character that already uses this skin flag.
	   player.charflags = $&~SF_RUNONWATER
	end
	if kombiwhogetswl4stuff[player.mo.skin] == "smw" and (player.cmd.buttons & BT_CUSTOM2) and cv_wl4hp.value and kombiSMWItems[player.kombismwpowerupstate].usefunc
		kombiSMWItems[player.kombismwpowerupstate].usefunc(player)
	end
	if player.kombicustomshieldabil and player.kombicustomshieldabil > 0
		player.kombicustomshieldabil = $-1
		if (player.powers[pw_shield] & SH_NOSTACK) == SH_PITY|SH_PROTECTFIRE
			if VERSION >= 202 or (VERSION == 202 and SUBVERSION >= 14)
				player.cmd.buttons = $|BT_SPIN
			end
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
			-- P_SmokeRing(player, 10, -4*FRACUNIT)
			if not (BT_SHIELD and player.cmd.buttons & BT_SHIELD) or player.cmd.buttons & BT_SPIN
				S_StartSound(player.mo, sfx_s3k98)
				S_StartSound(player.mo, sfx_s3k43)
				S_StartSound(player.mo, sfx_zoom)
				local angleDifference = player.kombifirespinangle-player.drawangle
				local penaltyFactor = (angleDifference > ANGLE_90 or angleDifference < ANGLE_270) and FRACUNIT*3 or FRACUNIT
				local launchDistance = player.storemom + min(player.mindash + (maxaerialspin - player.kombicustomshieldabil) * (2*FRACUNIT/3), player.maxdash)
				launchDistance = FixedDiv(launchDistance, penaltyFactor)
				player.storemom = nil
				player.pflags = $|PF_SHIELDABILITY
				P_Thrust(player.realmo, player.drawangle, launchDistance)
				player.kombicustomshieldabil = 0
			end
			if player.kombicustomshieldabil == 0
				player.mo.state = S_PLAY_ROLL
				if player.storemom != nil
					S_StartSound(player.mo, sfx_kc59)
				end
			end
		elseif (player.powers[pw_shield] & SH_NOSTACK) == SH_ATTRACT
			P_InstaThrust(player.realmo, player.drawangle, player.actionspd)
			player.homingtarget = P_LookForEnemies(player) or $
			if player.kombicustomshieldabil == 0
				player.mo.state = S_PLAY_ROLL
				player.homingtarget = P_LookForEnemies(player) or $
				player.homingtime = 3*TICRATE
				player.pflags = $|PF_SHIELDABILITY
				if not player.homingtarget
					S_StartSound(player.mo, sfx_kc59)
					P_InstaThrust(player.realmo, player.drawangle, 18*FRACUNIT)
				end
			end
		elseif (player.powers[pw_shield] & SH_NOSTACK) == SH_WHIRLWIND
			player.mo.momx = 0
			player.mo.momy = 0
			player.mo.momz = 0
			if not (BT_SHIELD and player.cmd.buttons & BT_SHIELD) or player.cmd.buttons & BT_SPIN
				S_StartSound(player.mo, sfx_s3k98)
				P_SmokeRing(player, 10, -4*FRACUNIT, true)
				local launchDistance = min((15*FRACUNIT/4) + ((TICRATE - player.kombicustomshieldabil) * (FRACUNIT)), player.maxdash)
				P_Thrust(player.realmo, player.drawangle, player.storemom)
				player.pflags = $|PF_SHIELDABILITY
				P_SetObjectMomZ(player.realmo, launchDistance)
				if (TICRATE - player.kombicustomshieldabil) >= 24
					player.pflags = $|PF_NOJUMPDAMAGE
					player.mo.state = S_PLAY_SPRING
					player.kombispringtwirl = true
					P_RemoveShield(player)
				end
				player.kombicustomshieldabil = -1
			end
			if player.kombicustomshieldabil == 0
				S_StartSound(player.mo, sfx_s3k98)
				P_SmokeRing(player, 10)
				local launchDistance = min((15*FRACUNIT/4) + ((TICRATE - player.kombicustomshieldabil) * (FRACUNIT)), player.maxdash)
				P_Thrust(player.realmo, player.drawangle, player.storemom)
				player.pflags = $|PF_SHIELDABILITY
				P_SetObjectMomZ(player.realmo, launchDistance)
				if (TICRATE - player.kombicustomshieldabil) >= 24
					player.pflags = $|PF_NOJUMPDAMAGE
					player.mo.state = S_PLAY_SPRING
					player.kombispringtwirl = true
					P_RemoveShield(player)
				end
			end
		end
		if player.kombicustomshieldabil < 0
			player.kombicustomshieldabil = 0
		end
	end
	if player.homingtime
		if player.homingtarget and player.homingtarget.valid P_HomingAttack(player.mo, player.homingtarget) end
		player.homingtime = $-1
	end
	if player.mo.standingslope and player.mo.standingslope.zdelta and ((player.mo.skin == "kombi" and not player.kombiboosting) or player.mo.skin != "kombi")
		player.kombishouldroll = true
		if player.mo.skin == "shayde" and kombiwhocanslide[player.mo.skin] and (player.cmd.buttons & kombiwhocanslide[player.mo.skin])
			handle_slope_sliding(player)
		else
			local slopeang = R_PointToAngle2(0,0,player.mo.standingslope.normal.x,player.mo.standingslope.normal.y)
			if kombiwhocanslide[player.mo.skin] and (player.cmd.buttons & kombiwhocanslide[player.mo.skin])
				if not player.mo.kombislopetimer
					player.wl2slopeangle = slopeang
					player.mo.kombislopetimer = ($ or 0)+1
					player.powers[pw_strong] = STR_BUST|STR_ATTACK
					if not S_SoundPlaying(player.mo, sfx_wlslid)
						S_StartSound(player.realmo, sfx_wlslid)
					end
				elseif player.mo.kombislopetimer < 10
					player.mo.angle = player.wl2slopeangle
					player.mo.kombislopetimer = ($ or 0)+1
					player.kombislopespeed = abs(player.mo.standingslope.zdelta)*80
					P_InstaThrust(player.mo,slopeang,player.kombislopespeed)
					if not S_SoundPlaying(player.mo, sfx_wlslid)
						S_StartSound(player.realmo, sfx_wlslid)
					end
					player.powers[pw_strong] = STR_BUST|STR_ATTACK
				end
			end
		end
	elseif player.mo.kombislopetimer and player.mo.kombislopetimer < 10
		player.mo.kombislopetimer = 0
		player.kombishouldroll = false
	end
	if player.mo.skin == "shayde"
		player.kombishouldroll = nil
	end
	if (player.realmo.eflags & MFE_SPRUNG)
		player.wl2slopeangle = player.realmo.angle
	end
	if player.mo.kombislopetimer
		if not (player.cmd.buttons & kombiwhocanslide[player.mo.skin])
			player.mo.kombislopetimer = 0
			player.kombishouldroll = false
			return
		end
		player.drawangle = player.wl2slopeangle
		if player.mo.kombislopetimer >= 10
			if player.mo.state == S_PLAY_SPRING
				player.mo.kombislopetimer = 0
				player.kombishouldroll = false
				player.powers[pw_strong] = 0
				return
			end
			player.mo.angle = player.wl2slopeangle
			local compzdelta = player.mo.standingslope and abs(player.mo.standingslope.zdelta)*80 or -1
			if compzdelta > player.kombislopespeed
				player.kombislopespeed = compzdelta
			end
			P_InstaThrust(player.mo,player.mo.angle,player.kombislopespeed)
			player.kombirollsfxtimer = ($ or 0)
			if player.kombirollsfxtimer%8 == 0
				S_StartSound(player.realmo, sfx_wlroll)
			end
			player.kombirollsfxtimer = $+1
			if not (player.mo.state == S_PLAY_ROLL)
				player.mo.state = S_PLAY_ROLL
			end
			player.powers[pw_strong] = STR_BUST|STR_ATTACK
		end
	elseif kombiwhogetswl4stuff[player.mo.skin] and player.realmo.punchtime and player.realmo.punchtime <= 0
		player.powers[pw_strong] = 0
	end
	if player.realmo.skin == "tynker" and (player.realmo.eflags & MFE_UNDERWATER) and player.smswater < 100*FRACUNIT
		player.smswater = $+FRACUNIT
	end
	if player.smswater and player.smswater > 100*FRACUNIT player.smswater = 100*FRACUNIT end
	player.slamstate = $ or 0
	if player.slamstate
		if player.mo.skin == "trez"
			if not P_IsObjectOnGround(player.realmo)
				player.mo.state = S_PLAY_SLAM
				player.powers[pw_strong] = STR_BOUNCE
			else
				player.slamstate = 0
			end
		end
		player.charflags = $|SF_NOSHIELDABILITY
	else
		if player.mo and player.mo.skin == "trez" or not (player.mo.kombislopetimer and player.mo.kombislopetimer < 11)
			player.powers[pw_strong] = 0
			player.slamstate = 0
		end
	end
	if player.slamstate or player.realmo.collidewall
		if not player.powers[pw_super]
			player.charflags = $&~SF_SUPER
		end
		player.charflags = $|SF_NOSHIELDABILITY
	else
		if not (player.charflags & SF_SUPER) and (skins[player.mo.skin].flags & SF_SUPER)
			player.charflags = $|SF_SUPER
		end
		if (player.charflags & SF_NOSHIELDABILITY) and not (skins[player.mo.skin].flags & SF_NOSHIELDABILITY)
			player.charflags = $&~SF_NOSHIELDABILITY
		end
	end
	if not player.mo.pushing
		player.realmo.pushing = 0
	else
		player.realmo.pushing = $ - 1
	end
	if not player.mo.pause
		player.realmo.pause = -35
	end
	if not player.mo.state == S_PLAY_FALL
		player.realmo.pushing = 0
	end
	if player.realmo.pause > 0
		player.realmo.pause = $-1
		player.momx = 0
		player.momy = 0
		player.momz = 0
	elseif player.realmo.pause <= 0
		player.realmo.pause = -35
		player.momx = player.storemomx
		player.momy = player.storemomy
		player.momz = player.storemomz
	end
	if player.mo.kombislopetimer == nil
		player.mo.kombislopetimer = 0
	end
	if player.kombishouldroll and not (player.mo.kombislopetimer or player.mo.standingslope and player.mo.standingslope.zdelta)
		player.kombishouldroll = false
	end
	if (player.mo.eflags & MFE_JUSTHITFLOOR) and player.playerstate != PST_DEAD
		player.kombisquashclock = kombigroundhittimer
		if kombiwhogetswl4stuff[player.mo.skin]
			S_StartSound(nil, sfx_kmland, player)
		end
	else
		if player.kombisquashclock -- please speed i need this
			player.kombisquashclock = $-1
		else
			player.lastvertmom = player.mo.momz
		end
	end
	if player.kombispinabil == "waitamoment" -- bounce from Kombi's Bounce Bracelet
		if kombiallowsquashnstretch[player.mo.skin]
			player.realmo.spriteyscale = max(1, FixedDiv(FixedMul(player.mo.momz, (5*FRACUNIT/3)-(2*FRACUNIT)), 45*FRACUNIT) + FRACUNIT)
		end
		if player.kombigrounded
			player.kombispinabil = nil
			player.pflags = $&~PF_SPINNING
			player.pflags = $&~PF_STARTDASH
			player.nospindash = false
		end
	elseif player.kombispinabil == "rico" -- Jettisoning down to the floor from Kombi's Bounce Bracelet
		if kombiallowsquashnstretch[player.mo.skin]
			player.realmo.spriteyscale = max(1, FixedDiv(FixedMul(-1*abs(player.mo.momz), (5*FRACUNIT/3)-(2*FRACUNIT)), 50*FRACUNIT) + FRACUNIT)
		end
		if player.kombigrounded
			player.bouncedelay = 4
			P_SetObjectMomZ(player.realmo, min(60*FRACUNIT, (player.zvel-22*FRACUNIT)*3/2), false)
			player.kombispinabil = "waitamoment"
			player.mo.state = S_PLAY_ROLL
			player.pflags = $|PF_JUMPED
			player.pflags = $&~PF_SPINNING
			player.pflags = $&~PF_STARTDASH
		else
			player.nospindash = true
			player.zvel = abs(player.mo.momz)
		end
	elseif player.kombicustomshieldabil and (player.powers[pw_shield] & SH_NOSTACK) == SH_PITY|SH_PROTECTFIRE -- Kombi charging the Flame Shield Spindash
		player.realmo.spriteyscale = max(1, FixedDiv(FixedMul((player.kombicustomshieldabil - maxaerialspin)*FRACUNIT, (5*FRACUNIT/3)-(2*FRACUNIT)), 50*FRACUNIT) + FRACUNIT)
	elseif player.kombicustomshieldabil and (player.powers[pw_shield] & SH_NOSTACK) == SH_WHIRLWIND -- Kombi charging the Whirlwind Boost
		player.realmo.spriteyscale = max(1, FixedDiv(FixedMul((player.kombicustomshieldabil - TICRATE)*FRACUNIT, FRACUNIT - FRACUNIT/2), 50*FRACUNIT) + FRACUNIT)
	else
		if kombiallowsquashnstretch[player.mo.skin] -- Default Behavior
			if player.kombisquashclock -- ANY self-respecting Squash and Stretch code squashes the player sprite when we hit the ground!
				local progress = FixedDiv(player.kombisquashclock, kombigroundhittimer)
				local squish = FixedDiv(abs(player.lastvertmom or 0), FRACUNIT*5/2)
				player.realmo.spriteyscale = ease.outback(progress, FRACUNIT,FixedDiv(FRACUNIT,((30*FRACUNIT)+squish)/32))
			else
				player.realmo.spriteyscale = max(1, FixedDiv(FixedMul(-abs(player.mo.momz), (5*FRACUNIT/3)-(2*FRACUNIT)), 70*FRACUNIT) + FRACUNIT)
			end
		end
	end
	if kombiallowsquashnstretch[player.mo.skin]
		player.realmo.spritexscale = max(1, FixedDiv(FRACUNIT, player.realmo.spriteyscale))
	end
	
	if (player.realmo.skin != "kombi") return end -- now we're REALLY getting into hardcode!
	if player.bouncedelay player.bouncedelay = $-1 end
	if P_LookForEnemies(player, true) and not player.homing
		player.charability = CA_HOMINGTHOK
	else
		player.charability = CA_DOUBLEJUMP
	end
	if player.realmo.state == S_PLAY_SPINJUMP
		player.spinangle = ($ or 0)+FixedAngle(60*FRACUNIT)
		player.drawangle = player.spinangle
	end
end)

addHook("MobjDamage", function(mo,mobj,src,dmg,dmgtype)
	if not (mo and mo.valid) return end
	if not ((mo.flags & MF_SHOOTABLE) or (mo.flags & (MF_ENEMY|MF_BOSS|MF_MONITOR))) return end
	
	if not (mobj and mobj.valid) return end
	if not (mobj.player and mobj.player.valid) return end
	if mobj.player.pflags & PF_THOKKED >= 1
		mobj.player.pflags = $&~PF_THOKKED
	end
end)

addHook("JumpSpinSpecial", function(player)
	if player.kombimode == 1 and player.realmo.skin == "kombi"
		if not (player.valid and player.realmo and player.realmo.valid) return true end
			if player.realmo.skin == "kombi" and not player.instad
				
				player.instad = true
			end
		return true
	end
end)

rawset(_G, "cv_kombiwallkicktype", CV_RegisterVar({
	name = "k_instantwallkick",
	defaultvalue = "Off",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {On = 1, Off = 0},
}))

rawset(_G, "cv_kombibonkers", CV_RegisterVar({
	name = "k_bonking",
	defaultvalue = "Off",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {On = 1, Off = 0},
}))

local skin = "kombi"
local thebutton = BT_JUMP
local wallkickheight = 20
local wallkickthrust = 15
local sound = sfx_kmwkik

local function resetWallJump(player)
    player.realmo.walljump = false
    player.kombispinabil = nil
    player.realmo.collidewall = 0
end

local function handleWallkick(player)
	P_InstaThrust(player.realmo, player.realmo.angle, player.wallhitvel+wallkickthrust*FRACUNIT)
    if player.realmo.walljumps > 4 then
        P_SetObjectMomZ(player.realmo, FixedDiv(wallkickheight * FRACUNIT, max((player.realmo.walljumps - 4) * FRACUNIT, FRACUNIT)))
    else
        P_SetObjectMomZ(player.realmo, wallkickheight * FRACUNIT)
    end
    if player.realmo.walljumps == 0 and (player.pflags & PF_THOKKED) then
        player.pflags = $ & ~PF_THOKKED
    end
    S_StartSound(player.realmo, sound)
    player.realmo.walljumps = $ + 1
end

addHook("PlayerThink", function(player)
    if not player.mo then return end
    if CV_FindVar("k_instantwallkick").string == "Off" then
        if player.realmo.walljump == nil then
            player.realmo.walljump = false
        end
        if player.realmo.collidewall == nil then
            player.realmo.collidewall = 0
        end
        if player.realmo.collidewall > 0 then
            player.realmo.collidewall = $ - 1
        end
        if P_IsObjectOnGround(player.realmo) then
            player.realmo.walljumps = 0
        end

        -- Walljump logic (initial jump)
        if player.kombimode == 0 and player.realmo.skin == skin and (player.cmd.buttons & thebutton) and
           not P_IsObjectOnGround(player.realmo) and player.realmo.collidewall and not player.realmo.walljump then
            player.realmo.walljump = true
            player.realmo.state = S_PLAY_CLING
            player.kombispinabil = nil
            player.pflags = $ | PF_FULLSTASIS
            P_SpawnSkidDust(player, player.realmo.radius, false)
            S_StartSound(player.realmo, sfx_kwskid)
            P_SetObjectMomZ(player.realmo, 0)
        end

        -- Walljump logic (ongoing)
        if player.realmo.walljump == true and player.realmo.collidewall then
            player.realmo.state = S_PLAY_CLING
            player.pflags = $ | PF_FULLSTASIS
            player.kombispinabil = nil
            player.pflags = $ & ~PF_GLIDING
            P_SpawnSkidDust(player, player.realmo.radius, false)
            S_StartSound(player.realmo, sfx_kwskid)
            P_SetObjectMomZ(player.realmo, -2 * FRACUNIT)
        end

        -- Wallkick logic (release button)
        if player.realmo.skin == skin and not (player.cmd.buttons & thebutton) and not P_IsObjectOnGround(player.realmo) and
           player.realmo.walljump == true and player.realmo.collidewall then
            resetWallJump(player)
            player.realmo.angle = $ + ANGLE_180
            player.drawangle = player.realmo.angle
            handleWallkick(player)
            player.realmo.state = S_PLAY_SPRING
            player.pflags = $ | PF_JUMPED
        end

        -- Wallkick logic (no wall)
        if player.realmo.walljump == true and player.realmo.collidewall == 0 and not (player.cmd.buttons & thebutton) and
           not P_IsObjectOnGround(player.realmo) then
            resetWallJump(player)
            player.realmo.state = S_PLAY_FALL
            player.pflags = $ & ~PF_FULLSTASIS
        end
    else
        if player.realmo.collidewall == nil then
            player.realmo.collidewall = 0
        end
        if player.realmo.collidewall > 0 then
            player.realmo.collidewall = $ - 1
        end
        if P_IsObjectOnGround(player.realmo) then
            player.realmo.walljumps = 0
        end

        if player.realmo.skin == skin and (player.cmd.buttons & thebutton) and not P_IsObjectOnGround(player.realmo) and
           player.realmo.collidewall then
            resetWallJump(player)
            player.realmo.angle = $ + ANGLE_180
            player.drawangle = player.realmo.angle
            handleWallkick(player)
            player.realmo.state = S_PLAY_ROLL
            player.pflags = $ | PF_JUMPED
        end
    end
end)

addHook("MobjMoveBlocked", function(mo, mobj, line)
    if mo.skin == skin and not P_IsObjectOnGround(mo) and not (mobj and mobj.valid and mobj.flags & (MF_MONITOR | MF_ENEMY | MF_BOSS)) then
        if (mo.player.cmd.buttons & BT_JUMP) then return end
        if PTR_GlideClimbTraverse(mo, line) and mo.player and mo.player.valid then
            local real, ang = PTR_GlideClimbTraverse(mo, line)
            if line and line.valid then
                if P_IsClimbingValid(mo.player, ang) or (mobj and mobj.valid) then
                    if mobj and mobj.valid then
                        -- handle valid object collision
                    end
                    if not mo.collidewall then
                        mo.player.wallhitvel = mo.player.speed >> 2
                    end
                    mo.collidewall = 10
                end
            end
        elseif mobj and mobj.valid then
            mo.collidewall = 10
        end
    end
end, MT_PLAYER)

addHook("MobjMoveBlocked", function(mo, mobj, line)
    if mo.skin == skin and not P_IsObjectOnGround(mo) and PTR_GlideClimbTraverse(mo, line) then
        if abs(mo.momx) + abs(mo.momy) >= 20 * FRACUNIT + FRACUNIT / 4 and cv_kombibonkers.string == "On" then
            if abs(mo.momx) + abs(mo.momy) >= 32 * FRACUNIT then
                S_StartSound(mo, sfx_m64doh)
                mo.state = S_PLAY_PAIN
            else
                S_StartSound(mo, sfx_m64unh)
                mo.state = S_PLAY_FALL
            end
            P_InstaThrust(mo, mo.angle, -4 * FRACUNIT)
        end
    elseif mo.skin == skin and PTR_GlideClimbTraverse(mo, line) then
        if mo.pushing >= 6 then
            if mo.pushing == 6 then
                S_StartSound(mo, P_RandomRange(sfx_kmbip0, sfx_kmbip1))
            end
            mo.state = S_PLAY_FALL
        end
        mo.pushing = $ + 2
    end
end, MT_PLAYER)