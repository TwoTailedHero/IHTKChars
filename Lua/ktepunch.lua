/// Ability: Punch
// allows you to do a thrusting melee attack

// CUSTOMIZE SECTION START
local skin = "stryke" // your character here
local thebutton = BT_SPIN // the button needed to do the punch
local sound = sfx_s3k43 // the sound of the punch
local punchspeed = 24 // the speed that your thrusted at while punching
local punchlenght = 25 // the lenght of the punch
local hasdust = false // if this is true, you will spawn dust while punching
local hasghost = true // if this is true, you will have a after effect while punching
local hasthok = false  // if this true, you will have a thok effect while punching
local punchdelay = 6 // the delay of punching
local cooldownhud = false // if this is true, the cooldown will be shown in a heads up display
// CUSTOMIZE SECTION END PROCCED BELOW IF YOU KNOW WHAT YOUR DOING

freeslot("S_PLAY_PUNCH")
// can modifiy this for your own punch frames if you want
states[S_PLAY_PUNCH] = {
	sprite = SPR_PLAY,
	frame = SPR2_RUN|A,
	tics = punchlenght,
	var1 = S_PLAY_WALK,
	nextstate = S_PLAY_WALK
}

hud.add(function(v,player)
	if player.mo and player.mo.skin == skin and player.weapondelay and cooldownhud == true
		local xpos = hudinfo[HUD_LIVES].x
		local ypos = hudinfo[HUD_LIVES].y
		v.drawString(xpos, (ypos - 35), ("COOLDOWN:" + (player.weapondelay)), V_PERPLAYER|V_SNAPTOBOTTOM|V_SNAPTOLEFT)
	end
end)

addHook("PlayerThink", function(player)
	if not player.mo return end
	if player.mo.punchingkte == nil
		player.mo.punchingkte = false
	end
	if player.mo.ktepunchtime == nil
		player.mo.ktepunchtime = 0
	end
	if player.mo.ktepunchtime > 0
		player.pflags = $|PF_FULLSTASIS
		P_InstaThrust(player.mo, player.mo.angle, FRACUNIT*punchspeed)
		player.powers[pw_invulnerability] = TICRATE / 2
		player.mo.ktepunchtime = $ - 1
		if hasdust == true
			P_SpawnSkidDust(player, player.mo.radius, true)
		end
		if hasghost == true
			local punchtrail = P_SpawnGhostMobj(player.mo) 
			punchtrail.colorized = true
			punchtrail.color = player.mo.color
			punchtrail.fuse = 4 
			punchtrail.blendmode = AST_ADD 
		end
		if hasthok == true
			local thokeffect = P_SpawnThokMobj(player) 
		end
	end
	if player.mo.ktepunchtime == 1
		player.mo.punchingkte = false
		player.pflags = $1 & ~PF_FULLSTASIS
		player.weapondelay = punchdelay
	end
	if player.mo and player.mo.skin == skin
	and not P_IsObjectOnGround(player.mo)
	or P_PlayerInPain(player)
	or P_CheckDeathPitCollide(player.mo)
	or not (player.playerstate == PST_LIVE)
	and player.mo.punchingkte == true
		player.pflags = $1 & ~PF_FULLSTASIS
		player.mo.punchingkte = false
		player.mo.ktepunchtime = 0
	end
	if player.mo.state == S_PLAY_PUNCH
	and player.mo.ktepunchtime == 0
		player.mo.state = S_PLAY_WALK
	end
	if player.mo and player.mo.skin == skin
	and (player.cmd.buttons & thebutton)
	and P_IsObjectOnGround(player.mo)
	and player.mo.punchingkte == false
	and player.mo.ktepunchtime == 0
	and not player.weapondelay
		S_StartSound(player.mo, sound)
		player.mo.ktepunchtime = punchlenght
		player.mo.state = S_PLAY_PUNCH
	end
end)