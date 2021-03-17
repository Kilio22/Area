const Discord = require('discord.js');
const client = new Discord.Client();
const { BOT_TOKEN } = require('../config/discordConfig');

client.login(BOT_TOKEN);

async function discordReact(area) {
    if (area.reaction.name === "post_message") {
        try {
            client.channels.cache.get(area.reaction.data.id).send(area.reaction.data.body);
        } catch (err) {
            console.log(err);
        }
    }
}

module.exports = {
    discordReact
}
