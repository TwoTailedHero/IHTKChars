--LUIG BUD!!!
--this code is old and sucks booty

/*
	--TODO
	-make gus and stick into seperate objects and make 1 spawner obbject
	 on mapthingspawn, choose one or the other. GUS AND STICK NUM = -1!!!
*/
/*
freeslot("MT_KOMBI_EXITSIGN_SPAWN")
freeslot("SPR_GSSE")
freeslot("S_EXITSPAWN_PLACEHOLDER")

states[S_EXITSPAWN_PLACEHOLDER] = {
	sprite = SPR_GSSE,
	frame = A,
	tics = -1,
}
mobjinfo[MT_KOMBI_EXITSIGN_SPAWN] = {
	--$Name Exit Sign
	--$Sprite GSSEA0
	--$Category Spice Runners
	doomednum = 1263, --1-26-[202]3
	spawnstate = S_EXITSPAWN_PLACEHOLDER,
	spawnhealth = 1000, --gus cannot die lol
	radius = 14*FU,
	height = 26*FU,
	flags = MF_NOCLIPTHING
}

freeslot("MT_KOMBI_EXITSIGN")
freeslot("S_KOMBI_EXIT_WAIT")
freeslot("S_KOMBI_EXIT_FALL")
freeslot("S_KOMBI_EXIT_RALLY")

states[S_KOMBI_EXIT_WAIT] = {
	sprite = SPR_RING,
	frame = A,
	tics = -1,
}

states[S_KOMBI_EXIT_FALL] = {
	sprite = SPR_PLAY,
	frame = A|SPR2_FALL|FF_ANIMATE,
	var1 = 1-1,
	var2 = 2,
	tics = -1,
}

states[S_KOMBI_EXIT_RALLY] = {
	sprite = SPR_PLAY,
	frame = A|SPR2_STND|FF_ANIMATE,
	var1 = 1-1,
	var2 = 2,
	tics = -1,
}

mobjinfo[MT_KOMBI_EXITSIGN] = {
	doomednum = -1,
	spawnstate = S_KOMBI_EXIT_WAIT,
	spawnhealth = 1000, --gus cannot die lol
	radius = 14*FU,
	height = 26*FU,
	flags = MF_NOCLIPTHING
}
*/