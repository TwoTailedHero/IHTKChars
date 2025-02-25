-- the .lua dedicated to creating everything we'll require later
-- rawset EVERYTHING to _G because we can't just declare a function normally and expect it to work

local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end

local playersize
local smallrescale = FRACUNIT*2/3
local medrescale = FRACUNIT*5/6
local powerupinterval = TICRATE / 3

local function warn(str)
	print("\131WARNING: \128"..str);
end

local function notice(str)
	print("\x83NOTICE: \x80"..str);
end

if not srb2p -- non-functions
local success, luabanks = pcall(reserveLuabanks)

if success then
    kombi.currentsave = luabanks
else
    warn("Luabanks already reserved! Data won't be saved!")
    kombi.currentsave = {}
    for i = 0, 15 do
        kombi.currentsave[i] = 0
    end
end

SafeFreeSlot("sfx_mwmush","sfx_mwhurt","sfx_mwfeth","S_KOMBI_GROW","SPR2_GROW","SKINCOLOR_KOMBI_FIREFLOWER","SKINCOLOR_KOMBI_FROGSWITCH")

skincolors[SKINCOLOR_KOMBI_FIREFLOWER] = {
	name = "Flamesman",
	ramp = {0,0,0,80,48,216,217,50,51,53,55,58,61,63,45,46},
	invcolor = SKINCOLOR_AQUAMARINE,
	invshade = 11,
	accessible = true
}
skincolors[SKINCOLOR_KOMBI_FROGSWITCH] = {
	name = "Frog Switched",
	ramp = {0,1,128,129,131,132,133,133,148,148,149,149,150,153,168,31},
	invcolor = SKINCOLOR_CRIMSON,
	invshade = 10,
	accessible = true
}

states[S_KOMBI_GROW] = {
	sprite = SPR_PLAY,
	frame = SPR2_GROW|A,
	tics = -1,
	var1 = 6,
	var2 = 2,
	nextstate = S_KOMBI_GROW,
}

local fireflowermap = {
SKINCOLOR_PLUM,
SKINCOLOR_RED,
SKINCOLOR_KOMBI_FIREFLOWER,
SKINCOLOR_GREEN,
}

rawset(_G, "TR_FIRE", 1)
rawset(_G, "TR_FLAT", 2)
rawset(_G, "TR_ZOMBIE", 3)
rawset(_G, "TR_ZOMBIEACTIVE", 4)
rawset(_G, "TR_PUFFY", 5)

if not kombiShieldToSMW
	rawset(_G, "kombiShieldToSMW", {}) -- Shield Remappings
end

kombiShieldToSMW = {
	[SH_PITY] = "mushroom",
	[SH_PINK] = "mushroom",
	[SH_ARMAGEDDON] = "fireflower",
	[SH_WHIRLWIND] = "capefeather",
	[SH_ELEMENTAL] = "fireflower",
	[SH_ATTRACT] = "fireflower",
	[SH_FLAMEAURA] = "fireflower",
	[SH_BUBBLEWRAP] = "capefeather",
	[SH_THUNDERCOIN] = "capefeather",
	[SH_FORCE] = "mushroom",
}

if not kombiwhogetswl4stuff
	rawset(_G, "kombiwhogetswl4stuff", {}) -- WL4 Mechanics, do it this way because rawset may unintentionally overwrite entries
end

kombiwhogetswl4stuff["kombi"] = "wl4" -- make sure to change back to wl4 later.
kombiwhogetswl4stuff["tynker"] = "sms"
kombiwhogetswl4stuff["stryke"] = "wlsi"
kombiwhogetswl4stuff["trez"] = "wl4"
kombiwhogetswl4stuff["shayde"] = "smw"

if not kombimobjtransformations
	rawset(_G, "kombimobjtransformations", {})
end

local translist = kombimobjtransformations

translist[MT_SPINBOBERT] = TR_ZOMBIE
translist[MT_SPINBOBERT_FIRE1] = TR_ZOMBIE
translist[MT_SPINBOBERT_FIRE2] = TR_ZOMBIE
translist[MT_SMASHINGSPIKEBALL] = TR_FLAT
translist[MT_BUMBLEBORE] = TR_PUFFY

if not kombiSMWItems
	rawset(_G, "kombiSMWItems", {}) -- SMW-Styled Items
