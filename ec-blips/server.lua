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
    end
end

-- Initialize database
local function InitializeDatabase()
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `]]..Config.DatabaseTable..[[` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `name` VARCHAR(50) NOT NULL,
            `sprite` INT NOT NULL,
            `color` INT NOT NULL,
            `scale` FLOAT NOT NULL,
            `shortRange` TINYINT(1) NOT NULL DEFAULT 1,
            `display` INT NOT NULL DEFAULT 4,
            `coords` LONGTEXT NOT NULL,
            `customImageUrl` VARCHAR(255) DEFAULT NULL
        )
    ]])
    
    -- Check if customImageUrl column exists, add it if not
    MySQL.query([[
        SELECT COUNT(*) AS count FROM information_schema.COLUMNS 
        WHERE TABLE_SCHEMA = DATABASE() 
        AND TABLE_NAME = ']]..Config.DatabaseTable..[[' 
        AND COLUMN_NAME = 'customImageUrl'
    ]], {}, function(result)
        if result[1].count == 0 then
            MySQL.query([[
                ALTER TABLE `]]..Config.DatabaseTable..[[`
                ADD COLUMN `customImageUrl` VARCHAR(255) DEFAULT NULL
            ]])
        end
    end)
end

-- Load all blips from database
local function LoadBlipsFromDatabase()
    local blips = MySQL.query.await('SELECT * FROM `'..Config.DatabaseTable..'`')
    return blips or {}
end

-- Check if player is whitelisted
local function IsPlayerWhitelisted(src)
    if not Config.UseWhitelist then return true end
    
    local identifiers = GetPlayerIdentifiers(src)
    
    for _, identifier in ipairs(identifiers) do
        if Config.Whitelist[identifier] then
            return true
        end
    end
    
    return false
end

-- Check if player has permission
local function HasPermission(src)
    if not Config.UsePermissionSystem then return true end
    
    if Config.Framework == 'qb' and QBCore then
        local Player = QBCore.Functions.GetPlayer(src)
        if not Player then return false end
        
        return QBCore.Functions.HasPermission(src, Config.RequiredPermission)
    elseif Config.Framework == 'esx' and ESX then
        local xPlayer = ESX.GetPlayerFromId(src)
        if not xPlayer then return false end
        
        local playerGroup = xPlayer.getGroup()
        for _, adminGroup in ipairs(Config.ESXAdminGroups) do
            if playerGroup == adminGroup then
                return true
            end
        end
    end
    
    return false
end

-- Check if player can use blip commands
local function CanUseBlipCommands(src)
    -- If both systems are enabled, player needs to pass at least one
    if Config.UsePermissionSystem and Config.UseWhitelist then
        return HasPermission(src) or IsPlayerWhitelisted(src)
    end
    
    -- If only one system is enabled, player needs to pass that one
    if Config.UsePermissionSystem then
        return HasPermission(src)
    end
    
    if Config.UseWhitelist then
        return IsPlayerWhitelisted(src)
    end
    
    -- If no system is enabled, allow everyone
    return true
end

-- Add player to whitelist
RegisterCommand("addblipwhitelist", function(source, args, rawCommand)
    local src = source
    
    -- Only console or players with admin permission can add to whitelist
    if src > 0 and not HasPermission(src) then
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'You do not have permission to use this command')
            end
        end
        return
    end
    
    if #args < 1 then
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'Usage: /addblipwhitelist [identifier]', 'error')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'Usage: /addblipwhitelist [identifier]')
            end
        else
            print('Usage: addblipwhitelist [identifier]')
        end
        return
    end
    
    local identifier = args[1]
    
    -- Add to whitelist
    Config.Whitelist[identifier] = true
    
    -- Save whitelist to file
    SaveResourceFile(GetCurrentResourceName(), "whitelist.json", json.encode(Config.Whitelist), -1)
    
    if src > 0 then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'Added ' .. identifier .. ' to blip whitelist', 'success')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'Added ' .. identifier .. ' to blip whitelist')
        end
    else
        print('Added ' .. identifier .. ' to blip whitelist')
    end
end, true)

-- Remove player from whitelist
RegisterCommand("removeblipwhitelist", function(source, args, rawCommand)
    local src = source
    
    -- Only console or players with admin permission can remove from whitelist
    if src > 0 and not HasPermission(src) then
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'You do not have permission to use this command')
            end
        end
        return
    end
    
    if #args < 1 then
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'Usage: /removeblipwhitelist [identifier]', 'error')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'Usage: /removeblipwhitelist [identifier]')
            end
        else
            print('Usage: removeblipwhitelist [identifier]')
        end
        return
    end
    
    local identifier = args[1]
    
    -- Remove from whitelist
    Config.Whitelist[identifier] = nil
    
    -- Save whitelist to file
    SaveResourceFile(GetCurrentResourceName(), "whitelist.json", json.encode(Config.Whitelist), -1)
    
    if src > 0 then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'Removed ' .. identifier .. ' from blip whitelist', 'success')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'Removed ' .. identifier .. ' from blip whitelist')
        end
    else
        print('Removed ' .. identifier .. ' from blip whitelist')
    end
end, true)

