-- Framework initialization
local QBCore = nil
local ESX = nil

-- Initialize the appropriate framework
local function InitializeFramework()
    if Config.Framework == 'qb' then
        QBCore = exports['qb-core']:GetCoreObject()
    elseif Config.Framework == 'esx' then
        ESX = nil
        TriggerEvent(Config.ESXEvent, function(obj) ESX = obj end)
        while ESX == nil do Wait(0) end
    end
end

-- Framework-agnostic notification function
local function ShowNotification(message, type)
    if Config.Framework == 'qb' and QBCore then
        QBCore.Functions.Notify(message, type)
    elseif Config.Framework == 'esx' and ESX then
        if type == 'error' then
            ESX.ShowNotification(message, false, true, 140)
        else
            ESX.ShowNotification(message)
        end
    else
        -- Fallback notification
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(false, false)
    end
end

local blips = {}
local isMenuOpen = false

-- Load blips from server data
local function LoadBlips(blipsData)
    -- Remove existing blips first
    for _, blipData in pairs(blips) do
        if blipData and blipData.handle and DoesBlipExist(blipData.handle) then
            RemoveBlip(blipData.handle)
        end
    end
    
    blips = {}
    
    -- Create blips from data
    if blipsData and type(blipsData) == 'table' then
        for _, blipData in pairs(blipsData) do
            if blipData and blipData.coords then
                local coords = nil
                
                -- Handle different coord formats
                if type(blipData.coords) == 'string' then
                    -- Try to decode JSON string
                    local success, result = pcall(function()
                        return json.decode(blipData.coords)
                    end)
                    
                    if success and result then
                        coords = vector3(result.x or 0.0, result.y or 0.0, result.z or 0.0)
                    end
                elseif type(blipData.coords) == 'table' then
                    -- Direct table access
                    coords = vector3(blipData.coords.x or 0.0, blipData.coords.y or 0.0, blipData.coords.z or 0.0)
                end
                
                -- Only create blip if we have valid coordinates
                if coords then
                    local blipHandle = AddBlipForCoord(coords.x, coords.y, coords.z)
                    
                    -- Set blip properties with error checking
                    if DoesBlipExist(blipHandle) then
                        SetBlipSprite(blipHandle, tonumber(blipData.sprite) or 1)
                        SetBlipColour(blipHandle, tonumber(blipData.color) or 0)
                        SetBlipScale(blipHandle, tonumber(blipData.scale) or 0.8)
                        -- Convert to boolean: either 1 or true should be treated as true
                        SetBlipAsShortRange(blipHandle, blipData.shortRange == 1 or blipData.shortRange == true)
                        SetBlipDisplay(blipHandle, tonumber(blipData.display) or 4)
                        
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(blipData.name or "Blip")
                        EndTextCommandSetBlipName(blipHandle)
                        
                        -- Store blip data
                        blips[tonumber(blipData.id)] = {
                            handle = blipHandle,
                            data = {
                                id = tonumber(blipData.id),
                                name = blipData.name or "Blip",
                                sprite = tonumber(blipData.sprite) or 1,
                                color = tonumber(blipData.color) or 0,
                                scale = tonumber(blipData.scale) or 0.8,
                                shortRange = blipData.shortRange == 1 or blipData.shortRange == true,
                                display = tonumber(blipData.display) or 4,
                                coords = coords,
                                customImageUrl = blipData.customImageUrl or ""
                            }
                        }
                    end
                end
            end
        end
    end
end

-- Create a new blip at player's position
local function CreateBlip(data)
    if not data then data = {} end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    if not coords then
        ShowNotification('Failed to get player position', 'error')
        return
    end
    
    local blipData = {
        name = data.name or Config.DefaultBlipSettings.name,
        sprite = tonumber(data.sprite) or Config.DefaultBlipSettings.sprite,
        color = tonumber(data.color) or Config.DefaultBlipSettings.color,
        scale = tonumber(data.scale) or Config.DefaultBlipSettings.scale,
        shortRange = data.shortRange ~= nil and data.shortRange or Config.DefaultBlipSettings.shortRange,
        display = tonumber(data.display) or Config.DefaultBlipSettings.display,
        coords = coords,
        customImageUrl = data.customImageUrl or ""
    }
    
    TriggerServerEvent('ec-blips:server:createBlip', blipData)
    ShowNotification('Blip created: ' .. blipData.name, 'success')
