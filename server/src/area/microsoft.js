const User = require('../models/User');
const microsoftService = require('../services/microsoftService');
const checkCount = require('./checkCount');

async function getInboxItemCount(user, msalClient) {
    const accessToken = await microsoftService.getUserAccessToken(user, msalClient);
    let count = undefined;

    if (accessToken === null) {
        throw "Not connected to microsoft";
    }
    try {
        count = await microsoftService.getInboxItemCount(accessToken);
    } catch (err) {
        console.log(err);
        throw "Could not process query";
    }
    if (count === undefined) {
        throw "Could not find any email";
    }
    return count;
}

async function microsoftTriggers(area, react, publicMsalClient, confidentialMsalClient) {
    const user = await User.findById(area.userId);

    if (area.action.name === 'incoming_mail') {
        await checkCount(area, () => getInboxItemCount(user, (area.isMobile ? publicMsalClient : confidentialMsalClient)), react);
    }
}

async function microsoftReact(area, publicMsalClient, confidentialMsalClient) {
    const user = await User.findById(area.userId);

    if (area.reaction.name === "send_mail") {
        const accessToken = await microsoftService.getUserAccessToken(user, (area.isMobile ? publicMsalClient : confidentialMsalClient));

        try {
            await microsoftService.sendEmail(accessToken, area.reaction.data.to, area.reaction.data);
        } catch (err) {
            console.log(err);
        }
    }
}

async function microsoftCheck(user, action, msalClient) {
    if (action.name === 'incoming_mail') {
        try {
            await getInboxItemCount(user, msalClient);
        } catch (err) {
            return err;
        }
        return false;
    }
    return "Could not find any query from action name (not supposed to happen)";
}

module.exports = {
    microsoftTriggers,
    microsoftReact,
    microsoftCheck
};
