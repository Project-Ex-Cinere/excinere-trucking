fx_version 'cerulean'
game 'gta5'

author 'Project ExCinere'
description 'ExCinere-Trucking Script'

shared_script 'config.lua'

client_scripts {
    'client/cl_*.lua',
    'client/cl_*.lua'
}

server_script {
    'server/sv_main.lua'
}

files {
    'html/dist/index.html',
    'html/dist/assets/*.css',
    'html/dist/assets/*.js',
    'html/dist/*.svg',
}

ui_page 'html/dist/index.html'