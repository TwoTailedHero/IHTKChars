/*
local dist = 1500
local whoscurrentlyplaying = {
	["kombi"] = false,
	["stryke"] = false,
	["tynker"] = false,
	["trez"] = false,
}
local kombirallyvalidoptions = {
	[1] = "kombi",
}

addHook("PlayerThink", function(player)
	if not whoscurrentlyplaying[player.mo.skin] -- are we currently playing as any of the ralliers?
		whoscurrentlyplaying[player.mo.skin] = true
	end
end)

addHook("MapLoad", function(mapid)
	whoscurrentlyplaying = { --ensure the rally list gets reset at the start of every map
	["kombi"] = false,
	["stryke"] = false,
	["tynker"] = false,
	["trez"] = false,
}
end)

addHook("MapThingSpawn",function(mo,mt)
	--we dont wanna see EXIT pop up from no where
	--looks like an ERROR in a source game!
	mo.flags2 = $|MF2_DONTDRAW
	

	local mul = 14
	do
		local gus = P_SpawnMobjFromMobj(mo,0,0,(mo.height*mul),MT_GUSTAVO_EXITSIGN)
			gus.state = S_GUSTAVO_EXIT_WAIT
			gus.skin = kombirallyvalidoptions[P_RandomRange(1,#kombirallyvalidoptions)]
			if not whoscurrentlyplaying[gus.skin]
				gus.color = skins[gus.skin].prefcolor
			else
				gus.color = SKINCOLOR_SILVER
				gus.colorized = true
			end
			gus.angle = mo.angle
			gus.tracer = mo
			return true
	end
	return true
end,MT_KOMBI_EXITSIGN_SPAWN)

addHook("MobjThinker",function(mo)
	if not mo
	or not mo.valid
		return
	end
	
	if PTJE
		return
	end
	
	local grounded = P_IsObjectOnGround(mo)
	
	mo.angle = mo.tracer.angle+ANGLE_90
	
	if mo.state == S_GUSTAVO_EXIT_WAIT
	and not mo.alreadyfell
		mo.flags2 = $|MF2_DONTDRAW
		mo.flags = $|MF_NOGRAVITY
		if not whoscurrentlyplaying[mo.skin]
			mo.color = skins[mo.skin].prefcolor
		else
			mo.color = SKINCOLOR_SILVER
			mo.colorized = true
		end
		if kombi.hurryup
			local px = mo.x
			local py = mo.y
			local br = dist*mo.scale

			searchBlockmap("objects", function(mo, found)
				if found and found.valid
				and found.health
				and found.player
				and (P_CheckSight(mo,found))
					mo.state = S_GUSTAVO_EXIT_FALL
					mo.alreadyfell = true
				end
			end, mo, px-br, px+br, py-br, py+br)
		end
	else
		mo.flags2 = $ &~MF2_DONTDRAW
		mo.flags = $ &~MF_NOGRAVITY
		if grounded
			mo.state = S_GUSTAVO_EXIT_RALLY
		else
			mo.state = S_GUSTAVO_EXIT_FALL
		end
			mo.momz = $ + P_GetMobjGravity(mo)
		end
end,MT_GUSTAVO_EXITSIGN)
*/