fx_version 'cerulean'
game 'gta5'

author 'NRG Development'
description 'EC-Blips - In-game blip management system with clean UI'
version '1.0.1'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua',
}

ui_page 'ui/index.html'

files {
    'ui/index.html',
    'ui/style.css',
    'ui/script.js',
    'ui/assets/*.png',
    'ui/assets/icons/*.svg'
}

lua54 'yes'

dependency 'oxmysql'
