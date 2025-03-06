local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
SafeFreeSlot("sfx_sready", "sfx_slspgo", "sfx_salspd", "sfx_lspdst", "sfx_lspdlo",
"S_PLAY_KOMBICROUCH","SPR2_CRCH","SPR_KOMBIINSTASHIELD",
"S_PLAY_KOMBILOOKUP1","S_PLAY_KOMBILOOKUP2","SPR2_LUP1","SPR2_LUP2",
"S_PLAY_KOMBIPEELOUT1","S_PLAY_KOMBIPEELOUT2","S_PLAY_KOMBIPEELOUT3",
"MT_KMBIINSTA","S_KMBIINSTA",
"S_PLAY_KOMBILSD", "SPR2_LSPD")
sfxinfo[sfx_sready].caption = '\x85"READYYY!"\x80'
sfxinfo[sfx_slspgo].caption = '\x85"GO!!"\x80'
sfxinfo[sfx_salspd].caption = 'Lightspeed Dash'
sfxinfo[sfx_lspdst].caption = 'Lightspeed Dash Start!'
sfxinfo[sfx_lspdlo].caption = '/'

rawset(_G, "cv_soniccddash", CV_RegisterVar({
	name = "k_cdfx",
	defaultvalue = "Auto",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {Yes = 2, Auto = 1, No = 0},
}))

rawset(_G, "cv_limitshayde", CV_RegisterVar({
	name = "k_shaydeabillimits",
	defaultvalue = "Dont",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {Dont = -1, Auto = 0, Sonic1 = 1, Sonic2 = 2, SonicCD = 3, Sonic3 = 4},
}))

mobjinfo[MT_KMBIINSTA] = {
	doomednum = -1,
	dispoffset = 1,
	spawnhealth = 1000,
	spawnstate = S_KMBIINSTA,
	radius = 30*FRACUNIT,
	height = 60*FRACUNIT,
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIPHEIGHT
}

states[S_KMBIINSTA] = {
	sprite = SPR_KOMBIINSTASHIELD,
	frame = A|FF_ANIMATE,
	tics = 8,
	var1 = 8,
	var2 = 1,
	nextstate = S_NULL
}

states[S_PLAY_KOMBILOOKUP1] = {
	sprite = SPR_PLAY,
	frame = SPR2_LUP1,
	tics = 18,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBILOOKUP2
}
states[S_PLAY_KOMBILOOKUP2] = {
	sprite = SPR_PLAY,
	frame = SPR2_LUP2,
	tics = -1,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBILOOKUP2
}
states[S_PLAY_KOMBICROUCH] = {
	sprite = SPR_PLAY,
	frame = SPR2_CRCH,
	tics = -1,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBILOOKUP2
}
states[S_PLAY_KOMBIPEELOUT1] = {
	sprite = SPR_PLAY,
	frame = SPR2_WALK,
	tics = -1,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBIPEELOUT2
}
states[S_PLAY_KOMBIPEELOUT2] = {
	sprite = SPR_PLAY,
	frame = SPR2_RUN_,
	tics = -1,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBIPEELOUT3
}
states[S_PLAY_KOMBIPEELOUT3] = {
	sprite = SPR_PLAY,
	frame = SPR2_DASH,
	tics = -1,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBIPEELOUT3
}

spr2defaults[SPR2_CRCH] = SPR2_LAND

rawset(_G, "cv_kombilspd", CV_RegisterVar({
	name = "k_lightspeeddash",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {On = 1, Off = 0},
}))

local function stripColorTags(text)
	return text:gsub("[%z\128-\143]", "") -- I HATE YOU
end
/*
CDFM79 = Air Warning
CDFM02 = Jump
CDFM00 = Skid
*/
local shaydeAbilityMap = {
	["S1"] = {
		spindash = false,
		cdfx = false,
		peelout = false,
		instashield = false,
	},
	["S2"] = {
		spindash = true,
		cdfx = false,
		peelout = false,
		instashield = false,
	},
	["CD"] = {
		spindash = true,
		cdfx = true,
		peelout = true,
		instashield = false,
	},
	["S3"] = {
		spindash = true,
		cdfx = false,
		peelout = false,
		instashield = true,
	},
	["NoLimits"] = {
		spindash = true,
		cdfx = false,
		peelout = true,
		instashield = true,
	},
}