end

-- Update an existing blip
local function UpdateBlip(id, data)
    if not id or not data then return false end
    
    id = tonumber(id)
    if not id or not blips[id] then return false end
    
    local blipHandle = blips[id].handle
    if not DoesBlipExist(blipHandle) then return false end
    
    -- Update blip on the map with error checking
    if data.sprite then 
        local sprite = tonumber(data.sprite)
        if sprite then SetBlipSprite(blipHandle, sprite) end
    end
    
    if data.color then 
        local color = tonumber(data.color)
        if color then SetBlipColour(blipHandle, color) end
    end
    
    if data.scale then 
        local scale = tonumber(data.scale)
        if scale then SetBlipScale(blipHandle, scale) end
    end
    
    if data.shortRange ~= nil then 
        -- Convert to boolean for the native function
        SetBlipAsShortRange(blipHandle, data.shortRange)
    end
    
    if data.display then 
        local display = tonumber(data.display)
        if display then SetBlipDisplay(blipHandle, display) end
    end
    
    if data.name then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blipHandle)
    end
    
    -- Update server data
    TriggerServerEvent('ec-blips:server:updateBlip', id, data)
    ShowNotification('Blip updated: ' .. (data.name or blips[id].data.name), 'success')
    return true
end

-- Delete a blip
local function DeleteBlip(id)
    if not id then return false end
    
    id = tonumber(id)
    if not id or not blips[id] then return false end
    
    local blipHandle = blips[id].handle
    if DoesBlipExist(blipHandle) then
        RemoveBlip(blipHandle)
    end
    
    TriggerServerEvent('ec-blips:server:deleteBlip', id)
    blips[id] = nil
    ShowNotification('Blip deleted', 'success')
    return true
end

-- Find the nearest blip to the player
local function GetNearestBlip()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    if not playerCoords then
        ShowNotification('Failed to get player position', 'error')
        return nil, 1000.0
    end
    
    local closestDistance = 1000.0
    local closestBlipId = nil
    
    for id, blipData in pairs(blips) do
        if blipData and blipData.data and blipData.data.coords then
            local coords = blipData.data.coords
            local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
            
            if distance < closestDistance then
                closestDistance = distance
                closestBlipId = id
            end
        end
    end
    
    return closestBlipId, closestDistance
end

-- Open the blip management menu
function OpenBlipMenu()
    if isMenuOpen then return end
    isMenuOpen = true
    
    -- Prepare data for UI
    local blipsList = {}
    for id, blipData in pairs(blips) do
        if blipData and blipData.data then
            table.insert(blipsList, {
                id = blipData.data.id,
                name = blipData.data.name,
                sprite = blipData.data.sprite,
                color = blipData.data.color,
                scale = blipData.data.scale,
                shortRange = blipData.data.shortRange,
                customImageUrl = blipData.data.customImageUrl or "",
                coords = {
                    x = blipData.data.coords.x,
                    y = blipData.data.coords.y,
                    z = blipData.data.coords.z
                }
            })
        end
    end
    
    -- Send data to NUI
    SetNuiFocus(true, true)
    
    -- Determine which sprite list to use
    local spriteData = Config.CommonSprites
    local spriteCategories = Config.BlipCategories
    
    if Config.UseExtendedSpriteList then
        if Config.ExtendedBlipCategories and #Config.ExtendedBlipCategories > 0 then
            spriteCategories = Config.ExtendedBlipCategories
            spriteData = Config.AllExtendedSprites or Config.AllSprites or Config.CommonSprites
        else
            spriteCategories = Config.BlipCategories
            spriteData = Config.AllSprites or Config.CommonSprites
        end
    end
    
    SendNUIMessage({
        action = "openMenu",
        blips = blipsList,
        commonColors = Config.CommonColors or {},
        commonSprites = spriteData,
        spriteCategories = spriteCategories
    })
end

-- Close the NUI interface
function CloseBlipMenu()
    if not isMenuOpen then return end
    
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeMenu"
    })
end

-- NUI Callbacks
RegisterNUICallback('closeMenu', function(data, cb)
    CloseBlipMenu()
    if cb then cb({success = true}) end
end)

