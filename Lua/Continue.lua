local top, bottom, vpad, hpad = 15, 180, 5, 2 -- UI layout constants
local timeleft

hud.add(function(v, player, x, y, scale, skin, sprite2, frame, rotation, color, ticker, continuing)
	local time = (11 * TICRATE) + 8 - ticker
	
	v.drawFill()
	v.draw(160, bottom, v.cachePatch("CONTSPOTGREEN"), nil, v.getColormap(TC_RAINBOW, SKINCOLOR_PURPLE))
	
	if not continuing
		local patch, newypos
		if time < TICRATE * 2 / 3
			patch = v.getSprite2Patch(skin, SPR2_FALL, false, A, ((ticker / 2) % 8) + 1)
			newypos = ease.linear(FixedDiv(time, TICRATE * 2 / 3), 0, bottom * FRACUNIT)
		else
			patch = v.getSprite2Patch(skin, sprite2, false, frame, rotation)
			newypos = bottom * FRACUNIT
		end
		timeleft = ticker / TICRATE -- to not have weirdness happen when we actually continue
		v.drawScaled(x, newypos, scale, patch, nil, v.getColormap(skin, color))
	else
		local patch, flip, newxpos
		if ticker <= 2
			patch, flip = v.getSprite2Patch(skin, SPR2_FALL, false, A, 7)
		elseif ticker <= TICRATE / 2
			patch, flip = v.getSprite2Patch(skin, SPR2_WALK, false, ticker / 2 % skins[skin].sprites[SPR2_WALK].numframes, 7)
		else
			patch, flip = v.getSprite2Patch(skin, SPR2_RUN_, false, ticker / 2 % skins[skin].sprites[SPR2_RUN_].numframes, 7)
			if ticker > TICRATE * 2
				newxpos = ease.linear(FixedDiv(ticker - TICRATE * 2, 104 - TICRATE * 2), 160 * FRACUNIT, (320 + (patch.width + patch.leftoffset) * 3 / 2) * FRACUNIT)
			end
		end
		v.drawScaled(newxpos or x, bottom * FRACUNIT, scale, patch, flip and V_FLIP or nil, v.getColormap(skin, color))
	end
	
	local yp = top
	v.draw(160, yp, v.cachePatch("S1CONTINUETEXT"))
	yp = yp + v.cachePatch("S1CONTINUETEXT").height + vpad
	
	local contpatch = v.getSprite2Patch(skin, SPR2_XTRA, false, C, 0)
	local total_width = (player.continues - 1) * (contpatch.width + hpad)
	local start_x = 160 - (total_width / 2)
	
	for i = 0, player.continues - 1 do
		if i > 0 or not continuing or (ticker % 2 == 1)
			v.draw(start_x + (i * (contpatch.width + hpad)), yp + contpatch.topoffset, contpatch, nil, v.getColormap(skin, color))
		end
	end

	
	yp = yp + contpatch.height + vpad
	v.draw(136, yp, v.cachePatch("S1CONTINUENUMS"))
	
	for i = 0, 1 do
		local frame = (timeleft or 0) / (10 ^ i) % 10 or 0
		v.draw(160 - (i * 8), yp, v.cachePatch("S1CONTINUENUM" .. frame))
	end
	
	v.draw(168, yp, v.cachePatch("S1CONTINUENUMS"))
	return true
end, "continue")