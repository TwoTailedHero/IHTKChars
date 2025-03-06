local lineheight = 13
local KOMBI_CREDIT_CAMY = -200+lineheight
local fadedivisor = 6
local fade = -40
local credtime = 0
local creditSlideshowFadeTime = TICRATE
local creditSlideshowShowTime = TICRATE*127/3

addHook("ThinkFrame", function(player)
	for player in players.iterate do
		if kombi.candosa1credits and not player.realmo.state == S_PLAY_STND
			player.realmo.state = S_PLAY_STND
		end
		if mapheaderinfo[gamemap].nextlevel > 1100 and player.exiting and player.exiting < 2 and not kombi.candosa1credits
			G_SetCustomExitVars(743, 1)
			G_ExitLevel()
			player.exiting = 0
		end
		if player.wldestlevel and player.exiting and player.exiting < 2 -- hook into here because contrary to popular belief i DON'T want to pollute the BLUA handler with more ThinkFrames than there should be
			G_SetCustomExitVars(player.wldestlevel, 1)
			G_ExitLevel()
			player.exiting = 0
		end
		if fade-(fadedivisor*10) >= 196
			fade = -40
			KOMBI_CREDIT_CAMY = -188
			G_SetCustomExitVars(1101, 2)
			G_ExitLevel()
			player.exiting = 0
		end
	end
end)

addHook("MapChange", function()
	if OLDC and OLDC.SetSkinFullName and not OLDC.SkinFullNames["kombi"] -- hook into our mapchange so we both ensure our OLDC names get set and we don't run this every tic
		OLDC.SetSkinFullName("kombi", "KOMBI THE RABBIT")
		OLDC.SetSkinFullName("trez", "TREZ THE HEDGEHOG")
		OLDC.SetSkinFullName("shayde", "SHAYDE THE RABBIT")
		OLDC.SetSkinFullName("stryke", "STRYKE THE BEAR")
	end
	KOMBI_CREDIT_CAMY = -188
	credtime = 0
end)

local CREDIT_HEADER = 8
local CREDIT_NORMAL = 20
local CREDIT_CENTER = INT16_MAX

