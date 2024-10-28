fx_version 'cerulean'
game 'gta5'

author 'Project ExCinere'
description 'ExCinere-Trucking Script'

shared_script 'config.lua'

client_scripts {
    'client/cl_utils.lua',
   'client/cl_main.lua'
}

server_script {
   'server/sv_main.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

ui_page 'html/index.html'