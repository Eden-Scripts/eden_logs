local eden = exports.eden_logs

AddEventHandler('playerConnecting', function()
    local source = source

    eden:sendDiscordLog('connect', 'Player connected', nil, source)
end)

AddEventHandler('playerDropped', function(reason)
    eden:sendDiscordLog('dropped', 'Player left', ('Player left the server. Reason: **%s**'):format(reason), source)
end)