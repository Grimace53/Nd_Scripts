fx_version 'cerulean'
game 'gta5'

author 'Grimace53'
description 'Neon Dream Drug System'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

client_scripts {
    'client/*.lua'
}

lua54 'yes'
