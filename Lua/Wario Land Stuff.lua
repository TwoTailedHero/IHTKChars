local function SafeFreeSlot(...)
	for _,slot in ipairs({...}) do
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
local function SpawnCoins(mo, count)
	if count >= 500
		local coin = P_SpawnMobjFromMobj(mo,0,0,0,MT_WARIOLAND500COIN)
		mo.spawning = $ - 500
	elseif count >= 100
		local coin = P_SpawnMobjFromMobj(mo,0,0,0,MT_WARIOLAND100COIN)
		mo.spawning = $ - 100
	elseif count >= 50
		local coin = P_SpawnMobjFromMobj(mo,0,0,0,MT_WARIOLAND50COIN)
		mo.spawning = $ - 50
	elseif count >= 10
		local coin = P_SpawnMobjFromMobj(mo,0,0,0,MT_WARIOLAND10COIN)
		mo.spawning = $ - 10
	end
	if coin
		coin.angle = mo.angle-ANGLE_180
	end
end

local function K_SummonSMSWater(mo, xoff, yoff, zoff, xvel, yvel, zvel, type)

end

addHook("SpinSpecial", function(player)
	if player.realmo.skin == "tynker" and player.smswater > 0 and not player.kombidontusefludd
		player.kombismswater = P_SpawnMobjFromMobj(player.realmo, 0, 0, player.mo.height*2, MT_FLUDDWATER)
		player.kombismswater.fuse = 35  -- speed should ALWAYS be 36*FRACUNIT
		player.smswater = $ - (1*FRACUNIT/6)
		player.kombismswater.target = player.mo
		print(player.kombigrounded)
		if not player.kombigrounded
			if player.realmo.momz <= FRACUNIT*2
				P_SetObjectMomZ(player.realmo, FRACUNIT*2, player.realmo.momz <= FRACUNIT*2)
			end
			P_SetObjectMomZ(player.kombismswater, -36*FRACUNIT, false)
		elseif player.speed < 5*FRACUNIT
			player.pflags = $|PF_FULLSTASIS
			player.kombismsrocketcharge = ($ or 0)+1
			print(player.kombismsrocketcharge)
			if player.kombismsrocketcharge >= TICRATE
				P_SetObjectMomZ(player.realmo, FRACUNIT*45, false)
				player.kombidontusefludd = true
				player.kombismsrocketcharge = nil
			end
		else
			player.kombismswater.momx = cos(player.realmo.angle)*(36*FRACUNIT)
			player.kombismswater.momy = sin(player.realmo.angle)*(36*FRACUNIT)
		end
		return true
	end
	if player.realmo.skin == "stryke"
		return true -- don't do the thing we specifically told you to do seconds earlier because we're evil actually (pull this stunt to add basic foxBot compat)
	end
	if player.realmo.skin == "kombi" and not ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo)) and (not player.kombispinabil or player.kombispinabil == "waitamoment") and not player.bouncedelay
		if (player.lastbuttons & BT_SPIN) return end
		P_SetObjectMomZ(player.realmo, -30*FRACUNIT, false)
		S_StartSound(mo, sfx_thok)
		player.kombispinabil = "rico"
	end
end)

local fireflowermap = {
SKINCOLOR_PLUM,
SKINCOLOR_RED,
SKINCOLOR_KOMBI_FIREFLOWER,
SKINCOLOR_GREEN,
}

if not srb2p
rawset(_G, "coinlist", {
	[MT_BLUECRAWLA] = 20,
	[MT_REDCRAWLA] = 50,
	[MT_GFZFISH] = 20,
	[MT_GOLDBUZZ] = 40,
	[MT_REDBUZZ] = 80,
	[MT_JETTBOMBER] = 100,
	[MT_JETTGUNNER] = 100,
	[MT_CRAWLACOMMANDER] = 300,
	[MT_DETON] = 20,
	[MT_SKIM] = 40,
	[MT_POPUPTURRET] = 40,
	[MT_SPINCUSHION] = 50,
	[MT_CRUSHSTACEAN] = 50,
	[MT_BANPYURA] = 50,
	[MT_JETJAW] = 20,
	[MT_SNAILER] = 50,
	[MT_VULTURE] = 50,
	[MT_SPRINGSHELL] = 30,
	[MT_YELLOWSHELL] = 30,
	[MT_ROBOHOOD] = 50,
	[MT_FACESTABBER] = 300,
	[MT_UNIDUS] = 50,
	[MT_POINTY] = 40,
	[MT_CANARIVORE] = 30,
	[MT_PYREFLY] = 20,
	[MT_DRAGONBOMBER] = 50,
	[MT_EGGMOBILE] = 1000,
	[MT_EGGMOBILE2] = 1000,
	[MT_EGGMOBILE3] = 1000,
	[MT_EGGMOBILE4] = 1000,
	[MT_FANG] = 1000,
	[MT_CYBRAKDEMON] = 1000,
	[MT_METALSONIC_BATTLE] = 1000,
	[MT_GOOMBA] = 20,
	[MT_BLUEGOOMBA] = 20
})

