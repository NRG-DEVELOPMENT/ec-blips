Config = {}

-- Permission system
Config.UsePermissionSystem = false -- Set to false to use only whitelist
Config.RequiredPermission = 'admin' -- QBCore permission level required if using permission system

-- Whitelist system
Config.UseWhitelist = true -- Set to false to use only permission system
Config.Whitelist = {
    -- FiveM identifiers (license:, steam:, discord:, etc.)
    ["license:1234567890abcdef1234567890abcdef12345678"] = true,
    ["steam:1100001012345678"] = true,
    ["discord:783727897961037867"] = true,
    
    -- You can add more identifiers here
}

-- Command to open the blip management menu
Config.Command = 'blips' -- Change this to whatever command you prefer

-- Default blip settings
Config.DefaultBlipSettings = {
    sprite = 1,
    color = 0,
    scale = 0.8,
    name = "New Blip",
    shortRange = true,
    display = 4
}

-- Common blip colors for quick selection
Config.CommonColors = {
    {id = 0, name = "White"},
    {id = 1, name = "Red"},
    {id = 2, name = "Green"},
    {id = 3, name = "Blue"},
    {id = 4, name = "Yellow"},
    {id = 5, name = "Light Blue"},
    {id = 6, name = "Purple"},
    {id = 7, name = "Pink"},
    {id = 8, name = "Orange"},
    {id = 39, name = "Light Red"},
    {id = 46, name = "Dark Blue"},
    {id = 52, name = "Dark Green"},
    {id = 76, name = "Dark Purple"},
    {id = 84, name = "Gold"}
}

-- Common blip sprites for quick selection
Config.CommonSprites = {
    {id = 1, name = "Standard"},
    {id = 8, name = "Waypoint"},
    {id = 25, name = "Store"},
    {id = 50, name = "Police"},
    {id = 61, name = "Hospital"},
    {id = 71, name = "Garage"},
    {id = 106, name = "Vehicle Shop"},
    {id = 110, name = "Clothing Store"},
    {id = 225, name = "Barber Shop"},
    {id = 361, name = "Ammunation"},
    {id = 410, name = "Mechanic"},
    {id = 521, name = "Restaurant"},
    {id = 566, name = "Bank"},
    {id = 614, name = "Apartment"}
}

-- Database table name
Config.DatabaseTable = 'ec_blips'
