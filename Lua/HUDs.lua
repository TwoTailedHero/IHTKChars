local req = mapheaderinfo[gamemap].ptsr_s_rank_points or 10000
local actualhealth
local xpos = 254
local ypos = hudinfo[HUD_SCORE].y + 12
local healthbar
local smsoffsets = {
	[8] = {18, 36},
	[7] = {12, 61},
	[6] = {19, 83},
	[5] = {37, 98},
	[4] = {63, 95},
	[3] = {81, 82},
	[2] = {83, 57},
	[1] = {78, 34},
	[9] = {48, 60},
	[10] = {49, 16},
}

local function SMSunshineHUD(v,player)
	xpos = 265
	ypos = hudinfo[HUD_SCORE].y + 10
	local size = FRACUNIT/2
	local gain = (((leveltime%35)/23)%2)*FRACUNIT/6
	v.drawScaled((xpos+2)*FRACUNIT,
	(ypos+5)*FRACUNIT,
	FRACUNIT/2,
	v.cachePatch("SMSLIFEBG"),
	(min(V_40TRANS+v.localTransFlag(),V_90TRANS))<<V_ALPHASHIFT|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER,
	v.getColormap(nil, SKINCOLOR_ORANGE))
	v.drawScaled((xpos + (smsoffsets[9][1]/2))*FRACUNIT+(smsoffsets[9][1]%2*(FRACUNIT/2)),
	(ypos + (smsoffsets[9][2]/2))*FRACUNIT+(smsoffsets[9][2]%2*(FRACUNIT/2)), size+(gain/3),
	v.cachePatch("SMSLIFEMAINE"),
	V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
	if player.hp
		v.drawScaled((xpos + (smsoffsets[9][1]/2))*FRACUNIT+(smsoffsets[9][1]%2*(FRACUNIT/2)), (ypos + (smsoffsets[9][2]/2))*FRACUNIT+(smsoffsets[9][2]%2*(FRACUNIT/2)), size+(gain/3), v.cachePatch("SMSLIFEMAIN"), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
		if player.hp < 8 v.drawScaled((xpos + (smsoffsets[9][1]/2))*FRACUNIT+(smsoffsets[9][1]%2*(FRACUNIT/2)), (ypos + (smsoffsets[9][2]/2))*FRACUNIT+(smsoffsets[9][2]%2*(FRACUNIT/2)), size+(gain/3), v.cachePatch("SMSLIFEMAIN"), (min(((player.hp+2)<<V_ALPHASHIFT)+v.localTransFlag(),V_90TRANS))|V_REVERSESUBTRACT|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER) end
	end
	for i = 1, 8 do
		v.drawScaled((xpos + (smsoffsets[i][1]/2))*FRACUNIT+(smsoffsets[i][1]%2*(FRACUNIT/2)), (ypos + (smsoffsets[i][2]/2))*FRACUNIT+(smsoffsets[i][2]%2*(FRACUNIT/2)), size+gain, v.cachePatch("SMSLIFETICK\$i\E"), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
		if player.hp >=i
			v.drawScaled((xpos + (smsoffsets[i][1]/2))*FRACUNIT+(smsoffsets[i][1]%2*(FRACUNIT/2)), (ypos + (smsoffsets[i][2]/2))*FRACUNIT+(smsoffsets[i][2]%2*(FRACUNIT/2)), size+gain, v.cachePatch("SMSLIFETICK\$i\"), V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
		end
	end
	v.drawScaled((xpos + (smsoffsets[10][1]/2))*FRACUNIT+(smsoffsets[10][1]%2*(FRACUNIT/2)),
	(ypos + (smsoffsets[10][2]/2))*FRACUNIT+(smsoffsets[10][2]%2*(FRACUNIT/2)), FRACUNIT/2,
	v.cachePatch("SMSLIFETEXT"),
	V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
	if player.hp < 8 v.drawScaled((xpos + (smsoffsets[10][1]/2))*FRACUNIT+(smsoffsets[10][1]%2*(FRACUNIT/2)), (ypos + (smsoffsets[10][2]/2))*FRACUNIT+(smsoffsets[10][2]%2*(FRACUNIT/2)), FRACUNIT/2, v.cachePatch("SMSLIFETEXT"), (min(((player.hp+2)<<V_ALPHASHIFT)+v.localTransFlag(),V_90TRANS))|V_REVERSESUBTRACT|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER) end
	xpos = 265
	ypos = hudinfo[HUD_LIVES].y - 40
	gain = 0
	v.drawScaled((xpos+2)*FRACUNIT,
	(ypos+5)*FRACUNIT,
	FRACUNIT/2,
	v.cachePatch("SMSLIFEBG"),
	(min(V_40TRANS+v.localTransFlag(),V_90TRANS))<<V_ALPHASHIFT|V_SNAPTORIGHT|V_SNAPTOBOTTOM|V_PERPLAYER,
	v.getColormap(nil, SKINCOLOR_COBALT))
	v.drawFill((xpos+11), (ypos+40)-((player.smswater*30)/(100*FRACUNIT)), 5, (player.smswater*30)/(100*FRACUNIT), 131)
	v.drawFill((xpos+16), (ypos+40)-((player.smswater*30)/(100*FRACUNIT)), 16, (player.smswater*30)/(100*FRACUNIT), 133)
	xpos = 254
	ypos = hudinfo[HUD_SCORE].y + 50
end

local function RobloxHUD(v,player)
	xpos = 117
	ypos = 170
	v.draw(xpos, ypos, v.cachePatch("RBLXEDGE"), V_SNAPTOBOTTOM|V_PERPLAYER|V_FLIP)
	for i = 1,86 do
		v.draw(86+xpos-i, ypos, v.cachePatch("RBLXBACK"), V_SNAPTOBOTTOM|V_PERPLAYER)
		if (player.rblxhp*86)/(player.rblxmaxhp*FRACUNIT) >= i
			if player.rblxhp*4 <= player.rblxmaxhp*FRACUNIT
				v.draw(86+xpos-i, ypos, v.cachePatch("RBLXTICK"), V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_RED))
			else
				v.draw(86+xpos-i, ypos, v.cachePatch("RBLXTICK"), V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_GREEN))
			end
		elseif player.rblxouch and (player.rblxouch*80)/(player.rblxmaxhp*FRACUNIT) >= i and player.rblxouchclock
			local whitefade = player.rblxouchclock-15
			local redfade = 9-min(player.rblxouchclock,9)
			v.draw(86+xpos-i, ypos, v.cachePatch("RBLXOUCHTICK"), min((redfade<<V_ALPHASHIFT)+v.localTransFlag(),V_90TRANS)<<V_ALPHASHIFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_RED))
			v.draw(86+xpos-i, ypos, v.cachePatch("RBLXOUCHTICK"), min((whitefade<<V_ALPHASHIFT)+v.localTransFlag(),V_90TRANS)|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_WHITE))
		end
	end
	v.draw(xpos+86, ypos, v.cachePatch("RBLXEDGE"), V_SNAPTOBOTTOM|V_PERPLAYER)
	v.draw(xpos+86-1, ypos, v.cachePatch("RBLXTEXT"), V_SNAPTOBOTTOM|V_PERPLAYER)
	xpos = 254
	ypos = hudinfo[HUD_SCORE].y + 12
end

local minrings = 2

customhud.SetupFont("SMWLIFEFONT", -1, 8)
customhud.SetupFont("SMWHUDFONT", 0, 0, 8)

local function SMWHUD_Lives(v, player)
	local xpos = 68
	local ypos = 16
	local hudname = skins[player.mo.skin].hudname
	local lifeWidth = customhud.CustomFontStringWidth(v, hudname, "SMWLIFEFONT", 1)
	customhud.CustomFontString(v, xpos - lifeWidth/2, ypos, hudname, "SMWLIFEFONT", 0, "left", 1, player.skincolor)
	
	ypos = ypos + 7
	if G_GametypeUsesLives()
		local livesStr = (player.lives == INFLIVES) and "\22" or tostring(player.lives)
		local livesLen = #livesStr
		local lifeX = xpos - 12
		if livesLen > 2
			lifeX = lifeX - 8
		end
		customhud.CustomFontString(v, lifeX, ypos, "*", "SMWHUDFONT", 0, "left", 1, SKINCOLOR_WHITE)
		if livesLen < 2
			lifeX = lifeX + 8
		end
		customhud.CustomFontString(v, lifeX + 8, ypos, livesStr, "SMWHUDFONT", 0, "left", 1, SKINCOLOR_WHITE)
	end
end

local function SMWHUD_Treasure(v, player)
	if Style_Pack_Active return end

	local xpos = 136
	local ypos = 23
	local scoreStr = tostring(player.wl4score or 0)
	for i = 0, #scoreStr - 1 do
		 local digit = (player.wl4score or 0) / (10^i) % 10
		 if digit == 1 and i ~= (#scoreStr - 1)
			  digit = "1A"
		 end
		 local patchName = "SMWSTAR" .. tostring(digit)
		 v.draw(xpos - (i * 8), ypos - 8, v.cachePatch(patchName))
	end
end

local function SMWHUD_Time(v, player)
	local xpos = 208
	local ypos = 23
	local clockStr, clockpalette
	if kombi.hurryup
		clockStr = tostring((FixedMul(kombi.disptime, 5 * FRACUNIT / 2)) / TICRATE)
		clockpalette = ((leveltime / 4) % 2 == 0) and SKINCOLOR_BRONZE
		or SKINCOLOR_RED
	else
		clockStr = tostring((FixedMul(player.realtime, 5 * FRACUNIT / 2)) / TICRATE)
		clockpalette = SKINCOLOR_BRONZE
	end
	local timeWidth = customhud.CustomFontStringWidth(v, clockStr, "SMWHUDFONT", 1)
	customhud.CustomFontString(v, xpos - timeWidth, ypos, clockStr, "SMWHUDFONT", 0, "left", 1, clockpalette)
end

local function SMWHUD_Score(v, player)
	local xpos = 272
	local ypos = 23
	local scoreText = tostring(player.score)
	local scoreWidth = customhud.CustomFontStringWidth(v, scoreText, "SMWHUDFONT", 1)
	customhud.CustomFontString(v, xpos - scoreWidth, ypos, scoreText, "SMWHUDFONT", 0, "left", 1, SKINCOLOR_WHITE)
end

local function SMWHUD_Rings(v, player)
	local baseX = 272
	local ringsStr = tostring(player.rings)
	local adjust = max(0, #ringsStr - 2) * 8
	local xpos = baseX - adjust
	local ypos = 15
	customhud.CustomFontString(v, xpos - 40, ypos, "$", "SMWHUDFONT", 0, "left", 1, SKINCOLOR_BRONZE)
	customhud.CustomFontString(v, xpos - 32, ypos, "*", "SMWHUDFONT", 0, "left", 1, SKINCOLOR_WHITE)
	
	local coinpalette = (player.rings <= minrings) and (((leveltime / 8) % 2 == 0) and SKINCOLOR_WHITE or SKINCOLOR_RED) or SKINCOLOR_WHITE
	local xshift = min(0, #ringsStr - 2) * 8  -- compensates for one-digit rings
	customhud.CustomFontString(v, xpos - 16 - xshift, ypos, ringsStr, "SMWHUDFONT", 0, "left", 1, coinpalette)
end

local function SMWHUD_Reserve(v, player)
	local xpos = 152
	local ypos = 16
	v.draw(xpos, ypos, v.cachePatch("SMWRESERVEBOX"))
	local curreserve = kombiSMWItems[player.kombismwreserveitem]
	if curreserve and curreserve.hudgraphic
		v.draw(xpos, ypos, v.cachePatch(curreserve.hudgraphic))
	end
end

customhud.AddItem("lives", "ShaydeSMW", SMWHUD_Lives, "game", 0)
customhud.AddItem("treasure", "ShaydeSMW", SMWHUD_Treasure, "game", 0)
customhud.AddItem("time", "ShaydeSMW", SMWHUD_Time, "game", 0)
customhud.AddItem("score", "ShaydeSMW", SMWHUD_Score, "game", 0)
customhud.AddItem("rings", "ShaydeSMW", SMWHUD_Rings, "game", 0)
customhud.AddItem("reserve", "ShaydeSMW", SMWHUD_Reserve, "game", 0)

local shaydeunique = {
	disable = {
		["kerotime"] = true
	},
	mod = {
		["lives"] = "ShaydeSMW",
		["treasure"] = "ShaydeSMW",
		["time"] = "ShaydeSMW",
		["score"] = "ShaydeSMW",
		["rings"] = "ShaydeSMW",
		["reserve"] = "ShaydeSMW"
	}
}
customhud.AssignToCharacter("shayde", shaydeunique)

local kombiunique = {
	disable = {
		["reserve"] = true
	},
	mod = {
		["kerotime"] = "KombiWL4",
		["lives"] = "vanilla",
		["treasure"] = "KombiWL4",
		["time"] = "vanilla",
		["score"] = "vanilla",
		["rings"] = "vanilla",
		["health"] = "KombiWL4",
	}
}
customhud.AssignToCharacter("kombi", kombiunique)
customhud.AssignToCharacter("trez", kombiunique)

local strykeunique = {
	disable = {
		["reserve"] = true
	},
	mod = {
		["kerotime"] = "KombiWL4",
		["lives"] = "vanilla",
		["treasure"] = "KombiWL4",
		["time"] = "vanilla",
		["score"] = "vanilla",
		["rings"] = "vanilla",
		["health"] = "StrykeWLSI",
	}
}
customhud.AssignToCharacter("stryke", strykeunique)
-- TODO: Create a system where you can give any WL4 character a health HUD item not matching their game style and still have it look correct

local function WLShakeItHUD(v,player)
	xpos = 20
	if kombiwhogetswl4stuff[player.realmo.skin] == "wlsi"
		for i = 1,cv_kombiwlsihearts.value do
			if player.hp/2 >= i
				healthbar = v.cachePatch("SHAKEHP2")
			else
				if player.hp%2 == 1 and (player.hp/2)+1 >= i
					healthbar = v.cachePatch("SHAKEHP1")
				else
					healthbar = v.cachePatch("SHAKEHP0")
				end
			end
			v.draw(xpos+i*10, ypos, healthbar, V_40TRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
		end
	else
		if player.hp
			local shield = player.powers[pw_shield]
			local fireflower = (shield & SH_FIREFLOWER) >> 9
			local force = (shield & SH_FORCE) >> 8
			local forceHP = min((shield & SH_FORCEHP), (shield & SH_FORCE))
			local whirlwind = (shield & SH_WHIRLWIND) >> 1
			local pity = (shield & SH_PITY)
			actualhealth = player.hp + fireflower + ((force + forceHP) or whirlwind or pity)
		end
		for i = 1,max(actualhealth,cv_kombiwl4max.value) do
			if player.hp and player.hp >= i
				if actualhealth == 1 and ((leveltime + player.leveltimeadd) % 53 <= 24)
					healthbar = v.cachePatch("WARIOHPW")
					if (leveltime + player.leveltimeadd) % 53 == 0
						S_StartSound(player.mo, sfx_wllowh) -- I had to rip this myself. I really wish I didn't have to.
					end
				else
					healthbar = v.cachePatch("WARIOHPF")
				end
			else
				if actualhealth >= i
					if leveltime%2 == 0 -- funny blinking effect if a shield is active. not too epileptic since we have a background to go along with it (and sorta GBA-accurate!)
						healthbar = v.cachePatch("WARIOHPF")
					else
						healthbar = v.cachePatch("WARIOHPE")
					end
				else
					healthbar = v.cachePatch("WARIOHPE")
				end
			end
			v.draw(xpos+10*i, ypos, healthbar, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
		end
	end
	xpos = 254
end

local function WL4HUD(v,player)
	local actualhealth = 0
	if player.hp
		local shield = player.powers[pw_shield]
		local fireflower = (shield & SH_FIREFLOWER) >> 9
		local force = (shield & SH_FORCE) >> 8
		local forceHP = min((shield & SH_FORCEHP), (shield & SH_FORCE))
		local whirlwind = (shield & SH_WHIRLWIND) >> 1
		local pity = (shield & SH_PITY)
		actualhealth = player.hp + fireflower + ((force + forceHP) or whirlwind or pity)
	end
	xpos = 254
	ypos = hudinfo[HUD_SCORE].y + 12
	local offset = ((8-min(max(actualhealth,cv_kombiwl4max.value),8))*4)
	local tickbar
	if player.hpdivvies != nil and player.hpdivvies > -10 tickbar = v.cachePatch("TICKBAR\$player.hpdivvies\") end
	xpos = $ + offset
	for i = 1,max(actualhealth,cv_kombiwl4max.value) do -- TODO: how do I make this extend by the necessary empty hearts when we get a shield?
		if player.hp and player.hp >= i
			if actualhealth == 1 and ((leveltime + player.leveltimeadd) % 53 <= 24)
				healthbar = v.cachePatch("WARIOHPW")
				if (leveltime + player.leveltimeadd) % 53 == 0
					S_StartSound(player.mo, sfx_wllowh) -- I had to rip this myself. I really wish I didn't have to.
				end
			else
				healthbar = v.cachePatch("WARIOHPF")
			end
		else
			if actualhealth >= i
				if leveltime%2 == 0 -- funny blinking effect if a shield is active. not too epileptic since we have a background to go along with it (and sorta GBA-accurate!)
					healthbar = v.cachePatch("WARIOHPF")
				else
					healthbar = v.cachePatch("WARIOHPE")
				end
			else
				healthbar = v.cachePatch("WARIOHPE")
			end
		end
		v.draw(xpos+(8*(((i-1)%8))), ypos-(((i-1)/8)*-8), healthbar, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
	end
	xpos = $ - offset
	if tickbar
		ypos = $ + 7 + ((((max(actualhealth,cv_kombiwl4max.value)-1)/8))*8)
		v.draw(xpos, ypos, tickbar, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER)
	end
end

local SA2Bonuses = {
	{"Good!", SKINCOLOR_SAPPHIRE},
	{"Nice!", SKINCOLOR_SKY},
	{"Great!", SKINCOLOR_AQUA},
	{"Jammin'!", SKINCOLOR_PERIDOT},
	{"Cool!", SKINCOLOR_YELLOW},
	{"Radical!", SKINCOLOR_SUNSET},
	{"Tight!", SKINCOLOR_ORANGE},
	{"Awesome!", SKINCOLOR_FLAME},
	{"Extreme!", SKINCOLOR_MAGENTA},
	{"Perfect!", true},
}

local perfectColors = {
	SKINCOLOR_SAPPHIRE,
	SKINCOLOR_AQUA,
	SKINCOLOR_SKY,
	SKINCOLOR_PERIDOT,
	SKINCOLOR_YELLOW,
	SKINCOLOR_SUNSET,
	SKINCOLOR_ORANGE,
	SKINCOLOR_FLAME,
	SKINCOLOR_MAGENTA,
	SKINCOLOR_GREEN, -- still haven't done these lmao
	SKINCOLOR_GREEN
};

local coolBonuses = {100,200,300,400,500,600,800,1000,1500,2000}

local gameHUDs = {
	["sms"] = SMSunshineHUD,
	["rblx"] = RobloxHUD,
	["wlsi"] = WLShakeItHUD,
	["wl4"] = WL4HUD,
}

local boostticks = 16

local function RushBoostMeter(v, player)
	if not player.kombiboost return end

	local xpos = 280
	local ypos = 54 + (boostticks * 7)

	-- Cache patches beforehand
	local tensionPatch = v.cachePatch("KOMBITENSION0")
	local rushPatch = v.cachePatch("KOMBITENSION4")

	if player.kombirushclock or player.powers[pw_super]
		-- Draw rush boost ticks in one go
		local colormap
		if not player.powers[pw_super]
			colormap = v.getColormap(nil, (leveltime / 3 % 79) + 31)
		else
			colormap = v.getColormap(nil, player.mo.color)
		end
		for i = 1, boostticks do
			local y = ypos - (i * 7)
			v.draw(xpos, y, rushPatch, V_SNAPTOBOTTOM | V_PERPLAYER, colormap)
		end
	else
		-- Draw base tension bars
		for i = 1, boostticks do
			local y = ypos - (i * 7)
			v.draw(xpos, y, tensionPatch, V_SNAPTOBOTTOM | V_PERPLAYER)
		end

		local curboost = player.kombiboost
		local maxPerStage = 100 * FRACUNIT

		for stage = 1, 3 do
			if curboost <= 0 break end

			-- Let's see here... what do we need for this stage?
			local stageBoost = min(curboost, maxPerStage)
			local tickPatch = v.cachePatch("KOMBITENSION" .. stage)
			local numTicks = (stageBoost * boostticks) / maxPerStage

			for d = 1, numTicks do
				local y = ypos - (d * 7)
				v.draw(xpos, y, tickPatch, V_SNAPTOBOTTOM | V_PERPLAYER)
			end

			curboost = curboost - maxPerStage
		end
	end
end

local function RBLXBoostMeter(v,player)
	xpos = 117
	ypos = 180
	v.draw(xpos, ypos, v.cachePatch("RBLXEDGE"), V_SNAPTOBOTTOM|V_PERPLAYER|V_FLIP)
	for i = 1,86 do
		v.draw(86+xpos-i, ypos, v.cachePatch("RBLXBACK"), V_SNAPTOBOTTOM|V_PERPLAYER)
	end
	local ourboost = (player.kombiboost or 0)/10
	if ourboost
		local colorize = (ourboost > 0 and not (player.powers[pw_carry]) and not player.kombishouldroll)
		for i = 1,(ourboost*86)/(10*FRACUNIT) do
			if ourboost*4 <= 10*FRACUNIT
				v.draw(86+xpos-i, ypos, v.cachePatch("RBLXTICK"), V_SNAPTOBOTTOM|V_PERPLAYER, colorize and v.getColormap(nil, SKINCOLOR_RED) or v.getColormap(nil, SKINCOLOR_GREY))
			else
				if i > 86
					v.draw(86+xpos-i, ypos, v.cachePatch("RBLXTICK"), V_SNAPTOBOTTOM|V_PERPLAYER, colorize and v.getColormap(nil, (leveltime/5%79)+31) or v.getColormap(nil, SKINCOLOR_GREY))
				else
					v.draw(86+xpos-i, ypos, v.cachePatch("RBLXTICK"), V_SNAPTOBOTTOM|V_PERPLAYER, colorize and v.getColormap(nil, player.realmo.color) or v.getColormap(nil, SKINCOLOR_GREY))
				end
			end
		end
	end
	v.draw(xpos+86, ypos, v.cachePatch("RBLXEDGE"), V_SNAPTOBOTTOM|V_PERPLAYER)
	v.draw(xpos+85, ypos, v.cachePatch("RBLXBOOSTTEXT"), V_SNAPTOBOTTOM|V_PERPLAYER)
	local offset = 0
	if ourboost
		for i = 0,3 do
			local frame = (max(FixedInt(ourboost*100),0))/(10^i)%10
			if FixedInt(ourboost*100) < 10^i and 10^i > 10
				frame = ""
			end
			if i < 1
				v.drawScaled((110-offset)*FRACUNIT, FRACUNIT/2+(3+ypos)*FRACUNIT, FRACUNIT/2, v.cachePatch("2011RBLX\$frame\"), V_SNAPTOTOP|V_PERPLAYER)
			else
				v.drawScaled((110-offset)*FRACUNIT, (1+ypos)*FRACUNIT, FRACUNIT, v.cachePatch("2011RBLX\$frame\"), V_SNAPTOTOP|V_PERPLAYER)
			end
			if i < 0 offset = $+3 else offset = $+6 end
		end
	end
end

customhud.AddItem("health", "KombiWL4", WL4HUD, "game", 0)
customhud.AddItem("health", "StrykeWLSI", WLShakeItHUD, "game", 0)
customhud.AddItem("health", "TynkerSMS", SMSunshineHUD, "game", 0)
customhud.AddItem("health", "MiscRBLX", RobloxHUD, "game", 0)
/*
customhud.AddItem("boost", "MiscRBLX", RBLXBoostMeter, "game", 0)
customhud.AddItem("boost", "SEGARush", RushBoostMeter, "game", 0)
*/
hud.add(function(v,player)
	if not player.mo return end
		if player.realmo and kombiwhogetswl4stuff[player.realmo.skin]
			if not srb2p
				if not (maptol & TOL_NIGHTS)
					/*
					if CV_FindVar("k_wl4health").string == "On"
						gameHUDs[kombiwhogetswl4stuff[player.realmo.skin]](v,player)
					end
					*/
				end
			end
		/*
		if player.mo and player.mo.skin == "kombi"
			local playnum = player.kombimode or 0
			local playtype = v.cachePatch("ABILSET\$playnum\")
			if ((player.pflags & PF_THOKKED) or not (not P_IsObjectOnGround(player.realmo) and (player.pflags & PF_JUMPED)))
				v.draw(xpos+32, ypos+8, playtype, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, player.realmo.color))
				v.draw(xpos+32, ypos+8, playtype, min((4<<V_ALPHASHIFT)+v.localTransFlag(),V_90TRANS)|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_BONE))
			else
				v.draw(xpos+32, ypos+8, playtype, V_HUDTRANS|V_SNAPTORIGHT|V_SNAPTOTOP|V_PERPLAYER, v.getColormap(nil, player.realmo.color))
			end
		end
		*/
	end
	if kombiglobalhint:len()
		local kombihintxpos = 0
		local kombihintypos = 3*FRACUNIT/4
		v.drawFill(0, 0, 1000, 10, 31)
		for i = 1,kombiglobalhint:len() do
			local dothis = v.cachePatch("KMBIARIAL\$kombiglobalhint:byte(i,i)\")
			v.drawScaled(kombihintxpos, kombihintypos, FRACUNIT/5, dothis, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SKINCOLOR_WHITE))
			kombihintxpos = $+(dothis.width*FRACUNIT/5)+(FRACUNIT*6/5)
		end
	end
	xpos = 235
	ypos = 18
	if mapheaderinfo[gamemap].ptsr_maxportals
		req = mapheaderinfo[gamemap].ptsr_s_rank_points or 10000
	else
		req = (mapheaderinfo[gamemap].ptsr_s_rank_points or 10000)/2 -- divide by 2 because it's very likely we can't meet the score requirement
	end
	if player.mo.skin != "kombifreeman" and kombiwhogetswl4stuff[player.mo.skin] != "smw"
		v.draw(xpos, ypos, v.cachePatch("WL4NONECROWN"), V_SNAPTOTOP|V_PERPLAYER)
		local per = FixedDiv(player.wl4score, req/4)
		v.drawCropped(xpos*FRACUNIT, ypos*FRACUNIT, FRACUNIT, FRACUNIT, v.cachePatch("WL4BRNZCROWN"), 0, nil, 0, 0, per*16, 13*FRACUNIT) -- Crown sprites are always 16x13. Stupid hardcode? Who cares!
		local per = FixedDiv(player.wl4score-req/4, req/2-req/4)
		v.drawCropped(xpos*FRACUNIT, ypos*FRACUNIT, FRACUNIT, FRACUNIT, v.cachePatch("WL4SILVCROWN"), 0, nil, 0, 0, max(0,per*16), 13*FRACUNIT)
		local per = FixedDiv(player.wl4score-req/2, req-req/2)
		v.drawCropped(xpos*FRACUNIT, ypos*FRACUNIT, FRACUNIT, FRACUNIT, v.cachePatch("WL4GOLDCROWN"), 0, nil, 0, 0, max(0,per*16), 13*FRACUNIT)
	end
	local kmbibonusypos = 56
	for k,b in ipairs(player.kombibonuses or {}) do
		if b['bclock'] > TICRATE
			local kmbibonus = tostring(coolBonuses[b['btype']])
			local kmbibonusxpos = 15
			for i = 1,kmbibonus:len() do
				local dothis = v.cachePatch("GMSFT\$kmbibonus:byte(i,i)\")
				if SA2Bonuses[b['btype']][2] == true
					v.draw(kmbibonusxpos, kmbibonusypos, dothis, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, perfectColors[((i+(leveltime/4))%11)+1]))
				else
					v.draw(kmbibonusxpos, kmbibonusypos, dothis, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SA2Bonuses[b['btype']][2]))
				end
				kmbibonusxpos = $+dothis.width
			end
			kmbibonusypos = $+8
		else
			local kmbibonus = SA2Bonuses[b['btype']][1]
			local kmbibonusxpos = (15+(TICRATE/2)*8)-(min(b['bclock'],(TICRATE/2))*8)
			for i = 1,kmbibonus:len() do
				local dothis = v.cachePatch("GMSFT\$kmbibonus:byte(i,i)\")
				if SA2Bonuses[b['btype']][2] == true
					v.draw(kmbibonusxpos, kmbibonusypos, dothis, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, perfectColors[((i+(leveltime/4))%11)+1]))
				else
					v.draw(kmbibonusxpos, kmbibonusypos, dothis, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER, v.getColormap(nil, SA2Bonuses[b['btype']][2]))
				end
				kmbibonusxpos = $+dothis.width
			end
			kmbibonusypos = $+8
		end
	end
	-- kombiDrawSpinballFont(v,"spinnin my balls",0,0,nil,FRACUNIT/3,v.getColormap(nil, SKINCOLOR_KOMBI_CUSTOM_SPINBALLDISP1))
end)