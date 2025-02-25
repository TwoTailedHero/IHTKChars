local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
SafeFreeSlot("sfx_wl4sba", "sfx_wlskid", "sfx_wlsbwa", "sfx_wlatta") // SFX freeslot assignment likely requires we freeslot before assigning
sfxinfo[sfx_wl4sba].caption = 'Shoulder Bash'
sfxinfo[sfx_wlskid].caption = 'Skidding'
sfxinfo[sfx_wlsbwa].caption = 'Hit Wall'
sfxinfo[sfx_wlatta].caption = 'Hit Enemy'

sfxinfo[sfx_wlatta] = {
        singular = false,
        priority = 1,
        flags = SF_X2AWAYSOUND
}

sfxinfo[sfx_wlsbwa] = {
        singular = false,
        priority = 1,
        flags = SF_X2AWAYSOUND
}

-- This takes a list of arguments that SHOULD be formatted like {sound, caption}
-- ofc you can just call this a bunch of times to get lots of uncaptioned sound effects, but why would you do that?
local function FreeSlotAndCaption(...)
    local args = {...}
    for i = 1, #args, 2 do
        local slotName = args[i]
        local caption = args[i + 1]
        if not _G[slotName] then
            local slotID = freeslot(slotName) -- thank GOD this returns the thing we freeslotted
            if caption then
                sfxinfo[slotID].caption = caption
            end
        end
    end
end

local didthing = false

FreeSlotAndCaption(
    "sfx_snowch", '\133Aww; geesh..!\x80',
    "sfx_lspdwa", "bonk.mp3"
)

/// Ability: Punch
// allows you to do a thrusting melee attack

// CUSTOMIZE SECTION START
local skin = "kombi" // your character here
rawset(_G, "kombiwhocanbash", { -- Characters who get to use the shoulder bash
	["kombi"] = BT_CUSTOM1,
	["trez"] = BT_SPIN,
})
local thebutton = BT_CUSTOM2 // the button needed to do the punch
local sound = sfx_wl4sba // the sound of the punch
local punchlenght = 55 // the lenght of the punch
local punchdelay = 10 // the delay of punching
local cooldownhud = false // if this is true, the cooldown will be shown in a heads up display
// CUSTOMIZE SECTION END PROCCED BELOW IF YOU KNOW WHAT YOUR DOING

freeslot("S_PLAY_KOMBISBASH","SPR2_BASH")
// can modifiy this for your own punch frames if you want

states[S_PLAY_KOMBISBASH] = {
	sprite = SPR_PLAY,
	frame = A|SPR2_BASH|FF_ANIMATE,
	tics = punchlenght,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_KOMBISBASH
}
spr2defaults[SPR2_BASH] = SPR2_DASH

