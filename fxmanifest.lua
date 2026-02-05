fx_version 'cerulean'
game 'gta5'

author 'Neon Dream'
description 'Drug Growing and Crafting System with Placeable Props'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core',
    'oxmysql'
}

lua54 'yes'