local classichudmap = {
	"S1", "S2", "CD", "S3", "S2", "S2", "NoLimits", "S2"
}

local function K_SetCDFXLatch(entry)
	local isCD = CV_FindVar("classic_hud") and classichudmap[CV_FindVar("classic_hud").value] == "CD"
	if cv_soniccddash.value == 2
		entry["cdfx"] = true
	elseif cv_soniccddash and cv_soniccddash.value == 1 and isCD
		entry["cdfx"] = true
	elseif cv_soniccddash.value == 0
		entry["cdfx"] = false
	end
end

local function K_GetAbils(map)
	if mapheaderinfo[map]["shaydeprefabilset"] and shaydeAbilityMap[mapheaderinfo[map]["shaydeprefabilset"]]
		local abilityEntry = shaydeAbilityMap[mapheaderinfo[map]["shaydeprefabilset"]]
		K_SetCDFXLatch(abilityEntry)
		return abilityEntry
	end

	local zoneMappings = {
		CD = {
			"palmtree panic", "collision chaos", "tidal tempest", "quartz quadrant",
			"wacky workbench", "stardust speedway", "metallic madness", "dubious depths",
			"desert dazzle", "final fever", "black core zone 1", "neo palmtree" -- Black Core Zone Act 1 is inherently Sonic CD, Neo Palmtree is just Palmtree Panic
		},
		["S1"] = {
			"green hill", "marble zone", "spring yard", "labyrinth zone",
			"star light", "scrap brain", "final zone", "special stage",
			"temple trek zone" -- Based off of Labyrinth Zone.
		},
		["S2"] = {
			"emerald hill", "chemical plant", "aquatic ruin", "casino night",
			"hill top", "mystic cave", "oil ocean", "metropolis zone",
			"sky chase", "wing fortress"
		},
		["S3"] = {
			"angel island", "hydrocity", "marble garden", "carnival night",
			"icecap", "launch base", "mushroom hill", "flying battery",
			"sandopolis", "lava reef", "hidden palace", "sky sanctuary",
			"death egg", "doomsday", "the doomsday" -- prefer S3K over S2 for more abilities
		}
	}

	local stageName = string.lower(stripColorTags(G_BuildMapTitle(map)))

	for entryKey, zones in pairs(zoneMappings) do
		for _, zone in ipairs(zones) do
			if string.find(stageName, zone)
				local entry = shaydeAbilityMap[entryKey]
				K_SetCDFXLatch(entry)
				return entry
			end
		end
	end

	if CV_FindVar("classic_hud")
		local entry = shaydeAbilityMap[classichudmap[CV_FindVar("classic_hud").value]]
		return entry
	end

	return shaydeAbilityMap["NoLimits"]
end

addHook("PlayerSpawn", function(player)
	if (player.realmo.skin == "kombi") and not srb2p
		player.lightspeedhold = 0
		player.lightspeeddashable = 0
		player.timervar2 = 0
	end
end)

local function SearchForGrabbables(player)
	local closest = nil
	searchBlockmap("objects", function(refmobj, mo)
		if mo.health <= 0 -- Don't be gross.
			return
		end
		
		if (mo.flags & MF_SPECIAL) -- We're probably trying to grab the portal or somewhere similar
			return
		end

		if not P_CheckSight(player.realmo, mo) -- Out of sight, so out of mind.
			return
		end

		if closest and P_AproxDistance(P_AproxDistance(player.realmo.x-mo.x, player.realmo.y-mo.y),
			player.realmo.z-mo.z) > P_AproxDistance(P_AproxDistance(player.realmo.x-closest.x,
			player.realmo.y-closest.y), player.realmo.z-closest.z)
			return
		end
		
		closest = mo
	end, player.realmo, player.realmo.x-64*FRACUNIT, player.realmo.x+64*FRACUNIT, player.realmo.y-64*FRACUNIT, player.realmo.y+64*FRACUNIT)
	return closest or false
end

