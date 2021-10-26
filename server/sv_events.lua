RegisterNetEvent('NGWD:purchaseVehicle', function(plate, modelHash, localizedName) -- Should also pass the modelName maybe?
    local playerId      = source
    local identifier    = Utils.getPlayerIdentifier(playerId)
    if not identifier then TriggerClientEvent('NGWD:notifyError', playerId, "Unable to purchase vehicle.") return Utils.Debug('error', "Unable to purchase vehicle, identifier not found.") end
    if plate and modelHash then
        -- can also add a distance check for the dealership cords and trigger a kick event..
        MySQL.Async.fetchScalar('SELECT 1 FROM '..Config.databaseName..' WHERE (owner, plate) = (@owner, @plate)', {
            ['owner']          = identifier,
            ['plate']          = plate,
        }, function(result)
            if not result then
                MySQL.Async.execute('INSERT INTO '..Config.databaseName..' (owner, modelHash, localizedName, plate) VALUES (@owner, @modelHash, @localizedName, @plate)',
                {
                    ['owner']          = identifier, 
                    ['modelHash']      = modelHash,
                    ['localizedName']  = localizedName,
                    ['plate']          = plate,
                })
                Utils.Debug('success', "".. identifier .. " Purchased a vehicle with the plate " .. plate .. ".")
                if Config.purchaseNotification then
                    TriggerClientEvent('NGWD:notifySuccess', playerId, "" .. modelHash .. " Was purchased successfully.")
                end
            else
                Utils.Debug('error', "Duplicate Entry for ^1[" ..plate.. "]^0 owned by: ^3[".. identifier .. "]^0")
                if Config.purchaseNotification then
                    TriggerClientEvent('NGWD:notifyError', playerId, "Vehicle can't be purchased.")
                end
            end
        end)
    else
        Utils.Debug('error', "Purchasing Vehicle: Model and plate not found.")
    end
end)

RegisterNetEvent('NGWD:storeVehicle', function(vehicle, garageName, plate, modelHash, localizedName, vehicleProperties, vehicleCondition, vehicleMods)
    local playerId      = source
    local identifier    = Utils.getPlayerIdentifier(playerId)
    if not identifier then TriggerClientEvent('NGWD:notifyError', playerId, "Error storing vehicle.") return Utils.Debug('error', "Unable to store vehicle, identifier not found.") end
    
    if plate and modelHash then
        MySQL.Async.fetchAll('SELECT * FROM '..Config.databaseName..' WHERE (modelHash, plate) = (@modelHash, @plate)', {
            ['modelHash']  = modelHash,
            ['plate']      = plate,
        }, function(results)
            if results then
                if results[1].owner == identifier then
                    MySQL.Async.execute('UPDATE '..Config.databaseName..' SET garage = @garage, vehicleProperties = @vehicleProperties, vehicleCondition = @vehicleCondition, vehicleMods = @vehicleMods WHERE plate = @plate', { 
                        ['owner']                  = identifier, 
                        ['modelHash']              = modelHash,
                        ['localizedName']          = localizedName,
                        ['plate']                  = plate, 
                        ['garage']                 = garageName,
                        ['vehicleProperties']      = json.encode(vehicleProperties),
                        ['vehicleCondition']       = json.encode(vehicleCondition),
                        ['vehicleMods']            = json.encode(vehicleMods),
                    })             
                    TriggerClientEvent('NGWD:leaveVehicle', playerId, vehicle)
                    Utils.Debug('inform', "Vehicle owned by: ^5".. results[1].owner .. "^2 with the plate ^5" .. plate .. "^2 has been stored at ^5" .. garageName .. " Garage")
                    Wait(1000)
                    TriggerClientEvent('NGWD:notifySuccess', playerId, "Vehicle Stored Successfully at " .. garageName .. " Garage")
                elseif results[1].owner ~= identifier then
                    if not Config.ownerRestricted then
                        MySQL.Async.execute('UPDATE '..Config.databaseName..' SET garage = @garage, vehicleProperties = @vehicleProperties, vehicleCondition = @vehicleCondition, vehicleMods = @vehicleMods WHERE plate = @plate', { 
                            ['owner']                  = identifier, 
                            ['modelHash']              = modelHash,
                            ['localizedName']          = localizedName,
                            ['plate']                  = plate, 
                            ['garage']                 = garageName,
                            ['vehicleProperties']      = json.encode(vehicleProperties),
                            ['vehicleCondition']       = json.encode(vehicleCondition),
                            ['vehicleMods']            = json.encode(vehicleMods),
                        })                      
                        TriggerClientEvent('NGWD:leaveVehicle', playerId, vehicle)
                        Wait(1000)
                        TriggerClientEvent('NGWD:notifySuccess', playerId, "Vehicle Stored Successfully at " .. garageName .. " Garage")
                        Utils.Debug('inform', "Vehicle owned by: ^2".. results[1].owner .. "^3 with the plate ^2" .. plate .. "^3 has been stored at ^2" .. garageName .. " Garage")
                    else
                        TriggerClientEvent('NGWD:notifyError', playerId, "Ownership Required")
                        Utils.Debug('inform', "Prevented User ^5" .. identifier .. "^1 from storing ^2" .. results[1].owner .. "'s ^1 vehicle")
                    end
                end
            else
                Utils.Debug('error', "Unable to find the modelHash " .. modelHash .. " owned by: ".. identifier .. " with the plate " .. plate .. ".")
                TriggerClientEvent('NGWD:notifyError', playerId, "Vehicle Can't be Stored")
            end
        end)
    else
        Utils.Debug('error', "Unable to store vehicle, plate or modelHash is nil")
    end
end)

