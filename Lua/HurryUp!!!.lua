-- 1 WL4 Heart == 50
local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
SafeFreeSlot(
-- States
"S_WARSPORT","S_WARMPORT","S_WARLPORT","S_HURRYUP","S_COINLOSS",
-- Objects
"MT_WLPORTALSMALL","MT_WLPORTALMEDIUM","MT_WLPORTALLARGE","MT_KOMBIFROGSWITCH","MT_COINLOSSEFFECT","MT_FROGSWITCHANIMATOR","MT_WLPORTALSPAWNER",
-- Sprites
"SPR_WLPS","SPR_WLPM","SPR_WLPL","SPR_KOMBIFROGSWITCH","SPR_WLC2",
-- Wario's Voice (Hurry Up!)
"sfx_hurry0","sfx_hurry1","sfx_hurry2","sfx_hurry3","sfx_hurry4",
-- Kero SFX
"sfx_wlohno","sfx_wlclos")

local personaltrackset
local keroclockrotation = 0

kombi.hurryup = false
kombi.mapclock = 180*TICRATE
kombi.hittime = 0
kombi.outtatimegong = false
kombi.coinxoff = 0
kombi.coinsize = FRACUNIT
kombi.disptime = 0
kombi.timeleft = 0
kombi.frogswitch = 0
kombi.candosa1credits = false
kombi.animationClock = 0

sfxinfo[sfx_hurry0].caption = '"Hurry up!"'
sfxinfo[sfx_hurry1].caption = '"Hurry up!"'
sfxinfo[sfx_hurry2].caption = '"Hurry up!"'
sfxinfo[sfx_hurry3].caption = '"H-H-H-HURRY UP!"'
sfxinfo[sfx_hurry4].caption = '"No, no, no! Grrr... Hurry up!"'
sfxinfo[sfx_wlohno].caption = '/'
sfxinfo[sfx_wlclos].caption = '/'
sfxinfo[sfx_wlohno].singular = true
sfxinfo[sfx_wlclos].singular = true

local inescapable = {
	["hell coaster zone 1"] = true,
	["festung oder so"] = true,
	["spiral hill pizza"] = true,
	["tutorial zone"] = true,
	["pipe towers zone"] = true,
}

local srbtpmetaltimers = {
	1958,
	2396,
	2133,
	3253,
	3007,
	2203,
	3113,
	2448,
	3761,
	3428,
	5843,
	2133,
	7208,
	3708,
	2712,
	2308,
	2712,
	2308,
	5231,
	10449,
	3707,
	4872,
	18476
}

rawset(_G, "maptimers", { -- Escape Sequence timers
	["greenflower zone 1"] = {time = 110},
	["greenflower zone 2"] = {time = 110},
	["techno hill zone 1"] = {time = 155},
	["techno hill zone 2"] = {time = 130},
	["deep sea zone 1"] = {time = 180},
	["deep sea zone 2"] = {time = 240},
	["castle eggman zone 1"] = {time = 280},
	["castle eggman zone 2"] = {time = 340},
	["arid canyon zone 1"] = {time = 125},
	["arid canyon zone 2"] = {time = 155},
	["red volcano zone 1"] = {time = 265},
	["egg rock zone 1"] = {time = 180},
	["egg rock zone 2"] = {time = 135},
	["black core zone 1"] = {time = 160},
	["aerial garden zone"] = {time = 240},
	["frozen hillside zone"] = {time = 50},
	["haunted heights zone"] = {time = 120},
	["neo palmtree zone"] = {time = 180},
	["pipe towers zone"] = {time = 240},
	["641 crumbling collab zone"] = {time = 195},
	["alcudia port"] = {time = 140},
	["uptown"] = {time = 165},
	["final demo zone"] = {time = 1820/2, iswar = true},
})

rawset(_G, "cv_kombinoescape", CV_RegisterVar({
	name = "k_frogswitch",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0, Forced = 4, Multiplayer = 2, Both = 3},
}))

rawset(_G, "cv_kombizawarudo", CV_RegisterVar({
	name = "k_clockpause",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0, Always = 2},
}))

rawset(_G, "cv_kombimaptitle", CV_RegisterVar({
	name = "k_devmode",
	defaultvalue = "Off",
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0, FrogSwitch = 2},
}))

