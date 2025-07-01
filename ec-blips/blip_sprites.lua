
Config = Config or {}
Config.ExtendedSpriteList = {
    -- This is a comprehensive list of all available blip sprites in GTA5
    -- Format: {id = sprite_id, name = "Descriptive Name", category = "Category Name"}
    
    -- IDs 0-100
    {id = 0, name = "Blank", category = "General"},
    {id = 1, name = "Standard", category = "General"},
    {id = 2, name = "Standard with Friend", category = "People"},
    {id = 3, name = "White", category = "General"},
    {id = 4, name = "Mission Vehicle", category = "Vehicles"},
    {id = 5, name = "Mission Bike", category = "Vehicles"},
    {id = 6, name = "Player", category = "People"},
    {id = 7, name = "North", category = "General"},
    {id = 8, name = "Waypoint", category = "General"},
    {id = 9, name = "Big Circle", category = "General"},
    {id = 10, name = "Parachute", category = "Activities"},
    {id = 11, name = "Lobby", category = "General"},
    {id = 12, name = "GTA Race", category = "Activities"},
    {id = 13, name = "Deathmatch", category = "Activities"},
    {id = 14, name = "Arm Wrestling", category = "Activities"},
    {id = 15, name = "Ammunition", category = "Services"},
    {id = 16, name = "Strip Club", category = "Entertainment"},
    {id = 17, name = "Barber", category = "Services"},
    {id = 18, name = "Car Mod Shop", category = "Services"},
    {id = 19, name = "Clothes", category = "Services"},
    {id = 20, name = "Tattoo", category = "Services"},
    {id = 21, name = "German Car", category = "Vehicles"},
    {id = 22, name = "Bike", category = "Vehicles"},
    {id = 23, name = "Crew Member", category = "People"},
    {id = 24, name = "Race Finish", category = "Activities"},
    {id = 25, name = "Store", category = "Services"},
    {id = 26, name = "Helicopter", category = "Vehicles"},
    {id = 27, name = "Plane", category = "Vehicles"},
    {id = 28, name = "Boat", category = "Vehicles"},
    {id = 29, name = "Vehicle Sales", category = "Services"},
    {id = 30, name = "Bike Sales", category = "Services"},
    {id = 31, name = "Garage Vehicle", category = "Vehicles"},
    {id = 32, name = "Garage Bike", category = "Vehicles"},
    {id = 33, name = "Actor", category = "People"},
    {id = 34, name = "Camp", category = "Locations"},
    {id = 35, name = "Military", category = "Locations"},
    {id = 36, name = "Gun Shop", category = "Services"},
    {id = 37, name = "Crown", category = "General"},
    {id = 38, name = "Standard with Ring", category = "General"},
    {id = 39, name = "Michael's House", category = "Locations"},
    {id = 40, name = "Trevor's House", category = "Locations"},
    {id = 41, name = "Franklin's House", category = "Locations"},
    {id = 42, name = "Tractor", category = "Vehicles"},
    {id = 43, name = "Tennis", category = "Activities"},
    {id = 44, name = "Golf Flag", category = "Activities"},
    {id = 45, name = "Shooting Range", category = "Activities"},
    {id = 46, name = "Triathlon", category = "Activities"},
    {id = 47, name = "Off-Road Race", category = "Activities"},
    {id = 48, name = "Gang Attack", category = "Activities"},
    {id = 49, name = "Enemy Helicopter", category = "Vehicles"},
    {id = 50, name = "Police Station", category = "Services"},
    {id = 51, name = "Hospital", category = "Services"},
    {id = 52, name = "Armored Truck", category = "Vehicles"},
    {id = 53, name = "Tow Truck", category = "Vehicles"},
    {id = 54, name = "Barber 2", category = "Services"},
    {id = 55, name = "Car Mod Shop 2", category = "Services"},
    {id = 56, name = "Clothes 2", category = "Services"},
    {id = 57, name = "Tattoo 2", category = "Services"},
    {id = 58, name = "Michael", category = "People"},
    {id = 59, name = "Trevor", category = "People"},
    {id = 60, name = "Franklin", category = "People"},
    {id = 61, name = "Fast Food", category = "Services"},
    {id = 62, name = "Lester", category = "People"},
    {id = 63, name = "Omega", category = "People"},
    {id = 64, name = "Tonya", category = "People"},
    {id = 65, name = "Paparazzo", category = "People"},
    {id = 66, name = "Bounty", category = "Activities"},
    {id = 67, name = "Cable Car", category = "Transportation"},
    {id = 68, name = "Cinema", category = "Entertainment"},
    {id = 69, name = "Weed Stash", category = "Misc"},
    {id = 70, name = "Hunting", category = "Activities"},
    {id = 71, name = "Garage", category = "Services"},
    {id = 72, name = "Golf Cart", category = "Vehicles"},
    {id = 73, name = "Drugs Package", category = "Misc"},
    {id = 74, name = "Apartment", category = "Properties"},
    {id = 75, name = "Question Mark", category = "General"},
    {id = 76, name = "Taxi", category = "Transportation"},
    {id = 77, name = "Fuel", category = "Services"},
    {id = 78, name = "Bar", category = "Entertainment"},
    {id = 79, name = "Base Jumping", category = "Activities"},
    {id = 80, name = "Car Wash", category = "Services"},
    {id = 81, name = "Comedy Club", category = "Entertainment"},
    {id = 82, name = "Dart", category = "Activities"},
    {id = 83, name = "Dating", category = "Activities"},
    {id = 84, name = "Epsilon", category = "Misc"},
    {id = 85, name = "Financial", category = "Services"},
    {id = 86, name = "Bank Heist", category = "Activities"},
    {id = 87, name = "Jewelry Heist", category = "Activities"},
    {id = 88, name = "Golf", category = "Activities"},
    {id = 89, name = "Clothes Store", category = "Services"},
    {id = 90, name = "Altruist Cult", category = "Misc"},
    {id = 91, name = "Marijuana Shop", category = "Services"},
    {id = 92, name = "Hangar", category = "Properties"},
    {id = 93, name = "Helipad", category = "Transportation"},
    {id = 94, name = "Jerry Can", category = "Misc"},
    {id = 95, name = "Masks", category = "Services"},
    {id = 96, name = "Heist Setup", category = "Activities"},
    {id = 97, name = "Incapacitated", category = "People"},
    {id = 98, name = "Spawn Point", category = "General"},
    {id = 99, name = "Boilersuit", category = "Misc"},
    {id = 100, name = "Completed", category = "General"},
    
    -- Continue with more sprites...
    -- This is just a sample, you would need to add all sprites from 0-826
}

-- Create extended categories based on the comprehensive list
Config.ExtendedBlipCategories = {}
local categoryMap = {}

-- Group sprites by category
for _, sprite in ipairs(Config.ExtendedSpriteList) do
    local category = sprite.category
    if not categoryMap[category] then
        categoryMap[category] = {
            name = category,
            sprites = {}
        }
    end
    table.insert(categoryMap[category].sprites, {id = sprite.id, name = sprite.name})
end

-- Convert map to array
for categoryName, categoryData in pairs(categoryMap) do
    table.insert(Config.ExtendedBlipCategories, categoryData)
end

-- Sort categories alphabetically
table.sort(Config.ExtendedBlipCategories, function(a, b)
    return a.name < b.name
end)
