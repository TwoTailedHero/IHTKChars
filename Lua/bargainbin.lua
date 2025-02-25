/*
AddMindscapeDialogSet(nil, {
    {"FA_SMUG", "Facciolo", "Ah, the rabbit. Tell me, have you come seeking the same oblivion that claimed your island?"},
    {"KO_HEHE", "Kombi", "Oblivion? No. Justice? Absolutely."},
    {"FA_SMUG", "Facciolo", "Justice... Such a mortal, fleeting concept. Why cling to it when I offer eternal significance?"},
    {"KO_GRRR", "Kombi", "Your 'eternity' can rot. Let's settle this."},
}, "kombi", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_ANGR", "Facciolo", "You insolent creature! Do you not see how insignificant you are?!"},
    {"KO_SMUG", "Kombi", "Yeah, well... insignificant doesn't mean helpless."},
}, "kombi", BOSS_PHASE1_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_SMUG", "Facciolo", "The genius Brayne himself. I was expecting you."},
    {"BR_NEUT", "Brayne", "Of course you were. My reputation precedes me."},
    {"FA_SMUG", "Facciolo", "And yet, your intellect will falter against my power."},
    {"BR_HEHE", "Brayne", "Your bravado is amusing. Let’s see if it’s justified."},
}, "brayne", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_ANGR", "Facciolo", "You dare challenge my supremacy?"},
    {"BR_ANGR", "Brayne", "Supremacy? I see only delusions of grandeur."},
}, "brayne", BOSS_PHASE1_TEXT)

AddMindscapeDialogSet(nil, {
	{"FA_SMUG", "Facciolo", "Stryke, huh? I’ve heard of you. A merciless fighter."},
	{"ST_SMUG", "Stryke", "Mercy doesn't exist in my world, Facciolo. Prepare yourself."},
	{"FA_SMUG", "Facciolo", "Such confidence. But you will fall just like the rest."},
	{"ST_DETR", "Stryke", "We'll see about that. I'll make sure you regret underestimating me."},
}, "stryle", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
	{"FA_ANGR", "Facciolo", "You think you can beat me? I am your end."},
	{"ST_DETR", "Stryke", "Then let’s get to it. I’m not backing down!"}, 
}, "stryle", BOSS_PHASE1_TEXT)

AddMindscapeDialogSet(nil, {
	{"FA_SMUG", "Facciolo", "And here we have the mind behind the madness. Tynker, correct?"},
	{"TY_SASS", "Tynker", "Wow, someone can read. Are you going to compliment my engineering next?"},
	{"FA_SMUG", "Facciolo", "Oh, I don’t need to. Your overconfidence already speaks volumes."},
	{"TY_GEAR", "Tynker", "Then let me make this clear. I'm not just brains. I'm here to take you down."},
	{"FA_SMUG", "Facciolo", "How quaint. Let us see if that resolve holds once I've broken your toys."},
}, "tynker", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
	{"FA_ANGR", "Facciolo", "Arrogant pest! I'll rip apart your little gadgets and leave you defenseless!"},
	{"TY_SASS", "Tynker", "Good luck keeping up with my upgrades."},
}, "tynker", BOSS_PHASE1_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_SMUG", "Facciolo", "Ah, the mirror’s shadow. Shyne, is it?"},
    {"SH_NEUT", "Shyne", "I’ll take that as a compliment. You’re about to regret it."},
    {"FA_SMUG", "Facciolo", "You assume much. A fatal flaw."},
    {"SH_NEUT", "Shyne", "We’ll see who’s left standing to call it fatal."},
}, "shyne", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_ANGR", "Facciolo", "I will break you, pretender!"},
    {"MK_GRRR", "Shyne", "Keep dreaming. I’ll shatter you first."},
}, "shyne", BOSS_PHASE1_TEXT)

AddMindscapeDialogSet(nil, {  
    {"FA_SMUG", "Facciolo", "A machine dares challenge me? You lack the soul for resistance."},  
    {"U7_COLD", "Unit-7", "A soul is unnecessary. Purpose is sufficient."},  
    {"FA_SMUG", "Facciolo", "Purpose will not save you from destruction."},  
    {"U7_CALM", "Unit-7", "Observation: Your overconfidence is irrational."},  
}, "unit7aegis", INTRO_TEXT)  

AddMindscapeDialogSet(nil, {  
    {"FA_ANGR", "Facciolo", "Prepare to be dismantled!"},  
    {"U7_DEFI", "Unit-7", "Countermeasure initiated."},  
}, "unit7aegis", BOSS_PHASE1_TEXT)  

AddMindscapeDialogSet(nil, {
    {"FA_SMUG", "Facciolo", "A shadow of Kombi, lingering in his wake."},
    {"SHD_NEUT", "Shayde", "A shadow stands where light falters."},
    {"FA_SMUG", "Facciolo", "Then you will be snuffed out in darkness."},
    {"SHD_DETR", "Shayde", "Not without a fight."},
}, "shayde", INTRO_TEXT)

AddMindscapeDialogSet(nil, {
    {"FA_ANGR", "Facciolo", "You cannot escape your nature!"},
    {"SHD_DETR", "Shayde", "I have already embraced it."},
}, "shayde", BOSS_PHASE1_TEXT)
*/	
/* ### BARGAIN BIN ### -- take whatever you want from this, I'm not even using these anyways!
if not ((player.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(player.mo)) and (player.cmd.buttons & BT_JUMP)
	player.kmbidropdash = ($ or 0)+1
else
	if (player.mo.eflags & MFE_JUSTHITFLOOR) and player.kmbidropdash and player.kmbidropdash >= 11 and player.kmbidropdasheligible
		player.pflags = $|PF_SPINNING
		player.realmo.state = S_PLAY_ROLL
		S_StartSound(player.realmo, sfx_zoom)
		P_InstaThrust(player.realmo, player.realmo.angle, min((player.speed/2)+18*FRACUNIT,72*FRACUNIT))
		player.kmbidropdasheligible = nil
	end
	player.kmbidropdash = nil
end
if (player.pflags & PF_JUMPED) and not (player.pflags & PF_STARTJUMP)
	player.kmbidropdasheligible = true
end


local teamnames = {
	["kombi"] = "Mirror Match",
	["stryke"] = "Brains & Brawn",
	["tynker"] = "Winds of Change",
	["trez"] = "Rich & Reckless",
	["sonic"] = "Speed Demons",
	["tails"] = "High Fliers",
	["knuckles"] = "Knuckleduster",
	["amy"] = "Heartbreaker",
	["fang"] = "Rogue Riders",
	["metalsonic"] = "Iron Will",
	["eggman"] = "Ironic Fate",
	["mario"] = "Jump Bros.",
	["luigi"] = "Jump Bros.",
	["smwmario"] = "Nintendo Power",
	["smwluigi"] = "Nintendo Power",
	["sgimario"] = "Nintendon't",
	["wario"] = "Treasure Tech",
	["bowser"] = "Shellshockers",
	["xsonic"] = "X Factor",
	["xtreme"] = "X-Treme Alliance",
	["adventuresonic"] = "Adventure Seekers",
	["cdsonic"] = "Sonic Boom",
	["s3sonic"] = "Lock-On League",
	["modernsonic"] = "Dreams Cast",
	["earlessreredo"] = "Final Demo",
	["tgfsonic"] = "Final Demo",
	["npeppino"] = "Pizza Party",
	["nthe_noise"] = "Trouble Makers",
}
addHook("PlayerThink", function(player)
	if not player.botleader return end
	local leader = player.botleader
	if leader.realmo.skin == "kombi"
		if player.realmo.skin == "kombi"
			player.realmo.color = SKINCOLOR_SILVER
			player.realmo.colorized = true
		elseif player.realmo.skin == "tails"
			leader.jumpfactor = 5*skins[player.realmo.skin].jumpfactor/4
		end
	end
end)
addHook("PlayerThink", function(player)
	if not player.mo return end
	if not player.botleader
		if player.realmo.color == SKINCOLOR_SILVER
			for otherplayer in players.iterate do
				if otherplayer.botleader == player player.realmo.color = player.currcolor end
			end
		end
		player.currcolor = player.realmo.color
	end
	player.kombiduo = nil
	for otherplayer in players.iterate do
		if otherplayer.botleader == player player.kombiduo = otherplayer.realmo.skin end
	end
	if not player.kombiduo
		player.jumpfactor = skins[player.realmo.skin].jumpfactor
	end
end)

hud.add(function(v,player)
	kombidrawwl4font(v,teamnames[player.kombiduo] or "Is this okay?",0,0)
end

if player.rushmode
    if player.cmd.buttons & BT_CUSTOM1 and player.kombiboost > 0
        player.kombiboost = $ - (100*FRACUNIT/128) -- Faster gauge drain in Rush Mode
        P_InstaThrust(player.mo, player.mo.angle, (skins[player.realmo.skin].normalspeed + player.speedinc) * 1.5) 
        player.kombiboosting = true
        player.speedinc = 32*FRACUNIT
        if not S_SoundPlaying(player.mo, sfx_lspdst)
            S_StartSound(player.realmo, sfx_lspdst)
        end
    else
        -- Gauge slowly recovers when not boosting
        player.kombiboost = $+100*FRACUNIT/1024
    end

    if player.kombiboost >= 3*100*FRACUNIT
        player.kombiboost = 0
        P_InstaThrust(player.mo, player.mo.angle, (skins[player.realmo.skin].normalspeed + player.speedinc) * 2)
        player.kombirushclock = 5 * TICRATE
    end

    if player.kombirushclock > 0
        player.kombirushclock = $-1
        if player.kombirushclock == 0
            player.kombiboosting = false
        end
    end
	
	if player.kombiboost == nil player.kombiboost = 100*FRACUNIT end
	
	if player.instad == nil
		player.instad = false
	end
	
	if player.slamstate > 0
		if (player.cmd.buttons & BT_SPIN) and not srb2p P_SetObjectMomZ(player.realmo, -1*FRACUNIT, true) end
	end
	
	if player.slamstate == 1 and player.realmo.momz <= 0
		player.slamstate = 2
		player.realmo.state = S_PLAY_SLAM
		if not srb2p
			player.powers[pw_strong] = STR_BOUNCE
		end
	end
	
	if player.slamstate > 0
		if player.kombigrounded
			player.slamstate = 0
			if (player.cmd.buttons & BT_JUMP) -- use our slam for what, exactly?
				if player.kombimode == 0 -- height?
					player.nospindash = false
					player.realmo.state = S_PLAY_ROLL
					player.pflags = $|PF_JUMPED&~PF_THOKKED
					P_SetObjectMomZ(player.realmo, 15*FRACUNIT, false)
					P_SmokeRing(player, 5, 0)
				else -- dropdashing?
					player.nospindash = false
					player.realmo.state = S_PLAY_ROLL
					player.pflags = $|PF_SPINNING
					P_Thrust(player.realmo, player.realmo.angle, 12*FRACUNIT)
					S_StartSound(player.realmo,sfx_zoom)
				end
			else -- offense?
				
			end
			S_StartSound(player.realmo,sfx_ptslam)
		end
	end
	if not player.switchwait
		player.switchwait = 0
	end
	if player.switchwait
		player.switchwait = $ - 1
	end
	if (player.cmd.buttons & BT_CUSTOM3) and not player.switchwait
		player.kombimode = ($+1)%2
		S_StartSound(player.realmo, sfx_kswtch)
		player.switchwait = 8
	end
	if player.kombiinpostboost and player.speed > skins[player.realmo.skin].normalspeed
		player.kombispeedcap = true
	else
		player.kombiinpostboost = false
		player.kombispeedcap = false
	end
	-- print(player.kombiboost/FRACUNIT, player.kombirushclock, player.speed/FRACUNIT, skins[player.realmo.skin].normalspeed/FRACUNIT, player.speed > skins[player.realmo.skin].normalspeed)
	local thrustang = player.cmd.angleturn<<16 + R_PointToAngle2(0, 0, player.cmd.forwardmove*FRACUNIT, -player.cmd.sidemove*FRACUNIT)
	-- maybe we can use player.cmd.angleturn<<16 + R_PointToAngle2(0, 0, player.cmd.forwardmove*FRACUNIT, -player.cmd.sidemove*FRACUNIT) for something? defo not boosting tho
	if player.rushmode
		if (player.cmd.buttons & BT_CUSTOM1)
			if player.kombiboost > 0 or player.kombirushclock or player.powers[pw_super]
				if not (player.kombirushclock or player.powers[pw_super])
					player.kombiboost = $ - (100*FRACUNIT/128)
				end
				if player.kombirushclock or player.powers[pw_sneakers] or player.powers[pw_super]
					P_InstaThrust(player.mo, thrustang, (skins[player.realmo.skin].normalspeed + player.speedinc)*3/2)
				else
					P_InstaThrust(player.mo, thrustang, (skins[player.realmo.skin].normalspeed + player.speedinc))
				end
				player.speedinc = 32*FRACUNIT
				if not player.kombiboosting
					S_StartSound(player.realmo, sfx_cdfm01)
					S_StartSound(player.realmo, sfx_lspdst)
				end
				if not S_SoundPlaying(player.mo, sfx_lspdst)
					S_StartSound(player.realmo, sfx_lspdlo)
				end
				player.kombiboosting = true
			else
				S_StopSoundByID(player.realmo, sfx_lspdst)
				S_StopSoundByID(player.realmo, sfx_lspdlo)
				if player.kombiboosting
					player.speedinc = 0
					player.kombiinpostboost = true -- this variable SHOULD go with the above code to cut your speed down to your regular running speed.
					player.kombiboosting = false
				end
			end
		else
			if player.kombiboost < 100*FRACUNIT
				player.kombiboost = $+100*FRACUNIT/1024
				if player.kombiboost > FRACUNIT*100 player.kombiboost = FRACUNIT*100 end -- checks to make sure we hit our target exactly
			else
				player.kombiboost = $-100*FRACUNIT/4096 -- decay pretty slowly so it isn't practically impossible to achieve Rush
				if player.kombiboost < FRACUNIT*100 player.kombiboost = FRACUNIT*100 end -- same as above comment.
			end
			S_StopSoundByID(player.realmo, sfx_lspdst)
			S_StopSoundByID(player.realmo, sfx_lspdlo)
			if player.kombiboosting
				player.speedinc = 0
				player.kombiinpostboost = true
				player.kombiboosting = false
			end
		end
		if player.kombiboost >= 300*FRACUNIT and not player.kombirushclock
			player.kombirushclock = 5*TICRATE
			S_StartSound(player.realmo, sfx_cdfm40)
		end
		if player.kombirushclock and not player.kombirushdecay
			player.kombirushclock = $ - 1
			if not player.kombirushclock
				S_StartSound(player.realmo, sfx_kc65)
				player.kombirushdecay = true
			end
		end
		if player.kombirushdecay
			if player.kombiboost <= 0
				player.kombirushdecay = nil
				player.kombiboost = 0
			else
				player.kombiboost = $ - 300*FRACUNIT/256
				if player.kombiboost <= 0
					player.kombirushdecay = nil
					player.kombiboost = 0
				end
			end
		end
	else
		if (player.cmd.buttons & BT_CUSTOM1) and player.kombiboost > 0 and not (player.powers[pw_carry]) and not player.kombishouldroll
			if not (player.mo.transformation == TR_ZOMBIE or player.mo.transformation == TR_ZOMBIEACTIVE)
				player.kombiboost = $ - (100*FRACUNIT/192)
				-- GS.railspeed = 60*FRACUNIT*GS_RAILS.GrindFlip(player.mo, GS.myrail, true)
				if player.powers[pw_sneakers] or player.powers[pw_super]
					P_InstaThrust(player.mo,thrustang,5*(skins[player.realmo.skin].normalspeed+player.speedinc)/3)
				else
					P_InstaThrust(player.mo,thrustang,(skins[player.realmo.skin].normalspeed+player.speedinc))
				end
				if not player.kombiboosting
					S_StartSound(player.realmo, sfx_cdfm01)
					S_StartSound(player.realmo, sfx_lspdst)
					player.kombiboosting = true
					player.speedinc = 24*FRACUNIT
				else
					if not S_SoundPlaying(player.mo, sfx_lspdst) and not S_SoundPlaying(player.mo, sfx_lspdlo)
						S_StartSound(player.realmo, sfx_lspdlo)
					end
					player.speedinc = $+FRACUNIT/12
				end
			end
		else
			if player.kombiboost > 100*((FRACUNIT/2)+FRACUNIT)
				player.kombiboost = $ - 100*FRACUNIT/256
			elseif player.kombiboost > 100*FRACUNIT
				player.kombiboost = $ - 100*FRACUNIT/512
				if player.kombiboost < FRACUNIT*100 player.kombiboost = FRACUNIT*100 end
			end
			if player.kombiboost < 0 player.kombiboost = 0 end
			if player.kombiboosting
				S_StopSoundByID(player.realmo, sfx_lspdst)
				S_StopSoundByID(player.realmo, sfx_lspdlo)
				player.speedinc = 0
				player.mo.momx = $/2
				player.mo.momy = $/2
				player.kombiboosting = false
			end
			if not (player.cmd.buttons & BT_CUSTOM1)
				player.kombiboost = $ + 100*FRACUNIT/8192
				if player.powers[pw_super]
					player.kombiboost = $+100*FRACUNIT/384
				end
				if player.dashmode > 3*TICRATE
					player.kombiboost = $+100*FRACUNIT/512
				end
			end
		end
	end
	if player.powers[pw_flashing] >= 105
		player.powers[pw_flashing] = $-1
	end
	
			if player.kombimode == 1 and not (player.pflags & PF_THOKKED) return end
			if (player.realmo.skin != "kombi") return end
			elseif player.realmo.state == S_PLAY_SPINJUMP
			player.nospindash = true
			player.slamstate = 1
			player.realmo.momx = $/2
			player.realmo.momy = $/2
			P_SetObjectMomZ(player.realmo, 5*FRACUNIT, false)
			player.realmo.state = S_PLAY_ROLL
			player.spinjumping = false
			if not player.powers[pw_super]
				player.charflags = $&~SF_SUPER
			end
			S_StartSound(player.realmo,sfx_ptstsl)
*/