--Air Acceleration
--"AA" in the code stands for "air acceleration"

local aaamount = FRACUNIT
--network stuff, thanks luigi budd!!
local ran = P_RandomFixed()

addHook("NetVars",function(net)
    ran = net($)
    aaamount = net($)
end)

COM_AddCommand("_airacceleration_sync",function(player,sig,value)
	if tonumber(sig) ~= ran return end
	
	if value
		player.aaamount = tonumber(value)
	else
		player.aaon = false
	end
end)

local function spawn(player)
    player.aaon = true
    player.aaamount = FRACUNIT
    
    local fi = io.openlocal("client/airacceleration.dat","r")
    
    if fi
	    local data = fi:read("*a") --read whole file
	    if data == "off" COM_BufInsertText(player,"_airacceleration_sync "..ran) end
	    fi:close()
    else
	    local fi = io.openlocal("client/airacceleration.dat","w+")
        
	    if fi
		    fi:write(player.aaon and "on" or "off")
		    fi:close()
	    end
    end
    
    --amount
    local fi = io.openlocal("client/airacceleration_amount.dat","r")
    
    if fi
	    local data = fi:read("*a") --read whole file
	    COM_BufInsertText(player,"_airacceleration_sync "..ran.." "..(tonumber(data) or FU))
	    fi:close()
    else
	    local fi = io.openlocal("client/airacceleration_amount.dat","w+")
        
	    if fi
		    fi:write(tostring(FRACUNIT))
		    fi:close()
	    end
    end
end

local disablelist = {
	"mario",
	"luigi",
	"s3sonic",
	"elfilin",
}

addHook("PreThinkFrame", function()
    for player in players.iterate
        if not player.aaamount player.aaamount = FRACUNIT end
		local setplayeraa = player.aaamount
        if not kombiwhogetswl4stuff[player.mo.skin] return end
		
        local mo = player.mo
        local grounded = P_IsObjectOnGround(mo) or (mo.eflags & MFE_JUSTHITFLOOR)
        
		if player.kombispinabil == "rico"
			player.aaamount = 0
		elseif player.realmo.state == S_PLAY_SPINJUMP
			player.aaamount = 63815
		end
		
        local disable = player.powers[pw_tailsfly] or (mo.flags2 & MF2_TWOD) or (maptol & TOL_2D) or not player.aaon or (disablelist[mo.skin] or (mo.skin == "cdsonic" and player.physics))
        local amount = aaamount == -1 and player.aaamount or min(player.aaamount,aaamount)
        
        if not grounded and not disable and not player.exiting and not (player.pflags & PF_STASIS) and not player.powers[pw_nocontrol] and not P_PlayerInPain(player) and player.playerstate == PST_LIVE
            local super = ((player.powers[pw_super] or player.powers[pw_sneakers]) and 2 or 1)
            local thrustfactor = player.thrustfactor*super
            local acceleration = player.accelstart/super + (FixedDiv(player.speed,mo.scale)>>FRACBITS) * player.acceleration/super
            
            local normalspd = FixedMul(player.normalspeed,mo.scale)
            local topspeed = ((player.pflags & PF_SLIDING) and normalspd or ((player.powers[pw_super] or player.powers[pw_sneakers]) and 5*normalspd/3 or normalspd))
            if (mo.eflags & (MFE_UNDERWATER|MFE_GOOWATER))
                topspeed = $ >> 1
                acceleration = 2*$/3
            end
            
            local om = R_PointToDist2(mo.momx-player.cmomx,mo.momy-player.cmomy,0,0) --old magnitude
            local shift = 2
            if (player.pflags & (PF_SPINNING|PF_THOKKED)) == PF_SPINNING
                shift = $ + 1
            end
            local controldirection = R_PointToAngle2(0,0,player.cmd.forwardmove*FU,-player.cmd.sidemove*FU) + (player.cmd.angleturn * FU)
            
            mo.momx = $ + P_ReturnThrustX(mo,controldirection,FixedMul((abs(player.cmd.forwardmove)+abs(player.cmd.sidemove))*(thrustfactor*acceleration),FixedMul(mo.scale,amount)) >> shift)
            mo.momy = $ + P_ReturnThrustY(mo,controldirection,FixedMul((abs(player.cmd.forwardmove)+abs(player.cmd.sidemove))*(thrustfactor*acceleration),FixedMul(mo.scale,amount)) >> shift)
            
            local nm = R_PointToDist2(mo.momx-player.cmomx,mo.momy-player.cmomy,0,0) --new magnitude
            if nm > topspeed
                if om > topspeed
                    if nm > om
                        mo.momx = FixedMul(FixedDiv($ - player.cmomx, nm), om) + player.cmomx
                        mo.momy = FixedMul(FixedDiv($ - player.cmomy, nm), om) + player.cmomy
                    end
                else
                    mo.momx = FixedMul(FixedDiv($ - player.cmomx, nm), topspeed) + player.cmomx
                    mo.momy = FixedMul(FixedDiv($ - player.cmomy, nm), topspeed) + player.cmomy
                end
            end
        end
		player.aaamount = setplayeraa
    end
end)