-- List all identifiers for a player
RegisterCommand("listidentifiers", function(source, args, rawCommand)
    local src = source
    
    -- Only console or players with admin permission can list identifiers
    if src > 0 and not HasPermission(src) then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'You do not have permission to use this command')
        end
        return
    end
    
    local targetId = args[1] and tonumber(args[1]) or src
    
    if GetPlayerName(targetId) then
        local identifiers = GetPlayerIdentifiers(targetId)
        
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'Identifiers for ' .. GetPlayerName(targetId) .. ' sent to console', 'info')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'Identifiers for ' .. GetPlayerName(targetId) .. ' sent to console')
            end
        end
        
        print('Identifiers for ' .. GetPlayerName(targetId) .. ':')
        for _, identifier in ipairs(identifiers) do
            print(identifier)
        end
    else
        if src > 0 then
            if Config.Framework == 'qb' and QBCore then
                TriggerClientEvent('QBCore:Notify', src, 'Player not found', 'error')
            elseif Config.Framework == 'esx' and ESX then
                TriggerClientEvent('esx:showNotification', src, 'Player not found')
            end
        else
            print('Player not found')
        end
    end
end, true)

-- Check if player has permission to use blip commands
RegisterServerEvent('ec-blips:server:checkPermission')
AddEventHandler('ec-blips:server:checkPermission', function()
    local src = source
    
    if CanUseBlipCommands(src) then
        TriggerClientEvent('ec-blips:client:openMenuAfterPermCheck', src)
    else
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to use this command', 'error')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'You do not have permission to use this command')
        end
    end
end)

RegisterServerEvent('ec-blips:server:createBlip')
AddEventHandler('ec-blips:server:createBlip', function(blipData)
    local src = source
    
    if not CanUseBlipCommands(src) then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to create blips', 'error')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'You do not have permission to create blips')
        end
        return
    end
    
    local coords = json.encode(blipData.coords)
    -- Convert boolean to 0/1 for database
    local shortRange = blipData.shortRange and 1 or 0
    
    local id = MySQL.insert.await('INSERT INTO `'..Config.DatabaseTable..'` (name, sprite, color, scale, shortRange, display, coords, customImageUrl) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
        blipData.name,
        blipData.sprite,
        blipData.color,
        blipData.scale,
        shortRange,
        blipData.display,
        coords,
        blipData.customImageUrl or nil
    })
    
    if id then
        -- Sync to all clients
        SyncBlipsToAllPlayers()
    end
end)

RegisterServerEvent('ec-blips:server:updateBlip')
AddEventHandler('ec-blips:server:updateBlip', function(id, blipData)
    local src = source
    
    if not CanUseBlipCommands(src) then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to update blips', 'error')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'You do not have permission to update blips')
        end
        return
    end
    
    local query = 'UPDATE `'..Config.DatabaseTable..'` SET '
    local params = {}
    local updates = {}
    
    -- Add existing fields
    if blipData.name then
        table.insert(updates, 'name = ?')
        table.insert(params, blipData.name)
    end
    
    if blipData.sprite then
        table.insert(updates, 'sprite = ?')
        table.insert(params, blipData.sprite)
    end
    
    if blipData.color then
        table.insert(updates, 'color = ?')
        table.insert(params, blipData.color)
    end
    
    if blipData.scale then
        table.insert(updates, 'scale = ?')
        table.insert(params, blipData.scale)
    end
    
    if blipData.shortRange ~= nil then
        table.insert(updates, 'shortRange = ?')
        table.insert(params, blipData.shortRange and 1 or 0)
    end
    
    if blipData.display then
        table.insert(updates, 'display = ?')
        table.insert(params, blipData.display)
    end
    
    if blipData.coords then
        table.insert(updates, 'coords = ?')
        table.insert(params, json.encode(blipData.coords))
    end
    
    -- Add customImageUrl field
    if blipData.customImageUrl ~= nil then
        table.insert(updates, 'customImageUrl = ?')
        table.insert(params, blipData.customImageUrl == "" and nil or blipData.customImageUrl)
    end
    
    if #updates > 0 then
        query = query .. table.concat(updates, ', ') .. ' WHERE id = ?'
        table.insert(params, id)
        
        MySQL.update(query, params, function()
            SyncBlipsToAllPlayers()
        end)
    end
end)

-- Delete a blip
RegisterServerEvent('ec-blips:server:deleteBlip')
AddEventHandler('ec-blips:server:deleteBlip', function(id)
    local src = source
    
    if not CanUseBlipCommands(src) then
        if Config.Framework == 'qb' and QBCore then
            TriggerClientEvent('QBCore:Notify', src, 'You do not have permission to delete blips', 'error')
        elseif Config.Framework == 'esx' and ESX then
            TriggerClientEvent('esx:showNotification', src, 'You do not have permission to delete blips')
        end
        return
    end
    
    MySQL.update('DELETE FROM `'..Config.DatabaseTable..'` WHERE id = ?', {id}, function()
        SyncBlipsToAllPlayers()
    end)
end)

-- Request blips from server
RegisterServerEvent('ec-blips:server:requestBlips')
AddEventHandler('ec-blips:server:requestBlips', function()
    local src = source
    local blips = LoadBlipsFromDatabase()
    TriggerClientEvent('ec-blips:client:syncBlips', src, blips)
end)

-- Sync blips to all players
function SyncBlipsToAllPlayers()
    local blips = LoadBlipsFromDatabase()
    TriggerClientEvent('ec-blips:client:syncBlips', -1, blips)
end

-- Load whitelist from file
local function LoadWhitelist()
    local fileContent = LoadResourceFile(GetCurrentResourceName(), "whitelist.json")
    if fileContent then
        local whitelist = json.decode(fileContent)
        if whitelist then
            Config.Whitelist = whitelist
        end
    end
end

-- Initialize
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    
    -- Initialize framework
    InitializeFramework()
    
    -- Initialize database and load whitelist
    InitializeDatabase()
    LoadWhitelist()
end)