SafeFreeSlot("sfx_wl4dmg","sfx_whurt0","sfx_whurt1","sfx_whurt2","sfx_whurt3","sfx_whurt4","sfx_whurt5","sfx_whurt6","sfx_whurt7","sfx_wltran",
"MT_WLHEALTHDISP","S_WARIDISP","sfx_wmhart","sfx_saring","sfx_saflik","SPR_WLHP","sfx_wllowh",
"S_WARIOLAND10COIN","MT_WARIOLAND10COIN","SPR_WLC1","sfx_wlcoi1",
"S_WARIOLAND50COIN","MT_WARIOLAND50COIN","SPR_WLC2","sfx_wlcoi2",
"S_WARIOLAND100COIN","MT_WARIOLAND100COIN","SPR_WLC3","sfx_wlcoi3",
"S_WARIOLAND500COIN","MT_WARIOLAND500COIN","SPR_WLC4","sfx_wlcoi4",
"S_KEYZERASLEEP","S_KEYZERAWAKE","MT_KEYZER","SPR_WLKI","sfx_keyzer","MT_KEYZERFOLLOW","S_KOMBIHIDE",
"sfx_saexpl",
"sfx_sgood1","sfx_sgood2","sfx_sgood3","sfx_sgood4","sfx_sgood5","sfx_sgood6",
"sfx_shurt1","sfx_shurt2","sfx_shurt3","sfx_shurt4")

sfxinfo[sfx_saexpl].caption = "Pop"
sfxinfo[sfx_wl4dmg].caption = "Damage"
sfxinfo[sfx_whurt0].caption = "No, no..."
sfxinfo[sfx_whurt1].caption = "No no..."
sfxinfo[sfx_whurt2].caption = "Oh boy..."
sfxinfo[sfx_whurt3].caption = "Oh boy..."
sfxinfo[sfx_whurt4].caption = "Grr..! no, no..."
sfxinfo[sfx_whurt5].caption = "Hee hee hee hee hee hee!"
sfxinfo[sfx_whurt6].caption = "Yeah!"
sfxinfo[sfx_whurt7].caption = "Hey!"
sfxinfo[sfx_wmhart].caption = "Mini-Heart"
sfxinfo[sfx_saring].caption = "Sparkle"
sfxinfo[sfx_saflik].caption = "Animal Escaping"
sfxinfo[sfx_wlcoi1].caption = "Small Coin"
sfxinfo[sfx_wlcoi2].caption = "Bronze Coin"
sfxinfo[sfx_wlcoi3].caption = "Silver Coin"
sfxinfo[sfx_shurt1].caption = "Grunt"
sfxinfo[sfx_shurt2].caption = "No way..- way..!"
sfxinfo[sfx_shurt3].caption = "H-Hey!"
sfxinfo[sfx_shurt4].caption = "H-Ha, ha ha ha!"
sfxinfo[sfx_sgood1].caption = "Grunt"
sfxinfo[sfx_sgood2].caption = "Ye-Yes!"
sfxinfo[sfx_sgood3].caption = "A-Alright!"
sfxinfo[sfx_sgood4].caption = "C'mon!"
sfxinfo[sfx_sgood5].caption = "Leave-Leave it to me!"
sfxinfo[sfx_sgood6].caption = "Too easy!"
sfxinfo[sfx_wllowh].caption = "/"
sfxinfo[sfx_keyzer].caption = "/"
sfxinfo[sfx_wltran].caption = "/"

mobjinfo[MT_WARIOLAND500COIN] = {
spawnstate = S_WARIOLAND500COIN,
spawnhealth = 1000,
deathstate = S_WARIOLAND500COIN,
radius = mobjinfo[MT_RING].radius,
height = mobjinfo[MT_RING].height/2,
dispoffset = 4,
flags = MF_SCENERY|MF_SPECIAL,
}

states[S_WARIOLAND500COIN] = {
	sprite = SPR_WLC4,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 6,
	var2 = 2,
	nextstate = S_WARIOLAND500COIN,
}

mobjinfo[MT_WARIOLAND100COIN] = {
spawnstate = S_WARIOLAND100COIN,
spawnhealth = 1000,
deathstate = S_WARIOLAND100COIN,
radius = mobjinfo[MT_RING].radius,
height = mobjinfo[MT_RING].height/2,
dispoffset = 4,
flags = MF_SCENERY|MF_SPECIAL,
}

states[S_WARIOLAND100COIN] = {
	sprite = SPR_WLC3,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 5,
	var2 = 2,
	nextstate = S_WARIOLAND100COIN,
}

mobjinfo[MT_WARIOLAND50COIN] = {
spawnstate = S_WARIOLAND50COIN,
spawnhealth = 1000,
deathstate = S_WARIOLAND50COIN,
radius = mobjinfo[MT_RING].radius,
height = mobjinfo[MT_RING].height/2,
dispoffset = 4,
flags = MF_SCENERY|MF_SPECIAL,
}

states[S_WARIOLAND50COIN] = {
	sprite = SPR_WLC2,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 5,
	var2 = 2,
	nextstate = S_WARIOLAND50COIN,
}

mobjinfo[MT_WARIOLAND10COIN] = {
spawnstate = S_WARIOLAND10COIN,
spawnhealth = 1000,
deathstate = S_WARIOLAND10COIN,
radius = mobjinfo[MT_RING].radius,
height = mobjinfo[MT_RING].height/2,
dispoffset = 4,
flags = MF_SCENERY|MF_SPECIAL,
}

states[S_WARIOLAND10COIN] = {
	sprite = SPR_WLC1,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 3,
	var2 = 2,
	nextstate = S_WARIOLAND10COIN,
}