COM_AddCommand("k_trackset", function(player, arg1)
	if arg1 and not (#arg1 > 3 and not arg1 == "None")
		personaltrackset = arg1
		CONS_Printf(player,"Trackset now set to \$personaltrackset\.")
		COM_BufInsertText(player, "tunes -default")
	elseif not arg1
		CONS_Printf(player,"Trackset currently set to \$personaltrackset\.")
	else
		CONS_Printf(player,"Trackset length is too long...","Maximum characters are 3!")
		
	end
end)

COM_AddCommand("k_exitlevel", function(player) -- the "I'm not escape sequencing this" command
	if gamestate ~= GS_LEVEL
		CONS_Printf(player,"You need a level to exit.")
		return
	end
	if kombi.hurryup == false
		CONS_Printf(player,"Can't do this right now.")
		return
	end
	if multiplayer
		CONS_Printf(player,"Do not.")
		return
	end
	P_DoPlayerFinish(player)
end)

rawset(_G, "currentlyplaying", "none")

rawset(_G, "kombicustomtrackchars", { -- Characters who get to utilize custom tracks
	["shayde"] = "SA2", -- Always prefer SA2 for this character.
})

rawset(_G, "mapreplacements", { -- map-specific tracks
	["939 thorndyke mansion"] = "SS0",
	["537 infernal cavern zone"] = "RM2",
	["940 station x"] = "SS0",
	["161 beach coast"] = "EC2",
	["328 greenflower city"] = "SS0",
	["mystic ruins"] = "MR0",
	["greenflower zone 1"] = "EC1",
	["greenflower zone 2"] = "EC2",
	["techno hill zone 1"] = "TP1",
	["techno hill zone 2"] = "TP3",
	["deep sea zone 1"] = "LW1",
	["deep sea zone 2"] = "LW2",
	["castle eggman zone 1"] = "CO3",
	["castle eggman zone 2"] = "CO2",
	["arid canyon zone 1"] = "HS1",
	["arid canyon zone 2"] = "HS2",
	["red volcano zone 1"] = "RM1",
	["red volcano zone 2"] = "RM2",
	["egg rock zone 1"] = "FE1",
	["egg rock zone 2"] = "FE2",
	["black core zone 1"] = "SD1",
	["black core zone 2"] = "SD2",
	["infernal cavern zone"] = "RM2",
	["station square"] = "SS0",
})

rawset(_G, "trackreplacements", { -- track replacements in general
	["GFZ1"] = "EC1",
	["GFZ2"] = "EC2",
	["VSBOSS"] = "VEM",
	["VSALT"] = "VEM",
	["THZ1"] = "TP1",
	["THZ2"] = "TP3",
	["DSZ1"] = "LW1",
	["DSZ2"] = "LW2",
	["CEZ1"] = "CO3",
	["CEZ2"] = "CO2",
	["ACZ1"] = "HS1",
	["ACZ2"] = "HS2",
	["VSFANG"] = "VCH",
	["RVZ1"] = "RM1",
	["RVZ2"] = "RM2",
	["RVZALT"] = "RM2",
	["ERZ1"] = "FE1",
	["ERZ2"] = "FE2",
	["BCZ1"] = "SD1",
	["VSMETL"] = "SD2",
	["VSBRAK"] = "VEV",
	["DISCO"] = "TOE",
	["THZALT"] = "TP3",
	["ATZ"] = "IC2",
	["CCZ"] = "SH3",
	["DHZ"] = "WV1",
	["_CONTI"] = "WYC",
})

local function KombiTeleport(player)
	if player and player.mo and player.mo.valid
		player.powers[pw_carry] = 0
		local floorz = P_FloorzAtPos(kombi.frogswitch.x, kombi.frogswitch.y, kombi.frogswitch.z, player.mo.height)
		P_SetOrigin(player.mo, kombi.frogswitch.x,kombi.frogswitch.y, floorz)
		player.mo.angle = kombi.frogswitch.angle - ANGLE_90
	end
end

addHook("MapLoad", function(mapid)
	kombi.hittime = 0
	kombi.coinxoff = 0
	kombi.coinsize = FRACUNIT
	kombi.hurryup = false
	kombi.mapclock = kombi.RunHook("KeroTimeLimit", gamemap)
	kombi.animationClock = 0
	kombi.warlogic = false
	if kombi.mapclock == nil
		if G_BuildMapTitle(gamemap)
			local lowerTitle = string.lower(G_BuildMapTitle(gamemap))
			local lowerKey = string.lower("\$gamemap\ " .. G_BuildMapTitle(gamemap))
			local mapTimeData = maptimers[lowerKey] or maptimers[lowerTitle]
			kombi.mapclock = ((type(mapTimeData) == "table" and mapTimeData.time) or 
							  (type(mapTimeData) == "number" and mapTimeData) or 
							  mapheaderinfo[gamemap].kombikerotimelimit or 90)*TICRATE
			kombi.warlevel = (type(mapTimeData) == "table" and mapTimeData.iswar) or 
							 mapheaderinfo[gamemap].kombiwar or false
			kombi.noportal = (type(mapTimeData) == "table" and mapTimeData.noportal) or 
							 mapheaderinfo[gamemap].kombiwar
		else
			kombi.mapclock = 90*TICRATE
			kombi.warlevel = false
			kombi.noportal = false
		end
	end
	print(cv_kombimaptitle.value)
	if cv_kombimaptitle.value
		if G_BuildMapTitle(gamemap)
			print("Map is now \$gamemap\ \$string.lower(G_BuildMapTitle(gamemap))\.")
		else
			print("Map doesn't seem to have a map title... Maybe verify if you set a level header for \$mapid\?")
		end
		print("Map escape timer set to \$kombi.mapclock\ tics...")
		if not ((maptimers[string.lower("\$gamemap\ \$G_BuildMapTitle(gamemap))\"] or maptimers[string.lower(G_BuildMapTitle(gamemap))]).time or mapheaderinfo[gamemap].kombikerotimelimit)
			print("...Because you forgot to set the escape timer correctly.")
		end
		print("WAR Status for this level is \$tostring(kombi.warlevel)\.")
	end
	kombi.outtatimegong = false
	local canfrog = true
	local cankeyzer = true
	for player in players.iterate do
		player.wl4score = 0
		player.wl4kombitime = 0
		if kombi.disptime -- we probably have the escape sequence track playing if this is active, make sure to: not.
			COM_BufInsertText(player, "tunes -default")
			kombi.disptime = 0
		end
		player.kombitime = 0
		player.kombilaps = 1
		player.wl4exitcutscene = nil
		player.wldestlevel = nil
	end
	if cv_kombinoescape.string == "Off" canfrog = false end
	if not (canfrog
	or cankeyzer
	and CV_FindVar("k_frogswitch").value == 0) canfrog = false end
	if not G_BuildMapTitle(gamemap) or (inescapable[string.lower(G_BuildMapTitle(gamemap))]) canfrog = false end
	if multiplayer and not (CV_FindVar("k_frogswitch").value & 2) canfrog = false end
	if not multiplayer and not (CV_FindVar("k_frogswitch").value & 1) canfrog = false end
	if (G_IsSpecialStage(gamemap))
	or (maptol & TOL_NIGHTS)
	or (mapheaderinfo[gamemap].bonustype == 1)
	or (gamemap == titlemap)
	or G_BuildMapTitle(gamemap) == nil canfrog = false end
	if CV_FindVar("k_frogswitch").value == 4 canfrog = true end
	if kombi.warlevel canfrog = false end -- override all other statements.
	if kombi.RunHook("SpawnKero", gamemap) canfrog = false end
	if kombi.RunHook("SpawnKeyzer", gamemap) cankeyzer = false end
	
	local hassign = false
	local hasportal = false
	
	for mthing in mapthings.iterate do
		if canfrog
			if mthing.type == 1
				if not hasportal and not kombi.noportal
					local smallportal = P_SpawnMobj(mthing.x*FRACUNIT,mthing.y*FRACUNIT,mthing.z*FRACUNIT,MT_WLPORTALSMALL)
					local mediumportal = P_SpawnMobj(mthing.x*FRACUNIT,mthing.y*FRACUNIT,mthing.z*FRACUNIT,MT_WLPORTALMEDIUM)
					local largeportal = P_SpawnMobj(mthing.x*FRACUNIT,mthing.y*FRACUNIT,mthing.z*FRACUNIT,MT_WLPORTALLARGE)
					smallportal.z = smallportal.subsector.sector.floorheight+(128*FRACUNIT)
					mediumportal.z = mediumportal.subsector.sector.floorheight+(128*FRACUNIT)
					largeportal.z = largeportal.subsector.sector.floorheight+(128*FRACUNIT)
					hasportal = true
				end
			end
			if mthing.type == 501
				local trig = P_SpawnMobjFromMobj(mthing.mobj,0,0,0,MT_KOMBIFROGSWITCH)
				kombi.frogswitch = trig
				if (mthing.mobj and mthing.mobj.valid) P_RemoveMobj(mthing.mobj) end
				hassign = true
			end
			if rawget(_G, "MT_OLDSIGN") and mthing.type == 542
				local trig = P_SpawnMobjFromMobj(mthing.mobj,0,0,0,MT_KOMBIFROGSWITCH)
				kombi.frogswitch = trig
				if (mthing.mobj and mthing.mobj.valid) P_RemoveMobj(mthing.mobj) end
				hassign = true
			end
		end
		if cankeyzer
			if mthing.type == 312
				if P_RandomChance(3*FRACUNIT/4)
					local keyzer = P_SpawnMobjFromMobj(mthing.mobj,0,0,0,MT_KEYZER)
				else
					local fcukinmac = P_SpawnMobjFromMobj(mthing.mobj,0,0,0,MT_KOMBIMACANDCHEESE)
				end
				if (mthing.mobj and mthing.mobj.valid) P_RemoveMobj(mthing.mobj) end
			end
		end
	end
	
	local SSF_REALEXIT = 1<<7
	if hassign and canfrog
		for sec in sectors.iterate do
			if (sec.specialflags & SSF_REALEXIT)
			or (GetSecSpecial(sec.special, 4) == 2)
				sec.specialflags = $ &~SSF_REALEXIT
			end
		end
	end
end)

addHook("MobjThinker", function(mobj)
	if kombi.hurryup
		P_RemoveMobj(mobj) -- There is no such thing as a Metal Sonic.
	end
end, MT_METALSONIC_RACE)

mobjinfo[MT_WLPORTALSMALL] = {
spawnstate = S_WARSPORT,
spawnhealth = 1000,
deathstate = S_WARSPORT,
radius = 24*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 5,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT,
}

mobjinfo[MT_WLPORTALMEDIUM] = {
spawnstate = S_WARMPORT,
spawnhealth = 1000,
deathstate = S_WARMPORT,
radius = 24*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 4,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT,
}

mobjinfo[MT_WLPORTALLARGE] = {
spawnstate = S_WARLPORT,
spawnhealth = 1000,
deathstate = S_WARLPORT,
radius = 24*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 3,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_SPECIAL,
}

mobjinfo[MT_WLPORTALSPAWNER] = {
--$Title Frog Switch Portal
--$Sprite WLPLA0
--$Category Wario Land 4 Objects
--$ParameterText Custom Level ID
--$Arg0 "Custom Level ID"
--$Arg0Type 0
--$Arg0Default 0
--$Arg0ToolTip "If greater than 0, this value overrides the map header's destination level and binary's Parameter field.\nThis automatically skips the results screen."
--$NotAngled
doomednum = 2049,
spawnstate = S_WARLPORT,
spawnhealth = 1000,
deathstate = S_WARLPORT,
radius = 24*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 3,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_SPECIAL,
}

mobjinfo[MT_KOMBIFROGSWITCH] = {
--$Title Frog Switch
--$Sprite KEROA0
--$Category Wario Land 4 Objects
--$Flags1Text "No Escape Sequence"
--$Flags4Text "Use WAR mode"
--$Arg0 "Escape Mode"
--$Arg0Type 11
--$Arg0Enum { 0="Normal"; 1="WAR"; 2="None"; }
--$Arg0Default 0
--$Arg0ToolTip "Select escape mode: Normal uses header/default timer. WAR carries timer between checkpoints, None disables escape.\nThis overrides binary's Parameter field."
--$Arg1 "Custom Timer (sec)"
--$Arg1Type 0
--$Arg1Default 0
--$Arg1ToolTip "Enter a custom timer value in seconds (non-zero overrides header/default).\nThis overrides binary's Parameter field."
--$Angled
doomednum = 2048,
spawnstate = S_HURRYUP,
spawnhealth = 1000,
deathstate = S_HURRYUP,
radius = 12*FRACUNIT,
height = 36*FRACUNIT,
dispoffset = 3,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_SOLID,
}
--$GZDB_SKIP
mobjinfo[MT_FROGSWITCHANIMATOR] = {
spawnstate = S_HURRYUP,
spawnhealth = 1000,
deathstate = S_HURRYUP,
radius = 12*FRACUNIT,
height = 36*FRACUNIT,
dispoffset = 3,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIPHEIGHT,
}

mobjinfo[MT_COINLOSSEFFECT] = {
spawnstate = S_COINLOSS,
spawnhealth = 1000,
deathstate = S_COINLOSS,
radius = 16*FRACUNIT,
height = 48*FRACUNIT,
dispoffset = 4,
flags = MF_SCENERY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING, -- i actually don't know if we need NOCLIPTHING
}

states[S_WARSPORT] = {
	sprite = SPR_WLPS,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 32,
	var2 = 10,
	nextstate = S_WARSPORT,
}

states[S_WARMPORT] = {
	sprite = SPR_WLPM,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 32,
	var2 = 10,
	nextstate = S_WARMPORT,
}

states[S_COINLOSS] = {
	sprite = SPR_WLC2,
	frame = FF_ANIMATE|A,
	tics = 36,
	var1 = 5,
	var2 = 2,
	nextstate = S_NULL,
}

states[S_WARLPORT] = {
	sprite = SPR_WLPL,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 32,
	var2 = 10,
	nextstate = S_WARLPORT,
}

states[S_HURRYUP] = {
	sprite = SPR_KOMBIFROGSWITCH,
	frame = A,
	tics = -1,
	var1 = 0,
	var2 = 0,
	nextstate = S_HURRYUP,
}

addHook("PlayerSpawn", function(player)
	kombi.timeleft = 20965
	if player.wl4kombitime and player.wl4kombitime >= 3*TICRATE
		kombi.disptime = (kombi.timeleft-(player.wl4kombitime-3*TICRATE))
	else
		kombi.disptime = kombi.timeleft
	end
	kombi.timeleftmins = kombi.disptime/(TICRATE*60)
	kombi.timeleftsecs =  (kombi.disptime/TICRATE)%60
	kombi.timeleftcents = (((kombi.disptime*100)%3500)/35)
	kombi.outtatimegong = false
	player.wl4kombitime = 0
end)

local function K_PunchFrogSwitch(prepassedtime, escapetype, activeportal)
	if kombi.hurryup return end -- no point in trying to hurry faster.
	kombi.warlogic = escapetype == 1
	local falsealarm = escapetype == 2
	kombi.falsealarm = falsealarm
	if not falsealarm
		S_ChangeMusic("hurryu", true)
		for player in players.iterate do
			local sound = kombi.RunHook("PreKeroHit", player, escapetype) or P_RandomRange(sfx_hurry0,sfx_hurry4)
			S_StartSound(nil, sound, player)
		end
	end
	if prepassedtime
		player.wl4kombitime = prepassedtime
	end
	kombi.hurryup = true
	print(kombi.warlogic)
	if kombi.warlogic
		kombi.hittime = 0
	else
		kombi.hittime = leveltime
	end
	kombi.activeportal = activeportal or 0
	K_SwapKeroBlocks()
	if multiplayer
		for player in players.iterate do
			KombiTeleport(player)
		end
	end
end

addHook("PlayerThink", function(player)
	if not player.mo return end
	kombi.timeleft = $ or 0
	if gamemap >= 604 and gamemap <= 624
		kombi.timeleft = srbtpmetaltimers[gamemap - 603]
	end
	if not kombi.hurryup and kombi.warlogic
		K_PunchFrogSwitch(player.starposttime, 1)
	end
	if gamemap == 25 and mapheaderinfo[gamemap].lvlttl == "Black Core"
		kombi.timeleft = 3340
	end
	if player.mo.skin == "kombi" and G_BuildMapTitle(gamemap) == "Tutorial Zone" and not player.mo.colorized
		player.mo.colorized = true
	end
	if kombi.wl4kombitime == nil
		kombi.wl4kombitime = 0
	end
	if kombi.hurryup
		kombi.timeleft = (kombi.mapclock - kombi.wl4kombitime)
	end
	if player.wl4kombitime or kombi.hittime > 0
		kombi.disptime = kombi.timeleft-player.wl4kombitime
	else
		kombi.disptime = kombi.timeleft
	end
	if kombi.disptime == nil
		kombi.disptime = 0
	end
	if kombi.warlevel and not kombi.warlogic
		player.realtime = 0
	end
	if kombi.hurryup
		if gametype == 0 and not kombi.warlogic
			player.realtime = kombi.hittime
		end
		if kombi.disptime < 0
			if (player.wl4kombitime-kombi.hittime)%6 == 0 and kombi.hurryup
				local coinloss = P_SpawnMobjFromMobj(player.realmo, 0, 0, mobjinfo[MT_PLAYER].height, MT_COINLOSSEFFECT)
				coinloss.angle = player.drawangle
				P_InstaThrust(coinloss, coinloss.angle, -4*FRACUNIT)
				P_SetObjectMomZ(coinloss, 10*FRACUNIT, false)
			end
			if not kombi.outtatimegong
				kombi.RunHook("KeroTimeUp")
				S_ChangeMusic("wlclos", true)
				S_StartSound(nil, sfx_wlclos)
				kombi.outtatimegong = true
			end
			if kombi.disptime%4 == 0 and player.wl4score > 0 and not (player.pflags & PF_FINISHED)
				local lossamnt = kombi.RunHook("KeroCoinLossTick", player) or 10
				P_AddPlayerScore(player, -lossamnt)
				player.wl4score = $-lossamnt
				if player.wl4score <= 0 and player.realmo.health
					P_KillMobj(player.realmo, nil, nil, DMG_SPACEDROWN)
				end
			else
				if player.wl4score <= 0 and player.realmo.health
					P_KillMobj(player.realmo, nil, nil, DMG_SPACEDROWN)
				end
			end
			kombi.disptime = 0
		end
	end
	kombi.timeleftmins = G_TicsToMinutes(kombi.disptime, true) --kombi.disptime/(TICRATE*60)
	kombi.timeleftsecs =  G_TicsToSeconds(kombi.disptime) --(kombi.disptime/TICRATE)%60
	kombi.timeleftcents = G_TicsToCentiseconds(kombi.disptime) --(((kombi.disptime*100)%3500)/35)
	if kombi.disptime == 385 and kombi.hurryup
		S_StartSound(nil, sfx_wlohno)
	end
	if player.wl4kombitime == nil player.wl4kombitime = 0 end
	if not player.exiting and ((kombi.hurryup or (gamemap >= 604 and gamemap <= 624 or (gamemap == 25 and mapheaderinfo[gamemap].lvlttl == "Black Core"))) and not kombi.falsealarm)
		player.wl4kombitime = $+1
	end
end)

addHook("IntermissionThinker", function(failed)
	kombi.hurryup = false
end)

if not srb2p
	local clocktype = CV_FindVar("timerres") -- Get the ConVar
	local offset = 16
	local center = 160 - offset
	local wltimeclr = SKINCOLOR_WHITE

	-- Function to determine timer color
	local function getTimeColor(ourtime)
		if ourtime <= 11 * TICRATE then
			return SKINCOLOR_RED
		elseif ourtime <= 31 * TICRATE then
			return SKINCOLOR_YELLOW
		else
			return SKINCOLOR_WHITE
		end
	end

	-- Function to draw a digit at a given position
	local function drawDigit(v, xpos, ypos, scale, digit, color)
		local patch = v.cachePatch("WLTIME" .. digit)
		if patch then
			v.drawScaled(xpos * FRACUNIT, ypos * FRACUNIT, scale * FRACUNIT, patch, V_SNAPTOTOP | V_PERPLAYER, v.getColormap(nil, color))
		end
	end

	-- Above, but for treasure.
	local function drawCoinDigit(v, xpos, ypos, scale, digit, color)
		local patch = v.cachePatch("WLCOIN" .. digit)
		if patch then
			v.drawScaled(xpos, ypos, scale, patch, V_SNAPTOTOP | V_PERPLAYER, v.getColormap(nil, color))
		end
	end

	-- Function to draw the escape clock digits
	local function drawTimerDigits(v, xpos, ypos, timeValue, color)
		local timeStr = tostring(timeValue)
		for i = 1, #timeStr do
			drawDigit(v, xpos, ypos, 2, timeStr:sub(i, i), color)
			xpos = xpos + offset
		end
	end

	-- Function to draw the clock animation
	local function drawClockAnimation(v, xpos, ypos, frame)
		local patch = v.cachePatch("WLCLOCK" .. frame)
		if patch then
			v.draw(xpos - 16, ypos, patch, V_SNAPTOTOP | V_PERPLAYER)
		end
	end

	-- Function to handle different timer display modes
	local function WL4HUD_KeroClock(v, player)
		if not player.mo then return end
		if not (gamemap >= 604 and gamemap <= 624 or (gamemap == 25 and mapheaderinfo[gamemap].lvlttl == "Black Core") or (kombi.hurryup and not kombi.falsealarm)) then return end

		local xpos, ypos = center, hudinfo[HUD_SCORE].y
		local frame = ((player.wl4kombitime) / 3) % 6 or 0

		if clocktype.value == 3 then -- Timer Display: Tics
			local ourtime = kombi.disptime
			wltimeclr = getTimeColor(ourtime)
			drawTimerDigits(v, xpos, ypos, ourtime, wltimeclr)
			drawClockAnimation(v, center, ypos, frame)

		elseif clocktype.value == 2 or clocktype.value == 1 then -- Timer Display: CD/Mania
			wltimeclr = getTimeColor(kombi.disptime)
			if not kombi.outtatimegong then
				local overflow = kombi.timeleftmins > 9
				local drawdots = (player.wl4kombitime - kombi.hittime) % 35 < 18

				if overflow then drawDigit(v, center, ypos, 2, (kombi.timeleftmins / 10) % 10, wltimeclr) end
				if drawdots then drawDigit(v, center + offset, ypos, 2, "C", wltimeclr) end
				if drawdots then drawDigit(v, center + offset * 4, ypos+15, 1, "D", wltimeclr) end

				drawDigit(v, center + offset * 3, ypos, 2, kombi.timeleftsecs % 10, wltimeclr)
				drawDigit(v, center + offset * 2, ypos, 2, (kombi.timeleftsecs / 10) % 10, wltimeclr)

				if overflow then
					drawDigit(v, center + offset, ypos, 2, kombi.timeleftmins % 10, wltimeclr)
				else
					drawDigit(v, center, ypos, 2, kombi.timeleftmins % 10, wltimeclr)
				end

				drawDigit(v, center + offset * 5, ypos+15, 1, kombi.timeleftcents % 10, wltimeclr)
				drawDigit(v, center + offset * 4 + 8, ypos+15, 1, (kombi.timeleftcents / 10) % 10, wltimeclr)
			end

			drawClockAnimation(v, center, ypos, frame)

		else -- Timer Display: Classic
			wltimeclr = getTimeColor(kombi.disptime)
			if not kombi.outtatimegong then
				local overflow = kombi.timeleftmins > 9
				local drawdots = (player.wl4kombitime - kombi.hittime) % 35 < 18

				if overflow then drawDigit(v, center, ypos, 2, (kombi.timeleftmins / 10) % 10, wltimeclr) end
				if drawdots then drawDigit(v, center + offset, ypos, 2, "C", wltimeclr) end

				drawDigit(v, center + offset * 3, ypos, 2, kombi.timeleftsecs % 10, wltimeclr)
				drawDigit(v, center + offset * 2, ypos, 2, (kombi.timeleftsecs / 10) % 10, wltimeclr)

				if overflow then
					drawDigit(v, center + offset, ypos, 2, kombi.timeleftmins % 10, wltimeclr)
				else
					drawDigit(v, center, ypos, 2, kombi.timeleftmins % 10, wltimeclr)
				end
			end

			drawClockAnimation(v, center, ypos, frame)
		end
	end

	-- Function to handle treasure display
	local function WL4HUD_Treasure(v, player)
		local xpos = (320 * FRACUNIT) + kombi.coinxoff - (((offset / 2) * kombi.coinsize) * 8) - kombi.coinsize
		local ypos = (hudinfo[HUD_SCORE].y + 2) * FRACUNIT

		v.drawScaled(xpos, ypos, kombi.coinsize, v.cachePatch("WLCOINC"), V_SNAPTOTOP | V_PERPLAYER)

		for i = 0, 5 do
			local frame = (player.wl4score or 0) / (10 ^ i) % 10
			drawCoinDigit(v, (320 * FRACUNIT) + kombi.coinxoff - (((offset / 2) * kombi.coinsize) * (2 + i)), ypos, kombi.coinsize, frame, SKINCOLOR_WHITE)
		end
	end

	customhud.AddItem("kerotime", "KombiWL4", WL4HUD_KeroClock)
	customhud.AddItem("treasure", "KombiWL4", WL4HUD_Treasure)
end

local function K_CheckTag(mobj)
	if not mobj.spawnpoint return end
	return mobj.spawnpoint.tag
end

addHook("MobjThinker", function(mobj)
	if mobj.alpha < 1 return end
	if not mobj.spawnpoint return end
	local s = P_SpawnMobj(mobj.x,mobj.y,mobj.z,MT_WLPORTALSMALL)
	local m = P_SpawnMobj(mobj.x,mobj.y,mobj.z,MT_WLPORTALMEDIUM)
	local l = P_SpawnMobj(mobj.x,mobj.y,mobj.z,MT_WLPORTALLARGE)
	l.destlevel = mobj.spawnpoint.args[0]
	s.switch = K_CheckTag(mobj)
	m.switch = K_CheckTag(mobj)
	l.switch = K_CheckTag(mobj)
	mobj.alpha = 0
end, MT_WLPORTALSPAWNER)

local function K_RunPortalSwitchCheck(mobj, onlyswitch)
	if onlyswitch
		return mobj.switch and kombi.activeportal == mobj.switch
	else
		return not mobj.switch or (kombi.activeportal and kombi.activeportal == mobj.switch)
	end
end

local function K_PortalThinker(mobj)
	if not mobj.switch mobj.switch = K_CheckTag(mobj) end
	/*
	if K_RunPortalSwitchCheck(mobj)
		mobj.alpha = 255
	else
		mobj.alpha = 0
	end
	*/
	if kombi.hurryup and K_RunPortalSwitchCheck(mobj)
		mobj.destscale = 2*FRACUNIT
		mobj.scalespeed = FixedDiv(FRACUNIT, 24*FRACUNIT)
	else
		mobj.scale = FixedDiv(FRACUNIT, 4*FRACUNIT)
	end
end

addHook("MobjThinker", function(mobj)
	mobj.rollangle = $ + FixedDiv(ANGLE_45, 45*FRACUNIT)
	K_PortalThinker(mobj)
end, MT_WLPORTALSMALL)

addHook("MobjThinker", function(mobj)
	mobj.rollangle = $ + FixedDiv(ANGLE_45, 30*FRACUNIT)
	K_PortalThinker(mobj)
end, MT_WLPORTALMEDIUM)

addHook("MobjThinker", function(mobj)
	mobj.rollangle = $ + FixedDiv(ANGLE_45, 25*FRACUNIT)
	K_PortalThinker(mobj)
end, MT_WLPORTALLARGE)

addHook("TouchSpecial",function(port,mo)
	if kombi.hurryup and K_RunPortalSwitchCheck(port)
	and not mo.player.wl4exitcutscene
	and not mo.player.exiting
		mo.player.exitcutscene = 1
		mo.player.wldestlevel = port.destlevel
		P_DoPlayerFinish(mo.player)
		mo.momx = 0
		mo.momy = 0
		print("total time taken: \$G_TicsToMinutes(mo.player.wl4kombitime,true)\:\$G_TicsToSeconds(mo.player.wl4kombitime)\.\$G_TicsToCentiseconds(mo.player.wl4kombitime)\")
		print("in escape time list format: \$G_TicsToSeconds(mo.player.wl4kombitime) + (G_TicsToMinutes(mo.player.wl4kombitime, true)*60)\")
		if mo.player.hp
			CONS_Printf(mo.player,"Gained \$mo.player.hp*50\ bonus treasure for \$mo.player.hp\ HP.")
			mo.player.wl4score = $+mo.player.hp*50
		end
	end
	return true
end,MT_WLPORTALLARGE)

rawset(_G, 'L_DecimalFixed', function(str)
	if str == nil return nil end
	local dec_offset = string.find(str,'%.')
	if dec_offset == nil
		return (tonumber(str) or 0)*FRACUNIT
	end
	local whole = tonumber(string.sub(str,0,dec_offset-1)) or 0
	local decstr = string.sub(str,dec_offset+1)
	local decimal = tonumber(decstr) or 0

	if(decimal==0)
		decstr = "0"
	end

	whole = $ * FRACUNIT
	local dec_len = string.len(decstr)
	decimal = $ * FRACUNIT / (10^dec_len)
	return whole + decimal
end)

local pressanimframes = TICRATE/3
local pause = TICRATE
local unpressanimframes = TICRATE
local pauseby = 8 -- real game pauses after 14@60FPS.
local letgoby = 125 -- TODO: What kinda fraction am i expected to just. GUESS to make 125.41666666667 with TICRATE = 35
local presstotalmovement = FRACUNIT*12
local unpresstotalmovement = FRACUNIT*16
local clockspin = FixedAngle(L_DecimalFixed("13.125"))

addHook("MobjSpawn", function(switch)
	for i = 1, 3 do
		local part = P_SpawnMobjFromMobj(switch, 0, 0, 0, MT_FROGSWITCHANIMATOR)
		part.tracer = switch
		part.frame = i
		part.dispoffset = 5-i
	end
	switch.alpha = 0
end, MT_KOMBIFROGSWITCH)

addHook("MobjCollide", function(switch, mo)
	if kombi.hurryup return end
	if not mo or not mo.valid return end
	if mo.type ~= MT_PLAYER return end
	local relzpos = mo.z - switch.z
	if relzpos == 74*FRACUNIT or relzpos == mo.height + 74*FRACUNIT -- TODO: Make these checks better.
		if abs(mo.momz) <= 2*FRACUNIT
			K_PunchFrogSwitch(0, switch.escapetype, switch.portal) -- PASSES: (WAR Mode, Time Defecit, Escape Type, Portals to Open)
		end
	end
end, MT_KOMBIFROGSWITCH)

addHook("ThinkFrame", function()
	if not kombi.hurryup kombi.animationClock = 0 return end
	kombi.animationClock = $ + 1
	local clock = kombi.animationClock
	if kombi.falsealarm return
	else
		if clock <= pauseby
			for player in players.iterate do
				if clock == pauseby
					K_PauseMomentum(player)
				else
					if player.wl4kombitime player.wl4kombitime = $ - 1 end
				end
			end
		end
		if clock == letgoby
			for player in players.iterate do
				K_ResumeMomentum(player)
			end
		end
	end
end)

addHook("MobjThinker", function(mobj)
	mobj.scale = 2*FRACUNIT
	if mobj.spawnpoint and not mobj.escapetype
		mobj.escapetype = mobj.spawnpoint.args[0] or mobj.spawnpoint.extrainfo
		mobj.portal = mobj.spawnpoint.tag
	end
	local clock = kombi.animationClock
	if kombi.falsealarm return
	elseif clock - pause == pressanimframes
		local part = P_SpawnMobjFromMobj(mobj, 0, 0, 0, MT_FROGSWITCHANIMATOR)
		part.tracer = mobj
		part.frame = E
		part.dispoffset = 1
	end
end, MT_KOMBIFROGSWITCH)

local frogSwitchEyeRemaps = {
	SKINCOLOR_KOMBI_FROGSWITCH,
	SKINCOLOR_KOMBI_FROGSWITCH,
	SKINCOLOR_RED,
	SKINCOLOR_YELLOW,
}

addHook("MobjThinker", function(mobj)
	mobj.scale = 2*FRACUNIT
	local frame = mobj.frame
	if frame == D return end
	
	local mainbody = mobj.tracer
	if not mainbody return end

	local animClock = kombi.animationClock
	local isPressing = animClock < pressanimframes
	local isUnpressing = (animClock - pause) >= pressanimframes and (animClock - pause) <= (pressanimframes + unpressanimframes)
	local inPost = (animClock - pause) > (pressanimframes + unpressanimframes)

	if frame == B and not inPost
		mobj.color = SKINCOLOR_KOMBI_FROGSWITCH
	end

	if isPressing
		if frame ~= B return end
		local t = FixedDiv(animClock, pressanimframes)
		if (mobj.eflags & MFE_VERTICALFLIP) ~= 0
			mobj.z = mainbody.z + ease.outback(t, 0, presstotalmovement)
		else
			mobj.z = mainbody.z - ease.outback(t, 0, presstotalmovement)
		end
	elseif isUnpressing
		if frame > C return end
		local t = FixedDiv(animClock - pressanimframes - pause, unpressanimframes)
		if (mobj.eflags & MFE_VERTICALFLIP) ~= 0
			mobj.z = mainbody.z - ease.linear(t, 0, unpresstotalmovement)
			if frame == B
				mobj.z = mobj.z + presstotalmovement
			end
		else
			mobj.z = mainbody.z + ease.linear(t, 0, unpresstotalmovement)
			if frame == B
				mobj.z = mobj.z - presstotalmovement
			end
		end
	elseif frame == B and inPost and not kombi.falsealarm
		mobj.color = frogSwitchEyeRemaps[(((animClock-pause-pressanimframes-unpressanimframes) / 4) % 4) + 1]
	end
end, MT_FROGSWITCHANIMATOR)

local priority = {
	["_minv"] = true,
	["_inv"] = true,
	["_shoes"] = true,
	["wlclos"] = true,
	["_drown"] = true,
	["sacler"] = true,
	["clear"] = true,
	["wl4did"] = true,
}

rawset(_G, "kombiCreditTrackMap", {
	["kombi"] = {default = "sa1tos", super = "opnyht"},
	["sonic"] = {default = "sa1tos", super = "opnyht"},
	["adventuresonic"] = {default = "sa1tos", super = "livean"},
	["shayde"] = {default = "sa2tos", super = "livean"},
})

addHook("MusicChange", function(oldname, newname, mflags, looping, position, prefadems, fadeinms)
	currentlyplaying = newname:lower()
	if cv_kombimaptitle.value == 1 and currentlyplaying != newname
		print("now playing track name \$currentlyplaying\")
	end
	if newname == "_chsel" and CV_FindVar("k_jinglereplacements").string == "SA1"
		return "sa1cyb", mflags, looping, position, 0, fadeinms
	end
	if not (consoleplayer and consoleplayer.valid)
		return
	end
	local playerskin = skins[consoleplayer.skin].name
	if newname == "_creds"
		return kombiCreditTrackMap[playerskin].default
	end
	if consoleplayer.kombilaps and consoleplayer.kombilaps >= 3 and not priority[newname] and not consoleplayer.exiting return "wl4efp" end
	if consoleplayer.kombilaps and consoleplayer.kombilaps > 3 and not priority[newname] and not consoleplayer.exiting
		if oldname == "wlclos"
			return true
		else
			return "wlclos"
		end
	end
	if kombi.hurryup and not priority[newname] and not consoleplayer.exiting
		if oldname == "hurryu"
			return true
		else
			return "hurryu"
		end
	end
	if personaltrackset
		if trackreplacements[newname]
			return "\$personaltrackset\\$trackreplacements[newname]\"
		end
		
		if (mapreplacements["\$gamemap\ \$string.lower(G_BuildMapTitle(gamemap))\"] or mapreplacements["\$string.lower(G_BuildMapTitle(gamemap))\"]) and newname == mapheaderinfo[gamemap].musname
			local printplay = mapreplacements["\$gamemap\ \$string.lower(G_BuildMapTitle(gamemap))\"] or mapreplacements["\$string.lower(G_BuildMapTitle(gamemap))\"]
			return "\$personaltrackset\\$printplay\"
		end
	end
	
	if newname == "_conti"
		return "s1cont"
	end
	
	if CV_FindVar("k_jinglereplacements").string == "Off" or (oldname == "opnyht" or oldname == "livean" or oldname == "sheroes" and consoleplayer.powers[pw_super]) or not (consoleplayer and consoleplayer.valid)
		if newname == "_super" -- redundancy my behated
			if CV_FindVar("k_supertheme").string == "SA1"
				return "opnyht", mflags, looping, position, 0, fadeinms
			elseif CV_FindVar("k_supertheme").string == "SA2"
				return "livean", mflags, looping, position, 0, fadeinms
			elseif CV_FindVar("k_supertheme").string == "SH"
				return "sheroes", mflags, looping, position, 0, fadeinms
			end
		end
		return
	end
	
	if newname == "_super"
		if CV_FindVar("k_supertheme").string == "SA1"
			return "opnyht", mflags, looping, position, 0, fadeinms
		elseif CV_FindVar("k_supertheme").string == "SA2"
			return "livean", mflags, looping, position, 0, fadeinms
		elseif CV_FindVar("k_supertheme").string == "SH"
			return "sheroes", mflags, looping, position, 0, fadeinms
		end
	end

	if not consoleplayer.powers[pw_super]
		if CV_FindVar("k_jinglereplacements").value == 1 or CV_FindVar("k_jinglereplacements").value == -1 and (not kombicustomtrackchars[playerskin] or kombicustomtrackchars[playerskin] == "SA1")
		if newname == "_shoes"	
			return "heyyou", mflags, looping, position, 0, fadeinms
		elseif newname == "_inv" or newname == "_minv"
			return "nofear", mflags, looping, position, 0, fadeinms
		end
		elseif CV_FindVar("k_jinglereplacements").string == "SA2" or CV_FindVar("k_jinglereplacements").value == -1 and kombicustomtrackchars[playerskin] == "SA2"
			if newname == "_shoes"	
				return "sagain", mflags, looping, position, 0, fadeinms
			elseif newname == "_inv" or newname == "_minv"
				return "stilli", mflags, looping, position, 0, fadeinms
			end
		end
	end

	if newname == "_clear"
		return "sacler"
	end
	
	if newname == "_drown"
		return "sadrwn", mflags, looping, position, 0, fadeinms
	end
end)