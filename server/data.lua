return {
    name = 'Eden Logs Management',
    icon = 'https://cdn.discordapp.com/attachments/825015087696969739/1061716401678725230/Icon-circle_black_Purple.png',
    config = {
        activeIps = false, -- If "true" then logs will send players IPs on the logs
        activeDiscords = true, -- If "true" then logs will send players discords IDs on the logs
    },
    logs = {
        connect = {
            url = 'https://discord.com/api/webhooks/1068310790156861511/wtEXUdwryh1J2uIQkMkW-IazrGFmUW9D15ajsfLxbRp5PRvRoMIKmO25aodYBBl7M0OtnOcj',
            color = '#E649E8' -- only hexcodes
        }, -- Webhooks when players join
        dropped = {
            url = 'https://discord.com/api/webhooks/1068310790156861511/wtEXUdwryh1J2uIQkMkW-IazrGFmUW9D15ajsfLxbRp5PRvRoMIKmO25aodYBBl7M0OtnOcj',
            color = '#E649E8' -- only hexcodes
        }, -- Webhooks when players leave the server
    }
}