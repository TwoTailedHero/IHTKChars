-- Why did I copy this? Am I lazy?
if srb2p
SafeFreeSlot("sfx_ebpsi","sfx_ebheal","sfx_ebpdie","sfx_ebphur","sfx_ebmort","sfx_ebitem","sfx_ebmiss","sfx_ebsmaa","sfx_ebhsta","sfx_ebpatk",
"sfx_ebdodg","sfx_eblear",
"sfx_ebfre1","sfx_ebfre2","sfx_ebfre3","sfx_ebehur","sfx_ebfla3","sfx_ebfir1","sfx_ebfir2")
-- Due to the exe nature of the mod, this only requires a one-time check.

-- Define our base character's stats!
charStats["kombi"] = {

		-- GENERAL

		name = "Kombi",		-- This is only for bots / enemies
		basehp = 90,			-- base HP for level 1 (Cannot be <= 0)
		basesp = 30,			-- base SP for level 1 (Can be 0, but not < 0!)
		persona = "kombi",		-- Persona to use
		melee_natk = "earthbound_bash",	-- normal melee attack
		wep = "hammer_01",
		weptype = WPT_HAMMER,

		-- Normal attack attributes
		-- Scales with game difficulty
		atk = 40,	-- power (generally < 50)
		acc = 95,	-- accuracy (%)
		crit = 2,	-- crit rate (%)

		-- ANIMS
		-- Anims are built like this:
		-- {SPR_SPRITE, frame1, frame2, frame3, ... , duration between each frame, ["SPR2_CONST"]}
		-- (SPR2 must be a string, and is optional. Only for use with SPR_PLAY)

		-- Note: As of Beta 1.0.0, not all animations are implemented
		-- (* = unimplemented)

		anim_stand = 		{SPR_PLAY, A, 8, "SPR2_STND"},					-- standing
		anim_stand_hurt =	{SPR_PLAY, A, 1, "SPR2_STND"},					-- standing (low HP) *
		anim_stand_bored =	{SPR_PLAY, A, 8, "SPR2_STND"},					-- standing (occasionally plays after anim_stand has played several times)
		anim_guard = 		{SPR_PLAY, A, 1, "SPR2_GARD"},					-- guarding
		anim_move =			{SPR_PLAY, A, B, C, D, E, F, 2, "SPR2_WALK"},	-- moving
		anim_run =			{SPR_PLAY, A, B, C, D, E, F, 2, "SPR2_RUN_"},	-- guess what
		anim_atk =			{SPR_PLAY, A, B, 2, "SPR2_ROLL"},			-- attacking
		anim_aoa_end =		{SPR_PLAY, B, A, 2, "SPR2_ROLL"},			-- jumping out of all-out attack
		anim_hurt =			{SPR_PLAY, A, 35, "SPR2_PAIN"},					-- taking damage
		anim_getdown =		{SPR_PLAY, A, 1, "SPR2_CNT1"},					-- knocked down from weakness / crit *
		anim_downloop =		{SPR_PLAY, A, 1, "SPR2_CNT1"},					-- is down
		anim_getup =		{SPR_PLAY, A, B, C, D, 1, "SPR2_ROLL"},			-- gets up from down
		anim_death =		{SPR_PLAY, A, 30, "SPR2_DEAD"},					-- dies
		anim_revive =		{SPR_PLAY, A, B, C, D, 1, "SPR2_ROLL"},			-- gets revived

		-- anim_special1 through anim_special32 may also be used for various purposes (ie: attack animations)
		anim_special1 =	{SPR_PLAY, A, 2, "SPR2_MLEE"},
		anim_special2 = {SPR_PLAY, B, C, D, 2, "SPR2_MLEE"}, -- hammer swing
		anim_special3 = {SPR_PLAY, A, "SPR2_MLEE"},	-- hammer swung
		anim_special4 = {SPR_PLAY, A, B, C, D, E, "SPR2_TWIN"},	-- hammer spin

		-- VOICES
		-- Possible list of voices
		-- vfx_action = {"sfx_voice1", "sfx_voice2", [...], "sfx_voicen"}

		-- ...In the case of kanade, she's silent, but I will leave these here for reference!

		vfx_summon = {},	-- Summoning Persona to use a Skill
        vfx_skill = {},		-- Used a Skill
        vfx_item = {"sfx_ebitem"},		-- Used an item
        vfx_hurt = {"sfx_ebphur"},		-- Sustained damage
        vfx_hurtx = {"sfx_ebmort"},		-- Sustained heavy damage / Critical hit / Weakness
        vfx_die = {"sfx_ebpdie"},		-- Death
        vfx_heal = {},		-- Healed by teammate
        vfx_healself = {},	-- Healed self
        vfx_kill = {},		-- Killed an enemy
        vfx_1more = {},		-- Performed 1more
        vfx_crit = {},		-- Cut-in for Weakness/Critical Hit
        vfx_aoaask = {},	-- Ask to All-Out Attack
        vfx_aoado = {},		-- Performing All-Out Attack
        vfx_aoarelent = {},	-- Relenting from All-Out Attack
        vfx_miss = {"sfx_ebmiss"},		-- Missed attack
        vfx_dodge = {"sfx_ebdodg"},		-- Dodged enemy attack
        vfx_win = {},		-- Battle won
        vfx_levelup = {"sfx_eblear"},	-- Level Up!


		-- HUD DEFINTIIONS

		icon = "ICO_KMBI",			-- head icon for character select
		hudbust = "H_KOMBAR",			-- patch to draw on the stat hud
		hudaoa = "H_KOMAOA",		-- patch for all out attack hud
		hudcutin = "KANA_A",		-- cut in frames prefix

		-- Tip to display on the character select.
		-- Give insight on their skill type and their strengths/weaknesses in battle!
		tip = "oughhh i'm over here bounding my earth",
}

