--╔════════════════════════════╗════════════════════════════════════════════════════════════════════════════════#
--║     	  EXAMPLES		   ║  Just some examples you definitely want to remove in your own implementation.
--╚════════════════════════════╝════════════════════════════════════════════════════════════════════════════════#
local function BoxIconSpawn(mo)
	if mo.info.seesound == sfx_itemup and kombiwhogetswl4stuff[mo.target.skin]
		mo.info.seesound = sfx_saring
	elseif not kombiwhogetswl4stuff[mo.target.skin] and mo.info.seesound == sfx_saring
		mo.info.seesound = sfx_itemup
	end
end

/*
╔════════════════════════════╗═════════════════════════════════════════════════════════════════════════════════#
║     	ACTUAL CODE		     ║  Below is the actual core you want to use. Keep your local functions above it!
╚════════════════════════════╝═════════════════════════════════════════════════════════════════════════════════#
Legend:
type = The object type number. So MT_PLAYER, MT_THOK, MT_RING, etc.
INFO = The mobjinfo field. Same as if you were accessing mo.info.
SemiGlobal = A local table keeping track of which objects got hooks assigned already. Prevent duplication!
*/
local SemiGlobal = {}
local function GSAddonLoad(_)
	for type = 1,max(1, (#mobjinfo)-1) local INFO=mobjinfo[type] if INFO==nil or (SemiGlobal[type]) continue end --
		if (INFO.flags & MF_BOXICON) --For all objects with the MF_MONITOR flag, add a hook!
			SemiGlobal[type] = true --Adding this is crucial! It prevents hooks from being added multiple times.
			addHook("MobjThinker", BoxIconSpawn, type) --This is how you should add hooks.
		end
	end
end

addHook("AddonLoaded", GSAddonLoad) --This hook makes sure to scan for new objects everytime a new mod is added.
GSAddonLoad(_) --Run the function once on initial load.

addHook("NetVars", function(network)
	SemiGlobal = network($) --Sync what's been added so far for netgame sanity.
end)