mobjinfo[MT_KEYZER] = {
spawnstate = S_KEYZERASLEEP,
spawnhealth = 1000,
deathstate = S_KEYZERASLEEP,
radius = mobjinfo[MT_TOKEN].radius/2,
height = mobjinfo[MT_TOKEN].height/2,
dispoffset = 0,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_SPECIAL,
}

states[S_KEYZERASLEEP] = {
	sprite = SPR_WLKI,
	frame = FF_ANIMATE|A,
	tics = -1,
	var1 = 7,
	var2 = 6,
	nextstate = S_KEYZERASLEEP,
}

states[S_KEYZERAWAKE] = {
	sprite = SPR_WLKI,
	frame = FF_ANIMATE|I,
	tics = -1,
	var1 = 3,
	var2 = 6,
	nextstate = S_KEYZERAWAKE,
}

mobjinfo[MT_KEYZERFOLLOW] = {
spawnstate = S_KOMBIHIDE,
spawnhealth = 1000,
deathstate = S_KOMBIHIDE,
radius = mobjinfo[MT_TOKEN].radius/2,
height = mobjinfo[MT_TOKEN].height/2,
dispoffset = 0,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING,
}

states[S_KOMBIHIDE] = {
	sprite = SPR_NULL,
	frame = A,
	tics = -1,
	var1 = 0,
	var2 = 0,
	nextstate = S_KOMBIHIDE,
}

mobjinfo[MT_WLHEALTHDISP] = {
spawnstate = S_WARIDISP,
spawnhealth = 4,
deathstate = S_WARIDISP,
radius = mobjinfo[MT_PLAYER].radius/2,
height = mobjinfo[MT_PLAYER].radius/2,
dispoffset = 72,
flags = MF_SCENERY|MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING,
}

states[S_WARIDISP] = {
	sprite = SPR_WLHP,
	tics = -1,
	var1 = 0,
	var2 = 0,
	nextstate = S_WARIDISP,
}
end

rawset(_G, "cv_wl4hp", CV_RegisterVar({
	name = "k_wl4health",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {On = 1, Off = 0},
}))

rawset(_G, "cv_wl4hurtdrop", CV_RegisterVar({
	name = "k_wl4hurtdrop",
	defaultvalue = 400,
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = CV_UNSIGNED,
}))

rawset(_G, "cv_kombiwl4max", CV_RegisterVar({
	name = "k_wl4maxhealth",
	defaultvalue = 8,
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {MIN = 1, MAX = 64},
}))

rawset(_G, "cv_kombiwl4spawnhp", CV_RegisterVar({
	name = "k_wl4spawnhealth",
	defaultvalue = 0,
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {MIN = 0, MAX = 64},
}))

rawset(_G, "cv_kombiwl4trans", CV_RegisterVar({
	name = "k_wl4transformations",
	defaultvalue = 1,
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {On = 1, Off = 0},
}))

rawset(_G, "cv_kombiwlsihearts", CV_RegisterVar({
	name = "k_wlsimaxhearts",
	defaultvalue = 5,
	flags = CV_SAVE|CV_SHOWMODIF|CV_NETVAR,
	PossibleValue = {MIN = 1, MAX = 10},
}))

rawset(_G, "kombiglobalhint", "")

local skin = "kombi"
local shieldtake = true
local hitsound = sfx_wl4dmg
local healthbar = 1
addHook("PlayerSpawn", function(player)
	player.hp = nil
	player.hpdivvies = nil
	player.kombimode = 0
	player.keyzerfollow = P_SpawnMobjFromMobj(player.realmo,0,0,0,MT_KEYZERFOLLOW)
	player.keyzerfollow.target = player.realmo
	player.kombismwpowerupstate = "small"
	K_ResetWLTransformation(player.realmo)
end)

