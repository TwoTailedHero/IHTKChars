-- GSRail properties, built more to lean towards SA2. Copied and pasted? Who cares, it's allowed!
local RAIL = GS_RAILS -- do this to enable even more laziness, woohoo!
if GS_RAILS_SKINS==nil rawset(_G,"GS_RAILS_SKINS",{}) end
GS_RAILS_SKINS["kombi"] = {
	["S_SKIN"] = {
	JUMP = true, --You can jump off rails with the jump button!
	JUMPBOOST = true, --Gain a minor jumpboost when jumping off a rail? (Up to a certain limit.)
	AIRDRAG = 44, --Airdrag time in tics after hopping off a rail. (35 tics = 1 second)

	SIDEHOP = 44, --Specifies the speed of your sidehop speed. If 0, you can't sidehop at all!
	SIDEHOPARC = 0, --If not 0, adds a vertical arc when sidehopping, creating an "arced" sidehop like in modern games.
	SIDEFLIP = SPR2_SPNG, --Do a Modern-style sideflip? Specify a sprite here to use for it! (I recommend SPR2_SPNG for most chars)
	SIDEHOPTIME = 9, --How many tics your sidehop is considered active. If you have a slow sidehop, you probably want more time.

	EMERGENCYDROP = true, --If true, you can press CUSTOM3 to emergency-drop through rails.
	CROUCH = true, --If true, you can "crouch" by holding SPIN, gaining more favorable slope momentum at the cost of balance.
	CROUCHBUTTON = BT_SPIN, --Button to crouch with. If set to BT_SPIN|BT_CUSTOM1, it'd be either SPIN or CUSTOM1! 
	AUTOBALANCE = false, --You auto-balance on rails, losing less speed and making it near-impossible to fall off.
	SLOPEPHYSICS = true, --If false, slope physics are ignored.
	MUSTBALANCE = true, --The character must always balance as if crouching, risking falling off at all times like in SA2!

	SLOPEMULT = 10, --Percentage modifier of slope momentum. 10 would add 10% more, while -20 would reduce the effect by 20%.
	LAUNCHPOWER = 0, --Percentage modifier of vertical rail-flings. 10 would add 10% more height, while -20 would reduce it by 20%.
	STARTMODIFIER = 0, --Speed percentage modifier when attaching to rails. 10 would increase speed by 10%, while -20 decreases it 20%
	STARTSPEEDCONDITION = 0, --Minimum Speed you must be at before your start speed modifier takes place. If 0, defaults to 30.

	HEROESTWIST = 15, --The amount of speed the Heroes-Twist gives, diminishing with gained speed. If 0, you CAN'T twist at all!
	TWISTBUTTON = 0, --What button to press to perform the Heroes Twist. If 0, it mimicks the crouch button.
	ACCELSPEED = 0, --If not 0, you can forcibly accelerate on rails by simply holding forwards.
	ACCELCAP = 48, --This is the speed cap you can manually accelerate to, if you're capable. Defaults to 48.
	AUTODASHMODE = 72, --At what grinding speed you'll automatically enter dashmode. (only if you have SF_DASHMODE!)

	MINSPEED = 0, --Minimum speed your character always has when grinding. If not 0, your character can NEVER reverse!
	MAXSPEED = 180, --Your character won't gain more slopespeed than this. If 0, it's infinite.

	FORCESPRITE = nil, --Force a sprite2 when grinding, overriding both SPR2_GRND as well as the backup pose.
	FORCEHANGSPRITE = nil, --Force a sprite2 when on hangrails, rather than SPR2_RIDE
	WALLCLINGSPRITE = nil, --Use this sprite2 when readying for a walljump? Otherwise, picks sprite automatically.
	NOWINDLINES = false, --If true, doesn't spawn windlines when moving fast on rails.
	NOSIDEHOPGFX = 0, --If 1, only spawns sidehop ghosts. If 2, only spawns sidehop speedlines. If 3, spawns neither.
	NOFUNALLOWED = false, --If true, your character cannot use dunce poses with TOSS FLAG.
	TRICKS = 4, --Our own custom variable to let us cut down on total lists
	},
	["CustomJump"] = function(p, s, GS, rail, RAMPJUMP) -- now comes the part where i have to CODE. #SIGH...
	if RAMPJUMP == true
		p.kombirailgrindjump = true
		p.kombirgspeed = abs(GS.railspeed)
		print(GS.myrail.GSnextrail,GS.myrail.GSnextrail.valid,GS.myrail.GSnextrail.GSinvisiblerail)
		if not (GS.myrail.GSnextrail and GS.myrail.GSnextrail.valid) or GS.myrail.GSnextrail.GSinvisiblerail
			p.kmbilastrail = true
		end
	end
end,
	["GrindThinker"] = function(p, s, GS, rail)
	p.punchwait = 12
	if GS.perfectcorner
		p.kombiboost = $+(100*FRACUNIT/512)
	end
	if GS.railc1 and p.kombicandoshit and p.kombiboost > 0
		if not p.kombiboosting
			S_StartSound(s, sfx_cdfm01)
			S_StartSound(s, sfx_lspdst)
			p.kombiboosting = true
		end
		p.kombiboost = $ - (100*FRACUNIT/192)
		GS.railspeed = (60*FRACUNIT+(GS.railc1*FRACUNIT/12))*RAIL.GrindFlip(s, GS.myrail, true)
		if not S_SoundPlaying(s, sfx_lspdst) and not S_SoundPlaying(s, sfx_lspdlo)
			S_StartSound(s, sfx_lspdlo)
		end
	elseif p.kombiboosting
		GS.railspeed = $/2
		S_StopSoundByID(s, sfx_lspdst)
		S_StopSoundByID(s, sfx_lspdlo)
	end
	if GS.railc1 == 6488064
		p.kombicandoshit = true
	end
	if GS.railc2 == 1 -- do this ONLY at the start of a Custom 2 button press.
		if s.skin != "kombi" or p.kombiboost-(100*FRACUNIT/32) > 0
			p.kombiboost = $-(100*FRACUNIT/32)
			p.kombirgtrick = true
			p.kombic2trickheld = true -- do this to enable bringing up our cool bonus by even a little
			p.kombirgspeed = abs(GS.railspeed)
			p.kombinextrail = GS.myrail.GSnextrail
			GS_RAILS_SKINS[p.mo.skin]["S_SKIN"]["JUMPBOOST"] = false -- disable farming speed via this method
			if RAIL
				RAIL.ExitRail(s, true, "jump")
			end
			GS_RAILS_SKINS[p.mo.skin]["S_SKIN"]["JUMPBOOST"] = true
			P_SetObjectMomZ(s, 12*FRACUNIT) -- extend window for the trick
		else
			S_StartSound(s,sfx_hldeny)
		end
	end
end,
	["PreAttach"] = function(p, s, GS, rail)
		p.kombicandoshit = nil
		print(p.kombiboosting)
		GS.railc1 = 0
		p.punchwait = 12
		if p.kombirgtrick
			kombiGiveSA2Bonus(p,min((FixedInt((max(p.kombirgspeed-36*FRACUNIT,0))/34*10))+((p.didc2trick or 0)/3),10))
			p.kombic2trickheld = nil
			p.kombirgtrick = nil
			p.kombirgspeed = nil
			p.didc2trick = nil
		end
	end,
	["TwistDrive"] = function(p, s, GS, rail)
		if p.kombiboost-(100*FRACUNIT/16) > 0
			p.kombiboost = $-(100*FRACUNIT/16)
		else
			S_StartSound(s,sfx_hldeny)
			return true
		end
	end,
}