if not srb2p
	addHook("SpinSpecial", function(player)
		if (player.realmo.skin == "trez") and not P_IsObjectOnGround(player.realmo)
			/*if SearchForGrabbables(player)
			print("Grab!",SearchForGrabbables(player).type)
			else*/
			player.mo.state = S_PLAY_SLAM
			player.slamstate = 2
			--end
		end
		if player.realmo.skin == "kombi"
			if (player.realmo.state == S_PLAY_ROLL and not (player.pflags & PF_STARTDASH))
				player.nospindash = true
				player.realmo.state = S_PLAY_STND
				player.pflags = $&~PF_SPINNING
				return true
			end
			if (P_IsObjectOnGround(player.realmo))
			and player.realmo.state != S_PLAY_PAIN
			and player.realmo.state != S_PLAY_DEAD
			and player.realmo.state != S_PLAY_DRWN
			and player.realmo.state != S_PLAY_SPINDASH
			and player.realmo.state != S_PLAY_ROLL
			and not player.powers[pw_carry]
			and not player.nospindash
				if player.lightspeeddashable > 0 and CV_FindVar("k_lightspeeddash").string == "On" return true end
				player.pflags = $|PF_SPINNING|PF_STARTDASH
				player.charability2 = 0 -- Don't even fight the default CHARABILITY2 here. We aren't gonna win.
				player.realmo.state = S_PLAY_SPINDASH
				player.drawangle = player.realmo.angle
				player.lightspeedhold = leveltime
				S_StartSound(player.realmo, sfx_spndsh)
				if CV_FindVar("k_lightspeeddash").string == "On"
					S_StartSound(player.realmo, sfx_salspd)
				end
			end
			return true
		end
		if player.realmo.skin == "shayde" return true end
	end)
end

addHook("PlayerThink", function(player)
	if not (player.mo.skin == "shayde" and kombiwhocanslide[player.mo.skin] and (player.cmd.buttons & kombiwhocanslide[player.mo.skin]))
		player.slidingx = player.mo.momx
		player.slidingy = player.mo.momy
	end
	if not player.mo return end
	if player.lightspeedhold == nil
		player.lightspeedhold = 99999*TICRATE
	end
	if player.lightspeeddashable == nil
		player.lightspeeddashable = 0
	end
	if player.timervar2 == nil
		player.timervar2 = 99999*TICRATE
	end
	if (player.realmo.state == S_PLAY_PAIN) and player.lightspeeddashable == 2
		player.lightspeeddashable = 0
	end
	if (player.lightspeedhold - leveltime) <= -100 and player.realmo.state == S_PLAY_SPINDASH and player.realmo.skin == "kombi"
		if CV_FindVar("k_lightspeeddash").string == "On"
			player.realmo.colorized = true
			S_StopSoundByID(player.realmo, sfx_salspd)
			player.charability2 = CA2_SPINDASH
			S_StartSound(player.realmo, sfx_sready)
			player.lightspeeddashable = 1
			player.realmo.state = S_PLAY_STND
			player.pflags = $&~PF_SPINNING
			player.pflags = $&~PF_STARTDASH
		end
	end
	if CV_FindVar("k_lightspeeddash").string == "Off" and player.fcolorize == true
		player.fcolorize = false
	end
end)

local SpindashSFX = {
	sfx_s3kab,
	sfx_s3kab1,
	sfx_s3kab2,
	sfx_s3kab3,
	sfx_s3kab4,
	sfx_s3kab5,
	sfx_s3kab6,
	sfx_s3kab7,
	sfx_s3kab8,
	sfx_s3kab9,
	sfx_s3kaba,
	sfx_s3kabb,
	sfx_s3kabc,
	sfx_s3kabd,
	sfx_s3kabe,
	sfx_s3kabf
}

local function K_GetSpindashSFX(player, revspeed)
	local num_sections = 16

	if revspeed <= 0
		return SpindashSFX[1]
	end
	if revspeed > 8*FRACUNIT
		return SpindashSFX[num_sections] or SpindashSFX[1]
	end
	local section_size = 8*FRACUNIT / num_sections
	local section = FixedCeil(FixedDiv(revspeed,section_size))/FRACUNIT
	return SpindashSFX[min(section, num_sections)] or SpindashSFX[1]
end