personaList["kombi"] = {
		-- GENERAL
		name = "Kombi",	-- Name of the Persona
		arcana = nil,			-- Arcana (unused in Beta 1.0.0, can be left nil as well)

		sprite = SPR_PSN0,		-- Unused outside of debugging purposes for shortcuts. Can be left nil
		startframe = 0,			-- Unused outside of debugging purposes for shortcuts. Can be left nil

		-- Animations function the same way they do for players. (In Kanade's case, she's so good she doesn't need one, so let's make it invisible)
		anim_idle = 	{SPR_NULL, A},	-- Idle animation when summoned in the menu
		anim_atk = 		{SPR_NULL, A},	-- Animation when attacking

		-- Stats (at level 10)
		-- Remember that stats naturally cap at 99.
		strength = 12,
		magic = 7,
		endurance = 7,
		luck = 4,
		agility = 10,

		-- Affinities (weak, resist, block, drain)
		weak = ATK_CURSE,
		resist = ATK_SLASH|ATK_BLESS,
		block = ATK_PIERCE,

		/*Skills learnt and their level:
			{
				{"skillname", level, ["skill_to_replace"]},
				{"skill2name", level, ["skill_to_replace"]},
				[...]
			}

			Documentation for every existing skill name will be available publically at a later date.
			For now, feel free to scout the game files yourself!

			the 3rd argument is only useful on higher difficulties where characters automatically start at
			higher levels, meaning their skills need to be automatically replaced.

			NOTE: Characters can only have 8 skills total! But if you mess this up, the game won't stop you from having 69 skills.
			So pay attention!
		*/

		skills = {
					{"lifeup1", 2}, {"rockin1", 8},
					{"healing2", 15}, {"shield1", 12},
					{"lifeup4", 70}, {"fire1", 3},
					{"freeze1", 1}, {"thunder1", 8},
					
					{"fire2", 19, "fire1"},
					{"fire3", 37, "fire2"},
					{"fire4", 64, "fire3"},
					
					{"freeze2", 11, "freeze1"},
					{"freeze3", 31, "freeze2"},
					{"freeze4", 46, "freeze3"},
					
					{"thunder2", 15, "thunder1"},
					{"thunder3", 41, "thunder2"},
					{"thunder4", 55, "thunder3"},
					
					{"lifeup2", 15, "lifeup1"},
					{"lifeup3", 39, "lifeup2"},
					
					{"rockin2", 22, "rockin1"},
					{"rockin3", 49, "rockin2"},
					{"rockin4", 75, "rockin3"},
				},
}

-- Finally, let us define our additional skills.