GS_RAILS_SKINS["kombifreeman"] = {
	["S_SKIN"] = {
	JUMP = true, --You can jump off rails with the jump button!
	JUMPBOOST = true, --Gain a minor jumpboost when jumping off a rail? (Up to a certain limit.)
	AIRDRAG = 44, --Airdrag time in tics after hopping off a rail. (35 tics = 1 second)

	SIDEHOP = 44, --Specifies the speed of your sidehop speed. If 0, you can't sidehop at all!
	SIDEHOPARC = 0, --If not 0, adds a vertical arc when sidehopping, creating an "arced" sidehop like in modern games.
	SIDEFLIP = nil, --Do a Modern-style sideflip? Specify a sprite here to use for it! (I recommend SPR2_SPNG for most chars)
	SIDEHOPTIME = 9, --How many tics your sidehop is considered active. If you have a slow sidehop, you probably want more time.

	EMERGENCYDROP = true, --If true, you can press CUSTOM3 to emergency-drop through rails.
	CROUCH = true, --If true, you can "crouch" by holding SPIN, gaining more favorable slope momentum at the cost of balance.
	CROUCHBUTTON = BT_SPIN, --Button to crouch with. If set to BT_SPIN|BT_CUSTOM1, it'd be either SPIN or CUSTOM1! 
	AUTOBALANCE = false, --You auto-balance on rails, losing less speed and making it near-impossible to fall off.
	SLOPEPHYSICS = true, --If false, slope physics are ignored.
	MUSTBALANCE = true, --The character must always balance as if crouching, risking falling off at all times like in SA2!

	SLOPEMULT = 0, --Percentage modifier of slope momentum. 10 would add 10% more, while -20 would reduce the effect by 20%.
	LAUNCHPOWER = 0, --Percentage modifier of vertical rail-flings. 10 would add 10% more height, while -20 would reduce it by 20%.
	STARTMODIFIER = 0, --Speed percentage modifier when attaching to rails. 10 would increase speed by 10%, while -20 decreases it 20%
	STARTSPEEDCONDITION = 0, --Minimum Speed you must be at before your start speed modifier takes place. If 0, defaults to 30.

	HEROESTWIST = 15, --The amount of speed the Heroes-Twist gives, diminishing with gained speed. If 0, you CAN'T twist at all!
	TWISTBUTTON = 0, --What button to press to perform the Heroes Twist. If 0, it mimicks the crouch button.
	ACCELSPEED = 0, --If not 0, you can forcibly accelerate on rails by simply holding forwards.
	ACCELCAP = 48, --This is the speed cap you can manually accelerate to, if you're capable. Defaults to 48.
	AUTODASHMODE = 72, --At what grinding speed you'll automatically enter dashmode. (only if you have SF_DASHMODE!)

	MINSPEED = 0, --Minimum speed your character always has when grinding. If not 0, your character can NEVER reverse!
	MAXSPEED = 180, --Your character won't gain more slopespeed than this. If 0, it's infinite.

	FORCESPRITE = nil, --Force a sprite2 when grinding, overriding both SPR2_GRND as well as the backup pose.
	FORCEHANGSPRITE = nil, --Force a sprite2 when on hangrails, rather than SPR2_RIDE
	WALLCLINGSPRITE = nil, --Use this sprite2 when readying for a walljump? Otherwise, picks sprite automatically.
	NOWINDLINES = false, --If true, doesn't spawn windlines when moving fast on rails.
	NOSIDEHOPGFX = 0, --If 1, only spawns sidehop ghosts. If 2, only spawns sidehop speedlines. If 3, spawns neither.
	NOFUNALLOWED = false, --If true, your character cannot use dunce poses with TOSS FLAG.
	TRICKS = 4, --Our own custom variable to let us cut down on total lists
	AUTOVERTICALAIM = false --Soon-to-be a way to let us shoot whatever enemy's flying past us
	},
	["CustomJump"] = function(p, s, GS, rail, RAMPJUMP)
	if RAMPJUMP == true
		p.kombirailgrindjump = true
		p.kombirgspeed = abs(GS.railspeed)
		print(GS.myrail.GSnextrail,GS.myrail.GSnextrail.valid,GS.myrail.GSnextrail.GSinvisiblerail)
		if not (GS.myrail.GSnextrail and GS.myrail.GSnextrail.valid) or GS.myrail.GSnextrail.GSinvisiblerail
			p.kmbilastrail = true
		end
	end
end,
	["GrindThinker"] = function(p, s, GS, rail)
	p.punchwait = 12
	if GS.perfectcorner
		p.kombiboost = $+(100*FRACUNIT/512)
	end
end,
	["PreAttach"] = function(p, s, GS, rail)
	p.punchwait = 12
	if p.kombirgtrick
		kombiGiveSA2Bonus(p,min((FixedInt((max(p.kombirgspeed-36*FRACUNIT,0))/34*10))+((p.didc2trick or 0)/3),10))
		p.kombic2trickheld = nil
		p.kombirgtrick = nil
		p.kombirgspeed = nil
		p.didc2trick = nil
	end
end,
}

