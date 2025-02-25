-- Custom Hook Library originally by Lat' for SRB2P
-- updated and converted to a global namespace by Snu
if not kombi
	rawset(_G, "kombi", {})
end
	kombi.funcs = {}	-- where all functions for hooks are stored
	
	-- debugging stuff
	kombi.debug = false
	kombi.dprint = function(string)	-- debug print
		if not (kombi.debug) then return end
		print(string)
	end
	
	-- add a hooked function
	kombi.AddHook = function(hookname, func)
		-- validate arguments
		assert(hookname and type(hookname) == "string", "kombi.AddHook: bad argument #1 (string expected, got "..type(hookname)..")")
		assert(func and type(func) == "function", "kombi.AddHook: bad argument #2, (function expected, got "..type(hookname)..")")
		
		-- add this to the list of functions to run when the hook is called
		kombi.funcs[hookname] = $ or {}	-- init this if it hasnt been already
		table.insert(kombi.funcs[hookname], func)
		kombi.dprint("added function #"..#kombi.funcs[hookname].." to hook \""..hookname.."\"")
	end
	
	-- defs for what values to return
	local valuemode_constants = {	-- constants dictate what values to prioritize
		"HL_LASTFUNC",	-- gets the value of the last non-nil hook function ran
		"HL_ANYTRUE",	-- returns true if ANY hook function returns true
		"HL_ANYFALSE",	-- ditto, but for false returns
	}
	for k, v in pairs(valuemode_constants) do rawset(_G, v, k) end
	kombi.valuemodes = { -- this is the table we'll store all modes in
	["PlayerWLTrans"] = HL_LASTFUNC,
	["PlayerItemReserve"] = HL_LASTFUNC,
	["PlayerItemGet"] = HL_LASTFUNC,
	["KeroTimeLimit"] = HL_LASTFUNC,
	["SpawnKero"] = HL_ANYTRUE,
	["SpawnKeyzer"] = HL_ANYTRUE,
	["PreKeroHit"] = HL_LASTFUNC,
	["KeroCoinLossTick"] = HL_LASTFUNC,
	}
	
	-- put this where you want your hook to run its hooked functions
	kombi.RunHook = function(hookname, ...)
		-- validate the first field being a string
		assert(hookname and type(hookname) == "string", "kombi.RunHook: bad argument #1 (string expected, got "..type(hookname)..")")
		kombi.funcs[hookname] = $ or {}	-- init this if it hasnt been already
		
		kombi.dprint("running hook \""..hookname.."\"")
		local numfuncs = #kombi.funcs[hookname]
		if not (numfuncs) then return end	-- no functions to run?
		local args = {...}	-- ready arguments for hooked functions
		
		local hookvalue = nil	-- what we'll be returning after functions are ran
		for i = 1, numfuncs do
			kombi.dprint("running function #"..i.." in hook \""..hookname.."\"")
			
			-- run hooked function
			local func = kombi.funcs[hookname][i](unpack(args))
			
			-- value mode behaviours (explained above)
			local valuemode = kombi.valuemodes[hookname]
			if not (valuemode) then continue end	-- no need to do anything else if not set
			
			if ((valuemode == HL_LASTFUNC) and func != nil)
			or ((valuemode == HL_ANYTRUE) and func == true)
			or ((valuemode == HL_ANYFALSE) and func == false)
				hookvalue = func
			end
		end
		
		-- return the value of the hook
		return hookvalue
	end