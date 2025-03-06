/*
KeroTimeLimit

Hook format:    
    kombi.AddHook("KeroTimeLimit", functionname)

Function format:    
    function(gamemap)

Function return value:    
    Number (escape timer in tics)

    This hook is executed during map loading to determine the escape timer for the level. The function is passed the current map number (or identifier) and may return a numeric value specifying the time limit—in tics—to complete the level before the escape sequence begins. If the hook returns a non-nil value, that value overrides the default timer. Otherwise, the built-in settings (or values derived from the map’s header information) are used.

SpawnKero

Hook format:    
    kombi.AddHook("SpawnKero", functionname)

Function format:    
    function(gamemap)

Function return value:    
    Boolean (if true, suppress the spawning of the Frog Switch)

    This hook is called during the MapLoad hook, just before the mod attempts to spawn a Frog Switch. When invoked with the current map as its parameter, a hook function may return true to cancel the default spawning of the Frog Switch. Returning false or nil allows the normal behavior to continue.

SpawnKeyzer

Hook format:    
    kombi.AddHook("SpawnKeyzer", functionname)

Function format:    
    function(gamemap)

Function return value:    
    Boolean (if true, prevent the spawning of Keyzer)

    This hook is executed during the MapLoad hook to decide whether Keyzer should be spawned. It receives the current map as an argument. If a hook function returns true, the default spawning of Keyzer is suppressed; if it returns false or nil, the mod proceeds with its usual behavior.

PreKeroHit

Hook format:    
    kombi.AddHook("PreKeroHit", functionname)

Function format:    
    function(player, iswar)

Function return value:    
    Number (sound effect ID)

    Invoked when the escape sequence starts, typically by hitting the Frog Switch, the PreKeroHit hook allows modification of the resulting sound effect.
	The function is passed the player and a boolean flag indicating whether the level is in WAR mode.
	If the function returns a sound effect identifier, that sound is played in place of the default randomized choice.
	Returning nil will default to Wario's voice lines.

KeroTimeUp

Hook format:    
    kombi.AddHook("KeroTimeUp", functionname)

Function format:    
    function(player)

Function return value:    
    None

    This hook is triggered when the level’s escape timer runs out.
	It is passed a player and is intended for executing any custom logic that should occur as time expires. 

KeroCoinLossTick

Hook format:    
    kombi.AddHook("KeroCoinLossTick", functionname)

Function format:    
    function()

Function return value:    
    Number (the amount of coin/score loss to apply)

    During the escape sequence, the mod periodically deducts coins (or score) from the player.
	This hook is called at regular intervals (every few tics) with no parameters.
	A hook function can return a numeric value representing the amount by which the player’s score should be reduced on that tick.
	If nil or false is returned, the default coin loss amount is used.

PlayerItemReserve

Hook format:    
    kombi.AddHook("PlayerItemReserve", functionname)

Function format:    
    function(target, currentItem)

Function return value:    
    String (power-up to reserve)

    Executed when the mod updates a player’s reserve power-up item, this hook allows for overriding the item that is to be stored.
	The function receives a target (usually the player or the item’s owner) and the currently selected reserve item.
	If the hook returns a valid power-up identifier (a String), that value replaces the provided item; otherwise, the default (currentItem) is retained.

PlayerItemGet

Hook format:    
    kombi.AddHook("PlayerItemGet", functionname)

Function format:    
    function(target, currentItem, force)

Function return value:    
    String (power-up to give)

    This hook is called when a player collects a power-up item.
	It is passed three parameters: the target (i.e., the player), the current power-up item, and a boolean flag indicating whether the new power-up should forcibly replace the existing one 
	(true in the case of an immediate set, false when comparing priorities).
	Returning a valid string from this hook will override the default power-up assignment.

PlayerWLTrans

Hook format:    
    kombi.AddHook("PlayerWLTrans", functionname)

Function format:    
    function(target, trans)

Function return value:    
    String (transformation type or "reset")

    This hook is called when the mod sets or resets a player's Wario Land-style transformation due to environmental effects.
	The function receives the target (player) and the transformation type (e.g., TR_ZOMBIE, TR_FIRE, TR_FLAT, or "reset").
    Returning a non-nil string value replaces the transformation applied to the target.
	Returning nil or false keeps the default transformation.
	
MT_WLPORTALSPAWNER

Description:
    Spawns a set of portal objects when spawning.
Parameters:
    Arg0 "Destination Level ID" (Number) – If greater than 0, this value overrides the map header's destination level and binary’s Angle field.
	Angle "Destination Level ID" – If greater than 0, this value overrides the map header's destination level. Arg0 supercedes this.
	Tag "Associated Frog Switch" - If set, the Frog Switch connected to this portal must be hit for it to open.

MT_KOMBIFROGSWITCH

Description:
    Acts as the Frog Switch that triggers the escape sequence.
Parameters:
    Arg0 "Escape Mode" (Enum: 0="Normal", 1="WAR", 2="None")
         – Determines the behavior of the escape sequence:
           • Normal: Uses header/default timer.
           • WAR: Carries timer between checkpoints.
           • None: Disables escape.
    Arg1 "Custom Timer (sec)" (Number) – A non-zero value overrides the header/default timer.
	Angle (floor(Angle/360)//5) – A non-zero calculation overrides the header/default timer.
	Tag "Portal Types To Open" - Is set, the Frog Switch opens all portals connected to this tag.
*/