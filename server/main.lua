local data = import 'data'

---Get player identifiers by type
---@param source integer
---@param type string --[[@as license, steam, discord, xbox]]
---@return string | nil
local function getIdentifierType(source, type)
    if not source then
        return nil
    end

    for key, value in next, GetPlayerIdentifiers(source) do
        if value:match(type) then
            return type ~= 'discord' and value or value:sub(string.len('discord:') + 1)
        end
    end

    return nil
end

---Convert Hex Code to Int value for embed colors
---@param hexCode string
---@return unknown
local function convertHexToInt(hexCode)
    if hexCode:match('#') then
        hexCode = hexCode:gsub('#', '')
    end

    local intValue = tonumber(hexCode, 16)

    if not intValue then
        return error(('Invalid int value for %s color'):format(hexCode), 3)
    end

    return (intValue & 0xFFFFFFFF)
end

---Send server-data to discord by a webhook
---@param type string
---@param title string
---@param message string
---@param source integer
local function sendDiscordLog(type, title, message, source)
    if not data?.logs[type] then
        return error(('Invalid %s webhook type for discord logs'):format(type), 3)
    end

    local ped = GetPlayerPed(source)
    local date = os.date('*t')
    local embed = {
        {
            color = convertHexToInt(data.logs[type].color),
            title = title,
            fields = {},
            footer = {
                text = ('Date %s/%s/%s | %s:%s minutes and %s seconds'):format(date.day, date.month, date.year, date.hour, date.min, date.sec),
                icon_url = data.icon
            }
        }
    }

    if message then
        embed[1].description = message
    end

    if source then
        table.insert(embed[1].fields, { name = 'Player ID:', value = source or 'Unknown', inline = true })

        if data.config.activeDiscords and getIdentifierType(source, 'discord') then
            table.insert(embed[1].fields, { name =  'Player Discord:', value = '<@'..getIdentifierType(source, 'discord')..'>', inline = true })
        end

        table.insert(embed[1].fields, { name = 'Steam name:', value = GetPlayerName(source) or 'Unknown', inline = true })
        table.insert(embed[1].fields, { name = 'Steam hex:', value = getIdentifierType(source, 'steam'), inline = true })

        if data.config.activeIps then
            ---@diagnostic disable-next-line: param-type-mismatch
            table.insert(embed[1].fields, { name = 'Player IP:', value = GetPlayerEndpoint(source), inline = true })
        end

        ---@diagnostic disable-next-line: param-type-mismatch
        if GetPlayerPing(source) >= 1 then
            ---@diagnostic disable-next-line: param-type-mismatch
            table.insert(embed[1].fields, { name = 'Player Ping:', value = ('**%s** ms'):format(GetPlayerPing(source)), inline = true })
        end

        if DoesEntityExist(ped) then
            table.insert(embed[1].fields, { name = 'Player Health:', value = ('%s/**100**'):format(math.floor(GetEntityHealth(ped) / 2)), inline = true })
            table.insert(embed[1].fields, { name = 'Player Armour:', value = ('%s/**100**'):format(GetPedArmour(ped)), inline = true })
        end
    end

    if #embed[1]?.fields > 0 then
        PerformHttpRequest(data.logs[type].url, function(error, text, headers) end, 'POST', json.encode({ username = data.name, embeds = embed }), { ['Content-Type'] = 'application/json' })
    end
end

exports('sendDiscordLog', sendDiscordLog)
RegisterNetEvent('eden_logs:sendDiscordLog', sendDiscordLog)