RegisterNetEvent('NGWD:spawnVehicle', function(plate, garageName)
    local playerId      = source
    local identifier    = Utils.getPlayerIdentifier(playerId)
    if not identifier then return Utils.Debug('error', "Unable to spawn vehicle, identifier not found.") end

    if plate then
        MySQL.Async.fetchAll('SELECT * FROM '..Config.databaseName..' WHERE (owner, plate, garage) = (@owner, @plate, @garage)', {
            ['owner']   = identifier,
            ['plate']   = plate,
            ['garage']  = garageName,
        }, function(results)
            if results and results[1] then
                modelHash           = results[1].modelHash
                plate               = results[1].plate
                vehicleProperties   = json.decode(results[1].vehicleProperties)
                vehicleCondition    = json.decode(results[1].vehicleCondition)
                vehicleMods         = json.decode(results[1].vehicleMods)
                local plyPed = GetPlayerPed(playerId)
                local vehNet, veh = createVehicle(playerId, plyPed, modelHash, GetEntityCoords(plyPed))
                if not vehNet then 
                    return 
                end
                TriggerClientEvent('NGWD:setVehicleProperties', playerId, vehNet, plate, vehicleProperties, vehicleCondition, vehicleMods)

                Wait(100)
                if not DoesEntityExist(veh) then 
                    return 
                end
            else
                Utils.Debug('error', "No vehicle found owned by: " .. identifier .. " With Plate " .. plate .. "") 
            end
        end)
    else
       Utils.Debug('error', "Unable to spawn vehice, no plate was found.")  
    end
end)

RegisterNetEvent('NGWD:getOwnedVehicles', function(garageName)
    -- Add distance check with kick event?
    local playerId      = source
    local identifier    = Utils.getPlayerIdentifier(playerId)
    if not garageName then return Utils.Debug('error', "Unable to fetch vehicles, no garage specified.") end
    if type(garageName) ~= "string" then return Utils.Debug('error', "Unable to get owned vehicles. Data other than string found for garage.") end
    if not identifier then return Utils.Debug('error', "Unable to fetch vehicles, identifier not found.") end

    MySQL.Async.fetchAll('SELECT * FROM '..Config.databaseName..' WHERE owner= @owner', {
        ['owner']   = identifier,
    }, function(results)
        if results and results[1] then
            Utils.Debug('inform', "Vehicles found.")
            local count = 0
            for _,v in pairs(results) do
                print(v.plate, v.modelHash, v.garage)
                if v.garage == garageName then
                    count = count + 1
                end
            end
            print(""..count.." Vehicles stored at "..garageName.." Garage")
        else
            TriggerClientEvent('NGWD:notifyError', playerId, "You don't own any vehicles!") return Utils.Debug('error', "No vehicle found owned by: " .. identifier .. "") 
        end
    end)
end)


RegisterNetEvent('NGWD:sellVehicle', function(plate)
    local playerId      = source
    local identifier    = Utils.getPlayerIdentifier(playerId)
    if not identifier then return Utils.Debug('error', "Unable to sell vehicle, identifier not found.") end

    if plate then
        MySQL.Async.fetchScalar('SELECT 1 FROM '..Config.databaseName..' WHERE (owner, plate) = (@owner, @plate)', {
            ['owner'] = identifier,
            ['plate'] = plate,
        }, function(result)
            if result then
                MySQL.Async.execute('DELETE FROM '..Config.databaseName..' WHERE (owner, plate) = (@owner, @plate)', {
                    ['owner'] = identifier,
                    ['plate'] = plate,
                }, function(rowsChanged) 
                    if rowsChanged ~= 0 then
                        if Debug.debugLevel >= 2 then
                            Utils.Debug('success', "Sold "..rowsChanged.." vehicle owned by: ".. identifier .. " with the plate " .. plate .. ".")
                        end                 
                    else
                        Utils.Debug('error', "Error deleting vehicle from "..Config.databaseName..". No rows changed.")  
                    end
                end)
            else
                Utils.Debug('error', "No vehicle found owned by: " .. identifier .. " With Plate " .. plate .. "")
            end
        end)
    else
        Utils.Debug('error', "Unable to sell vehice, no plate was found.")
    end
end)

RegisterNetEvent('NGWD:giveVehicle', function()
    -- This will be used to give ownership of the vehicle to another player.
        -- Might use for keys or just peer to peer selling.
end)

RegisterNetEvent('NGWD:impoundVehicle', function()
    -- This will be used to send the vehicle to the Impound Garage.
end)

RegisterNetEvent('NGWD:releaseVehicle', function()
    -- This will be used to release the vehicle from the impound lot and spawn at a pre determined garage based off the config.
end)