addHook("PlayerThink", function(player)
	if not (player.cmd.buttons & BT_SPIN)
		player.nospindash = false
	end
	if (player.pflags & PF_STARTDASH)
	and player.realmo.skin == "kombi"
	and not (player.cmd.buttons & BT_SPIN)
		if player.lightspeeddashable > 0 and CV_FindVar("k_lightspeeddash").string == "On" return true end
		//player.charability2 = CA2_SPINDASH
		player.realmo.state = S_PLAY_ROLL
		player.pflags = $&~PF_STARTDASH
		P_Thrust(player.realmo, player.realmo.angle, min(player.mindash+(leveltime-player.lightspeedhold)*FRACUNIT,player.maxdash))
		S_StopSoundByID(player.realmo, sfx_salspd)
		S_StartSound(player.realmo, sfx_zoom)
	end
end)

local function GetShaydeAbilityMap(player) -- TODO: Merge with K_GetAbils
	local limitMode = cv_limitshayde.value
	local abilmap
	local tableshipt = {
		"S1",
		"S2",
		"CD",
		"S3"
	}
	if limitMode == 0 -- Auto
		abilmap = K_GetAbils(gamemap) or shaydeAbilityMap["NoLimits"]
	else
		abilmap = shaydeAbilityMap[tableshipt[limitMode]] or shaydeAbilityMap["NoLimits"]
	end
	K_SetCDFXLatch(abilmap)
	return abilmap
end

local CDReplacements = {
	[sfx_jump] = sfx_cdfm02,
	[sfx_skid] = sfx_cdfm00,
	-- [sfx_wtrdng] = sfx_cdfm79 -- Why does SRB2 not have anything to deal with locally-played sounds, again?
}

addHook("PlayerThink", function(player)
	if not player.mo return end
	if not player.mo.skin == "shayde" return end

	local abilityMap = GetShaydeAbilityMap(player)
	local minDash = player.mindash or 8 * FRACUNIT
	local maxDash = player.maxdash or 12 * FRACUNIT
	
	if abilityMap.cdfx -- cdfx == everything Sonic CD makes different.
		for originalSfx, replacementSfx in pairs(CDReplacements) do
			if S_SoundPlaying(player.mo, originalSfx)
				S_StopSoundByID(player.mo, originalSfx)
				S_StartSound(player.mo, replacementSfx)
			end
		end
	end
	
	if player.kombiclassicspindash
		if not abilityMap.cdfx
			-- Genesis Spindash
			print(player.kombispinrev)
			player.kombispinrev = max($ - FixedDiv(FixedFloor(FixedDiv(player.kombispinrev, FRACUNIT / 8)), 448 * FRACUNIT / 3), 0)
			player.pflags = $ | PF_JUMPSTASIS
			player.realmo.momx, player.realmo.momy = 0, 0
			local spinrevPercent = FixedDiv(player.kombispinrev, 8 * FRACUNIT)
			local launchSpeed = minDash + FixedMul(spinrevPercent, (maxDash - minDash))
			if not (player.cmd.buttons & BT_SPIN)
				player.pflags = $ & ~(PF_JUMPSTASIS | PF_STARTDASH)
				player.realmo.state = S_PLAY_ROLL
				player.kombiclassicspindash = nil
				S_StartSound(player.realmo, sfx_zoom)
				P_InstaThrust(player.realmo, player.realmo.angle, launchSpeed)
				player.kombispinrev = 0
			end
			if (player.cmd.buttons & BT_JUMP) and not (player.lastbuttons & BT_JUMP)
				for spindashsect, spindashsfx in ipairs(SpindashSFX) do
					S_StopSoundByID(player.realmo, spindashsfx)
				end
				S_StartSound(player.realmo, K_GetSpindashSFX(player, player.kombispinrev))
				player.kombispinrev = min($ + 2 * FRACUNIT, 8 * FRACUNIT)
				player.realmo.frame = A -- Emulate Sonic Games' decision to reset spindash frames every time you charge
			end
		else
			-- CD Spindash
			player.pflags = $ | PF_JUMPSTASIS
			if not player.kombicddashclock
				S_StartSound(player.realmo, sfx_cdfm11)
			end
			player.kombicddashclock = ($ or 0) + 1
			if player.kombicddashclock >= TICRATE * 3 / 8
				if player.kombicddashclock%2 player.realmo.state = S_PLAY_ROLL end -- we shouldn't be alternating checks.
			elseif player.kombicddashclock >= TICRATE * 3 / 4 -- additional indicator for full charge because it looks nice :)
				player.realmo.state = S_PLAY_ROLL
			end
			if not (player.cmd.buttons & BT_SPIN)
				player.pflags = $ & ~(PF_JUMPSTASIS | PF_STARTDASH)
				player.kombiclassicspindash = nil
				if player.kombicddashclock >= TICRATE * 3 / 4
					S_StartSound(player.realmo, sfx_cdfm01)
					P_InstaThrust(player.realmo, player.realmo.angle, player.maxdash)
					player.kombicddashclock = nil
				end
			end
		end
	elseif player.kombisuperpeelout and abilityMap.peelout
		-- Super Peel-Out
		player.kombisuperpeelout = $ + 1
		player.realmo.momx, player.realmo.momy = 0, 0
		if player.kombisuperpeelout < TICRATE / 4
			if player.kombisuperpeelout % 2 player.realmo.state = S_PLAY_KOMBIPEELOUT1 end
		elseif player.kombisuperpeelout < TICRATE / 3
			player.realmo.state = S_PLAY_KOMBIPEELOUT1
		elseif player.kombisuperpeelout - TICRATE / 3 < TICRATE / 2
			player.realmo.state = S_PLAY_KOMBIPEELOUT2
		else
			player.realmo.state = S_PLAY_KOMBIPEELOUT3
		end
		if not (player.cmd.buttons & BT_CUSTOM1)
			if player.kombisuperpeelout >= TICRATE / 2
				S_StartSound(player.realmo, sfx_cdfm01)
				P_Thrust(player.realmo, player.drawangle, player.maxdash)
				player.realmo.state = S_PLAY_DASH
			else
				player.realmo.state = S_PLAY_STND
			end
			player.kombisuperpeelout = nil
		end
	end