addHook("PlayerThink", function(player)
	if not player.mo return end
	if player.powers[pw_invulnerability] > 1
		local index = (((invulntics-player.powers[pw_invulnerability])/3)%#fireflowermap)+1
		player.mo.color = fireflowermap[index]
	elseif player.powers[pw_invulnerability] == 1
		player.mo.color = kombiSMWItems[player.kombismwpowerupstate].prefcolor or player.skincolor
	end
	if kombiwhogetswl4stuff[player.mo.skin] == "smw"
		if player.kombismwpowerupstate == "small"
			player.charflags = $|SF_NOJUMPSPIN
			player.charflags = $|SF_NOJUMPDAMAGE
			player.mo.eflags = $&~MFE_FORCESUPER
		else
			if not (skins[player.mo.skin].flags & SF_NOJUMPSPIN)
				player.charflags = $&~SF_NOJUMPSPIN
			end
			if not (skins[player.mo.skin].flags & SF_NOJUMPDAMAGE)
				player.charflags = $&~SF_NOJUMPDAMAGE
			end
			player.mo.eflags = $|MFE_FORCESUPER
		end
	end
	if player.hpdivvies == nil player.hpdivvies = 0 end
	if not player.wl4score player.wl4score = 0 end
	if player.rblxouchclock
		player.rblxouchclock = $-1
	end
	if player.smswater == nil player.smswater = 100*FRACUNIT end
	if player.hp == nil and kombiwhogetswl4stuff[player.realmo.skin]
		if ultimatemode
			player.hpdivvies = 0
			player.hp = 1
		else
			if kombiwhogetswl4stuff[player.realmo.skin] == "wlsi"
				player.hp = cv_kombiwlsihearts.value*2
				player.hpdivvies = -32768
			elseif kombiwhogetswl4stuff[player.realmo.skin] == "sms"
				player.hp = 8
				player.hpdivvies = -32768
			elseif kombiwhogetswl4stuff[player.realmo.skin] == "lbn"
				player.hp = kombilbninjagostats[kombiunitmapping[player.mo.skin][1]][kombiunitmapping[player.mo.skin][2]][1]
				player.hpdivvies = -32768
			elseif kombiwhogetswl4stuff[player.realmo.skin] == "wl4"
				if (mapheaderinfo[gamemap].bonustype == 1)
					player.hp = cv_kombiwl4max.value
					player.hpdivvies = -32768
				else
					player.hpdivvies = 0
					player.hp = (cv_kombiwl4spawnhp.value or cv_kombiwl4max.value/2) or 1
				end
			end
		end
		if player.hpdivvies == nil player.hpdivvies = -32768 end
	end
	if player.rblxmaxhp == nil player.rblxmaxhp = 100 return end
	if player.rblxhp == nil or (player.rblxhp <= 0 and ((player.playerstate & PST_LIVE) or (player.playerstate & PST_REBORN)))
		player.rblxhp = player.rblxmaxhp*FRACUNIT
	end
	if not player.keyzerfollow
		player.keyzerfollow = P_SpawnMobjFromMobj(player.realmo,0,0,0,MT_KEYZERFOLLOW)
		player.keyzerfollow.target = player.realmo
	end
	if player.realmo and not kombiwhogetswl4stuff[player.realmo.skin] == "wlsi"
	and player.hp > cv_kombiwl4max.value
		player.hp = cv_kombiwl4max.value
	end
	if player.realmo and kombiwhogetswl4stuff[player.realmo.skin]
	and player.hpdivvies
	and player.hpdivvies > 7
	and player.hp
	and player.hp < cv_kombiwl4max.value
		player.hp = $ + 1
		player.hpdivvies = 0
	end
	if player.hpdivvies and player.hpdivvies > 8
		player.hpdivvies = 8
	end
	if (maptol & TOL_NIGHTS)
		player.hp = 8
	end
end)

local actualhealth
local xpos
local ypos
local minrings = 2

addHook("PlayerThink", function(player)
	if not player.mo return end
	/*
	if player.wl4score-req >= 0
		player.kombicrownbonus = 4
	elseif player.wl4score-(req/2) >= 0
		player.kombicrownbonus = 2
	elseif player.wl4score-(req/4) >= 0
		player.kombicrownbonus = 1
	else
		player.kombicrownbonus = 0
	end
	*/
	-- print(player.mo.momz)
	if not player.mo.firedelay and player.mo.turns and player.mo.turns == 4
		player.mo.firedelay = 4*TICRATE
		player.mo.turns = 5
		player.kombispeedcap = true
		player.normalspeed = skins[player.realmo.skin].normalspeed/10
	end
	if player.mo.turns and player.mo.turns > 4
		if player.mo.firedelay == 0
			player.mo.transformation = 0
			player.mo.turns = 0
			player.mo.color = skins[player.realmo.skin].prefcolor
			COM_BufInsertText(player, "tunes -default")
			player.kombispeedcap = false
			player.normalspeed = skins[player.realmo.skin].normalspeed
		end
	end
	if player.mo.firedelay player.mo.firedelay = $-1 end
	if not player.realmo.transformation
		player.realmo.transformation = 0
	end
	if not player.leveltimeadd
		player.leveltimeadd = 0
	end
	if player.mo.transformation == TR_FIRE and player.mo.turns and player.mo.turns <= 4
		if ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo)) and not player.mo.state == S_PLAY_RUN player.mo.state = S_PLAY_RUN end
		player.drawangle = player.mo.fireangle
		P_InstaThrust(player.mo,player.mo.fireangle,30*FRACUNIT)
	elseif player.mo.transformation == TR_FLAT
		if not ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo))
			player.mo.momz = $ - (P_GetMobjGravity(player.mo)/3)
		end
		if kombiallowsquashnstretch[player.mo.skin]
			player.realmo.spriteyscale = $/4 -- always reset before we run this
			player.realmo.spritexscale = 5*$/3
		else
			player.realmo.spriteyscale = FRACUNIT/4
			player.realmo.spritexscale = 5*FRACUNIT/3
		end
		player.kombispeedcap = true
		player.normalspeed = 1*skins[player.realmo.skin].normalspeed/3
		player.kombispeedcap = true
	end
	if ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo)) and player.mo.transformation == TR_ZOMBIE
		player.mo.transformation = TR_ZOMBIEACTIVE
	end
	if player.mo.transformation == TR_FIRE
		player.mo.color = SKINCOLOR_KOMBIAKAI
	end
	if player.mo.transformation == TR_ZOMBIE or player.mo.transformation == TR_ZOMBIEACTIVE
		if player.mo.transformation == TR_ZOMBIE
			player.mo.momx = 0
			player.mo.momy = 0
		end
		player.kombispeedcap = true
		player.normalspeed = skins[player.realmo.skin].normalspeed/7
		player.mo.color = SKINCOLOR_GREEN
	end
	if player.mo.transformation == TR_PUFFY
		P_SetObjectMomZ(player.mo, FRACUNIT*4, false)
		player.kombispeedcap = true
		player.normalspeed = skins[player.realmo.skin].normalspeed/7
		if player.mo.subsector.sector
			local sector = player.mo.subsector.sector
			if P_MobjFlip(player.mo) > 0
				print(player.mo.z+player.mo.height,sector.ceilingheight,player.mo.z+player.mo.height >= sector.ceilingheight)
				if player.mo.z+player.mo.height >= sector.ceilingheight
					K_ResetWLTransformation(player.mo)
				end
			else
			
			end
		end
	end
	if (player.realmo.eflags & MFE_UNDERWATER) and player.mo.transformation
		K_ResetWLTransformation(player.mo)
	end
	if player.kmbiinstaclock
		player.kmbiinstaclock = $-1
		if player.kombismwpowerupstate == "small"
			if player.kmbiinstaclock > 0
				player.mo.state = S_PLAY_ROLL
				if not (skins[player.mo.skin].flags & SF_NOJUMPDAMAGE)
					player.charflags = $&~SF_NOJUMPDAMAGE
					player.pflags = $&~PF_NOJUMPDAMAGE
				end
			else
				player.mo.state = S_PLAY_FALL
			end
		end
	end