local creditsList = {
{'IHTKChars Credits', CREDIT_CENTER},
{'', CREDIT_NORMAL},
{'Programming', CREDIT_HEADER},
{'"I Hate Those Koopalings"', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Open Assets', CREDIT_HEADER},
{'"SP Moves Enjoyer"', CREDIT_NORMAL},
{'"MotdSpork"', CREDIT_NORMAL},
{'"aquaponiee"', CREDIT_NORMAL},
{'"Sls64LGamingBro"', CREDIT_NORMAL},
{'"Buggie"', CREDIT_NORMAL},
{'"Golden Shine"', CREDIT_NORMAL},
{'"Wumbo"', CREDIT_NORMAL},
{'"Cobaltn\'t"', CREDIT_NORMAL},
{'"Gomynola"', CREDIT_NORMAL},
{'"Biff"', CREDIT_NORMAL},
{'"romoney5"', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Character Design', CREDIT_HEADER},
{'"I Hate Those Koopalings"', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Game Credits', CREDIT_HEADER},
{'SEGA - Sonic Adventure', CREDIT_NORMAL},
{'SEGA - Sonic the Hedgehog 3', CREDIT_NORMAL},
{'SEGA - Sonic the Hedgehog CD', CREDIT_NORMAL},
{'Nintendo - Wario Land 4', CREDIT_NORMAL},
{'Nintendo - Wario Land: Shake it!', CREDIT_NORMAL},
{'Nintendo - Super Mario Sunshine', CREDIT_NORMAL},
{'Nintendo - Super Metroid', CREDIT_NORMAL},
{'Tour de Pizza - Pizza Tower', CREDIT_NORMAL},
{'Capcom - Mega Man X', CREDIT_NORMAL},
{'Nintendo - Donkey Kong Country', CREDIT_NORMAL},
{'Nintendo - Super Mario World', CREDIT_NORMAL},
{'Nintendo - Super Mario Galaxy', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Music and Sound FX', CREDIT_HEADER},
{'Tour de Pizza - Pizza Tower', CREDIT_NORMAL},
{'SEGA - Sonic Adventure', CREDIT_NORMAL},
{'Nintendo - Wario Land 3', CREDIT_NORMAL},
{'Nintendo - Wario Land 4', CREDIT_NORMAL},
{'Nintendo - Super Mario World', CREDIT_NORMAL},
{'Nintendo - Super Mario 64', CREDIT_NORMAL},
{'Nintendo - Earthbound', CREDIT_NORMAL},
{'VALVe - Half-Life', CREDIT_NORMAL},
{'id Software - DOOM', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Level Design', CREDIT_HEADER},
{'"Speedcore Tempest"', CREDIT_NORMAL},
{'"Pyrodiac"', CREDIT_NORMAL},
{'Art', CREDIT_HEADER},
{'Sonic Team', CREDIT_NORMAL},
{'"TehRealSalt"', CREDIT_NORMAL},
{'"GameMaster12"', CREDIT_NORMAL},
{'Yoichi Kotabe', CREDIT_NORMAL},
{'John Duggan', CREDIT_NORMAL},
{'Dhabih Eng', CREDIT_NORMAL},
{'Chuck Jones', CREDIT_NORMAL},
{'Shigefumi Hino', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Sonic Robo Blast 2 Credits', CREDIT_CENTER},
{'', CREDIT_NORMAL},
{'Game Design', CREDIT_HEADER},
{'Sonic Team Junior', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'Johnny "Sonikku" Wallbank', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Programming', CREDIT_HEADER},
{'"altaluna"', CREDIT_NORMAL},
{'Alam "GBC" Arias', CREDIT_NORMAL},
{'Logan "GBA" Arias', CREDIT_NORMAL},
{'Zolton "Zippy_Zolton" Auburn', CREDIT_NORMAL},
{'Colette "fickleheart" Bordelon', CREDIT_NORMAL},
{'Andrew "orospakr" Clunis', CREDIT_NORMAL},
{'Sally "TehRealSalt" Cochenour', CREDIT_NORMAL},
{'Gregor "Oogaland" Dick', CREDIT_NORMAL},
{'Callum Dickinson', CREDIT_NORMAL},
{'Scott "Graue" Feeney', CREDIT_NORMAL},
{'Victor "SteelT" Fuentes', CREDIT_NORMAL},
{'Nathan "Jazz" Giroux', CREDIT_NORMAL},
{'"Golden"', CREDIT_NORMAL},
{'Vivian "toaster" Grannell', CREDIT_NORMAL},
{'Julio "Chaos Zero 64" Guir', CREDIT_NORMAL},
{'"Hanicef"', CREDIT_NORMAL},
{'"Hannu_Hanhi"', CREDIT_NORMAL},
{'"hazepastel"', CREDIT_NORMAL},
{'Kepa "Nev3r" Iceta', CREDIT_NORMAL},
{'Thomas "Shadow Hog" Igoe', CREDIT_NORMAL},
{'Iestyn "Monster Iestyn" Jealous', CREDIT_NORMAL},
{'"Kaito Sinclaire"', CREDIT_NORMAL},
{'"Kalaron"', CREDIT_NORMAL},
{'Ronald "Furyhunter" Kinard', CREDIT_NORMAL},
{'"Lat\'"', CREDIT_NORMAL},
{'"LZA"', CREDIT_NORMAL},
{'Matthew "Shuffle" Marsalko', CREDIT_NORMAL},
{'Steven "StroggOnMeth" McGranahan', CREDIT_NORMAL},
{'"Morph"', CREDIT_NORMAL},
{'Louis-Antoine "LJ Sonic" de Moulins', CREDIT_NORMAL},
{'John "JTE" Muniz', CREDIT_NORMAL},
{'Colin "Sonict" Pfaff', CREDIT_NORMAL},
{'James "james" Robert Roman', CREDIT_NORMAL},
{'Sean "Sryder13" Ryder', CREDIT_NORMAL},
{'Ehab "Wolfy" Saeed', CREDIT_NORMAL},
{'Tasos "tatokis" Sahanidis', CREDIT_NORMAL},
{'Riku "Ors" Salminen', CREDIT_NORMAL},
{'Jonas "MascaraSnake" Sauer', CREDIT_NORMAL},
{'Wessel "sphere" Smit', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'"VelocitOni"', CREDIT_NORMAL},
{'Ikaro "Tatsuru" Vinhas', CREDIT_NORMAL},
{'Ben "Cue" Woodford', CREDIT_NORMAL},
{'Lachlan "Lach" Wright', CREDIT_NORMAL},
{'Marco "mazmazz" Zafra', CREDIT_NORMAL},
{'"Zwip-Zwap Zapony"', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Art', CREDIT_HEADER},
{'Victor "VAdaPEGA" Ara\x1fjo', CREDIT_NORMAL},
{'"Arrietty"', CREDIT_NORMAL},
{'Ryan "Blaze Hedgehog" Bloom', CREDIT_NORMAL},
{'Graeme P. "SuperPhanto" Caldwell', CREDIT_NORMAL},
{'"ChrispyPixels"', CREDIT_NORMAL},
{'Paul "Boinciel" Clempson', CREDIT_NORMAL},
{'Sally "TehRealSalt" Cochenour', CREDIT_NORMAL},
{'"Dave Lite"', CREDIT_NORMAL},
{'Desmond "Blade" DesJardins', CREDIT_NORMAL},
{'Sherman "CoatRack" DesJardins', CREDIT_NORMAL},
{'"DirkTheHusky"', CREDIT_NORMAL},
{'Jesse "Jeck Jims" Emerick', CREDIT_NORMAL},
{'"Fighter_Builder"', CREDIT_NORMAL},
{'Buddy "KinkaJoy" Fischer', CREDIT_NORMAL},
{'Vivian "toaster" Grannell', CREDIT_NORMAL},
{'James "SwitchKaze" Hale', CREDIT_NORMAL},
{'James "SeventhSentinel" Hall', CREDIT_NORMAL},
{'Kepa "Nev3r" Iceta', CREDIT_NORMAL},
{'Iestyn "Monster Iestyn" Jealous', CREDIT_NORMAL},
{'William "GuyWithThePie" Kloppenberg', CREDIT_NORMAL},
{'Alice "Alacroix" de Lemos', CREDIT_NORMAL},
{'Logan "Hyperchaotix" McCloud', CREDIT_NORMAL},
{'Alexander "DrTapeworm" Moench-Ford', CREDIT_NORMAL},
{'Andrew "Senku Niola" Moran', CREDIT_NORMAL},
{'"MotorRoach"', CREDIT_NORMAL},
{'Phillip "TelosTurntable" Robinson', CREDIT_NORMAL},
{'"Scizor300"', CREDIT_NORMAL},
{'Wessel "sphere" Smit', CREDIT_NORMAL},
{'David "Instant Sonic" Spencer Jr.', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'Daniel "Inazuma" Trinh', CREDIT_NORMAL},
{'"VelocitOni"', CREDIT_NORMAL},
{'Jarrett "JEV3" Voight', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Music and Sound Production', CREDIT_HEADER},
{'Victor "VAdaPEGA" Ara\x1fjo', CREDIT_NORMAL},
{'Malcolm "RedXVI" Brown', CREDIT_NORMAL},
{'Dave "DemonTomatoDave" Bulmer', CREDIT_NORMAL},
{'Paul "Boinciel" Clempson', CREDIT_NORMAL},
{'"Cyan Helkaraxe"', CREDIT_NORMAL},
{'Claire "clairebun" Ellis', CREDIT_NORMAL},
{'James "SeventhSentinel" Hall', CREDIT_NORMAL},
{'Kepa "Nev3r" Iceta', CREDIT_NORMAL},
{'Iestyn "Monster Iestyn" Jealous', CREDIT_NORMAL},
{'Jarel "Arrow" Jones', CREDIT_NORMAL},
{'Alexander "DrTapeworm" Moench-Ford', CREDIT_NORMAL},
{'Stefan "Stuf" Rimalia', CREDIT_NORMAL},
{'Shane Mychal Sexton', CREDIT_NORMAL},
{'Dave "Big Wave Dave" Spencer', CREDIT_NORMAL},
{'David "instantSonic" Spencer', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Level Design', CREDIT_HEADER},
{'Colette "fickleheart" Bordelon', CREDIT_NORMAL},
{'Hank "FuriousFox" Brannock', CREDIT_NORMAL},
{'Matthew "Fawfulfan" Chapman', CREDIT_NORMAL},
{'Paul "Boinciel" Clempson', CREDIT_NORMAL},
{'Sally "TehRealSalt" Cochenour', CREDIT_NORMAL},
{'Desmond "Blade" DesJardins', CREDIT_NORMAL},
{'Sherman "CoatRack" DesJardins', CREDIT_NORMAL},
{'Ben "Mystic" Geyer', CREDIT_NORMAL},
{'Nathan "Jazz" Giroux', CREDIT_NORMAL},
{'Vivian "toaster" Grannell', CREDIT_NORMAL},
{'James "SeventhSentinel" Hall', CREDIT_NORMAL},
{'Kepa "Nev3r" Iceta', CREDIT_NORMAL},
{'Thomas "Shadow Hog" Igoe', CREDIT_NORMAL},
{'"Kaito Sinclaire"', CREDIT_NORMAL},
{'Alexander "DrTapeworm" Moench-Ford', CREDIT_NORMAL},
{'"Revan"', CREDIT_NORMAL},
{'Anna "QueenDelta" Sandlin', CREDIT_NORMAL},
{'Wessel "sphere" Smit', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'Rob Tisdell', CREDIT_NORMAL},
{'"Torgo"', CREDIT_NORMAL},
{'Jarrett "JEV3" Voight', CREDIT_NORMAL},
{'Johnny "Sonikku" Wallbank', CREDIT_NORMAL},
{'Marco "mazmazz" Zafra', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Boss Design', CREDIT_HEADER},
{'Ben "Mystic" Geyer', CREDIT_NORMAL},
{'Vivian "toaster" Grannell', CREDIT_NORMAL},
{'Thomas "Shadow Hog" Igoe', CREDIT_NORMAL},
{'John "JTE" Muniz', CREDIT_NORMAL},
{'Samuel "Prime 2.0" Peters', CREDIT_NORMAL},
{'"SSNTails"', CREDIT_NORMAL},
{'Johnny "Sonikku" Wallbank', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Testing', CREDIT_HEADER},
{'Discord Community Testers', CREDIT_NORMAL},
{'Hank "FuriousFox" Brannock', CREDIT_NORMAL},
{'Cody "Playah" Koester', CREDIT_NORMAL},
{'Skye "OmegaVelocity" Meredith', CREDIT_NORMAL},
{'Stephen "HEDGESMFG" Moellering', CREDIT_NORMAL},
{'Rosalie "ST218" Molina', CREDIT_NORMAL},
{'Samuel "Prime 2.0" Peters', CREDIT_NORMAL},
{'Colin "Sonict" Pfaff', CREDIT_NORMAL},
{'Bill "Tets" Reed', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Special Thanks', CREDIT_HEADER},
{'id Software', CREDIT_NORMAL},
{'Doom Legacy Project', CREDIT_NORMAL},
{'FreeDoom Project', CREDIT_NORMAL},
{'Kart Krew', CREDIT_NORMAL},
{'Alex "MistaED" Fuller', CREDIT_NORMAL},
{'Howard Drossin', CREDIT_NORMAL},
{'Pascal "CodeImp" vd Heiden', CREDIT_NORMAL},
{'Randi Heit (<!>)', CREDIT_NORMAL},
{'Simon "sirjuddington" Judd', CREDIT_NORMAL},
{'SRB2 Community Contributors', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Produced By', CREDIT_HEADER},
{'Sonic Team Junior', CREDIT_NORMAL},
{'', CREDIT_NORMAL},
{'Published By', CREDIT_HEADER},
{'A 28K dialup modem', CREDIT_NORMAL},
}

hud.add(function(v,player)
	if gamemap == 743
		v.drawFill(INT16_MIN, INT16_MIN, UINT16_MAX, UINT16_MAX, 31)
		local startIndex = max(FixedCeil((KOMBI_CREDIT_CAMY/lineheight)*FRACUNIT)/FRACUNIT, 1)
		if startIndex > #creditsList
			fade = $+1
			local fadeflags
			if fade > -1 and fade < 196
				fadeflags = 0
			elseif fade >= 196
				fadeflags = abs(fade-196)/4
			else
				fadeflags = abs(fade)/4
			end
			if fadeflags < 10
				v.drawScaled(0, 0, FRACUNIT/2, v.cachePatch("SA1SONICENDSCREEN"), min(589824,max(0,fadeflags<<V_ALPHASHIFT)))
			end
		else
			if credtime%5 <= 2
				KOMBI_CREDIT_CAMY = $+1
			end
			credtime = $+1
			for i = startIndex,#creditsList do
				local ypos = i*lineheight-KOMBI_CREDIT_CAMY
				if ypos > 320 return end
				local credstring = creditsList[i][1]
				if not credstring continue end
				if creditsList[i][2] != CREDIT_NORMAL
					if creditsList[i][2] == CREDIT_CENTER
						v.drawFill(160-v.stringWidth(credstring, V_ALLOWLOWERCASE, "thin")/2, ypos+7, v.stringWidth(credstring, V_ALLOWLOWERCASE, "thin"), 1, 38)
					else
						v.drawFill(creditsList[i][2], ypos+7, v.stringWidth(credstring, V_ALLOWLOWERCASE, "thin"), 1, 38)
					end
				end
				if creditsList[i][2] == CREDIT_CENTER
					v.drawString(160, ypos, credstring, (creditsList[i][2] == CREDIT_NORMAL and V_ALLOWLOWERCASE or 0), "thin-center")
				else
					v.drawString(creditsList[i][2], ypos, credstring, (creditsList[i][2] == CREDIT_NORMAL and V_ALLOWLOWERCASE or 0), "thin")
				end
			end
		end
	end
end, "game")