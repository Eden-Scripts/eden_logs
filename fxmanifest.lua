---@diagnostic disable: undefined-global
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Eden Development Team (Snaily)'
description 'Logs Resource for Eden Services'

store 'store.edenservices.dev'
discord 'discord.edenservices.dev'

shared_scripts {
    'import.lua',
}

server_scripts {
    'server/main.lua',
    'server/logs.lua'
}