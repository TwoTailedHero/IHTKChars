COM_AddCommand("k_openmenu", function(player)
	if not player
		return
	end
	player.inkombimenu = ($ != true)
	if player.inkombimenu
		S_ChangeMusic("_s2opt", true, player)
	else
		COM_BufInsertText(player, "tunes -default")
	end
end)

COM_AddCommand("k_illyourself", function(player)
	if not (player and player.mo)
		return
	end
	P_KillMobj(player.mo, player.mo, player.mo, DMG_SPECTATOR|DMG_CANHURTSELF)
end)

hud.add(function(v,player)
	if player.inkombimenu == true
		local alphalevel = 10-min((player.kombimenutimer or 0)/4, 8)
		local truealpha
		if alphalevel == 0
			truealpha = 0
		elseif alphalevel == 10
			return
		end
		truealpha = (alphalevel or 0)<<V_ALPHASHIFT
		local xpos = 0
		local ypos = 0
		local width = v.width()
		local height = v.height()
		local graphic = v.cachePatch("SRB2BACK")
		local repeatx = width/136
		local repeaty = height/32
		local gw = graphic.width
		local gh = graphic.height
		for i = 0, repeaty do
			for i = 0, repeatx do
				v.draw(xpos, ypos, graphic, truealpha|V_SNAPTOLEFT|V_SNAPTOTOP)
				xpos = $+gw
			end
			xpos = 0
			ypos = $+gh
		end
	end
end, "game")

addHook("PlayerThink", function(player)
	if player.inkombimenu
		player.kombimenutimer = ($ or 0) + 1
	else
		player.kombimenutimer = nil
	end
	if player.charability == CA_GLIDEANDCLIMB and player.glidetime
		player.powers[pw_strong] = STR_GLIDE
	end
end)