attackDefs["earthbound_bash"] = {
	name = "Bash",
	type = ATK_STRIKE,
	power = 45,
	accuracy = 85,
	critical = 7, -- was 7
	target = TGT_ENEMY,
	costtype = CST_HP,
	cost = 0,
	desc = "A strong Hammer Hit.",
	anim_norepel = true,	-- do not bounce back our ANIMATION
	physical = true,	-- don't play the summoning anim for phys attacks, duh
	anim = 	function(mo, targets, hittargets, timer)
				local target = targets[1]
				if timer == 1
					ANIM_set(mo, mo.anim_special1, true)
					playSound(mo.battlen, sfx_ebpatk)

					-- fake A_LobShot:
					mo.angle = R_PointToAngle2(mo.x, mo.y, target.x, target.y)

					local z = mo.z
					local hit = P_SpawnMobj(target.x & (64*FRACUNIT -1), target.y & (64*FRACUNIT -1), target.subsector.sector.floorheight, MT_NULL)
					hit.tics = TICRATE

					local dist = P_AproxDistance(target.x - mo.x, target.y - mo.y)
					local horizontal = dist / TICRATE
					local vertical = FixedMul((gravity*TICRATE)/2, mo.scale)

					mo.momx = FixedMul(horizontal, cos(mo.angle))
					mo.momy = FixedMul(horizontal, sin(mo.angle))
					mo.momz = vertical


					-- move camera to an interresting spot

					local an = target.angle + 45*ANG1

					local cx = target.x + 384*cos(an)
					local cy = target.y + 384*sin(an)

					CAM_goto(server.P_BattleStatus[mo.battlen].cam, cx, cy, server.P_BattleStatus[mo.battlen].cam.z, 70*FRACUNIT)
					CAM_angle(server.P_BattleStatus[mo.battlen].cam, R_PointToAngle2(cx, cy, target.x, target.y), ANG1*4)
					--CAM_aiming(server.P_BattleStatus[mo.battlen].cam, -ANG1*10, ANG1)

				elseif timer == TICRATE - 7
					ANIM_set(mo, mo.anim_special2)	-- hammer hit prep

				elseif timer == TICRATE
					playSound(mo.battlen, sfx_ebehur)
					damageObject(hittargets[1])
					P_InstaThrust(mo, 0, 0)

					-- explode hearts all over!
					-- heart ring:
					for i = 1, 8 do -- do this even if we don't even need to because SLADE cannot physically handle us doing just "for 1 = 1, 8"
						local h = P_SpawnMobj(target.x, target.y, target.z, MT_DUMMY)
						h.state = S_LHRT
						h.fuse = TICRATE
						P_InstaThrust(h, (360/8 *i)*ANG1, FRACUNIT*32)
					end

					localquake(mo.battlen, FRACUNIT*30, 8)
					playSound(mo.battlen, sfx_pstop)

					for i = 1, 16 do
						local h = P_SpawnMobj(target.x, target.y, target.z, MT_DUMMY)
						h.state = S_LHRT
						h.fuse = TICRATE
						h.momx = P_RandomRange(-24, 24)*FRACUNIT
						h.momy = P_RandomRange(-24, 24)*FRACUNIT
						h.momz = P_RandomRange(2, 24)*FRACUNIT
					end
				elseif timer == TICRATE*2
					return true
				end
			end,
	critanim = 	function(mo, targets, hittargets, timer)
				local target = targets[1]
				if timer == 1
					ANIM_set(mo, mo.anim_special1, true)
					playSound(mo.battlen, sfx_ebpatk)

					-- fake A_LobShot:
					mo.angle = R_PointToAngle2(mo.x, mo.y, target.x, target.y)

					local z = mo.z
					local hit = P_SpawnMobj(target.x & (64*FRACUNIT -1), target.y & (64*FRACUNIT -1), target.subsector.sector.floorheight, MT_NULL)
					hit.tics = TICRATE

					local dist = P_AproxDistance(target.x - mo.x, target.y - mo.y)
					local horizontal = dist / TICRATE
					local vertical = FixedMul((gravity*TICRATE)/2, mo.scale)

					mo.momx = FixedMul(horizontal, cos(mo.angle))
					mo.momy = FixedMul(horizontal, sin(mo.angle))
					mo.momz = vertical


					-- move camera to an interresting spot

					local an = target.angle + 45*ANG1

					local cx = target.x + 384*cos(an)
					local cy = target.y + 384*sin(an)

					CAM_goto(server.P_BattleStatus[mo.battlen].cam, cx, cy, server.P_BattleStatus[mo.battlen].cam.z, 70*FRACUNIT)
					CAM_angle(server.P_BattleStatus[mo.battlen].cam, R_PointToAngle2(cx, cy, target.x, target.y), ANG1*4)
					--CAM_aiming(server.P_BattleStatus[mo.battlen].cam, -ANG1*10, ANG1)

				elseif timer == TICRATE - 7
					ANIM_set(mo, mo.anim_special2)	-- hammer hit prep

				elseif timer == TICRATE
					playSound(mo.battlen, sfx_ebsmaa)
					damageObject(hittargets[1])
					P_InstaThrust(mo, 0, 0)

					-- explode hearts all over!
					-- heart ring:
					for i = 1, 8 do
						local h = P_SpawnMobj(target.x, target.y, target.z, MT_DUMMY)
						h.state = S_LHRT
						h.fuse = TICRATE
						P_InstaThrust(h, (360/8 *i)*ANG1, FRACUNIT*32)
					end

					localquake(mo.battlen, FRACUNIT*30, 8)
					playSound(mo.battlen, sfx_pstop)

					for i = 1, 16 do
						local h = P_SpawnMobj(target.x, target.y, target.z, MT_DUMMY)
						h.state = S_LHRT
						h.fuse = TICRATE
						h.momx = P_RandomRange(-24, 24)*FRACUNIT
						h.momy = P_RandomRange(-24, 24)*FRACUNIT
						h.momz = P_RandomRange(2, 24)*FRACUNIT
					end
				elseif timer == TICRATE*2
					return true
				end
			end,
}