end)

addHook("ShouldDamage", function(target, inf, source, dmg, dmgType)
	if dmgType == DMG_CRUSHED
		if not target.transformation
			S_StartSound(target, P_RandomRange(sfx_whurt0,sfx_whurt7))
			S_StartSound(target, sfx_wltran)
			target.transformation = TR_FLAT
			S_ChangeMusic("wl3fla", true, player)
		end
		return false
	end
	if target.player.kmbiinstaclock
		return false
	end
end, MT_PLAYER)

rawset(_G, "kombisfxbank", { -- voicebanks
	["kombi"] = {
				pain = {sfx_shurt1,sfx_shurt2,sfx_shurt3,sfx_shurt4},
				cheer = {sfx_sgood1,sfx_sgood2,sfx_sgood3,sfx_sgood4,sfx_sgood5,sfx_sgood6},
				},
}) -- Trez doesn't need it since we default to WL4 anyway

local function P_AdventureRingBurst(player, rings)
	local kombiburstang
	local classicringinitang = ANGLE_90 + ANGLE_11hh -- 101.25 degrees
	local classicringang = classicringinitang
	local classicringspeed = 8 * FRACUNIT
	local losspenalty = FRACUNIT + FixedDiv(player.losstime << FRACBITS, 10 * TICRATE << FRACBITS)
	if not (twodlevel or (player.mo.flags2 & MF2_TWOD))
		kombiburstang = player.realmo.angle
	else
		kombiburstang = ANGLE_90 + ANGLE_11hh
	end
	if not rings return end -- You can't do anything, so don't even try. Sonic, dead or alive, is m-m-mine.
	for i = 1, rings do
		local ringburst = P_SpawnMobjFromMobj(player.realmo, 0, 0, player.mo.height, MT_FLINGRING)
		ringburst.angle = kombiburstang
		ringburst.fuse = 8 * TICRATE
		if not (twodlevel or (player.mo.flags2 & MF2_TWOD)) -- Adventure-style behavior
			ringburst.momx = FixedMul(cos(ringburst.angle), FixedMul(FixedMul(2 * FRACUNIT, losspenalty), player.mo.scale))
			ringburst.momy = FixedMul(sin(ringburst.angle), FixedMul(FixedMul(2 * FRACUNIT, losspenalty), player.mo.scale))
			ringburst.momz = 4 * FRACUNIT
			kombiburstang = $ + FixedAngle(FRACUNIT * 360 / rings)
		else -- Classic-style Behavior
			local classicringthrust = FixedMul(FixedMul(classicringspeed, losspenalty), player.mo.scale)
			ringburst.momx = FixedMul(cos(classicringang), classicringthrust)
			ringburst.momz = FixedMul(sin(classicringang), classicringthrust)
			if (i-1)%2
				ringburst.momx = -ringburst.momx
				classicringang = $ + ANGLE_22h
			end
			if i == 16
				classicringspeed = $/2
				classicringang = classicringinitang
			end
		end
	end
	player.losstime = $+10*TICRATE
end