end)

addHook("PreThinkFrame", function()
	for player in players.iterate do
		if not player.mo continue end
		if player.kombiboosting -- put irrelevant code here since i am NOT prepared for testing the performance impact of doing multiple PreThinkFrame hooks
			player.cmd.forwardmove = 50
			player.cmd.sidemove = $/2
		end
		if player.mo.skin != "shayde" continue end

		local abilityConfig = GetShaydeAbilityMap(player) or shaydeAbilityMap["NoLimits"]

		local canstand = true
		canstand = not player.mo.standingslope or (player.mo.standingslope.flags & SL_NOPHYSICS) or abs(player.mo.standingslope.zdelta) < FRACUNIT/2
		if canstand and ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo))
			if not player.kombishouldroll
				if player.speed < FixedMul(5*FRACUNIT, player.mo.scale)
					if (player.cmd.buttons & BT_SPIN) and not player.kombiclassicspindash
						player.realmo.state = S_PLAY_KOMBICROUCH
						if (player.cmd.buttons & BT_JUMP) and abilityConfig.spindash
							player.kombiclassicspindash = true
							player.pflags = $ | PF_SPINNING | PF_STARTDASH

							if (cv_soniccddash.value == 2 or (cv_soniccddash.value == 1 and abilityConfig.cdfx))
								-- We're setting up CD Spindash, set the player's state and remove the relevant variable!
								player.realmo.state = S_PLAY_ROLL -- Emulate Sonic CD's decision to not have spindash frames.
								player.kombicddashclock = nil
							else
								-- We're setting up Genesis Spindash, set the player's state and clear the relevant variable!
								player.realmo.state = S_PLAY_SPINDASH
								player.kombispinrev = 0
							end

							player.cmd.buttons = $ & ~BT_JUMP
						end
					end
				else
					if (player.cmd.buttons & BT_SPIN) and not (player.pflags & PF_SPINNING)
						player.pflags = $ | PF_SPINNING
						S_StartSound(player.realmo, sfx_spin)
						player.realmo.state = S_PLAY_ROLL
					end
				end
			end
		else
			if (player.cmd.buttons & BT_SPIN) and not (player.pflags & PF_SPINNING)
				player.pflags = $ | PF_SPINNING
				S_StartSound(player.realmo, sfx_spin)
				player.realmo.state = S_PLAY_ROLL
			end
		end
		if player.realmo.state == S_PLAY_KOMBICROUCH and not (player.cmd.buttons & BT_SPIN)
			player.realmo.state = S_PLAY_STND
		end
		if (player.panim == PA_IDLE or player.panim == PA_EDGE) and (player.cmd.buttons & BT_CUSTOM1)
			player.realmo.state = S_PLAY_KOMBILOOKUP1
		end
		if player.mo.state == S_PLAY_KOMBILOOKUP1 or player.mo.state == S_PLAY_KOMBILOOKUP2
			if not (player.cmd.buttons & BT_CUSTOM1)
				player.realmo.state = S_PLAY_STND
				continue
			end
			if (player.cmd.buttons & BT_CUSTOM2)
				
			end
			if (player.cmd.buttons & BT_JUMP) and not player.kombisuperpeelout and abilityConfig.peelout
				player.cmd.buttons = $ & ~BT_JUMP
				player.kombisuperpeelout = 1
				S_StartSound(player.realmo, sfx_cdfm11)
			end
		end
		if player.kombisuperpeelout or player.mo.state == S_PLAY_KOMBILOOKUP1 or player.mo.state == S_PLAY_KOMBILOOKUP2
			player.cmd.buttons = $ & ~(BT_SPIN | BT_CUSTOM2 | BT_CUSTOM3)
			if player.kombisuperpeelout
				player.cmd.buttons = $ & ~BT_JUMP
			end
		end
	end