addHook("PlayerThink", function(player)
	if not player.mo return end
	if not player.punchwait
		player.punchwait = 0
	end
	if not player.realmo.headbashing
		player.realmo.headbashing = 0
	end
	if player.realmo.skin == "trez"
		if (player.cmd.buttons & BT_CUSTOM1) and not player.realmo.punching
			player.realmo.punching = true
			player.realmo.headbashing = 1
			player.realmo.punchtime = 50
			player.speedinc = $ or FRACUNIT*12
		end
		if player.realmo.headbashing and (not (player.cmd.buttons & BT_CUSTOM1) or abs(player.realmo.momx) + abs(player.realmo.momy)*((player.realmo.eflags & MFE_UNDERWATER)>>2 or 1) < 3*player.normalspeed/4)
			player.realmo.punching = false
			player.realmo.headbashing = 0
			player.realmo.punchtime = 0
			player.speedinc = 0
			if not srb2p and kombiwhogetswl4stuff[player.mo.skin] and not player.mo.kombislopetimer
				player.powers[pw_strong] = 0
			end
		end
	end
	if player.punchwait
		player.punchwait = $ - 1
	end
	if not player.realmo.punching -- DON'T MODIFY S. BASH SPEED WHEN WE'RE IN ONE!!
		player.punchspeed = max(skins[player.realmo.skin].normalspeed*4/3,abs(player.realmo.momx) + abs(player.realmo.momy))
	end
	if player.realmo.punching == nil
		player.realmo.punching = false
	end
	if player.realmo.punchtime == nil
		player.realmo.punchtime = 0
	end
	if player.realmo.punchtime > 0
		player.realmo.punching = true
		if player.realmo.pause and player.realmo.pause <= 0
			player.realmo.punchtime = $ - 1
		end
		if not (player.realmo.headbashing) and (player.realmo.pause or -35) <= 0
			player.pflags = $|PF_STASIS
			if not player.realmo.state == S_PLAY_KOMBISBASH
				player.realmo.state = S_PLAY_KOMBISBASH
			end
			if (player.realmo.eflags & MFE_SPRUNG)
				player.realmo.punchangle = player.realmo.angle
			else
				player.drawangle = player.realmo.punchangle
			end
			if not player.paused
				P_InstaThrust(player.realmo, player.realmo.punchangle, 3*player.punchspeed/4)
			end
		elseif player.realmo.headbashing
			player.realmo.friction = 63815
			if (player.pflags&PF_STASIS)
				player.pflags = $&~PF_STASIS
			end
			if player.realmo.skin == "kombi"
				if abs(player.realmo.momx) + abs(player.realmo.momy)*((player.realmo.eflags & MFE_UNDERWATER)>>2 or 1) >= 3*player.normalspeed/4
					player.realmo.punchtime = 35
				end
			end
			if player.realmo.punchtime == 1
				player.realmo.punchtime = 0
				player.realmo.punching = false
				player.realmo.headbashing = 0
				if not srb2p and kombiwhogetswl4stuff[player.mo.skin] and not player.mo.kombislopetimer
					player.powers[pw_strong] = 0
				end
			end
		end
		if not srb2p and not player.mo.kombislopetimer 
			if not player.realmo.headbashing
				player.powers[pw_strong] = STR_BUST|STR_SPIKE|STR_PUNCH|STR_ANIM
			else
				player.powers[pw_strong] = STR_PUNCH|STR_ANIM
			end
		end
		if player.realmo.headbashing and leveltime%3 == 0
			local punchtrail = P_SpawnGhostMobj(player.realmo)
			punchtrail.colorized = true
			punchtrail.color = (leveltime/9%79)+31
			punchtrail.fuse = 9 
			punchtrail.blendmode = AST_ADD 
		end
	end
	if player.realmo.punchtime == 1
		if not srb2p and kombiwhogetswl4stuff[player.mo.skin] and not player.mo.kombislopetimer 
			player.powers[pw_strong] = 0
		end
		player.realmo.punching = false
		player.nospindash = false
		player.realmo.headbashing = 0
		player.pflags = $1 & ~PF_FULLSTASIS
		player.punchwait = punchdelay
	end
	if player.realmo and kombiwhocanbash[player.realmo.skin]
	and P_PlayerInPain(player)
	or P_CheckDeathPitCollide(player.realmo)
	or not (player.playerstate == PST_LIVE)
	and player.realmo.punching == true
		if not srb2p and kombiwhogetswl4stuff[player.mo.skin] and not player.mo.kombislopetimer 
			player.powers[pw_strong] = 0
		end
		player.pflags = $&~PF_FULLSTASIS
		player.realmo.punching = false
		player.nospindash = false
		player.realmo.headbashing = 0
		player.realmo.punchtime = 0
	end
	if player.realmo.state == S_PLAY_KOMBISBASH
	and player.realmo.punchtime == 0
		player.realmo.punching = false
		player.nospindash = false
		player.realmo.headbashing = 0
		player.realmo.state = S_PLAY_RUN
		if not srb2p and kombiwhogetswl4stuff[player.mo.skin] and not player.mo.kombislopetimer
			player.powers[pw_strong] = 0
		end
	end
	if player.realmo and kombiwhocanbash[player.realmo.skin]
	and (player.cmd.buttons & kombiwhocanbash[player.realmo.skin])
	and P_IsObjectOnGround(player.realmo)
	and player.realmo.punching == false
	and player.realmo.punchtime == 0
	and not player.powers[pw_carry] != CR_GRINDRAIL
	and not player.punchwait
		player.drawangle = player.realmo.angle
		player.realmo.punchangle = player.drawangle
		S_StartSound(player.realmo, sound)
		player.realmo.punchtime = punchlenght
		player.realmo.state = S_PLAY_KOMBISBASH
	elseif player.realmo and kombiwhocanbash[player.realmo.skin]
	and (player.cmd.buttons & kombiwhocanbash[player.realmo.skin])
	and (player.realmo.punchtime < (punchlenght - 10) and not player.realmo.headbashing)
	and player.realmo.punching
	and player.powers[pw_carry] != CR_GRINDRAIL
	and not player.punchwait
	and player.realmo.skin == "kombi" -- Only Kombi can use the move this way! hard-coded so that meddling chumps like you can't just place an entry in a table and it suddenly works
		player.realmo.headbashing = 1
		player.speedinc = FRACUNIT*24
		player.punchwait = 6
	end
end)

addHook("MobjDamage", function(target, inf, src, dmg, dmgType)
	if inf == nil or inf.player == nil then return end
	if inf.punching and target.flags & MF_ENEMY
		S_StartSound(inf, sfx_wlatta)
	end
end)

addHook("MobjMoveBlocked", function(target, mobj, line)
	if target.transformation == 1 and not target.firedelay
		if line target.fireangle = line.angle - ANGLE_90 else target.fireangle = $ + 180 end
		if not target.turns
			target.turns = 1
		else
			target.turns = $ + 1
		end
	end
	if line and not mobj and ((target.punching and target.skin == "trez") or (target.kombislopetimer and target.kombislopetimer >= 10)) or (target.player and target.player.lightdash)
		if target.player.lightdash
			target.state = S_PLAY_PAIN
			P_SetObjectMomZ(target, 8*FRACUNIT, false)
			P_InstaThrust(target, target.player.drawangle, -10*FRACUNIT)
			target.player.lightspeeddashable = 0
			target.player.lightdash = 0
			S_StartSound(nil, sfx_lspdwa, target.player)
			S_StartSound(target, sfx_snowch)
			return
		end
		if target.kombislopetimer
			target.kombislopetimer = 0
			target.state = S_PLAY_PAIN
			P_SetObjectMomZ(target, 8*FRACUNIT, false)
			P_InstaThrust(target, target.player.drawangle, -10*FRACUNIT)
		else
			P_SetObjectMomZ(target, 4*FRACUNIT, false)
			P_InstaThrust(target, target.player.drawangle, -10*FRACUNIT)
		end
		target.punching = false
		target.headbashing = 0
		target.punchtime = 0
		target.player.speedinc = 0
		if target.player.lightspeeddashable
			S_StartSound(inf, sfx_wlsbwa)
		else
			S_StartSound(inf, sfx_wlsbwa)
		end
		if not srb2p and kombiwhogetswl4stuff[target.skin] and not target.kombislopetimer
			target.player.powers[pw_strong] = 0
		end
	end
end, MT_PLAYER)