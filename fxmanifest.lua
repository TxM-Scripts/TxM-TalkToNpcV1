fx_version 'cerulean'
game 'gta5'

author 'TxM-TalkToNpcV1'
description 'TxM - Talk to NPC Interaction System for QBCore'
version '1.0.0'

ui_page 'build/ui/index.html'

files {
    'build/ui/index.html',
    'build/ui/style.css',
    'build/ui/script.js',
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependency 'interact' --https://github.com/darktrovx/interact