end

local interpolationFunction = ease.linear
local cycles = 2

kombiSMWItems["small"] = { -- state used for whenever we're small.
	reservesfx = sfx_null, -- the sfx_ constant to play when this item gets reserved. Defaults to sfx_mwresr.
	pickupsfx = sfx_mwhurt, -- the sfx_ constant to play when we pick this item up. Defaults to sfx_mwmush.
	priority = INT32_MIN, -- NEVER let small replace any of our current power-ups, unless we really want to force it (e.g. in our hit function). Defaults to 0.
	dieonhit = true, -- Die if we get hit in this power-up state. Defaults to false.
	reservable = false, -- If this power-up can be reserved. Defaults to true.
	forcespr2 = SPR2_GROW, -- the SPR2 to force the player into. Defaults to the last SPR2 the player was in.
	collectionanimatesplayer = true, -- Disables the frame part of the automatic freezing if set to true. Default is false.
	initcollectfunc = function(player, clock, oldpower) -- Called for the FIRST tic we get a power-up. Use this to do things such as setting important variables beforehand.
		player.mo.state = S_KOMBI_GROW
		player.mo.color = player.skincolor
	end,
	collectfunc = function(player, clock) -- Called when Shayde collects this item, clock being how many tics this has been running for. Return true in this function to release control back to the player!
		local progress = clock%(powerupinterval/cycles)
		local phase = (clock-1)/powerupinterval
		if clock < powerupinterval
			if progress >= powerupinterval / (cycles*2)
				player.mo.frame = B
			else
				player.mo.frame = C
			end
		else
			if progress >= powerupinterval / (cycles*2)
				player.mo.frame = B
			else
				player.mo.frame = A
			end
		end
		if clock == powerupinterval * 2 -- Ensures no animation weirdness happens due to flooring issues
			player.mo.state = S_PLAY_PAIN
			return true
		end
	end
}

kombiSMWItems["mushroom"] = {
	hudgraphic = "SMWMUSHROOM", -- All base HUD drawing systems use this to determine what the hell they're even drawing in the first place. Defaults to "NULLA0".
	priority = 1, -- Used to determine if we should replace our reserved item slot with this power-up. Higher replaces lower!
	collectionanimatesplayer = true,
	forcespr2 = SPR2_GROW,
	pickupsfx = sfx_mwmush,
	hudframes = 1, -- Animation frames for our HUD. Defaults to 1.
	objectsprite = SPR_KSMW, -- used for our associated MT_ object, refer to SRB2's documentation for how these are used! Defaults to SPR_KSMW.
	objectframe = A, -- used for our associated MT_ object, refer to SRB2's documentation for how these are used! Defaults to A.
	objectframes = 1, -- used for our associated MT_ object, refer to SRB2's documentation for how these are used! Defaults to 1.
	frametime = -1, -- used for our associated MT_ object, refer to SRB2's documentation for how these are used! Defaults to -1.
	movement = "slide", -- Movement type for this object, this one makes it always move forwards and immediately change direction when it hits a wall. Defaults to "stationary".
	initcollectfunc = function(player, clock, oldpower)
		player.previousstate = player.mo.state
		player.mo.state = S_KOMBI_GROW
	end,
	collectaniminpost = true, -- If true, collectfunc ONLY runs in a PostThink frame. Only use this if you're desperate to make something work. Default false.
	collectfunc = function(player, clock)
		local progress = clock%(powerupinterval/cycles)
		local phase = (clock-1)/powerupinterval
		if clock < powerupinterval
			if progress >= powerupinterval / (cycles*2)
				player.mo.frame = B
			else
				player.mo.frame = A
			end
		else
			if progress >= powerupinterval / (cycles*2)
				player.mo.frame = B
			else
				player.mo.frame = C
			end
		end
		if clock == powerupinterval * 2 -- Ensures no animation weirdness happens due to flooring issues
			player.mo.state = player.previousstate
			return true
		end
	end
}