end)

addHook("AbilitySpecial", function(player)  -- unFORTUNATELY SRB2 needs us to use a CA_ constant to utilize this hook so expect bots to instashield at inappropriate times
	if player.mo.skin == "shayde" and not player.powers[pw_shield] and not (player.pflags & PF_THOKKED)
		local abilityConfig = GetShaydeAbilityMap(player) or shaydeAbilityMap["NoLimits"]

		if not abilityConfig or not abilityConfig.instashield
			if player.kombismwpowerupstate != "small"
				return
			end
		end

		S_StartSound(player.mo, sfx_s3k42)
		local instashield = P_SpawnMobjFromMobj(player.mo, 0, 0, 0, MT_KMBIINSTA)
		instashield.target = player.mo
		instashield.scale = FixedMul(player.mo.scale, 6*FRACUNIT/5)
		player.kmbiinstaclock = 8
		player.pflags = $ | PF_THOKKED
		return true
	end
end)

addHook("PlayerHeight", function(player)
	if player.realmo.state == S_PLAY_KOMBICROUCH or (player.mo.skin == "shayde" and player.kombismwpowerupstate == "small") return player.spinheight end
end)

addHook("PlayerCanEnterSpinGaps", function(player) -- just let us use PlayerHeight and be done with it dude
	if player.realmo.state == S_PLAY_KOMBICROUCH or (player.mo.skin == "shayde" and player.kombismwpowerupstate == "small") return true end
end)

addHook("MobjThinker", function(mobj)
	P_MoveOrigin(mobj, mobj.target.x, mobj.target.y, mobj.target.z-12*FRACUNIT)
end, MT_KMBIINSTA)

addHook("MobjMoveCollide", function(tmthing, thing)
	if not (tmthing.z-FixedMul(18*FRACUNIT, tmthing.scale) > thing.z+thing.height) and not (thing.z-FixedMul(18*FRACUNIT, tmthing.scale) > tmthing.z+tmthing.height)
		if (thing.valid and (thing.flags & (MF_ENEMY|MF_BOSS|MF_MONITOR) or (thing.flags & MF_PUSHABLE and thing.flags & MF_SHOOTABLE))) and not (thing.flags2 & MF2_FRET) and (tmthing.target.player.pflags & PF_JUMPED)
			P_DamageMobj(thing, tmthing, tmthing.target)
			if P_MobjFlip(tmthing.target)*tmthing.target.momz < 0
				tmthing.target.momz = -$
			end
			if (thing.info.spawnhealth > 1)
				tmthing.target.momy = -$
				tmthing.target.momx = -$
			end
		end
	end
end, MT_KMBIINSTA)

