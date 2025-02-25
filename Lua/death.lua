local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
SafeFreeSlot("sfx_sdrown","sfx_sfall","sfx_sgener","sfx_2drown","sfx_2fall","sfx_2gener","sfx_agener","sfx_afall","sfx_adrown","S_PLAY_DROWNANIM","SPR2_DRW2","S_PLAY_DEATHANIM","SPR2_DEA2",
"sfx_wriaa0","sfx_wriaa1","sfx_wriaa2","sfx_wriaa3","sfx_wriaa4",
"sfx_frbeep","sfx_frflat")
sfxinfo[sfx_sdrown].caption = 'Drowning'
sfxinfo[sfx_sfall].caption = '\x85No!!\x80'
sfxinfo[sfx_sgener].caption = '\x85No!\x80'
sfxinfo[sfx_2drown].caption = 'Drowning'
sfxinfo[sfx_2fall].caption = '\x85Huehh!\x80'
sfxinfo[sfx_2gener].caption = '\x85No!\x80'
sfxinfo[sfx_adrown].caption = 'Drowning'
sfxinfo[sfx_afall].caption = '\x82"Woahhh!"\x80'
sfxinfo[sfx_agener].caption = '\x82"Oh no!"\x80'
sfxinfo[sfx_wriaa0].caption = 'Waahhhh..!'
sfxinfo[sfx_wriaa1].caption = 'Waaaaahh!'
sfxinfo[sfx_wriaa2].caption = 'Wahhhh..!'
sfxinfo[sfx_wriaa3].caption = 'Ereehhhhhh..!'
sfxinfo[sfx_wriaa4].caption = 'Ereeeeehhhh..!'

if not customdeaths
    rawset(_G, "customdeaths", {})
end

customdeaths["kombi"] = true
customdeaths["tynker"] = true
customdeaths["trez"] = true

states[S_PLAY_DROWNANIM] = {
	sprite = SPR_PLAY,
	frame = A|SPR2_DRW2|FF_ANIMATE,
	tics = 4,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_DROWNANIM
}
spr2defaults[SPR2_DRW2] = SPR2_CNT1
states[S_PLAY_DEATHANIM] = {
	sprite = SPR_PLAY,
	frame = A|SPR2_DEA2|FF_ANIMATE,
	tics = 4,
	var1 = 3,
	var2 = 4,
	nextstate = S_PLAY_DEATHANIM
}
spr2defaults[SPR2_DEA2] = SPR2_CNT1
/*
addHook("ShouldDamage", function(target, inf, source, dmg, dmgType)
	if dmgType == DMG_DEATHPIT
		return false
	end
end, MT_PLAYER)
*/
addHook("MobjDeath", function(mobj, inflictor, source, damageType)
	if mobj.skin == "kombi"
		mobj.player.diedto = 1
		if damageType == DMG_DEATHPIT
			if P_RandomChance(3*FRACUNIT/4)
				S_StartSound(mobj,sfx_sfall)
			else
				S_StartSound(mobj,sfx_2fall)
			end
		elseif damageType == DMG_DROWNED or damageType == DMG_SPACEDROWN
			mobj.player.diedto = 1 << 2
			if P_RandomChance(3*FRACUNIT/4)
				S_StartSound(mobj,sfx_sdrown)
			else
				S_StartSound(mobj,sfx_2drown)
			end
		else
			mobj.player.diedto = 1 << 1
			if P_RandomChance(3*FRACUNIT/4)
				S_StartSound(mobj,sfx_sgener)
			else
				S_StartSound(mobj,sfx_2gener)
			end
		end
	end
	if mobj.skin == "tynker"
		if damageType == DMG_DEATHPIT
			mobj.player.diedto = 1
			S_StartSound(mobj,sfx_afall)
		elseif damageType == DMG_DROWNED or damageType == DMG_SPACEDROWN
			mobj.player.diedto = 1 << 2
			S_StartSound(mobj,sfx_adrown)
		else
			mobj.player.diedto = 1 << 1
			S_StartSound(mobj,sfx_2gener)
		end
	end
	if mobj.skin == "trez"
		if damageType == DMG_DEATHPIT
			mobj.player.diedto = 1
			S_StartSound(mobj, P_RandomRange(sfx_wriaa0,sfx_wriaa4))
		elseif damageType == DMG_DROWNED or damageType == DMG_SPACEDROWN
			mobj.player.diedto = 1 << 2
			S_StartSound(mobj,sfx_adrown)
		else
			mobj.player.diedto = 1 << 1
		end
	end
	if not mobj.player.diedto return end
	if mobj.player.diedto >= 2
		if mobj.player.diedto >= 4 then mobj.state = S_PLAY_DROWNANIM else mobj.state = S_PLAY_DEATHANIM end
	elseif mobj.player.diedto == 1 and P_CheckDeathPitCollide(mobj)
		mobj.flags = $|MF_NOCLIPHEIGHT&~MF_NOGRAVITY
		mobj.state = S_PLAY_FALL
		mobj.kombixvel = mobj.momx
		mobj.kombiyvel = mobj.momy
		mobj.kombizvel = mobj.momz-- *5/2
	end
	mobj.player.lives = $-1
	if kombiwhogetswl4stuff[mobj.skin] return true end
end, MT_PLAYER)

addHook("ThinkFrame", function()
	for player in players.iterate do
		if player.playerstate == PST_DEAD
			if kombiwhogetswl4stuff[player.realmo.skin] --simplify by doing all wl4 chars, considering only the important chars get variables written to up above no conflicts should occur
				if player.diedto player.mo.flags2 = $&~MF2_DONTDRAW end -- Why do you get set.
				if player.diedto and player.diedto >= 2
					if player.diedto and player.diedto >= 4 then player.mo.state = S_PLAY_DROWNANIM else player.mo.state = S_PLAY_DEATHANIM end
					player.mo.z = $+player.mo.momz
					player.mo.momz = $+(P_GetMobjGravity(player.mo) or -1*FRACUNIT)
					print("nonpitdeath...", player.mo.momz, player.mo.flags, player.mo.flags2, player.mo.eflags)
				elseif player.diedto and player.diedto == 1 and P_CheckDeathPitCollide(player.mo)
					player.mo.flags = $|MF_NOCLIPHEIGHT&~MF_NOGRAVITY
					player.mo.momx = player.mo.kombixvel -- i gotta DO THIS. fuck my stupid chungus life vro
					player.mo.momy = player.mo.kombiyvel
					/* if not player.mo.momz
						player.mo.momz = player.mo.kombizvel+(P_GetMobjGravity(player.mo) or -1*FRACUNIT)
					end */
					local intersectcheck = (player.mo.z < player.mo.subsector.sector.floorheight + player.mo.height
					and player.mo.z >= player.mo.subsector.sector.floorheight)
					if intersectcheck and player.mo.kombizvel < player.mo.height
						player.mo.z = player.mo.subsector.sector.floorheight - player.mo.height + player.mo.kombizvel
					end
					player.mo.z = $+player.mo.kombizvel -- for SOME reason MF_NOCLIPHEIGHT is slower when passing through sector floors??? but setting momz directly doesn't work????? how the fuck did the other death anim guy do it then?????
					player.mo.kombizvel = $+(P_GetMobjGravity(player.mo) or -1*FRACUNIT)
				end
			end
		end
	end
end)