GS_RAILS_SKINS["shayde"] = {
	["S_SKIN"] = {
	JUMP = true, --You can jump off rails with the jump button!
	JUMPBOOST = true, --Gain a minor jumpboost when jumping off a rail? (Up to a certain limit.)
	AIRDRAG = 44, --Airdrag time in tics after hopping off a rail. (35 tics = 1 second)

	SIDEHOP = 44, --Specifies the speed of your sidehop speed. If 0, you can't sidehop at all!
	SIDEHOPARC = 0, --If not 0, adds a vertical arc when sidehopping, creating an "arced" sidehop like in modern games.
	SIDEFLIP = SPR2_SPNG, --Do a Modern-style sideflip? Specify a sprite here to use for it! (I recommend SPR2_SPNG for most chars)
	SIDEHOPTIME = 9, --How many tics your sidehop is considered active. If you have a slow sidehop, you probably want more time.

	EMERGENCYDROP = true, --If true, you can press CUSTOM3 to emergency-drop through rails.
	CROUCH = true, --If true, you can "crouch" by holding SPIN, gaining more favorable slope momentum at the cost of balance.
	CROUCHBUTTON = BT_SPIN, --Button to crouch with. If set to BT_SPIN|BT_CUSTOM1, it'd be either SPIN or CUSTOM1! 
	AUTOBALANCE = false, --You auto-balance on rails, losing less speed and making it near-impossible to fall off.
	SLOPEPHYSICS = true, --If false, slope physics are ignored.
	MUSTBALANCE = true, --The character must always balance as if crouching, risking falling off at all times like in SA2!

	SLOPEMULT = 0, --Percentage modifier of slope momentum. 10 would add 10% more, while -20 would reduce the effect by 20%.
	LAUNCHPOWER = 0, --Percentage modifier of vertical rail-flings. 10 would add 10% more height, while -20 would reduce it by 20%.
	STARTMODIFIER = 0, --Speed percentage modifier when attaching to rails. 10 would increase speed by 10%, while -20 decreases it 20%
	STARTSPEEDCONDITION = 0, --Minimum Speed you must be at before your start speed modifier takes place. If 0, defaults to 30.

	HEROESTWIST = 15, --The amount of speed the Heroes-Twist gives, diminishing with gained speed. If 0, you CAN'T twist at all!
	TWISTBUTTON = 0, --What button to press to perform the Heroes Twist. If 0, it mimicks the crouch button.
	ACCELSPEED = 0, --If not 0, you can forcibly accelerate on rails by simply holding forwards.
	ACCELCAP = 48, --This is the speed cap you can manually accelerate to, if you're capable. Defaults to 48.
	AUTODASHMODE = 72, --At what grinding speed you'll automatically enter dashmode. (only if you have SF_DASHMODE!)

	MINSPEED = 0, --Minimum speed your character always has when grinding. If not 0, your character can NEVER reverse!
	MAXSPEED = 180, --Your character won't gain more slopespeed than this. If 0, it's infinite.

	FORCESPRITE = nil, --Force a sprite2 when grinding, overriding both SPR2_GRND as well as the backup pose.
	FORCEHANGSPRITE = nil, --Force a sprite2 when on hangrails, rather than SPR2_RIDE
	WALLCLINGSPRITE = nil, --Use this sprite2 when readying for a walljump? Otherwise, picks sprite automatically.
	NOWINDLINES = false, --If true, doesn't spawn windlines when moving fast on rails.
	NOSIDEHOPGFX = 0, --If 1, only spawns sidehop ghosts. If 2, only spawns sidehop speedlines. If 3, spawns neither.
	NOFUNALLOWED = false, --If true, your character cannot use dunce poses with TOSS FLAG.
	TRICKS = 4, --Our own custom variable to let us cut down on total lists
	},
	["CustomJump"] = function(p, s, GS, rail, RAMPJUMP) -- now comes the part where i have to CODE. #SIGH...
	if RAMPJUMP == true
		p.kombirailgrindjump = true
		p.kombirgspeed = abs(GS.railspeed)
		print(GS.myrail.GSnextrail,GS.myrail.GSnextrail.valid,GS.myrail.GSnextrail.GSinvisiblerail)
		if not (GS.myrail.GSnextrail and GS.myrail.GSnextrail.valid) or GS.myrail.GSnextrail.GSinvisiblerail
			p.kmbilastrail = true
		end
	end
end,
	["GrindThinker"] = function(p, s, GS, rail)
		p.punchwait = 12
		if GS.railc2 == 1 -- do this ONLY at the start of a Custom 2 button press.
			p.kombiboost = $-(100*FRACUNIT/32)
			p.kombirgtrick = true
			p.kombic2trickheld = true -- do this to enable bringing up our cool bonus by even a little
			p.kombirgspeed = abs(GS.railspeed)
			p.kombinextrail = GS.myrail.GSnextrail
			GS_RAILS_SKINS[p.mo.skin]["S_SKIN"]["JUMPBOOST"] = false -- disable farming speed via this method
			if RAIL
				RAIL.ExitRail(s, true, "jump")
			end
			GS_RAILS_SKINS[p.mo.skin]["S_SKIN"]["JUMPBOOST"] = true
			P_SetObjectMomZ(s, 12*FRACUNIT) -- extend window for the trick
		end
	end,
	["PreAttach"] = function(p, s, GS, rail)
		p.kombicandoshit = nil
		print(p.kombiboosting)
		GS.railc1 = 0
		p.punchwait = 12
		if p.kombirgtrick
			kombiGiveSA2Bonus(p,min((FixedInt((max(p.kombirgspeed-36*FRACUNIT,0))/34*10))+((p.didc2trick or 0)/3),10))
			p.kombic2trickheld = nil
			p.kombirgtrick = nil
			p.kombirgspeed = nil
			p.didc2trick = nil
		end
	end,
}

