fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Neon Dream'
description 'Farming System with Fertilizers and Super Serum'
version '1.1.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/*.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}