hud.add(function(v, player)
	if not player.mo return end
	if player.mo.skin == "shayde"
		local abilityMap = GetShaydeAbilityMap(player)
		local abilities = {
			{enabled = abilityMap.spindash, graphic = "ABIL_S2SPINDASH"},
			{enabled = abilityMap.peelout, graphic = "ABIL_CDPEELOUT"},
			{enabled = abilityMap.instashield, graphic = "ABIL_S3INSTA"}
		}
		local nameoffset
		local spacing
		local x
		local y
		if not (Style_Pack_Active and Style_ClassicVersion) -- Classic Style checks
			nameoffset = kombiGetSMWLifeFontWidth(v,skins[player.mo.skin].hudname)/2
			spacing = 14
			x = 68-nameoffset
			y = 32
		else
			spacing = 14
			x = 16
			y = 163
		end
		for _, ability in ipairs(abilities) do
			if ability.enabled
				v.drawScaled(x*FRACUNIT, y*FRACUNIT, FRACUNIT/2, v.cachePatch(ability.graphic), V_HUDTRANS)
				x = $ + spacing
			end
		end
	end
end)

-- Commence Lightspeed Dash Section

local lspdrange = RING_DIST*2/3
local lspdspeed = 60 * FRACUNIT
local lspdskin = "kombi"
local min_rings = 3
local horizangle = 45*FRACUNIT
local vertangle = 45*FRACUNIT

local function GetDistance(x1, y1, z1, x2, y2, z2)
	return P_AproxDistance(P_AproxDistance(x1 - x2, y1 - y2), z1 - z2)
end

local function NormalizeAngle(angle)
	return (angle + 180*FRACUNIT) % (360*FRACUNIT) - 180*FRACUNIT
end

local function GetAngleDifference(angle1, angle2)
	return abs(NormalizeAngle(angle1 - angle2))
end

local function IsRingWithinAngle(player, ring)
	local px, py, pz = player.realmo.x, player.realmo.y, player.realmo.z
	local rx, ry, rz = ring.x, ring.y, ring.z

	local hor_angle = AngleFixed(R_PointToAngle2(px, py, rx, ry))
	local vert_dist = R_PointToDist2(px, py, rx, ry)
	local vert_angle = AngleFixed(R_PointToAngle2(vert_dist, pz, 0, rz)) - 180*FRACUNIT

	local player_angle = AngleFixed(player.realmo.angle)

	local hor_diff = GetAngleDifference(hor_angle, player_angle)
	local vert_diff = abs(vert_angle)

	return hor_diff <= horizangle and vert_diff <= vertangle, hor_diff, vert_diff
end

local function FindClosestRing(player)
	local rings = {}
	local px, py, pz = player.realmo.x, player.realmo.y, player.realmo.z

	searchBlockmap("objects", function(_, mo)
		if mo.health <= 0 or not (mo.type == MT_RING or mo.type == MT_COIN) then return end
		if GetDistance(px, py, pz, mo.x, mo.y, mo.z) > lspdrange then return end
		if not P_CheckSight(player.realmo, mo) then return end

		local hor_angle = AngleFixed(R_PointToAngle2(px, py, mo.x, mo.y))
		local vert_dist = R_PointToDist2(px, py, mo.x, mo.y)
		local vert_angle = AngleFixed(R_PointToAngle2(vert_dist, pz, 0, mo.z)) - 180 * FRACUNIT

		table.insert(rings, {mo = mo, hor_angle = hor_angle, vert_angle = vert_angle})
	end, player.realmo, px - lspdrange, px + lspdrange, py - lspdrange, py + lspdrange)

	if #rings == 0 then return nil end

	-- Sort rings by angle smoothness rather than direct player angle
	table.sort(rings, function(a, b)
		local wishdir = AngleFixed(player.kmbiwishdir)
		
		-- Calculate angle differences from the wish direction
		local wish_diff_a = GetAngleDifference(a.hor_angle, wishdir)
		local wish_diff_b = GetAngleDifference(b.hor_angle, wishdir)
		
		if wish_diff_a == wish_diff_b then
			local prev_ring = player.realmo
			if prev_ring then
				local prev_hor = AngleFixed(R_PointToAngle2(prev_ring.x, prev_ring.y, a.mo.x, a.mo.y))
				local prev_hor_b = AngleFixed(R_PointToAngle2(prev_ring.x, prev_ring.y, b.mo.x, b.mo.y))
				local hor_diff_a = GetAngleDifference(prev_hor, a.hor_angle)
				local hor_diff_b = GetAngleDifference(prev_hor_b, b.hor_angle)
				
				if hor_diff_a == hor_diff_b then
					return GetDistance(px, py, pz, a.mo.x, a.mo.y, a.mo.z) <
						   GetDistance(px, py, pz, b.mo.x, b.mo.y, b.mo.z)
				end
				return hor_diff_a < hor_diff_b
			else
				-- Default sorting when no previous ring exists (first ring selection)
				return GetDistance(px, py, pz, a.mo.x, a.mo.y, a.mo.z) <
					   GetDistance(px, py, pz, b.mo.x, b.mo.y, b.mo.z)
			end
		end
		
		return wish_diff_a < wish_diff_b
	end)
	return rings[1].mo
