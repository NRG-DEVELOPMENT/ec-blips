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
    ['discord:1008257467530084365'] = true
    
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

-- Categorized blip sprites
Config.BlipCategories = {
    {
        name = "General",
        sprites = {
            {id = 1, name = "Standard"},
            {id = 8, name = "Waypoint"},
            {id = 38, name = "Standard with Ring"},
            {id = 75, name = "Question Mark"}
        }
    },
    {
        name = "Locations",
        sprites = {
            {id = 40, name = "Safehouse"},
            {id = 50, name = "Police Station"},
            {id = 61, name = "Hospital"},
            {id = 71, name = "Garage"},
            {id = 72, name = "Parachute"},
            {id = 73, name = "Helicopter Pad"},
            {id = 106, name = "Vehicle Shop"},
            {id = 110, name = "Clothing Store"},
            {id = 225, name = "Barber Shop"},
            {id = 361, name = "Ammunation"},
            {id = 410, name = "Mechanic"},
            {id = 521, name = "Restaurant"},
            {id = 566, name = "Bank"},
            {id = 614, name = "Apartment"}
        }
    },
    {
        name = "Vehicles",
        sprites = {
            {id = 56, name = "Garage Vehicle"},
            {id = 225, name = "Car"},
            {id = 226, name = "Bike"},
            {id = 227, name = "Boat"},
            {id = 251, name = "Helicopter"},
            {id = 307, name = "Plane"},
            {id = 348, name = "Motorcycle"},
            {id = 523, name = "Race Car"},
            {id = 595, name = "Jet Ski"}
        }
    },
    {
        name = "Activities",
        sprites = {
            {id = 78, name = "Tennis"},
            {id = 79, name = "Golf"},
            {id = 311, name = "Race"},
            {id = 315, name = "Darts"},
            {id = 355, name = "Shooting Range"},
            {id = 357, name = "Triathlon"},
            {id = 358, name = "Off-Road Race"},
            {id = 359, name = "Triathlon 2"},
            {id = 486, name = "Stunt Race"}
        }
    },
    {
        name = "People",
        sprites = {
            {id = 6, name = "Player"},
            {id = 7, name = "Friend"},
            {id = 23, name = "Crew"},
            {id = 57, name = "Friend 2"},
            {id = 58, name = "Mission Character"},
            {id = 66, name = "Bounty Hit"},
            {id = 280, name = "Character Trevor"},
            {id = 281, name = "Character Michael"},
            {id = 282, name = "Character Franklin"},
            {id = 303, name = "Mugger"},
            {id = 304, name = "Snitch"}
        }
    },
    {
        name = "Services",
        sprites = {
            {id = 52, name = "Armored Truck"},
            {id = 67, name = "Cable Car"},
            {id = 76, name = "Taxi"},
            {id = 108, name = "Tow Truck"},
            {id = 198, name = "Fairground"},
            {id = 317, name = "Towing"},
            {id = 318, name = "Garbage Truck"},
            {id = 408, name = "Hairdresser"},
            {id = 409, name = "Tattoo Parlor"},
            {id = 431, name = "Fire Department"},
            {id = 446, name = "Laundromat"},
            {id = 494, name = "Recycling"}
        }
    },
    {
        name = "Properties",
        sprites = {
            {id = 350, name = "Garage for Sale"},
            {id = 374, name = "House for Sale"},
            {id = 375, name = "Apartment for Sale"},
            {id = 411, name = "Garage 2"},
            {id = 417, name = "Hangar for Sale"},
            {id = 429, name = "Dock for Sale"},
            {id = 475, name = "Clubhouse for Sale"},
            {id = 476, name = "Office for Sale"},
            {id = 477, name = "Clubhouse"},
            {id = 492, name = "Warehouse for Sale"},
            {id = 524, name = "Office"},
            {id = 557, name = "Bunker"},
            {id = 569, name = "Hangar"},
            {id = 590, name = "Facility"}
        }
    },
    {
        name = "Businesses",
        sprites = {
            {id = 93, name = "Gun Shop"},
            {id = 135, name = "Clothes Shop"},
            {id = 147, name = "Cinema"},
            {id = 267, name = "Weed Shop"},
            {id = 439, name = "Nightclub"},
            {id = 478, name = "Warehouse"},
            {id = 480, name = "Biker Clubhouse"},
            {id = 484, name = "Office Garage"},
            {id = 487, name = "Import/Export Garage"},
            {id = 488, name = "Vehicle Warehouse"},
            {id = 500, name = "Biker Business"},
            {id = 501, name = "Biker Supply Business"},
            {id = 513, name = "Arcade"},
            {id = 614, name = "Casino"},
            {id = 679, name = "Auto Shop"},
            {id = 780, name = "Agency"}
        }
    },
    {
        name = "Misc",
        sprites = {
            {id = 84, name = "Air Race"},
            {id = 126, name = "Bar"},
            {id = 162, name = "Armored Van"},
            {id = 188, name = "Survival"},
            {id = 205, name = "Tank"},
            {id = 269, name = "Cash Pickup"},
            {id = 305, name = "Ammo Pickup"},
            {id = 306, name = "Rocket Pickup"},
            {id = 351, name = "Gang Attack"},
            {id = 398, name = "Package"},
            {id = 403, name = "Boost"},
            {id = 407, name = "Crate Drop"},
            {id = 441, name = "Devin"},
            {id = 442, name = "Marina"},
            {id = 473, name = "Pickup"},
            {id = 474, name = "Arms Dealing"},
            {id = 481, name = "Wrench"},
            {id = 514, name = "Skull"},
            {id = 515, name = "Dollar Sign"},
            {id = 535, name = "Arena Wars"},
            {id = 587, name = "Adversary Mode"},
            {id = 600, name = "Bomb"},
            {id = 601, name = "Bomb 2"},
            {id = 618, name = "Heist Diamond"},
            {id = 619, name = "Heist Cash"},
            {id = 620, name = "Heist Gold"},
            {id = 621, name = "Heist Painting"},
            {id = 685, name = "Submarine"},
            {id = 745, name = "Treasure Chest"}
        }
    }
}

-- Create a flattened list of all sprites for backward compatibility
Config.AllSprites = {}
for _, category in pairs(Config.BlipCategories) do
    for _, sprite in pairs(category.sprites) do
        table.insert(Config.AllSprites, sprite)
    end
end

-- Keep the original CommonSprites for backward compatibility
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

-- Add a file with all blip sprites (0-826)
-- This will be loaded separately to avoid making the config file too large
Config.UseExtendedSpriteList = true
