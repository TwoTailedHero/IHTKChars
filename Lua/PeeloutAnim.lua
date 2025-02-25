local function SafeFreeSlot(...)
	for _,slot in ipairs({...})
		if not rawget(_G, slot) freeslot(slot) end -- Ensure we don't accidentally overlap existing freeslots
	end
end
SafeFreeSlot("SPR_PEEL")

rawset(_G, "cv_kombipeelout", CV_RegisterVar({
	name = "k_peeloutanim",
	defaultvalue = "On",
	flags = CV_SAVE|CV_SHOWMODIF,
	PossibleValue = {Off = 0, On = 1},
}))

addHook("ThinkFrame", do
	for player in players.iterate
		if not player.mo continue end
		if (player and player.realmo and player.realmo.valid) and (kombiwhoignoresmaxspeed[player.realmo.skin] and kombiwhoignoresmaxspeed[player.realmo.skin] & 2)
			if FixedDiv(FixedDiv(player.speed, max(1,player.mo.friction)), max(1,player.mo.scale)) >= (skins[player.realmo.skin].normalspeed*5)/3 and cv_kombipeelout.value
				if player.realmo.state == S_PLAY_RUN -- or player.realmo.state == S_PLAY_DASH
					player.realmo.state = S_PLAY_DASH
				end
			elseif player.realmo.state == S_PLAY_DASH
				player.realmo.state = S_PLAY_RUN
			end
			if player.realmo.state == S_PLAY_KOMBISBASH or player.realmo.state == S_PLAY_DASH or player.realmo.state == S_PLAY_KOMBIPEELOUT3
			and not player.powers[pw_super]
				for i = -40, 40
					if not cv_kombipeelout.value then return end
					local force = i*FRACUNIT/3
					local angle = ANGLE_90

					local shiftx = FixedMul(cos(player.drawangle + angle), force)
					local shifty = FixedMul(sin(player.drawangle + angle), force)
					
					local shiftx2 = FixedMul(cos(player.drawangle), FRACUNIT)
					local shifty2 = FixedMul(sin(player.drawangle), FRACUNIT)
					
					if i > 20
					or i < -20
						local peelout = P_SpawnMobjFromMobj(player.realmo, shiftx2 + shiftx, shifty2 + shifty, 0, MT_OVERLAY)
						peelout.target = player.realmo
						peelout.fuse = 1
						peelout.sprite = SPR_PEEL
						if i < 0
							if player.realmo.frame%4 == A
								peelout.frame = A
							elseif player.realmo.frame%4 == B
								peelout.frame = B
							elseif player.realmo.frame%4 == C
								peelout.frame = C
							elseif player.realmo.frame%4 == D
								peelout.frame = D
							end
							peelout.angle = player.drawangle + ANGLE_90/6
						else
							if player.realmo.frame%4 == A
								peelout.frame = C
							elseif player.realmo.frame%4 == B
								peelout.frame = D
							elseif player.realmo.frame%4 == C
								peelout.frame = A
							elseif player.realmo.frame%4 == D
								peelout.frame = B
							end
							peelout.angle = player.drawangle - ANGLE_90/6
						end
						peelout.renderflags = RF_PAPERSPRITE
						peelout.scale = player.realmo.scale/2
						if player.realmo.eflags & MFE_VERTICALFLIP
							peelout.eflags = $ | MFE_VERTICALFLIP
							peelout.z = player.realmo.z + player.realmo.height - peelout.height
						end
					end
				end
			end
		end
	end
end)