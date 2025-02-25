addHook ("PlayerThink", function(p)
	if not p.mo return end
	if p.pflags & PF_SPINNING and not (p.pflags & PF_STARTDASH) and ((p.mo.eflags & MFE_JUSTHITFLOOR) or P_IsObjectOnGround(p.mo)) and kombiwhoignoresmaxspeed[p.realmo.skin] and not (kombiwhoignoresmaxspeed[p.realmo.skin] & 4)
		p.acceleration = skins[p.realmo.skin].acceleration
		p.thrustfactor = (skins[p.realmo.skin].thrustfactor)*20
	elseif p.realmo.headbashing
		p.acceleration = skins[p.realmo.skin].acceleration/2
		p.thrustfactor = skins[p.realmo.skin].thrustfactor*2
	else
		p.acceleration = skins[p.realmo.skin].acceleration
		p.thrustfactor = skins[p.realmo.skin].thrustfactor
	end
end)