attackDefs["lifeup1"] = {
		name = "Lifeup Alpha",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 50,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		norepel = true,
		costtype = CST_SP,		-- Cost type
		cost = 10,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Heals 50 HP to \none ally.",	-- Description
		nocast = false,
		target = TGT_ALLY,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 55
				playSound(mo.battlen, sfx_ebheal)
				damageObject(target, P_RandomRange(-37, -62))
				return true
			end
		end,
}

attackDefs["lifeup2"] = {
		name = "Lifeup Beta",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 50,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		norepel = true,
		costtype = CST_SP,		-- Cost type
		cost = 16,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Heals 50 HP to \none ally.",	-- Description
		nocast = false,
		target = TGT_ALLY,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 55
				playSound(mo.battlen, sfx_ebheal)
				damageObject(target, P_RandomRange(-37, -62))
				return true
			end
		end,
}

attackDefs["lifeup3"] = {
		name = "Lifeup Gamma",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 999,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		norepel = true,
		costtype = CST_SP,		-- Cost type
		cost = 26,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Fully heals \none ally.",	-- Description
		nocast = false,
		target = TGT_ALLY,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 55
				playSound(mo.battlen, sfx_ebheal)
				damageObject(target, P_RandomRange(-999))
				return true
			end
		end,
}

attackDefs["lifeup4"] = {
		name = "Lifeup Omega",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 250,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		norepel = true,
		costtype = CST_SP,		-- Cost type
		cost = 48,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Heals 250 HP to \nall allies.",	-- Description
		nocast = false,
		target = TGT_ALLALLIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			if timer == 55
				playSound(mo.battlen, sfx_ebheal)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(-150, -250))
				end
				return true
			end
		end,
}

attackDefs["shield1"] = {
		name = "Shield Alpha",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 50,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		norepel = true,
		costtype = CST_SP,		-- Cost type
		cost = 10,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Heals 50 HP to \none ally.",	-- Description
		nocast = false,
		target = TGT_ALLY,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 55
				playSound(mo.battlen, sfx_ebheal)
				damageObject(target, P_RandomRange(-37, -62))
				return true
			end
		end,
}

attackDefs["healing2"] = {
		name = "Healing Beta",				-- Name of the skill
		type = ATK_HEAL,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 16,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Cures poison, dizziness, silence,\nbrainwashing, burning, poison,\n and freezing.",	-- Description
		target = TGT_ALLY,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]

			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)

			elseif timer == 55
				playSound(mo.battlen, sfx_ebhsta)
				
				return true
			end
		end,
}