RegisterNUICallback('createBlip', function(data, cb)
    if not data then
        if cb then cb({success = false, message = "Invalid data"}) end
        return
    end
    
    local newBlip = {
        name = data.name,
        sprite = tonumber(data.sprite),
        color = tonumber(data.color),
        scale = tonumber(data.scale),
        shortRange = data.shortRange, -- This should be a boolean
        customImageUrl = data.customImageUrl or ""
    }
    
    CreateBlip(newBlip)
    if cb then cb({success = true}) end
end)

RegisterNUICallback('updateBlip', function(data, cb)
    if not data or not data.id then
        if cb then cb({success = false, message = "Invalid data"}) end
        return
    end
    
    local id = tonumber(data.id)
    local updatedData = {
        name = data.name,
        sprite = tonumber(data.sprite),
        color = tonumber(data.color),
        scale = tonumber(data.scale),
        shortRange = data.shortRange, -- This should be a boolean
        customImageUrl = data.customImageUrl
    }
    
    local success = UpdateBlip(id, updatedData)
    if cb then cb({success = success}) end
end)

RegisterNUICallback('deleteBlip', function(data, cb)
    if not data or not data.id then
        if cb then cb({success = false, message = "Invalid data"}) end
        return
    end
    
    local id = tonumber(data.id)
    local success = DeleteBlip(id)
    if cb then cb({success = success}) end
end)

RegisterNUICallback('getNearestBlip', function(data, cb)
    local id, distance = GetNearestBlip()
    
    if not id or distance > 50.0 then
        if cb then cb({
            success = false,
            message = 'No blips found nearby'
        }) end
        return
    end
    
    if cb then cb({
        success = true,
        blip = {
            id = id,
            name = blips[id].data.name,
            sprite = blips[id].data.sprite,
            color = blips[id].data.color,
            scale = blips[id].data.scale,
            shortRange = blips[id].data.shortRange,
            customImageUrl = blips[id].data.customImageUrl or ""
        }
    }) end
end)

-- Emergency close UI callback
RegisterNUICallback('forceClose', function(data, cb)
    isMenuOpen = false
    SetNuiFocus(false, false)
    if cb then cb({success = true}) end
end)

-- Command to open the blip menu
RegisterCommand(Config.Command or 'blips', function()
    TriggerServerEvent('ec-blips:server:checkPermission')
end, false)

-- Event to open menu after permission check
RegisterNetEvent('ec-blips:client:openMenuAfterPermCheck', function()
    OpenBlipMenu()
end)

-- Sync blips from server
RegisterNetEvent('ec-blips:client:syncBlips', function(blipsData)
    LoadBlips(blipsData)
end)

-- Initialize
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Wait for everything to initialize
    Citizen.CreateThread(function()
        Citizen.Wait(1000)
        
        -- Initialize framework
        InitializeFramework()
        
        -- Force close UI if it's open
        isMenuOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            action = "closeMenu"
        })
        
        TriggerServerEvent('ec-blips:server:requestBlips')
        
        -- Register command suggestion
        TriggerEvent('chat:addSuggestion', '/' .. (Config.Command or 'blips'), 'Open the blip management menu')
    end)
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    -- Clean up
    for _, blipData in pairs(blips) do
        if blipData and blipData.handle and DoesBlipExist(blipData.handle) then
            RemoveBlip(blipData.handle)
        end
    end
    
    -- Remove command suggestion when resource stops
    TriggerEvent('chat:removeSuggestion', '/' .. (Config.Command or 'blips'))
    
    -- Close UI if open
    if isMenuOpen then
        CloseBlipMenu()
    end
end)

-- Handle player loading
if Config.Framework == 'qb' then
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        Citizen.CreateThread(function()
            Citizen.Wait(1000) -- Wait a bit to ensure everything is loaded
            TriggerServerEvent('ec-blips:server:requestBlips')
        end)
    end)
elseif Config.Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded', function()
        Citizen.CreateThread(function()
            Citizen.Wait(1000) -- Wait a bit to ensure everything is loaded
            TriggerServerEvent('ec-blips:server:requestBlips')
        end)
    end)
end

-- Key binding to close UI if it gets stuck
RegisterKeyMapping('closeblipui', 'Close Blip UI', 'keyboard', 'ESCAPE')
RegisterCommand('closeblipui', function()
    if isMenuOpen then
        CloseBlipMenu()
    end
end, false)

-- Emergency command to force close UI
RegisterCommand('forceblipui', function()
    isMenuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = "closeMenu"
    })
    ShowNotification('UI forcefully closed', 'info')
end, false)
