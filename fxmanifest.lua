fx_version 'cerulean'
game 'gta5'
description 'A simple bridge resource for ESX Compatibility for NPWD'

server_only 'yes'
use_fxv2_oal 'yes'
lua54 'yes'

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua'
}