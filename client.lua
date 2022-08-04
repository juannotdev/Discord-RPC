-- SCRIPT WAS MADE BY HypnoticSiege (xDiscord)
-- THIS IS JUST A FORKED VERSION WITH A COUPLE NEW THINGS

-- #1 ONLINE PLAYERS INSTEAD OF PLAYER ID
-- #2 ICONS NOW HAVE A WHITE OUTLINE ON THEM
-- #3 THERE IS NOW A RPC OF WHEN YOU ARE ON A BOAT
-- #4 IT NOW SHOWS THAT YOU ARE PARKED WHEN YOU ARE STOPPED IN YOUR VEHICLE

-- Here's a guide on how to set it up. https://forum.cfx.re/t/how-to-updated-discord-rich-presence-custom-image/157686

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        local playerCount = #GetActivePlayers()

        SetDiscordAppId('000000000000000000') -- Discord Developer Bot ID
	SetDiscordRichPresenceAsset('main') -- Name of the logo file
        SetDiscordRichPresenceAssetText('Server Name') -- Text when you hover over the logo in discord
        SetDiscordRichPresenceAction(0, "Connect", "fivem://connect/serverip") -- Connect Button
        SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/placeholder") -- Discord Button

        local pId = GetPlayerServerId(PlayerId())
        local pName = GetPlayerName(PlayerId())
        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId(),true))
        local StreetHash = GetStreetNameAtCoord(x, y, z)
        Citizen.Wait(1000)
        if StreetHash ~= nil then
            StreetName = GetStreetNameFromHashKey(StreetHash)
            if IsPedOnFoot(PlayerPedId()) and not IsEntityInWater(PlayerPedId()) then
                if IsPedDeadOrDying(PlayerPedId()) then
                    SetRichPresence("["..playerCount.. "/64] " ..pName.. " is dead near "..StreetName)
                    SetDiscordRichPresenceAssetSmall('dead')
                    SetDiscordRichPresenceAssetSmallText("Dead Near "..StreetName) 
				elseif IsPedSprinting(PlayerPedId()) then
					SetRichPresence("["..playerCount.. "/64] " ..pName.. " is sprinting down "..StreetName)
                    SetDiscordRichPresenceAssetSmall('run')
                    SetDiscordRichPresenceAssetSmallText("Sprinting Down "..StreetName) 
				elseif IsPedRunning(PlayerPedId()) then
					SetRichPresence("["..playerCount.. "/64] " ..pName.. " is running down "..StreetName)
                    SetDiscordRichPresenceAssetSmall('run')
                    SetDiscordRichPresenceAssetSmallText("Running Down "..StreetName) 
				elseif IsPedWalking(PlayerPedId()) then
					SetRichPresence("["..playerCount.. "/64] " ..pName.. " is walking down "..StreetName)
                    SetDiscordRichPresenceAssetSmall('walk')
                    SetDiscordRichPresenceAssetSmallText("Walking Down "..StreetName) 
				elseif IsPedStill(PlayerPedId()) then
					SetRichPresence("["..playerCount.. "/64] " ..pName.. " is standing on "..StreetName)
                    SetDiscordRichPresenceAssetSmall('walk')
                    SetDiscordRichPresenceAssetSmallText("Standing On "..StreetName) 
                end

                -- Vehicle RPC
            elseif GetVehiclePedIsUsing(PlayerPedId()) ~= nil and not IsPedInAnyHeli(PlayerPedId()) and not IsPedInAnyPlane(PlayerPedId()) and not IsPedOnFoot(PlayerPedId()) and not IsPedInAnySub(PlayerPedId()) and not IsPedInAnyBoat(PlayerPedId()) then
                local MPH = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                if MPH > 0 then
                    SetRichPresence("["..playerCount.. "/64] " ..pName.." is on "..StreetName.." going "..MPH.."MPH")
                elseif MPH == 0 then
                    SetRichPresence("["..playerCount.. "/64] " ..pName.." is parked on "..StreetName.."")  
                    SetDiscordRichPresenceAssetSmall('vehicle')
                    SetDiscordRichPresenceAssetSmallText("Going "..MPH.."MPH") 
                end

                -- Helicopter RPC
            elseif IsPedInAnyHeli(PlayerPedId()) then
                local Knots = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 1.0 then
                    SetRichPresence("["..playerCount.. "/64] " ..pName.." is flying above "..StreetName)
                    SetDiscordRichPresenceAssetSmall('heli')
                    SetDiscordRichPresenceAssetSmallText("Flying at "..Knots.." Knots")
                end
--
                -- Plane RPC
            elseif IsPedInAnyPlane(PlayerPedId()) then
                local Knots = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(PlayerPedId())) * 2.236936)
                if IsEntityInAir(GetVehiclePedIsUsing(PlayerPedId())) or GetEntityHeightAboveGround(GetVehiclePedIsUsing(PlayerPedId())) > 1.0 then
                    SetRichPresence("["..playerCount.. "/64] " ..pName.." is flying above "..StreetName)
                    SetDiscordRichPresenceAssetSmall('plane')
                    SetDiscordRichPresenceAssetSmallText("Flying at "..Knots.." Knots")
                end
                
                --Player Swimming & Boat RPC 
            elseif IsEntityInWater(PlayerPedId()) then
                SetRichPresence("["..playerCount.. "/64] " ..pName.." is swimming near "..StreetName)
                SetDiscordRichPresenceAssetSmall('swim')
                SetDiscordRichPresenceAssetSmallText("Swimming near "..StreetName)
            elseif IsPedInAnyBoat(PlayerPedId()) and IsEntityInWater(GetVehiclePedIsUsing(PlayerPedId())) then
				SetRichPresence("["..playerCount.. "/64] " ..pName.." is sailing near "..StreetName)
                SetDiscordRichPresenceAssetSmall('sub')
                SetDiscordRichPresenceAssetSmallText("Swimming near "..StreetName)
                
            end
        end
    end
end)