addHook("PlayerSpawn", spawn)

COM_AddCommand(
	"airacceleration_toggle",
	function(player)
	    if player.mo
            player.aaon = not $
            if secondarydisplayplayer secondarydisplayplayer.aaon = player.aaon end
            
            if player == consoleplayer
		        local fi = io.openlocal("client/airacceleration.dat","w+")
                
		        if fi
			        fi:write(player.aaon and "on" or "off")
			        fi:close()
		        end
            end
            CONS_Printf(player,"Acceleration in the air has now been turned "+(player.aaon and "on" or "off")+" for you")
        else
            CONS_Printf(player,"You cannot toggle this right now..")
	    end
	end
)

COM_AddCommand(
	"airacceleration_amount",
	function(player,arg)
        if player.mo.valid
            if tonumber(arg)
                if P_IsObjectOnGround(player.mo)
                    player.aaamount = tonumber(arg)
                    if secondarydisplayplayer secondarydisplayplayer.aaamount = tonumber(arg)end
                    
                    CONS_Printf(player,"Your Air Acceleration value has been set to "+player.aaamount)
                    if player.aaamount > aaamount
                        CONS_Printf(player,"Warning: Value is outside set range, it will be set to "+aaamount)
                    end
                    
                    if player == consoleplayer
			            local fi = io.openlocal("client/airacceleration_amount.dat","w+")
                        
			            if fi
				            fi:write(player.aaamount)
				            fi:close()
			            end
                    end
                else
                    CONS_Printf(player,"Please try again on the ground.")
                end
            else
                CONS_Printf(player,"airacceleration_amount <amount> - Set the amount of air acceleration players have, if they have it enabled")
                CONS_Printf(player,"Amount should range from 1 (none) to 65536 (full, default)")
                CONS_Printf(player,"Current value is "+player.aaamount)
            end
        end
	end
)

COM_AddCommand(
	"airacceleration_max_amount",
	function(player,arg)
        if tonumber(arg)
            if multiplayer
                aaamount = tonumber(arg)
                CONS_Printf(player,"Maximum Air Acceleration value has been set to "+aaamount)
                if aaamount < -1 or aaamount > FRACUNIT
                    CONS_Printf(player,"Warning: Value is outside intended range, issues may happen")
                end
            else
                CONS_Printf(player,"This is disabled in singleplayer")
            end
        else
            CONS_Printf(player,"airacceleration_amount <amount> - Set the maximum amount of air acceleration any player can set, if they have it enabled")
            CONS_Printf(player,"Amount should range from 1 (none) to 65536 (full, default), or to disable the limit, -1")
            CONS_Printf(player,"Current value is "+aaamount)
        end
	end
,COM_ADMIN)