kombiSMWItems["fireflower"] = {
	hudgraphic = "SMWFIREFLOWER1",
	priority = 2,
	pickupsfx = sfx_mwmush,
	usesfx = sfx_mwthrw, -- SFX to play when Shayde presses CUSTOM 2 with this power-up. Defaults to sfx_null.
	hudframes = 1,
	objectsprite = SPR_KSMW,
	objectframe = B,
	objectframes = 2,
	frametime = 18,
	movement = "stationary", -- stay there and think about what you've done
	prefcolor = SKINCOLOR_KOMBI_FIREFLOWER, -- The preferred color to switch back to after doing color-modifying effects, like with the color changing when we're invincible. Default is the player's skincolor variable.
	allowfirebutton = true, -- allows the power-up to be used with the Fire button.
	initcollectfunc = function(player, clock, oldpower)
		local index = ((clock/3)%#fireflowermap)+1
		player.mo.color = fireflowermap[index]
	end,
	collectfunc = function(player, clock)
		if clock == powerupinterval*2
			player.mo.color = SKINCOLOR_KOMBI_FIREFLOWER
			return true
		else
			local index = ((clock/3)%#fireflowermap)+1
			player.mo.color = fireflowermap[index]
		end
	end,
	usefunc = function(player) -- Called when Shayde presses CUSTOM 2 while he has this power-up.
		if player.weapondelay return end
		local mo = P_SpawnPlayerMissile(player.mo, MT_FIREBALL, 0)
		if mo
			P_InstaThrust(mo, player.mo.angle, ((mo.info.speed>>FRACBITS)*player.mo.scale) + player.speed)
			S_StartSound(player.mo, sfx_mario7)
		end
		player.weapondelay = TICRATE/3
	end,
	spinjumpfunc = function(player) -- Called when Shayde attempts to spinjump (CUSTOM 3) with this.
	end
}

kombiSMWItems["capefeather"] = {
	hudgraphic = "SMWCAPEFEATHER", 
	priority = 2,
	pickupsfx = sfx_mwfeth,
	hudframes = 1, 
	objectsprite = SPR_KSMW, 
	objectframe = D, 
	objectframes = 1, 
	frametime = -1,
	movement = "leaf", -- glide down into the pits of nothingness like a falling leaf in autumn
	initcollectfunc = function(player, clock, oldpower)
		player.mo.color = player.skincolor
	end,
	collectfunc = function(player, clock)
		if clock == TICRATE
			return true
		end
	end,
	usefunc = function(player)
	end,
	spinjumpfunc = function(player)
	end
}
/*
EXTRA FUNCTIONS THAT WE HAVE CODED, YET DON'T USE HERE:
activefunc -- Called every tic that we have this power-up.
duration -- How long this power-up will last for. Defaults to nil.
revertpowerup -- If we get hit (or if our duration value passes), this power-up is what we'll revert to. Default (only if both duration was set and said duration is the cause of our downgrade) is "mushroom".
canbereserved -- Determines if we can reserve this item. Default is true.
reservetransform -- What Power-Up this should get set to instead, if it just so happens that we already have this Power-Up or one that is of higher priority. Useful if you want to stomp out cheesing potential. Nothing is done if unset.
smbrules -- If you have to get a lower-priority item first, before you're allowed to take this one. Does not take into account if there's no item one priority value lower than yours. Defaults to false.
*/

SafeFreeSlot("sfx_kclear","sfx_kbossw","sfx_scaptr",
"MT_SAEXPL","MT_KOMBIMACANDCHEESE",
"SPR_SAEX","SPR_WARIOLANDWHEEL","SPR_MACNCHEESE", -- SAEX spawner is in WL4HP because i don't think i'd wanna write more hooks (proceeds to do it anyway)
"S_KOMBIMAC",
"SKINCOLOR_SUPER_COBALT1", "SKINCOLOR_SUPER_COBALT2", "SKINCOLOR_SUPER_COBALT3", "SKINCOLOR_SUPER_COBALT4", "SKINCOLOR_SUPER_COBALT5",
"SKINCOLOR_COBALTSUPER",
"SKINCOLOR_KOMBIAKAI","SKINCOLOR_KOMBIBLACKSMITH",
"sfx_kmland",
"sfx_waow0","sfx_waow1","sfx_waow2","sfx_waow3","sfx_waow4","sfx_waow5","sfx_waow6","sfx_waow7","sfx_waow8","sfx_waow9","sfx_waow10",
"sfx_waow11","sfx_waow12","sfx_waow13","sfx_waow14","sfx_waow15","sfx_waow16","sfx_waow17","sfx_waow18","sfx_kmcbad","sfx_kcgood","sfx_kcbest",
-- Idle voice lines
"sfx_sidmr2",
"sfx_sidmr1",
"sfx_sidtp0",
"sfx_sidss2",
"sfx_sidss1",
"sfx_sidss3",
"sfx_sidss4",
"sfx_sidss5",
"sfx_sidfe1",
"sfx_sidfe2",
"sfx_sidlw1",
"sfx_sidlw2",
"sfx_sidsd3",
"sfx_sidsd2",
"sfx_sidsd1",
"sfx_sidrm1",
"sfx_sidrm2",
"sfx_sidsh3",
"sfx_sidsh2",
"sfx_sidsh1",
"sfx_sidtp2",
"sfx_sidtp1",
"sfx_sidic3",
"sfx_sidic2",
"sfx_sidic1",
"sfx_sidco2",
"sfx_sidco1",
"sfx_sidwv3",
"sfx_sidwv2",
"sfx_sidwv1",
"sfx_sidec2",
"sfx_sidec1",
"sfx_sidgen",
"sfx_sidsup",
"sfx_sidbo4",
"sfx_sidbo3",
"sfx_sidun4",
"sfx_sidun3",
"sfx_sidun2",
"sfx_sidun1",
"sfx_sidbo2",
"sfx_sidbo1",
"sfx_sidcg1",
"sfx_sidcg2",
"sfx_sidcg3",
"sfx_sidsh0",
"sfx_sideg2",
"sfx_sideg1",
"sfx_sidtik",
"sfx_sideg0",
"sfx_sidmr3",
"SKINCOLOR_KOMBI_CUSTOM_LIFEWHITE",
"SKINCOLOR_KOMBI_CUSTOM_LIFERED",
"SKINCOLOR_KOMBI_CUSTOM_LIFES1CD",
"SKINCOLOR_KOMBI_CUSTOM_LIFES3",
"SKINCOLOR_KOMBI_CUSTOM_SPINBALLDISP1",
"sfx_hldeny",
"S_KOMBITRICK")
sfxinfo[sfx_sidmr2].caption = "Angel Island, huh?"
sfxinfo[sfx_sidmr1].caption = "Must be lonely here..."
sfxinfo[sfx_sidtp0].caption = "Not a fan of places like this..."
sfxinfo[sfx_sidss2].caption = "No time to rest!"
sfxinfo[sfx_sidss1].caption = "The station's the city center!"
sfxinfo[sfx_sidss3].caption = "I feel like a rat!"
sfxinfo[sfx_sidss4].caption = "No time to play!"
sfxinfo[sfx_sidss5].caption = "This place changed a lot!"
sfxinfo[sfx_sidfe1].caption = "Where does this end?"
sfxinfo[sfx_sidfe2].caption = "Wait, Robotnik!"
sfxinfo[sfx_sidlw1].caption = "It's so quiet here..."
sfxinfo[sfx_sidlw2].caption = "Where am I?"
sfxinfo[sfx_sidsd3].caption = "What's with this ship?"
sfxinfo[sfx_sidsd2].caption = "I hate this wind!"
sfxinfo[sfx_sidsd1].caption = "AAH! Don't fall!"
sfxinfo[sfx_sidrm2].caption = "That lava's hot!"
sfxinfo[sfx_sidrm1].caption = "Where'd the Egg Carrier go?"
sfxinfo[sfx_sidsh3].caption = "The cars barely move!"
sfxinfo[sfx_sidsh2].caption = "No time to relax!"
sfxinfo[sfx_sidsh1].caption = "Super sonic speed!"
sfxinfo[sfx_sidtp2].caption = "Looks deserted."
sfxinfo[sfx_sidtp1].caption = "Bumper car area entrance."
sfxinfo[sfx_sidic3].caption = "Watch and learn!"
sfxinfo[sfx_sidic2].caption = "Everything's frozen!"
sfxinfo[sfx_sidic1].caption = "It's cold!"
sfxinfo[sfx_sidco2].caption = "What's that smell? Trash?"
sfxinfo[sfx_sidco1].caption = "Pinball!"
sfxinfo[sfx_sidwv3].caption = "It's so high up!"
sfxinfo[sfx_sidwv2].caption = "I better get out of here!"
sfxinfo[sfx_sidwv1].caption = "I hear wind!"
sfxinfo[sfx_sidec2].caption = "Nice breeze!"
sfxinfo[sfx_sidec1].caption = "Just cruising!"
sfxinfo[sfx_sidgen].caption = "Better get moving!"
sfxinfo[sfx_sidsup].caption = "Chaos Emeralds power!"
sfxinfo[sfx_sidbo4].caption = "Now it's MY turn!"
sfxinfo[sfx_sidbo3].caption = "Where's his weak spot?"
sfxinfo[sfx_sidun4].caption = "I smell oil!"
sfxinfo[sfx_sidun3].caption = "That's his core!"
sfxinfo[sfx_sidun2].caption = "Not bad!"
sfxinfo[sfx_sidun1].caption = "Not getting away this time!"
sfxinfo[sfx_sidbo2].caption = "You're no match!"
sfxinfo[sfx_sidbo1].caption = "He can't be invincible!"
sfxinfo[sfx_sidcg1].caption = "No fighting!"
sfxinfo[sfx_sidcg2].caption = "Been good, guys?"
sfxinfo[sfx_sidcg3].caption = "Such a peaceful place!"
sfxinfo[sfx_sidsh0].caption = "Got sand in my eye!"
sfxinfo[sfx_sideg2].caption = "This ship is too weird!"
sfxinfo[sfx_sideg1].caption = "This ship's too much!"
sfxinfo[sfx_sidtik].caption = "That's bad!"
sfxinfo[sfx_sideg0].caption = "Robotnik's base!"
sfxinfo[sfx_sidmr3].caption = "Now this is more like it!"
-- Divisor lmao
sfxinfo[sfx_kclear].caption = "Yes!"
sfxinfo[sfx_kbossw].caption = "I'll play with you later!"
sfxinfo[sfx_scaptr].caption = 'Hey; let go!'
sfxinfo[sfx_waow0].caption = "Ya-hooooo!"
sfxinfo[sfx_waow1].caption = "Yahooo!"
sfxinfo[sfx_waow2].caption = "Ya-hoooo!"
sfxinfo[sfx_waow3].caption = "Ya-hoo!"
sfxinfo[sfx_waow4].caption = "Yahoo!"
sfxinfo[sfx_waow5].caption = "Hey, go!"
sfxinfo[sfx_waow6].caption = "Wow!"
sfxinfo[sfx_waow7].caption = "Wohhw!"
sfxinfo[sfx_waow8].caption = "Wow!"
sfxinfo[sfx_waow9].caption = "Ha, ha ha ha ha ha!"
sfxinfo[sfx_waow10].caption = "Hee, hee hee hee hee hee!"
sfxinfo[sfx_waow11].caption = "Ha ha- haa!!"
sfxinfo[sfx_waow12].caption = "Ha, ha ha ha ha!!"
sfxinfo[sfx_waow13].caption = "E-E-E-EXCLELLENT-E!"
sfxinfo[sfx_waow14].caption = "Excellent-e!"
sfxinfo[sfx_waow15].caption = "Excellent-e!"
sfxinfo[sfx_waow16].caption = "Alright!"
sfxinfo[sfx_waow17].caption = "Alright!"
sfxinfo[sfx_waow18].caption = "Wah!"
sfxinfo[sfx_hldeny].caption = "\135Can't Use\x80" -- for SOME reason using the usual hex for this caption turns it cyan and eats the first two proper letters
end

local transtunes = {
	[TR_ZOMBIE] = "wl3zmb",
	[TR_FIRE] = "wl3fir",
	[TR_FLAT] = "wl3fla"
}

rawset(_G, "K_SetWLTransformation", function(target,trans) -- environmental effects and their consequences
	if target and trans and not target.transformation
		S_StartSound(target, sfx_wltran)
		local newform = kombi.RunHook("PlayerWLTrans", target, trans) or trans
		target.transformation = newform
		S_ChangeMusic(transtunes[trans], true, player)
		return true
	end
end)

rawset(_G, "K_ResetWLTransformation", function(target) -- okay u're good to go naow
	local tunecheck = transtunes[target.transformation]
	if target
		local newform = kombi.RunHook("PlayerWLTrans", target, "reset")
		target.transformation = newform
		target.color = skins[target.skin].prefcolor
		target.player.normalspeed = skins[target.skin].normalspeed
		target.player.kombispeedcap = false
		if not kombiallowsquashnstretch[target.player.mo.skin]
			target.player.realmo.spriteyscale = FRACUNIT
			target.player.realmo.spritexscale = FRACUNIT
		end
		COM_BufInsertText(target.player, "tunes -default")
	end
end)

rawset(_G, "kombidrawwl4font", function(v,text,x,y,flags) -- peakio land 4 font
	local dotext = text
	local xpos = x
	local ypos = y
	local textflags = flags or 0
	for i = 1,#dotext do
		local dothis = dotext:byte(i,i);
		v.draw(xpos, ypos, v.cachePatch("WL4FONT\$dothis\"), textflags)
		xpos = $+8
	end
end)

local oppositefaces = {
	--awake to asleep
	["JOHNBLK1"] = "JOHNBLK0",
	--asleep to awake
	["JOHNBLK0"] = "JOHNBLK1",
}

rawset(_G, "K_SwapKeroBlocks", function()
	for sec in sectors.iterate do
		for rover in sec.ffloors() do
			if not rover.valid continue end
			local side = rover.master.frontside
			if not (side.midtexture == R_TextureNumForName("JOHNBLK1")
			or side.midtexture == R_TextureNumForName("JOHNBLK0"))
				continue
			end
			local oppositeface = oppositefaces[
				string.sub(R_TextureNameForNum(side.midtexture),1,8)
			]
			if oppositeface == nil continue end
			
			if rover.flags & FOF_SOLID
				rover.flags = $|FOF_NOSHADE&~(FOF_SOLID)
				rover.alpha = 255
			else
				rover.flags = $|FOF_SOLID&~(FOF_NOSHADE)
				rover.alpha = 255
			end
			side.midtexture = R_TextureNumForName(oppositeface)
		end
	end
end)

rawset(_G, "kombiDrawSMWFont", function(v,text,x,y,flags,colormap) -- super midio world font
	local dotext = tostring(text)
	local xpos = x
	local ypos = y
	local textflags = flags or 0
	local cmap = colormap or v.getColormap(nil, SKINCOLOR_WHITE)
	for i = 1,#dotext do
		local dothis = dotext:byte(i,i);
		v.draw(xpos, ypos, v.cachePatch("SMWHUDFONT\$dothis\"), textflags, cmap)
		xpos = $+8
	end
end)

local SMWAllowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?" -- everything i bothered to set up

rawset(_G, "kombiDrawSMWLifeFont", function(v, text, x, y, flags, colormap) -- the SMW font but unnecessarily italicized
	local dotext = tostring(text):upper():gsub(".", function(c)
		return SMWAllowedChars:find(c, 1, true) and c or "?"
	end)

	local xpos = x
	local ypos = y
	local textflags = flags or 0
	local cmap = colormap or v.getColormap(nil, SKINCOLOR_WHITE)

	for i = 1,#dotext do
		local dothis = dotext:byte(i,i)
		local thetext = v.cachePatch("SMWLIFEFONT\$dothis\")
		v.draw(xpos, ypos, thetext, textflags, cmap)
		xpos = xpos+thetext.width-1
	end
end)

rawset(_G, "kombiGetSMWLifeFontWidth", function(v,text) -- above but purely for getting the width
	local dotext = tostring(text):upper():gsub(".", function(c)
	return SMWAllowedChars:find(c, 1, true) and c or "?"
	end)
	local xpos = 0
	for i = 1,#dotext do
		local dothis = dotext:byte(i,i)
		local thetext = v.cachePatch("SMWLIFEFONT\$dothis\")
		xpos = xpos+thetext.width-1
	end
	return xpos
end)

rawset(_G, "kombiDrawSpinballFont", function(v,text,x,y,size,flags,colormap) -- peaknic spinball font
	local dotext = tostring(text):upper()
	local xpos = x
	local ypos = y
	local textflags = flags or 0
	local cmap = colormap or v.getColormap(nil, SKINCOLOR_GREEN)
	if size
		xpos = $*FRACUNIT
	end
	for i = 1,#dotext do
		local dothis = dotext:byte(i,i)
		local thetext = v.cachePatch("SPINBALL\$dothis\")
		if size
			v.drawScaled(xpos, ypos*FRACUNIT, size, thetext, textflags, colormap)
			xpos = $+FixedMul(thetext.width*FRACUNIT, size)
		else
			v.draw(xpos, ypos, thetext, textflags, cmap)
			xpos = $+thetext.width
		end
	end
end)

rawset(_G, "K_GetPlayer", function(var) -- adapt to getting either the mobj_t of the player or the player_t itself
	if var and var.valid and var.mo
		return var -- Already a player_t
	end
	if var and var.valid and var.player
		return var.player -- Get player_t from mobj_t
	end
	-- What the hell?! We're not supposed to be down here! Stop the count and get us the hell outta this place!!
	local errortype = type(var) == "userdata" and userdataType(var) or type(var)
	error("Bad argument #1 to 'K_GetPlayer' (PLAYER_T* or MOBJ_T* with reference to a PLAYER_T* expected, got \$errortype\)", 2) -- Print an error to the console!! Let them know how badly they fucked up!!!
	-- this should return nil if we manage to hit the error() line. Hi, I'm IHTK, and welcome to questionable coding practices.
end)

rawset(_G, "K_PauseMomentum", function(player) -- stop the player
	if not player.paused
		player.oldvel = {x = player.mo.momx, y = player.mo.momy, z = player.mo.momz, angle = player.drawangle}
		player.mo.momx = 0
		player.mo.momy = 0
		player.mo.momz = 0
		player.paused = true
		player.freezeframe = player.mo.frame
		player.freezesprite2 = player.mo.sprite2
	end
end)

rawset(_G, "K_ResumeMomentum", function(player) -- stopn't the player
	if player.paused
		if player.oldvel
			player.mo.momx = player.oldvel.x
			player.mo.momy = player.oldvel.y
			player.mo.momz = player.oldvel.z
		end
		player.paused = false
	end
end)

rawset(_G, "K_PowerUpValidityChecks", function(newpower) -- checks to make the below work fine
	if not newpower
		return
	end
	local powerupconvars = kombiSMWItems[newpower]
	if not powerupconvars
		local errortype = type(var) == "userdata" and userdataType(var) or (type(var) == "string" and var) or type(var)
		error("Bad argument #1 to 'K_SetPowerUp' (valid POWER_T* expected, got \$errortype\)", 2) -- please don't give us something we don't even know anything about
		return
	else
		return powerupconvars
	end
end)

rawset(_G, "K_UpdateReserveItem", function(victim,currentItem) -- set reserve item, includes checks to make sure we don't replace anything better
	local powerup = kombi.RunHook("PlayerItemReserve", target, currentItem) or currentItem
	if not powerup return end
	local player = K_GetPlayer(victim)
	if not player
		return
	end
	local selectedItemData = K_PowerUpValidityChecks(powerup)
	if not selectedItemData
		error("Unexpected circumstance in 'K_UpdateReserveItem' (Item \$powerup\ does not exist!)", 2)
		return
	end
	if not selectedItemData.priority
		error("Unexpected circumstance in 'K_UpdateReserveItem' (Item \$powerup\ lacks a priority argument!)", 2)
		return
	end
	local reserveItemData = K_PowerUpValidityChecks(player.kombismwreserveitem)
	local currentItemData = K_PowerUpValidityChecks(player.kombismwpowerupstate)
	if selectedItemData and selectedItemData.priority
		-- don't be mid and attempt to replace our item if we have a better one
		if selectedItemData.priority >= currentItemData.priority and not (currentItemData.reservable == false)
			player.kombismwreserveitem = powerup
			if selectedItemData.reservesfx != nil
				S_StartSound(player.mo, selectedItemData.reservesfx)
			else
				S_StartSound(player.mo, sfx_mwresr)
			end
		end
	end
end)

rawset(_G, "K_SetPowerUp", function(victim, newpower) -- set current item, regardless of what our old item was
	local powerup = kombi.RunHook("PlayerItemGet", target, currentItem, true) or newpower
	local powerupconvars = K_PowerUpValidityChecks(powerup) -- TODO: Fire Flower to Cape Feather doesn't reserve the Fire Flower... Wonder why? Super Mushroom to Fire Flower works fine...
	if not powerupconvars return end
	local player = K_GetPlayer(victim)
	if not player return end
	local oldpower = player.kombismwpowerupstate
	if not oldpower
		error("Unexpected circumstance in 'K_SetPowerUp' (Player's previous power does not exist!)", 2)
		return
	end
	player.kombismwpowerupstate = powerup
	local pickupSound = powerupconvars.pickupsfx != nil and powerupconvars.pickupsfx or sfx_mwmush
	S_StartSound(player.mo, pickupSound)
	K_PauseMomentum(player)
	player.kombiclock = 0
	if powerupconvars.initcollectfunc
		powerupconvars.initcollectfunc(player, player.kombiclock, oldpower) -- (player, animclock, prevpower)
	elseif powerupconvars.collectfunc
		powerupconvars.collectfunc(player, player.kombiclock, oldpower)
	end
	player.incollectanim = true
end)

rawset(_G, "K_PushPowerUp", function(victim, newpower) -- set current item only if it's of better status
	local powerup = kombi.RunHook("PlayerItemGet", target, currentItem, false) or newpower
	local powerupconvars = K_PowerUpValidityChecks(powerup)
	if not powerupconvars return end
	local player = K_GetPlayer(victim)
	if not player return end
	local currentPower = player.kombismwpowerupstate
	local currentPowerConvars = kombiSMWItems[currentPower]
	local powerupconvars = kombiSMWItems[powerup]
	if not powerupconvars
		error("Bad argument #1 to 'K_PushPowerUp' (valid POWER_T* expected, got \$tostring(powerup)\)", 2) -- please don't give us something we don't even know anything about
		return
	end
	if powerup ~= currentPower and 
	(not currentPowerConvars or powerupconvars.priority >= currentPowerConvars.priority)
		K_UpdateReserveItem(player, currentPower)
		K_SetPowerUp(victim, powerup)
	elseif currentPowerConvars and powerupconvars.priority <= currentPowerConvars.priority or powerup == currentPower
		K_UpdateReserveItem(player, powerup)
	end
end)

rawset(_G, "kombidrawlifefont", function(v,text,x,y,size,lifetype,flags) -- Draw Genesis-like life font
	local dotext = text
	local xpos = x or 0
	local ypos = y or 0
	local lifetypes =
	{
	["0"] = 0,
	["white"] = 0,
	["none"] = 0,
	["1"] = 1,
	["s1"] = 1,
	["sonic 1"] = 1,
	["sonic the hedgehog 1"] = 1,
	["scd"] = 1,
	["sonic cd"] = 1,
	["sonic the hedgehog cd"] = 2,
	["2"] = 2,
	["s3"] = 2,
	["sonic 3"] = 2,
	["sonic the hedgehog 3"] = 2,
	["s3k"] = 2,
	["sonic 3 & knuckles"] = 2,
	["sonic 3 and knuckles"] = 2,
	}
	local colormap
	if type(lifetype) == "userdata" and userdataType(lifetype) == "colormap"
		colormap = lifetype
	else
		colormap = v.getColormap(nil, SKINCOLOR_KOMBI_CUSTOM_LIFEWHITE+lifetypes[string.lower(tostring(lifetype or 0))])
	end
	local textflags = flags or 0
	if size
		xpos = $*FRACUNIT
		for i = 1,tostring(dotext):len() do
			local dothis = dotext:byte(i,i)
			local thetext = v.cachePatch("KMBILIVES\$dothis\")
			v.drawScaled(xpos, ypos*FRACUNIT, size, thetext, textflags, colormap)
			xpos = $+FixedMul(thetext.width*FRACUNIT,size)
		end
	else
		for i = 1,tostring(dotext):len() do
			local dothis = dotext:byte(i,i)
			local thetext = v.cachePatch("KMBILIVES\$dothis\")
			v.draw(xpos, ypos, thetext, textflags, colormap)
			xpos = $+thetext.width
		end
	end
end)

rawset(_G, "kombigetlifefontwidth", function(v,text) -- above, but purely for font width
	local dotext = text
	local xpos = 0
	for i = 1,tostring(dotext):len() do
		local dothis = dotext:byte(i,i)
		local thetext = v.cachePatch("KMBILIVES\$dothis\")
		xpos = $+thetext.width
	end
	return xpos
end)