attackDefs["rockin1"] = {
		name = "Rockin' Alpha",				-- Name of the skill
		type = ATK_PSY,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 20,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Psy damage to \nall enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(20, 60))
				end
				return true
			end
		end,
		
		critanim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebsmaa)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(24, 72))
				end
				//Damage *1.2 + knockdown
				return true
			end
		end,
}

attackDefs["rockin2"] = {
		name = "Rockin' Beta",				-- Name of the skill
		type = ATK_PSY,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 28,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Psy damage to \nall enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(45, 135))
				end
				return true
			end
		end,
}

attackDefs["rockin3"] = {
		name = "Rockin' Gamma",				-- Name of the skill
		type = ATK_PSY,				-- Type of the skill (does not stack like affinities)
		power = 160,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 80,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Psy damage to \nall enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(80, 240))
				end
				return true
			end
		end,
}

attackDefs["rockin4"] = {
		name = "Rockin' Omega",				-- Name of the skill
		type = ATK_PSY,				-- Type of the skill (does not stack like affinities)
		power = 320,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 196,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Psy damage to \nall enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(160, 480))
				end
				return true
			end
		end,
}

attackDefs["fire1"] = {
		name = "Fire Alpha",				-- Name of the skill
		type = ATK_FIRE,				-- Type of the skill (does not stack like affinities)
		power = 40,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 12,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Fire damage to \nall enemies.\mSmall chance to inflict BURN.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type
		status = COND_BURN,
		statucshance = 10,

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfir1)
			elseif timer == 38
				playSound(mo.battlen, sfx_ebfir2)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(30, 50))
				end
				return true
			end
		end,
}

attackDefs["fire2"] = {
		name = "Fire Beta",				-- Name of the skill
		type = ATK_FIRE,				-- Type of the skill (does not stack like affinities)
		power = 80,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 24,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Fire damage to \nall enemies.\mSmall chance to inflict BURN.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type
		status = COND_BURN,
		statucshance = 10,

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfir1)
			elseif timer == 38
				playSound(mo.battlen, sfx_ebfir2)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(60, 100))
				end
				return true
			end
		end,
}

attackDefs["fire3"] = {
		name = "Fire Gamma",				-- Name of the skill
		type = ATK_FIRE,				-- Type of the skill (does not stack like affinities)
		power = 120,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 40,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Fire damage to \nall enemies.\mSmall chance to inflict BURN.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type
		status = COND_BURN,
		statucshance = 10,

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfir1)
			elseif timer == 38
				playSound(mo.battlen, sfx_ebfir2)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(90, 150))
				end
				return true
			end
		end,
}

attackDefs["fire4"] = {
		name = "Fire Omega",				-- Name of the skill
		type = ATK_FIRE,				-- Type of the skill (does not stack like affinities)
		power = 160,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 84,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Fire damage to \nall enemies.\mSmall chance to inflict BURN.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type
		status = COND_BURN,
		statucshance = 10,

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfir1)
			elseif timer == 38
				playSound(mo.battlen, sfx_ebfir2)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,#hittargets do
					local target = hittargets[i]
					damageObject(target, P_RandomRange(120, 200))
				end
				return true
			end
		end,
}

attackDefs["freeze1"] = {
		name = "Freeze Alpha",				-- Name of the skill
		type = ATK_ICE,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 16,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Freeze damage to \none enemy.",	-- Description
		target = TGT_ENEMY,				-- Target type

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfre1)
			elseif timer == 46
				playSound(mo.battlen, sfx_ebfre2)
			elseif timer == 83
				playSound(mo.battlen, sfx_ebehur)
				damageObject(target, P_RandomRange(62, 117))
				return true
			end
		end,
}

attackDefs["freeze2"] = {
		name = "Freeze Beta",				-- Name of the skill
		type = ATK_ICE,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 18,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Freeze damage to \none enemy.",	-- Description
		target = TGT_ENEMY,				-- Target type

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfre1)
			elseif timer == 46
				playSound(mo.battlen, sfx_ebfre2)
			elseif timer == 83
				playSound(mo.battlen, sfx_ebehur)
				damageObject(target, P_RandomRange(135, 225))
				return true
			end
		end,
}

