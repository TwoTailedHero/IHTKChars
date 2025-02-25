// misc. section

local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end

skincolors[SKINCOLOR_SUPER_COBALT1] = {
    name = "Super Cobalt 1",
    ramp = {0,0,0,0,144,144,145,146,147,148,151,153,156,157,157,157},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_SUPER_COBALT2] = {
    name = "Super Cobalt 2",
    ramp = {0,0,144,145,147,148,149,150,152,154,156,157,157,158,158,158},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_SUPER_COBALT3] = {
    name = "Super Cobalt 3",
    ramp = {144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_SUPER_COBALT4] = {
    name = "Super Cobalt 4",
    ramp = {146,147,148,149,150,151,152,153,154,155,156,157,158,159,253,254},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_SUPER_COBALT5] = {
    name = "Super Cobalt 5",
    ramp = {147,148,149,150,152,153,154,155,156,157,158,159,253,253,254,254},
    invcolor = SKINCOLOR_ORANGE,
    invshade = 9,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_COBALTSUPER] = {
    name = "CobaltSuper",
    ramp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    invcolor = SKINCOLOR_SANDY,
    invshade = 6,
    chatcolor = V_BLUEMAP,
    accessible = false
}
skincolors[SKINCOLOR_KOMBIAKAI] = {
    name = "Akai",
    ramp = {48,217,218,51,53,55,56,58,37,38,40,41,42,43,44,45},
    invcolor = SKINCOLOR_GREEN,
    invshade = 6,
    chatcolor = V_REDMAP,
    accessible = true
}
skincolors[SKINCOLOR_KOMBIBLACKSMITH] = {
    name = "Blacksmith",
    ramp = {49,51,52,54,56,59,59,60,41,42,43,44,44,45,45,71},
    invcolor = SKINCOLOR_GREEN,
    invshade = 6,
    chatcolor = V_REDMAP,
    accessible = true
}

skincolors[SKINCOLOR_KOMBI_CUSTOM_LIFEWHITE] = {
	name = "Lives Palette - White",
	ramp = {0,0,0,0,0,0,0,0,2,6,11,15,19,23,27,31},
	accessible = false
}

skincolors[SKINCOLOR_KOMBI_CUSTOM_LIFERED] = {
	name = "Lives Palette - Red",
	ramp = {35,35,35,35,35,35,35,35,36,38,40,42,44,71,47,31},
	accessible = false
}

skincolors[SKINCOLOR_KOMBI_CUSTOM_LIFES1CD] = {
	name = "Lives Palette - Sonic 1/Sonic CD",
	ramp = {73,73,73,73,73,73,73,73,74,75,76,77,78,79,239,31},
	accessible = false
}

skincolors[SKINCOLOR_KOMBI_CUSTOM_LIFES3] = {
	name = "Lives Palette - Sonic 3",
	ramp = {0,0,0,80,82,83,72,73,73,74,75,91,92,18,19,137},
	accessible = false
}

skincolors[SKINCOLOR_KOMBI_CUSTOM_SPINBALLDISP1] = {
	name = "Spinball Display - Red to Yellow",
	ramp = {55,55,55,53,53,53,74,74,74,73,73,73,0,0,0,0},
	accessible = false
}

mobjinfo[MT_SAEXPL] = {
spawnstate = S_THOK,
deathsound = sfx_yusfxz,
flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_NOBLOCKMAP|MF_SCENERY|MF_NOGRAVITY
}
mobjinfo[MT_KOMBIMACANDCHEESE] = {
spawnstate = S_KOMBIMAC,
deathsound = sfx_yusfxz,
health = 1000,
flags = MF_SCENERY|MF_NOGRAVITY|MF_SPECIAL|MF_SCENERY
}
states[S_KOMBIMAC] = {
	sprite = SPR_MACNCHEESE,
	frame = A,
	tics = -1,
	nextstate = S_KOMBIMAC,
}
states[S_KOMBITRICK] = {
	sprite = SPR_PLAY,
	frame = SPR2_TAUN,
	tics = 6,
	var1 = 0,
	var2 = 0,
	nextstate = S_PLAY_FALL
}
local kombiS3KDontFuckingUseThese = {
	[SKINCOLOR_KOMBI_CUSTOM_LIFEWHITE] = true,
	[SKINCOLOR_KOMBI_CUSTOM_LIFERED] = true,
	[SKINCOLOR_KOMBI_CUSTOM_LIFES1CD] = true,
	[SKINCOLOR_KOMBI_CUSTOM_LIFES3] = true,
	[SKINCOLOR_KOMBI_CUSTOM_SPINBALLDISP1] = true,
}
addHook("MobjSpawn", function(mobj)
	repeat
		mobj.color = P_RandomRange(0,203)
	until not kombiS3KDontFuckingUseThese[mobj.color]
end, MT_BALLOON)

--Encompasses the intro... #PEAK!
-- we can use KeyDown hooks to override when the player presses a button and switch immediately to the title screen, just gotta make the intro a thing first
-- we can also do the same for the "PRESS START" text... i hope
-- TODO: THE ABOVE.
local elapsed = 0
local kombiwl4scene = 1
local kombiwhichgame = "wl4"
local introtracks = {
	["_title"] = true,
	["_wl4ti"] = true,
	["wl4int"] = true,
	["_wl3ti"] = true,
	["wl3int"] = true,
}

if not srb2p -- This isn't Wario Land 4-coded... BLOCKED!
	rawset(_G, "cv_kombiwl4titlescreen", CV_RegisterVar({ -- I'm the old SRB2! I want normal title screens!
	name = "k_wl4title",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0},
	}))
	if menuactive == true
		kombiwl4scene = 0
	end
	hud.add(function(v, player)
		if not cv_kombiwl4titlescreen.value return end
		elapsed = $ + 1
		v.drawFill() -- background. TODO: Make sure that we really want to hardcode this to always be black.
		local gameScenes = {
			wl4 = {
				[0] = function() -- Scene 0: Title Screen Animation
					local bglayer1 = v.cachePatch("WL4TIBG1")
					-- Background Layers
					v.draw(-128, -26, bglayer1)
					v.draw((elapsed / 8) % 512, 0, bglayer1)
					v.draw(((elapsed / 8) % 512) - 512, 0, bglayer1)
					v.draw((elapsed / 4) % 512, 46, v.cachePatch("WL4TIBG2"))
					v.draw(((elapsed / 4) % 512) - 512, 46, v.cachePatch("WL4TIBG2"))
					-- Foreground Layer
					local bglayer3 = v.cachePatch("WL4TIBG3")
					v.draw(((elapsed * 5) % 256) + 128, 130, bglayer3)
					v.draw(((elapsed * 5) % 256) - 128, 130, bglayer3)
					v.draw(((elapsed * 5) % 256) - 384, 130, bglayer3)
					-- Car and Wheels
					v.draw(262, 145, v.getSpritePatch(SPR_WARIOLANDWHEEL, A, 0, FixedAngle(elapsed * 12 * FRACUNIT)), 0)
					v.draw(180, 112, v.cachePatch("WL4TCAR"))
					v.draw(208, 145, v.getSpritePatch(SPR_WARIOLANDWHEEL, A, 0, FixedAngle(elapsed * 12 * FRACUNIT)), 0)
					-- Title Card Animation
					local titleOpacity = (-elapsed / 10) + 34
					if titleOpacity <= 0
						v.draw(0, 0, v.cachePatch("WL4TITLE"), min(max(2 ^ (((-elapsed / 10) + 40) + 15), 65536), 589824))
					elseif (-elapsed / 10) + 40 <= 0
						v.draw(0, 0, v.cachePatch("WL4TITLE"))
					end
				end,
				[1] = function() -- Scene 1: Nintendo Presents...
					local stretch = ease.outback(FixedDiv(min(elapsed-TICRATE/2, 14), 14), 0, FRACUNIT)
					local alphalevel = max(min((elapsed-TICRATE*5/2 or 0)/2, 10), 0)
					if alphalevel == 10
						return true
					end
					local logo = v.cachePatch("WL4NINTENDO")
					v.drawStretched(160*FRACUNIT, 100*FRACUNIT, max(FixedDiv(FRACUNIT, max(stretch,1)), FixedDiv(1, logo.height)), max(stretch, 1), logo, alphalevel<<V_ALPHASHIFT)
					if elapsed-TICRATE/2 >= TICRATE
						alphalevel = $+10-min((elapsed-TICRATE or 0)/4, 10)
						if alphalevel == 10
							return
						end
						v.draw(160, 121, v.cachePatch("WL4NPRESENTS"), alphalevel<<V_ALPHASHIFT)
					end
				end,
				[2] = function() -- Scene 2: Somewhere in a back alley...
					local ypos = min(max((elapsed/2)-30, 0), 53)
					if elapsed == 136+TICRATE
						return true
					end
					local alphalevel = 10-max(min((elapsed or 0)/3, 10), 0)
					if alphalevel == 10
						return
					end
					v.draw(160, -ypos, v.cachePatch("WL4INTRO1"), alphalevel<<V_ALPHASHIFT)
				end,
				[3] = function() -- Scene 3: In comes Wario.
					local doorbust = TICRATE*3/2
					if elapsed == doorbust
						v.draw(160, 100, v.cachePatch("WL4SC3WARIO1"))
					elseif elapsed == doorbust+1
						v.draw(160, 100, v.cachePatch("WL4SC3WARIO2"))
					elseif elapsed > doorbust
						v.draw(160, 100, v.cachePatch("WL4SC3WARIO3"))
						if elapsed == doorbust+TICRATE*2
							return true
						end
					end
				end,
				[4] = function() -- Scene 4: Wario gets into his car. Cue music.
					local xpos = (elapsed/2)-30
					if xpos > 106
						xpos = 106 + (xpos-106)/2
					end
					xpos = max(xpos, 0)
					local ypos = 130
					local carbodyoffset = 0
					local alphalevel = 10-max(min((elapsed or 0)/6, 10), 0)
					local carstartsat = TICRATE*13/3
					local carstarttime = TICRATE*4/3
					if alphalevel == 10
						return
					end
					local garagedooropening = 64
					local prefix = 1
					local openingdivisor = 8
					-- car SHOULD start by the time 4 rows of white come into view. reflect that here.
					if elapsed-(242-openingdivisor*4) >= carstartsat
						garagedooropening = $-(elapsed-(242-openingdivisor*4)-carstartsat or 0)/8
						if garagedooropening <= 38
							return true
						elseif garagedooropening == 45
							S_ChangeMusic("_wl4ti", true)
							prefix = 4
						elseif garagedooropening <= 55
							prefix = 4
						elseif garagedooropening <= 60
							prefix = 3
						elseif garagedooropening <= 62
							prefix = 2
						end
					end
					if elapsed-242 >= carstartsat
						if elapsed-242-carstartsat >= carstarttime
							carbodyoffset = FixedInt(sin(FixedAngle(elapsed*FRACUNIT*32))*3) -- TICRATE*32 Hz, 3 Amp
						else
							carbodyoffset = FixedInt(sin(FixedAngle(elapsed*FRACUNIT*64))*5) -- TICRATE*64 Hz, 5 Amp
						end
					end
					v.drawFill(160-xpos, ypos-40, 303, 64, 0)
					v.drawFill(160-xpos, ypos-40, 303, garagedooropening, 31)
					v.draw(311-xpos, ypos, v.cachePatch("WL4INTRO3-\$prefix\1"), alphalevel<<V_ALPHASHIFT)
					v.draw(366-xpos, ypos-40+carbodyoffset, v.cachePatch("WL4INTRO3-\$prefix\2"), alphalevel<<V_ALPHASHIFT)
				end,
				[5] = function() -- Scene 4: Wario speeds down the street.
					-- the car flashes the screen at frame 19@60FPS, fades by frame 25.
					-- Wario's car takes 60@60FPS to stop moving.
					local xpos = ease.outsine(FixedDiv(min(elapsed, TICRATE), TICRATE), 0, 160)
					local caroffset = FixedInt(sin(FixedAngle(elapsed*FRACUNIT*32))*2) -- TICRATE*32 Hz, 2 Amp
					v.draw(160, 100, v.cachePatch("WL4INTROROAD\$((elapsed/2)%6)+1\"))
					v.draw((xpos-46)+caroffset, 119, v.cachePatch("WL4INTROCARSHADOW"))
					v.draw(xpos, 100+caroffset, v.cachePatch("WL4INTROCAR"))
					if elapsed == TICRATE*16/2
						return true
					end
					if elapsed >= 11
						local alphalevel = ease.linear(FixedDiv(min(max(elapsed-11,0), 8), 8), 0, 10)
						if alphalevel == 10
							return
						end
						v.drawScaled(0, 0, FRACUNIT*999, v.cachePatch("KOMBIFLASH"), (alphalevel<<V_ALPHASHIFT)|V_SNAPTOTOP|V_SNAPTOLEFT)
					end
				end,
				[6] = function() -- Scene 5: Cat walks along the street, Wario almost runs it over.
					-- archway and city scroll a total of 8px.
					local alphalevel = 10-min(max((elapsed/6), 0), 10)
					if alphalevel == 10
						return
					end
					local ypos = min(max(elapsed-48, 0)/6,8)
					local wariospeedsbyat = TICRATE*2
					local carposition
					local carscale
					local brightness
					local carelapsed = elapsed-84-wariospeedsbyat
					if carelapsed <= TICRATE
						carposition = ease.linear(FixedDiv(min(max(carelapsed,0), TICRATE), TICRATE), 200, 132)
						print(carposition,carelapsed)
						carscale = ease.linear(FixedDiv(min(max(carelapsed,0), TICRATE), TICRATE), FRACUNIT*7/2, FRACUNIT/8)
						brightness = ease.linear(FixedDiv(min(max(carelapsed,0), TICRATE), TICRATE), 4, 0)
					else
						carposition = ease.linear(FixedDiv(min(max(carelapsed-TICRATE,0), TICRATE), TICRATE), 132, 145)
						carscale = ease.linear(FixedDiv(min(max(carelapsed-TICRATE,0), TICRATE), TICRATE), FRACUNIT/8, FRACUNIT/8)
						brightness = 0
					end
					v.draw(160, 100+ypos, v.cachePatch("WL4INTRO5CITY"), alphalevel<<V_ALPHASHIFT)
					if carelapsed > TICRATE
						v.drawScaled(162*FRACUNIT, carposition*FRACUNIT, carscale, v.cachePatch("WL4INTROCARBACK0"))
					end
					v.draw(160, 100-ypos, v.cachePatch("WL4INTRO5ARCHWAY"), alphalevel<<V_ALPHASHIFT)
					if carelapsed >= 0 and carelapsed <= TICRATE
						v.drawScaled(162*FRACUNIT, carposition*FRACUNIT, carscale, v.cachePatch("WL4INTROCARBACK\$brightness\"))
					end
					if carelapsed >= (TICRATE*7/8)+80+TICRATE
						return true
					end
					if carelapsed >= TICRATE*7/8
						local alphalevel = ease.linear(FixedDiv(min(max((carelapsed-TICRATE*7/8)/8,0), 8), 8), 0, 10)
						if alphalevel == 10
							return
						end
						v.drawScaled(0, 0, FRACUNIT*999, v.cachePatch("KOMBIFLASH"), (alphalevel<<V_ALPHASHIFT)|V_SNAPTOTOP|V_SNAPTOLEFT)
					end
				end,
			},
		}

		local scenes = gameScenes[kombiwhichgame] or gameScenes["wl4"]
		if not scenes[kombiwl4scene] or type(scenes[kombiwl4scene]) != "function"
			kombiwl4scene = 0 -- Skip to Scene 0! (Title Screen)
			return
		end
		if scenes[kombiwl4scene]()
			kombiwl4scene = $+1
			elapsed = 0
		end
		kombidrawwl4font(v, "Press ENTER to skip...", 0, 0, 0)
	end, "title")
end

addHook("MusicChange", function(oldname, newname, mflags, looping, position, prefadems, fadeinms)
	if newname == "_title"
		if kombiwl4scene > 0
			return "_wl4in", 0, true
		else
			return "_wl4ti"
		end
	end
end)

local validkeys = {
	["enter"] = true,
	["space"] = true
}

addHook("KeyDown", function(key)
	if kombiwl4scene != 0 and cv_kombiwl4titlescreen.value
		if introtracks[currentlyplaying]
			print(key.name)
			if key.name == "TILDE" return end
			if not validkeys[key.name] return true end
			S_ChangeMusic("_wl4ti", true)
			kombiwl4scene = 0
			return true
		end
	end
	if kombiwl4scene == 0 and cv_kombiwl4titlescreen.value and not menuactive and key.repeated return true end
end)

if not PlayerAnimInfo
	rawset(_G, "PlayerAnimInfo", {})
end

PlayerAnimInfo["kombi"] = {
		["runFrames"] = {0, 2},
		["dashFrames"] = {-1},
		["walkFrames"] = {3, 7},
		["waitFrames"] = {0},
		["milnekickFrames"] = {0, 4},
		["run"] = true,
		["dash"] = false,
		["walk"] = true,
		["idle"] = true,
		["wait"] = true,
		["milnekick"] = false,
		["superRun"] = true,
		["superDash"] = false,
		["superWalk"] = true,
		["superIdle"] = true,
		["superWait"] = true
}
if not solchars
	rawset(_G, "solchars", {})
end
solchars["kombi"] = {SKINCOLOR_SUPERGOLD1, 2}

rawset(_G, "cv_kombisuper", CV_RegisterVar({
	name = "k_supertheme",
	defaultvalue = "Default",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {Default = -1, SA1 = 0, SA2 = 1, SH = 2},
}))

rawset(_G, "cv_kombijingles", CV_RegisterVar({
	name = "k_jinglereplacements",
	defaultvalue = "Default",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {Default = -1, Off = 0, SA1 = 1, On = 1, SA2 = 2},
}))

local function WarioYahoo(player)
	S_StartSound(player, P_RandomRange(sfx_waow0,sfx_waow17))
end

local function K_RingCollect(ring, toucher)
	if toucher and toucher.valid
	and kombiwhogetswl4stuff[toucher.player.realmo.skin]
		if not P_CanPickupItem(toucher.player, false) and not (ring.flags2 & MF2_NIGHTSPULL) return end
		S_StartSound(toucher, sfx_saring)
		P_SpawnMobj(ring.x, ring.y, ring.z, MT_SPARK)
		P_GivePlayerRings(toucher.player, 1)
		if (ring.type != MT_FLINGRING and ring.type != MT_FLINGCOIN)
			P_AddPlayerScore(toucher.player, 10)
			if toucher and toucher.valid and not toucher.player.botleader
				if toucher.player.kombiboost toucher.player.kombiboost = $+100*FRACUNIT/48 else toucher.player.kombiboost = 100*FRACUNIT/48 end
				toucher.player.wl4score = $+10
			elseif toucher.player.botleader
				if toucher.player.botleader.kombiboost toucher.player.botleader.kombiboost = $+100*FRACUNIT/48 else toucher.player.botleader.kombiboost = 100*FRACUNIT/48 end
				toucher.player.botleader.wl4score = $+10
			end
			if (maptol & TOL_NIGHTS) P_DoNightsScore(toucher.player) end
		end
		P_RemoveMobj(ring)
	end
end

addHook("TouchSpecial", K_RingCollect, MT_RING)
addHook("TouchSpecial", K_RingCollect, MT_FLINGRING)
addHook("TouchSpecial", K_RingCollect, MT_COIN)
addHook("TouchSpecial", K_RingCollect, MT_FLINGCOIN)

addHook("MobjSpawn", function(mo)
	mo.renderflags = RF_FULLBRIGHT|RF_NOCOLORMAPS
	mo.fuse,mo.tics = 25,40
	mo.sprite = SPR_SAEX
	mo.frame = A|FF_TRANS30
	mo.blendmode = AST_ADD
	mo.dispoffset = 99
end, MT_SAEXPL)

local exitingplus = 70

addHook("PlayerSpawn", function(player)
	player.alreadyextended = false
end)

rawset(_G, "cv_kombicamerapoint", CV_RegisterVar({
	name = "k_playerdeathfocus",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0},
}))

rawset(_G, "kombiidletalks", { -- do mapnum AND track name alongside map name to be REALLY specific
	["vsboss"] = sfx_sidbo2, -- let's hope nobody decides any of these tracks are good level names??
	["vsalt"] = sfx_sidbo2,
	["vsfang"] = sfx_sidbo3,
	["vsmetl"] = sfx_sidbo1,
	["vsbrak"] = sfx_sidun1,
	["hurryu"] = sfx_sidwv2,
	["3 station square ss97"] = sfx_sidss1,
	["3 station square mrun"] = sfx_sidmr1,
	["greenflower zone 1"] = sfx_sidwv1,
	["greenflower zone 2"] = sfx_sidec2,
	["techno hill zone 1"] = sfx_sidss5,
	["techno hill zone 2"] = sfx_sidtp0,
	["deep sea zone 1"] = sfx_sidlw1,
	["deep sea zone 2"] = sfx_sidlw2,
	["castle eggman zone 1"] = sfx_sidss4,
	["castle eggman zone 2"] = sfx_sidsh2,
	["arid canyon zone 1"] = sfx_sidic3,
	["arid canyon zone 2"] = sfx_sidsh3,
	["red volcano zone 1"] = sfx_sidrm1,
	["egg rock zone 1"] = sfx_sidfe1,
	["egg rock zone 2"] = sfx_sidfe2,
	["black core zone 1"] = sfx_sidsh1,
	["frozen hillside zone"] = sfx_sidic1,
	["pipe towers zone mario1"] = sfx_sidwv3,
	["pipe towers zone mario2"] = sfx_sidss3,
	["forest fortress zone"] = sfx_sidun4,
	["final demo zone"] = sfx_sidss5,
	["final demo zone fdemo1"] = sfx_sidwv1,
	["final demo zone fdemo2"] = sfx_sidec2,
	["final demo zone fdemo3"] = sfx_sidss5,
	["final demo zone thzalt"] = sfx_sidtp0,
	["final demo zone fdemo5"] = sfx_sidss4,
	["final demo zone fdemo6"] = sfx_sidsh2,
	["final demo zone fdemo7"] = sfx_sidlw2,
	["final demo zone fdemob"] = sfx_sidbo2,
	["kori's cafe carcde"] = sfx_sidco1,
	["kori's cafe ccafe"] = sfx_sidcg2,
	["kori's cafe cdisco"] = sfx_sidic3,
	["kori's cafe coutsi"] = sfx_sidic2,
	["kori's cafe ccafeo"] = sfx_sidcg2,
	["kori's cafe cnull"] = sfx_sidlw2,
})

local REGEN_RATE = FixedDiv(FRACUNIT, FRACUNIT * 100) -- Fraction of MaxHealth regenerated per second
local REGEN_STEP = TICRATE -- Regeneration interval in tics

--------------------------------------------------------------------------------
-- Function to handle health regeneration for players
local function handleHealthRegen(player)
    if not player.rblxhp or player.rblxhp < 1 return end
    if leveltime % REGEN_STEP == 0
        player.rblxhp = $ + ((FixedMul(player.rblxmaxhp * FRACUNIT, REGEN_RATE)) * (REGEN_STEP / TICRATE))
    end
    if player.rblxhp > player.rblxmaxhp * FRACUNIT
        player.rblxhp = player.rblxmaxhp * FRACUNIT
    end
end

local function getMappedSound(dataTable, keys, default)
    for _, key in ipairs(keys) do
        local value = dataTable[key]
        if value
            return value
        end
    end
    return default
end

local function stripColorTags(text)
    return text:gsub("[%z\128-\143]", "") -- I HATE YOU
end

local function getIdleSound(currentMap, currentTrack)
    local lowerTitle = string.lower(stripColorTags(G_BuildMapTitle(currentMap)))
    local searchKeys = {
        currentTrack,
        string.format("%s %s %s", currentMap, lowerTitle, currentTrack),
        string.format("%s %s", lowerTitle, currentTrack),
        string.format("%s %s", currentMap, lowerTitle),
        lowerTitle
    }

    return getMappedSound(kombiidletalks, searchKeys, sfx_sidgen)
end

addHook("PlayerThink", function(player)
    if not player.mo return end
    if not (player.cmd.buttons & BT_TOSSFLAG) and player.kombitossingflag
        local soundToPlay = getIdleSound(gamemap, currentlyplaying)
        if P_RandomRange(0, 1) == 0
			S_StopSoundByID(player.realmo, soundToPlay)
            S_StartSound(player.mo, sfx_sidgen)
        else
			S_StopSoundByID(player.realmo, sfx_sidgen)
            S_StartSound(player.mo, soundToPlay)
        end
        player.kombitossingflag = false
    elseif (player.cmd.buttons & BT_TOSSFLAG) and not player.kombitossingflag
        player.kombitossingflag = true
    end
    if player.powers[pw_carry] == 11 and player.realmo.skin == "kombi" and not player.kombipteracarried
        S_StartSound(player.mo, sfx_scaptr)
        player.kombipteracarried = true
    elseif player.powers[pw_carry] ~= 11
        player.kombipteracarried = false
    end

    handleHealthRegen(player)

    if player.realmo.skin == "kombi" and not Style_Pack_Active
        if player.exiting > 100
            player.exiting = $ - 1
        end
        if player.exiting > 0 and not player.alreadyextended
            player.alreadyextended = true
            player.exiting = $ + exitingplus
        end
        if player.exiting - exitingplus == 2 and player.alreadyextended
            local bonusType = mapheaderinfo[gamemap].bonustype
            if bonusType == 1
                S_StartSound(player.realmo, sfx_kbossw)
            else
                S_StartSound(player.realmo, sfx_kclear)
            end
            S_ChangeMusic("sacler", false, player)
        end
    end
end)

addHook("MobjThinker", function(mo) 
	if not mo.valid or not mo.fuse return end
	if ((mo.frame & FF_FRAMEMASK) < P)
		mo.frame = $+1
		if mo.target and mo.target.valid --Stop an enemy's generic "pop" sounds.
			S_StopSoundByID(mo.target, sfx_pop)
		end
	end
	if (mo.fuse < 18)
		local TRANS = min(FF_TRANS90, 10<<16 - (mo.fuse/2)<<16 ) --Fading away!
		mo.frame = ($ & ~FF_TRANSMASK)|TRANS 
	end
end, MT_SAEXPL)

addHook("ThinkFrame", do
	skincolors[SKINCOLOR_COBALTSUPER].ramp = skincolors[SKINCOLOR_SUPER_COBALT1 + abs( ( (leveltime >> 1) % 9) - 4)].ramp
end)

local coolBonuses = {100,200,300,400,500,600,800,1000,1500,2000}

rawset(_G, "kombiGiveSA2Bonus", function(player,bonus)
	if bonus > 0 -- can't index out of lists!
		local score = coolBonuses[min(bonus,10)] -- I know y'all gon' try to give something greater than a "Perfect!" dude don't even try
		P_AddPlayerScore(player, score)
		player.wl4score = $+((score/10)/3)*10 -- Save our treasure a slice of our speed bonus
		player.kombibonuses = $ or {}
		table.insert(player.kombibonuses, {btype = bonus, bclock = 0})
	end
end)

/* addHook("PostThinkFrame", do
	for player in players.iterate
	local pollvar = player.aiming
	if pollvar
			print(pollvar)
		else
			print("No camera to poll!")
		end
	end
end) */