end

local function P_LightDash(source)
	if not source.tracer then return end
	local dest = source.tracer
	local dist = GetDistance(source.x, source.y, source.z, dest.x, dest.y, dest.z)
	if dist < 1 then dist = 1 end
	
	source.momx = FixedMul(FixedDiv(dest.x - source.x, dist), lspdspeed)
	source.momy = FixedMul(FixedDiv(dest.y - source.y, dist), lspdspeed)
	source.momz = FixedMul(FixedDiv(dest.z - source.z, dist), lspdspeed)
	source.player.drawangle = R_PointToAngle2(0, 0, source.momx, source.momy)
end

local function P_LookForRings(player)
	player.realmo.target = nil
	player.realmo.tracer = nil
	local closest = FindClosestRing(player)

	if closest then
		player.realmo.target = closest
		player.realmo.tracer = closest
		player.lightdash = TICRATE
		P_ResetPlayer(player)
		player.realmo.state = S_PLAY_FALL
		P_ResetScore(player)
		P_LightDash(player.realmo)
	else
		-- Reset LSD tracking when stopping
		player.pflags = $ & ~PF_THOKKED
		player.lightspeeddashable = 0
		player.lightdash = 0
		player.attackdown = false
	end

	player.realmo.momx = FixedDiv(player.realmo.momx, 1 * FRACUNIT)
	player.realmo.momy = FixedDiv(player.realmo.momy, 1 * FRACUNIT)
end

addHook("PlayerThink", function(player)
	if not player.mo then return end
	if lspdskin and player.realmo.skin ~= lspdskin or player.exiting or P_PlayerInPain(player) or player.climbing or player.powers[pw_carry] then
		player.lightdash = nil
		return
	end
	
	if player.lightspeeddashable >= 1 then
		if not (player.cmd.buttons & BT_SPIN) then
			if player.lightspeedhold >= leveltime then
				P_InstaThrust(player.realmo, player.realmo.angle, 60 * FRACUNIT)
			end
			if player.lightspeeddashable == 1 then
				player.realmo.colorized = false
				player.kmbiwishdir = player.realmo.angle
				S_StartSound(player.realmo, sfx_lspdst)
				S_StartSound(player.realmo, sfx_slspgo)
				player.lightspeedhold = leveltime + 7
				player.lightdash = 0
				player.lightspeeddashable = 2
			end
			if FindClosestRing(player) then
				player.lightspeedhold = leveltime
			end
			if player.lightspeedhold == leveltime and not player.attackdown then
				player.attackdown = true
				if FindClosestRing(player) then
					player.lightdash = TICRATE
					player.lightspeedhold = leveltime
				else
					player.realmo.momy = 0
					player.realmo.momx = 0
					player.lightspeeddashable = 0
					player.attackdown = false
				end
			end
		end
	else
		S_StopSoundByID(player.realmo, sfx_lspdst)
		S_StopSoundByID(player.realmo, sfx_lspdlo)
		player.lightspeeddashable = 0
		player.attackdown = false
	end
	
	if player.lightdash and player.lightdash > 0 then
		player.lightdash = player.lightdash - 1
		P_LookForRings(player)
		P_SpawnGhostMobj(player.realmo)
		player.powers[pw_flashing] = 1
		if not S_SoundPlaying(player.mo, sfx_lspdst) and not S_SoundPlaying(player.mo, sfx_lspdlo) then
			S_StartSound(player.realmo, sfx_lspdlo)
		end
	end
end)