-- P_CheckSkyHit(mo, line)
rawset(_G, "P_IsClimbingValid",function(player, angle)

	local platx, platy
	local glidesector
	local floorz, ceilingz
	local mo = player.realmo
	local rover

	platx = P_ReturnThrustX(mo, angle, mo.radius + FixedMul(8*FRACUNIT, mo.scale))
	platy = P_ReturnThrustY(mo, angle, mo.radius + FixedMul(8*FRACUNIT, mo.scale))

	glidesector = R_PointInSubsector(mo.x + platx, mo.y + platy).sector

	floorz = glidesector.floorheight
	ceilingz = glidesector.ceilingheight

	if (glidesector ~= mo.subsector.sector)
	
		local floorclimb = false
		local topheight, bottomheight

		for rover in glidesector.ffloors()
		
			if (not (rover.flags & FF_EXISTS) or not (rover.flags & FF_BLOCKPLAYER))
				continue
			end

			topheight = rover.topheight
			bottomheight = rover.bottomheight

			floorclimb = true

			if (mo.eflags & MFE_VERTICALFLIP)
			
				if ((topheight < mo.z + mo.height) and ((mo.z + mo.height + mo.momz) < topheight))
					floorclimb = true
				end
				if (topheight < mo.z)
					floorclimb = false
				end
				if (bottomheight > mo.z + mo.height - FixedMul(16*FRACUNIT,mo.scale))
					floorclimb = false
				end
			else
			
				if ((bottomheight > mo.z) and ((mo.z - mo.momz) > bottomheight))
					floorclimb = true
				end
				if (bottomheight > mo.z + mo.height)
					floorclimb = false
				end
				if (topheight < mo.z + FixedMul(16*FRACUNIT,mo.scale))
					floorclimb = false
				end
			end

			if (floorclimb)
				break
			end
		end

		if (mo.eflags & MFE_VERTICALFLIP)
		
			if ((floorz <= mo.z + mo.height)
				and ((mo.z + mo.height - mo.momz) <= floorz))
				floorclimb = true
			end

			if ((floorz > mo.z)
				and glidesector.floorpic == "F_SKY1")
				return false
			end

			if ((mo.z + mo.height - FixedMul(16*FRACUNIT,mo.scale) > ceilingz)
				or (mo.z + mo.height <= floorz))
				floorclimb = true
			end
		else
		
			if ((ceilingz >= mo.z)
				and ((mo.z - mo.momz) >= ceilingz))
				floorclimb = true
			end

			if ((ceilingz < mo.z+mo.height)
				and glidesector.ceilingpic == "F_SKY1")
				return false
			end

			if ((mo.z + FixedMul(16*FRACUNIT,mo.scale) < floorz)
				or (mo.z >= ceilingz))
				floorclimb = true
			end
		end

		if (not floorclimb)
			return false
		end

		return true
	else
		return true
	end

	return false
end)

rawset(_G,"PTR_GlideClimbTraverse",function(slidemo,li)
	local checkline = li
	local rover
	local topheight, bottomheight
	local fofline = false
	if li == nil then return end
	local checksector = (li.backsector and not P_PointOnLineSide(slidemo.x, slidemo.y, li)) and li.backsector or li.frontsector

	if (checksector.ffloors)
		for rover in checksector.ffloors()
			if (not(rover.flags & FF_EXISTS) or not(rover.flags & FF_BLOCKPLAYER) or ((rover.flags & FF_BUSTUP) and (slidemo.player.charflags & SF_CANBUSTWALLS)))
				continue
			end

			topheight = rover.topheight
			bottomheight = rover.bottomheight

			if (topheight < slidemo.z)
				continue
			end

			if (bottomheight > slidemo.z + slidemo.height)
				continue
			end

			// Got this far, so I guess it's climbable. // TODO: Climbing check, also, better method to do this?
			if (rover.master.flags & ML_TFERLINE)
				local linenum = checksector.lines[0]
				checkline = rover.master.frontsector.lines[0] + linenum
				fofline = true
			end

			break
		end
	end

	// see about climbing on the wall
	if (not(checkline.flags & ML_NOCLIMB) and checkline.special ~= 41)
		local canclimb
		local climbangle, climbline
		local whichside = P_PointOnLineSide(slidemo.x, slidemo.y, li)

		climbangle = R_PointToAngle2(li.v1.x, li.v1.y, li.v2.x, li.v2.y)
		climbline = climbangle

		if (whichside) // on second side?
			climbline = $+ ANGLE_180
		end

		climbangle = $+ (ANGLE_90 * (whichside and -1 or 1))

		canclimb = (li.backsector and P_IsClimbingValid(slidemo.player, climbangle) or true)

		if (((not slidemo.player.climbing and abs((slidemo.angle - ANGLE_90 - climbline)) < ANGLE_45)
		or (slidemo.player.climbing == 1 and abs((slidemo.angle - climbline)) < ANGLE_135))
		and canclimb) 
			return true,climbangle
		end
	end
	return false,0
end)