addHook("MobjDamage", function(target, inf, src, dmg, dmgType)
	if dmgType == DMG_SPIKE and target.player.spinjumping and abs(target.momz) >= 3*FRACUNIT
		S_StartSound(target, sfx_kmwkik)
		P_SetObjectMomZ(target, -3*target.momz/4, false)
		return true
	end
	if target.skin == "kombifreeman"
		return false
	end
	target.punchtime = 0
	target.headbashing = 0
	if target.transformation == TR_FIRE and dmgType == DMG_FIRE return true end
	if kombiwhogetswl4stuff[target.skin] and not(target.player.powers[pw_super] or target.player.powers[pw_flashing])
	if cv_kombiwl4trans.value == 1 and inf and kombimobjtransformations[inf.type]
		if K_SetWLTransformation(target, kombimobjtransformations[inf.type])
			if kombisfxbank[target.skin]
				S_StartSound(target, kombisfxbank[target.skin].pain[P_RandomRange(1,#kombisfxbank[target.skin].pain)])
			else
				S_StartSound(target, P_RandomRange(sfx_whurt0,sfx_whurt7))
			end
		end
		return true
	end
	if not (kombiwhogetswl4stuff[target.skin] == "rblx" or kombiwhogetswl4stuff[target.skin] == "smw")
		if kombisfxbank[target.skin]
			S_StartSound(target, kombisfxbank[target.skin].pain[P_RandomRange(1,#kombisfxbank[target.skin].pain)])
		else
			S_StartSound(target, P_RandomRange(sfx_whurt0,sfx_whurt7))
		end
	end
	target.spawning = min(CV_FindVar("k_wl4hurtdrop").value,target.player.wl4score)
	P_AddPlayerScore(target.player, target.spawning*-1) target.player.wl4score = $-target.spawning
	repeat
		SpawnCoins(target, target.spawning)
	until target.spawning < 10
	P_AddPlayerScore(target.player, target.spawning) target.player.wl4score = $+target.spawning -- do this to not scam people out of their score if spawning is not a multiple of 10
		if not kombiwhogetswl4stuff[target.skin] return end
		if CV_FindVar("k_wl4health").string == "On"
			if kombiwhogetswl4stuff[target.skin] == "rblx"
				if not (dmgType & DMG_DEATHMASK) and inf and not (inf.type and inf.type == MT_EGGMAN_ICON)
					if inf.player
						P_AddPlayerScore(inf.player, 50)
					end
				end
				if target.player.powers[pw_shield]
				and shieldtake == true
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					P_RemoveShield(target.player)
				else
					target.player.powers[pw_flashing] = 18
					target.player.timeshit = $+1
					P_PlayerEmeraldBurst(target.player,false)
					P_PlayerWeaponAmmoBurst(target.player)
					P_PlayerFlagBurst(target.player,false)
					local damage
					if inf != nil and inf.valid and FixedMul(inf.radius * 2, inf.height) / 20 > 0
						damage = max(1, FixedSqrt(FixedMul(inf.radius * 2, inf.height) / 20))
					else
						damage = 15*FRACUNIT
					end
					if damage >= 5*FRACUNIT
						if target.player.rblxouchclock
							target.player.rblxouchclock = 35
						else
							target.player.rblxouch = target.player.rblxhp
							target.player.rblxouchclock = 35
						end
					end
					target.player.rblxhp = $-damage
					if target.player.rblxhp <= 0
						P_KillMobj(target,inf,src)
					elseif target.player.hp == 1
						target.player.leveltimeadd = leveltime % 53
					end
				end
			elseif kombiwhogetswl4stuff[target.skin] == "wlsi"
				if not (dmgType & DMG_DEATHMASK) and inf and not (inf.type and inf.type == MT_EGGMAN_ICON)
					if inf.player
						P_AddPlayerScore(inf.player, 50)
					end
				end
				if target.player.powers[pw_shield]
				and shieldtake == true
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					S_StartSound(target, hitsound)
					P_RemoveShield(target.player)
				else
					if inf != nil and inf.valid and FixedMul(inf.radius * 2, inf.height) / 200 > 0
						target.player.hp = $-max(1, FixedSqrt(FixedMul(inf.radius * 2, inf.height) / 200)/FRACUNIT)
					else
						target.player.hp = $-3
					end
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					S_StartSound(target, hitsound)
					P_PlayerEmeraldBurst(target.player,false)
					P_PlayerWeaponAmmoBurst(target.player)
					P_PlayerFlagBurst(target.player,false)
					if target.player.hp <= 0 and target.player.hpdivvies < 8
						P_KillMobj(target,inf,src)
					elseif target.player.hp == 1
						target.player.leveltimeadd = leveltime % 53
					end
				end
			elseif kombiwhogetswl4stuff[target.skin] == "smw"
				if not (dmgType & DMG_DEATHMASK) and inf and not (inf.type and inf.type == MT_EGGMAN_ICON)
					if inf.player
						P_AddPlayerScore(inf.player, 50)
					end
				end
				local hurtsounda = kombiSMWItems["small"].pickupsfx or sfx_mwmush
				if target.player.powers[pw_shield]
				and shieldtake == true
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					S_StartSound(target, hurtsounda)
					P_RemoveShield(target.player)
				else
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					P_PlayerEmeraldBurst(target.player,false)
					P_PlayerWeaponAmmoBurst(target.player)
					P_PlayerFlagBurst(target.player,false)
					if target.player.kombismwpowerupstate == "small"
						if target.player.rings <= minrings
							P_KillMobj(target,inf,src)
						else
							target.player.rings = $/2
							P_AdventureRingBurst(target.player, min(target.player.rings/2, 32))
							hurtsounda = sfx_shldls
						end
					else
						K_SetPowerUp(target, "small")
					end
					S_StartSound(target, hurtsounda)
				end
			elseif kombiwhogetswl4stuff[target.skin] == "sms"
				if not (dmgType & DMG_DEATHMASK) and inf and not (inf.type and inf.type == MT_EGGMAN_ICON)
					if inf.player
						P_AddPlayerScore(inf.player, 50)
					end
				end
				if inf != nil and inf.valid and FixedMul(inf.radius * 2, inf.height) / 600 > 0
					target.player.hp = $-max(1, FixedSqrt(FixedMul(inf.radius * 2, inf.height) / 600)/FRACUNIT)
				else
					target.player.hp = $-1
				end
				if (dmgType & DMG_ELECTRIC)
					target.player.powers[pw_flashing] = 135
					target.player.pause = 53
				else
					P_DoPlayerPain(target.player, src, inf)
				end
				target.player.timeshit = $+1
				S_StartSound(target, hitsound)
				P_PlayerEmeraldBurst(target.player,false)
				P_PlayerWeaponAmmoBurst(target.player)
				P_PlayerFlagBurst(target.player,false)
				if target.player.hp <= 0
					P_KillMobj(target,inf,src)
				elseif target.player.hp == 1
					target.player.leveltimeadd = leveltime % 53
				end
			elseif kombiwhogetswl4stuff[target.skin] == "lbn"
				return
			else
				if not (dmgType & DMG_DEATHMASK) and inf and not (inf.type and inf.type == MT_EGGMAN_ICON)
					if inf.player
						P_AddPlayerScore(inf.player, 50)
					end
				end
				if target.player.powers[pw_shield]
				and shieldtake == true
					target.player.powers[pw_flashing] = 50
					P_DoPlayerPain(target.player, src, inf)
					S_StartSound(target, hitsound)
					P_RemoveShield(target.player)
				else
					target.player.powers[pw_flashing] = 50
					target.player.hp = $ - 1
					P_DoPlayerPain(target.player, src, inf)
					S_StartSound(target, hitsound)
					P_PlayerEmeraldBurst(target.player,false)
					P_PlayerWeaponAmmoBurst(target.player)
					P_PlayerFlagBurst(target.player,false)
					if target.player.hp == 0 and target.player.hpdivvies < 8
						P_KillMobj(target,inf,src)
					elseif target.player.hp == 1
						target.player.leveltimeadd = leveltime % 53
					end
				end
			end
		else
			if target.player.rings
				P_PlayRinglossSound(target)
				P_AdventureRingBurst(target.player, min(target.player.rings, 32))
				P_DoPlayerPain(target.player, src, inf)
				P_RemoveShield(target.player)
				P_PlayerEmeraldBurst(target.player,false)
				P_PlayerWeaponAmmoBurst(target.player)
				P_PlayerFlagBurst(target.player,false)
				target.player.rings = 0
			else
				P_KillMobj(target,inf,src)
			end
		end
		return true
	end
end, MT_PLAYER)

addHook("MobjDeath", function(target, inf, src, dmgType)
	target.player.hp = 0
end, MT_PLAYER)

addHook("MobjThinker", function(mobj)
	A_CapeChase(mobj.target,1,0)
	if mobj.target.player
		local player = mobj.target.player
	end
	mobj.frame = player.hp
	print("Active!",mobj.x)
end, MT_WLHEALTHDISP)

addHook("MobjDeath", function(mo, inf, src)
		if not src or not src.player or not (mo.flags & MF_ENEMY) or not (src) or not (kombiwhogetswl4stuff[src.skin] or (src.player.bot and src.player.botleader and kombiwhogetswl4stuff[src.player.botleader.realmo.skin])) return end
		-- Don't check for console command in the above "if" to not scam the player out of health if they decide to enable it again like the cowards they are
		if CV_FindVar("k_wl4health").string == "On" -- ...But we don't want to keep the auditory information despite this
			S_StartSound(mo, sfx_wmhart)
		end
		-- if src.skin == "kombi" and not src.player.botleader src.player.kombiboost = $+100*FRACUNIT/32 elseif src.player.bot and src.player.botleader.realmo.skin == "kombi" src.player.botleader.kombiboost = $+100*FRACUNIT/32 end
		if src.player.hpdivvies != nil src.player.hpdivvies = $+1 end
		print(src.player.hpdivvies)
		src.player.enemykillclock = 12 -- 12/35 seconds to teabag the poor sod
		if src.player.hpdivvies -- do this to make places like the GHZ Armageddon Shield area give you the health it's supposed to
		and src.player.hpdivvies > 7
		and src.player.hp
		and src.player.hp < cv_kombiwl4max.value
			src.player.hp = $ + 1
			src.player.hpdivvies = 0
		end
		if mo.type == MT_PLAYER
			mo.spawning = mo.player.wl4score
			P_AddPlayerScore(mo.player, mo.spawning*-1) mo.player.wl4score = $-mo.spawning
			repeat
				SpawnCoins(mo, mo.spawning)
			until mo.spawning < 10
		else
		mo.spawning = coinlist[mo.type] or 50
		repeat
			SpawnCoins(mo, mo.spawning)
		until mo.spawning < 10
		end
	local type = mo.type
	if (src) and (src.player) and (kombiwhogetswl4stuff[src.skin] or (src.player.bot and kombiwhogetswl4stuff[src.player.botleader.realmo.skin])) and not ((type > MT_BUGGLE) and (type < MT_SPINBOBERT_FIRE2))
		and not ((type > MT_COIN) and (type <= MT_SHLEEP))
		and not (type == MT_FANG)
		local flickysfx = P_SpawnMobjFromMobj(mo,0,0,0,MT_THOK)
		flickysfx.tics,flickysfx.fuse = 60,60 flickysfx.flags2 = MF2_DONTDRAW flickysfx.spriteyscale = 1
		S_StartSound(flickysfx, sfx_saflik)
		S_StartSound(flickysfx, sfx_saexpl) -- should be available since X-Tra freeslots before we could potentially even do this
	
		if not mo.spawnedsaexplosion --Makes the mod stackable and modifyable. You can add it to a MobjSpawn hook for example.
		and not mo.player --...duh.
		
			mo.spawnedsaexplosion = true
			mo.flags2 = $|MF2_DONTDRAW
			mo.spritexscale,mo.spriteyscale = 1,1
		
			local expl = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_SAEXPL)
			expl.scale = max(mo.scale, mo.height/32) --A bigger explosion the bigger you are!
			expl.target = mo
		end
	end
end)

local function CoinThinker(mobj)
	if mobj.collectwait > 0
		mobj.collectwait = $ - 1
	end
	mobj.scale = 2*FRACUNIT
end

local function CoinSpawn(mobj)
	if not ((mobj.flags2 & MF2_TWOD) or twodlevel)
		mobj.angle = FixedAngle(P_RandomRange(0, 359)*FRACUNIT)
	end
	P_Thrust(mobj, mobj.angle, 6*FRACUNIT)
	P_SetObjectMomZ(mobj, 12*FRACUNIT)
	mobj.collectwait = 13
end

local function WariYahoo(mobj)
	if kombisfxbank[mobj.skin]
		S_StartSound(mobj, kombisfxbank[mobj.skin].cheer[P_RandomRange(1,#kombisfxbank[mobj.skin].cheer)])
	else
		S_StartSound(mobj, P_RandomRange(sfx_waow0,sfx_waow18))
	end
end

addHook("TouchSpecial", function(mobj,toucher) --I swear there's a way to pass custom arguments to these that i just don't know about
	if not kombiwhogetswl4stuff[toucher.skin] or mobj.collectwait return true end
	P_AddPlayerScore(toucher.player, 10)
	if not toucher.player.botleader toucher.player.wl4score = $+10 else toucher.player.botleader.wl4score = $+10 end
	S_StartSound(toucher, sfx_wlcoi1)
	mobj.state = S_NULL
end, MT_WARIOLAND10COIN)

addHook("TouchSpecial", function(mobj,toucher)
	if not kombiwhogetswl4stuff[toucher.skin] or mobj.collectwait return true end
	P_AddPlayerScore(toucher.player, 50)
	if not toucher.player.botleader toucher.player.wl4score = $+50 else toucher.player.botleader.wl4score = $+50 end
	S_StartSound(toucher, sfx_wlcoi2)
	mobj.state = S_NULL
end, MT_WARIOLAND50COIN)

addHook("TouchSpecial", function(mobj,toucher)
	if not kombiwhogetswl4stuff[toucher.skin] or mobj.collectwait return true end
	P_AddPlayerScore(toucher.player, 100)
	if not toucher.player.botleader toucher.player.wl4score = $+100 else toucher.player.botleader.wl4score = $+100 end
	S_StartSound(toucher, sfx_wlcoi3)
	mobj.state = S_NULL
end, MT_WARIOLAND100COIN)

addHook("TouchSpecial", function(mobj,toucher)
	if not kombiwhogetswl4stuff[toucher.skin] or mobj.collectwait return true end
	P_AddPlayerScore(toucher.player, 500)
	if not toucher.player.botleader toucher.player.wl4score = $+500 else toucher.player.botleader.wl4score = $+500 end
	S_StartSound(toucher, sfx_wlcoi4)
	mobj.state = S_NULL
end, MT_WARIOLAND500COIN)

addHook("MobjSpawn", CoinSpawn, MT_WARIOLAND10COIN)
addHook("MobjSpawn", CoinSpawn, MT_WARIOLAND50COIN)
addHook("MobjSpawn", CoinSpawn, MT_WARIOLAND100COIN)
addHook("MobjSpawn", CoinSpawn, MT_WARIOLAND500COIN)
addHook("MobjThinker", CoinThinker, MT_WARIOLAND10COIN)
addHook("MobjThinker", CoinThinker, MT_WARIOLAND50COIN)
addHook("MobjThinker", CoinThinker, MT_WARIOLAND100COIN)
addHook("MobjThinker", CoinThinker, MT_WARIOLAND500COIN)

addHook("MobjThinker", function(mobj)
	mobj.scale = 2*FRACUNIT
	if mobj.awake
		A_HomingChase(mobj,R_PointToDist2(mobj.x, mobj.y, mobj.target.x, mobj.target.y)/3,0)
	end
end, MT_KEYZER)

addHook("MobjThinker", function(mobj)
	if not mobj.target
		mobj.state = S_NULL
	else
		P_SetOrigin(mobj, mobj.target.x+(cos(mobj.target.player.drawangle)*-36), mobj.target.y+(sin(mobj.target.player.drawangle)*-36), mobj.target.z+FRACUNIT*40)
	end
end, MT_KEYZERFOLLOW)

addHook("MobjSpawn", function(mobj)
	mobj.awake = false
end, MT_KEYZER)

addHook("TouchSpecial", function(mobj,toucher)
	mobj.target = toucher.player.keyzerfollow or toucher
	if not mobj.awake
		mobj.awake = true
		mobj.state = S_KEYZERAWAKE
		token = $ + 1
		S_StartSound(mobj, sfx_keyzer)
		WariYahoo(toucher)
	end
	return true
end,MT_KEYZER)

addHook("MobjThinker", function(mobj)
	mobj.scale = FRACUNIT/16
end, MT_KOMBIMACANDCHEESE)

addHook("MobjSpawn", function(mobj)
	mobj.scale = FRACUNIT/16
end, MT_KOMBIMACANDCHEESE)

addHook("TouchSpecial",function(port,mobj)
	S_StartSound(mobj, sfx_saring)
	P_SpawnMobj(port.x, port.y, port.z, MT_SPARK)
	P_RemoveMobj(port)
	WariYahoo(mobj)
	token = $+1
end,MT_KOMBIMACANDCHEESE)