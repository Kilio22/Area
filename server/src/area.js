const Area = require('./models/Area');
const AREA_SERVICES = require('./services.js');

async function doReaction(area, publicMsalClient, confidentialMsalClient) {
    const service = AREA_SERVICES[area.reaction.service];

    if (service) {
        await service.react(area, publicMsalClient, confidentialMsalClient);
    }
}

async function checkupTriggers(publicMsalClient, confidentialMsalClient) {
    const areas = await Area.find({});
    const react = (_area) => doReaction(_area, publicMsalClient, confidentialMsalClient);

    for (const area of areas) {
        const service = AREA_SERVICES[area.action.service];

        if (service) {
            await service.trigger(area, react, publicMsalClient, confidentialMsalClient);
        }
    }
}

module.exports = checkupTriggers;