attackDefs["freeze3"] = {
		name = "Freeze Gamma",				-- Name of the skill
		type = ATK_ICE,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 36,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Freeze damage to \none enemy.",	-- Description
		target = TGT_ENEMY,				-- Target type

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfre1)
			elseif timer == 46
				playSound(mo.battlen, sfx_ebfre2)
			elseif timer == 83
				playSound(mo.battlen, sfx_ebehur)
				damageObject(target, P_RandomRange(202, 337))
				return true
			end
		end,
}

attackDefs["freeze4"] = {
		name = "Freeze Omega",				-- Name of the skill
		type = ATK_ICE,				-- Type of the skill (does not stack like affinities)
		power = 90,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 56,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Freeze damage to \none enemy.",	-- Description
		target = TGT_ENEMY,				-- Target type

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[1]
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 28
				playSound(mo.battlen, sfx_ebfre1)
			elseif timer == 46
				playSound(mo.battlen, sfx_ebfre2)
			elseif timer == 83
				playSound(mo.battlen, sfx_ebehur)
				damageObject(target, P_RandomRange(270, 450))
				return true
			end
		end,
}

attackDefs["thunder1"] = {
		name = "Thunder Alpha",				-- Name of the skill
		type = ATK_ELEC,				-- Type of the skill (does not stack like affinities)
		power = 60,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 6,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Electric damage to \na random enemy.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		anim = function(mo, targets, hittargets, timer)
			local target = hittargets[P_RandomRange(1, #hittargets)]
			
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				damageObject(target, P_RandomRange(30, 90))
				return true
			end
		end,
}

attackDefs["thunder2"] = {
		name = "Thunder Beta",				-- Name of the skill
		type = ATK_ELEC,				-- Type of the skill (does not stack like affinities)
		power = 60,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 14,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Electric damage to \ntwo random enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local hit = P_RandomRange(1, #hittargets)
			local alreadytargetted = {
				[hit] = true
			}
			local target = hittargets[hit]
			local hitlist = {
			}
			
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,2 do
					repeat
						hit = P_RandomRange(1, #hittargets)
					until not alreadytargetted[hit]
					target = hittargets[hit]
					damageObject(target, P_RandomRange(30, 90))
				end
				return true
			end
		end,
}

attackDefs["thunder3"] = {
		name = "Thunder Gamma",				-- Name of the skill
		type = ATK_ELEC,				-- Type of the skill (does not stack like affinities)
		power = 100,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 14,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Electric damage to \nthree random enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local hit = P_RandomRange(1, #hittargets)
			local alreadytargetted = {
				[hit] = true
			}
			local target = hittargets[hit]
			local hitlist = {
			}
			
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,3 do
					repeat
						hit = P_RandomRange(1, #hittargets)
					until not alreadytargetted[hit]
					target = hittargets[hit]
					damageObject(target, P_RandomRange(50, 150))
				end
				return true
			end
		end,
}

attackDefs["thunder4"] = {
		name = "Thunder Omega",				-- Name of the skill
		type = ATK_ELEC,				-- Type of the skill (does not stack like affinities)
		power = 100,						-- Power of the skill
		accuracy = 100,					-- Accuracy (%) of the skill
		costtype = CST_SP,		-- Cost type
		cost = 14,						-- Cost
		critical = 0,					-- Critical chance (%)
		desc = "Electric damage to \nfour random enemies.",	-- Description
		target = TGT_ALLENEMIES,				-- Target type

		-- animation (mobj_t caster, table of mobj_t original targets, table of mobj_t actual hit targets, tic_t timer)
		/*
			targets is the table of originally targetted enemies
			hittargets is the table of enemies that were actually hit (ie: repels)
			timer is just a variable that will keep counting up each frame to aid in animating your attacks

			The animation ends when the function returns true.
			Use 'damageObject(mobj_t)' to deal the damage to the target in your animation.

		*/

		anim = function(mo, targets, hittargets, timer)
			local hit = P_RandomRange(1, #hittargets)
			local alreadytargetted = {
				[hit] = true
			}
			local target = hittargets[hit]
			local hitlist = {
			}
			
			if timer == 1
				playSound(mo.battlen, sfx_ebpsi)
			elseif timer == 55
				playSound(mo.battlen, sfx_ebehur)
				for i = 1,4 do
					repeat
						hit = P_RandomRange(1, #hittargets)
					until not alreadytargetted[hit]
					target = hittargets[hit]
					damageObject(target, P_RandomRange(50, 150))
				end
				return true
			end
		end,
}
end