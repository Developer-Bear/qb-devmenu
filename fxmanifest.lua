fx_version 'cerulean'

game 'gta5'

description 'Developer Menu for QBCore Framework'

version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@qb-core/import.lua'
}

client_scripts {
    '@menuv/menuv.lua',
    'devmenu-config.lua',
    'devmenu-cMenu.lua',
    'devmenu-cFunctions.lua'
}

server_scripts {
    'devmenu-config.lua',
    'devmenu-server.lua'
}

files { -- Credits to https://github.com/LVRP-BEN/bl_coords for clipboard copy method
    'html/index.html',
    'html/index.js'
}

dependencies {
    'menuv',
    'qb-core'
}