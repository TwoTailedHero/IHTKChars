-- This takes a list of arguments that SHOULD be formatted like {sound, caption}
-- ofc you can just call this a bunch of times to get lots of uncaptioned sound effects, but why would you do that?
local function FreeSlotAndCaption(...)
    local args = {...}
    for i = 1, #args, 2 do
        local slotName = args[i]
        local caption = args[i + 1]
        if not _G[slotName] then
            local slotID = freeslot(slotName) -- thank GOD this returns the thing we freeslotted
            if caption then
                sfxinfo[slotID].caption = caption
            end
        end
    end
end

local didthing = false

FreeSlotAndCaption(
	-- Kombi
	-- SA2
    "sfx_serank", "Barely made it.",
    "sfx_sdrank", "Huh, no problem.",
    "sfx_scrank", "Just made it.",
    "sfx_sbrank", "Too easy! Piece of cake!",
    "sfx_sarank", "*Whistle* That was cool!",
	-- Shayde
	-- SA2
    "sfx_herank", "I guess I'm not at full power here.",
    "sfx_hdrank", "Maybe I didn't try hard enough.",
    "sfx_hcrank", "That wasn't so hard.",
    "sfx_hbrank", "Hm. Too easy for me!",
    "sfx_harank", "Ultimate victory!",
	-- Stryke
	-- SA1
	"sfx_kcbest", "That was easy.",
	"sfx_kcgood", "Heh. Good enough.",
	"sfx_kclbad", "I can do better than that.",
	-- SA2
	"sfx_kerank", ""
)

local ranktalks = {
    kombi = {
		-- use SA1 *AND* SA2 for representation, since Adventure Sonic would probably just use SA2's rank voice lines anyway
        E = {sfx_kmcbad, sfx_serank},
        D = {sfx_kcgood, sfx_sdrank},
        C = {sfx_kcgood, sfx_scrank},
        B = {sfx_kcbest, sfx_sbrank},
        A = {sfx_kcbest, sfx_sarank}
    },
    shayde = {
        E = sfx_herank,
        D = sfx_hdrank,
        C = sfx_hcrank,
        B = sfx_hbrank,
        A = sfx_harank
    },
}

local function K_RankThinker(player)
    if not (player.exiting and player.tallytimer) then
        player.kombihasranked = false -- reset this pl0x
        return true
    end

    if player.tallytimer == TICRATE and not player.kombihasranked then
        local helper = tbsrequire 'helpers/c_inter' -- this looks weird i know
        local currank = helper.RankCounter(player) -- find this in Adventure Style's LUA! Can't comment about it because I don't own the code
        local ranktalk = ranktalks[player.mo.skin] and ranktalks[player.mo.skin][currank]

        if ranktalk then
            if type(ranktalk) == "table" then -- we probably shouldn't randomize things when we know for certain we'll just get the same result every time
                S_StartSound(nil, ranktalk[P_RandomRange(1, #ranktalk)], player)
            else
                S_StartSound(nil, ranktalk, player)
            end
            player.tallytimer = player.tallytimer + (TICRATE * 2 / 3) -- extend our exit clock so the game doesn't rudely interrupt us
            player.kombihasranked = true
        end
    end
end

local function K_DoAdventureStyleSupport()
    if not Style_AdventureVersion or didthing then return end
    print("Adventure Style loaded! Preparing necessary functions...")
    addHook("PlayerThink", K_RankThinker)
    didthing = true -- probably *don't* do this again since we'll just pollute the CPU with redundant code
end

addHook("AddonLoaded", K_DoAdventureStyleSupport)
K_DoAdventureStyleSupport()