addHook("PlayerThink", function(player)
	if not player.mo return end
	if player.kombirailgrindjump == true
		player.kombirgjumpclock = ($ or 0)+1
		if (player.mo.state == S_PLAY_JUMP or player.mo.state == S_PLAY_STND) and player.kombirgjumpclock > 35
			print("insert taunt state here")
			-- player.kmbilastrail
			local toadd = min(FixedInt((player.kombirgspeed or 0)/100*10),10)
			-- local toadd = 10
			if player.kmbilastrail
				toadd = min($,10)
			end
			kombiGiveSA2Bonus(player,toadd)
			S_StartSound(player.mo,sfx_wlcoi4)
			player.kombirailgrindjump = nil -- de-init unnecessary variables
			player.kombirgjumpclock = nil
			player.kombirgspeed = nil
			player.kmbilastrail = nil
		end
	end
	player.kombibonuses = $ or {}
	for k,b in ipairs(player.kombibonuses) do
		b['bclock'] = $+1
		if b['bclock'] > TICRATE*2
			table.remove(player.kombibonuses, k)
		end
	end
	if (player.mo.eflags & MFE_JUSTHITFLOOR) 
		player.kombicandoshit = nil
		if player.kombirgtrick -- imagine hitting the floor while tricking offa rail lmfaoooo
			player.kombirgtrick = nil
			player.kombirgspeed = nil
		end
	end
	if not (player.cmd.buttons & BT_CUSTOM2) and player.kombic2trickheld
		player.kombic2trickheld = false
	end
	if (player.cmd.buttons & BT_CUSTOM2) and player.kombic2trickheld == false
		player.mo.state = S_KOMBITRICK
		player.mo.frame = (P_RandomRange(1, GS_RAILS_SKINS[player.mo.skin]["S_SKIN"]["TRICKS"]))
		player.didc2trick = ($ or 0)+1
		player.kombic2trickheld = true
		S_StartSound(player.mo,sfx_wlcoi4)
	end
end)