const { google } = require('googleapis');

const User = require('../models/User');
const getUserClient = require('../services/googleService');
const checkCount = require('./checkCount');

async function getVideoCount(user, data) {
    const oauth2Client = await getUserClient(user);
    let count = undefined;

    if (oauth2Client == null) {
        throw "Not connected to google";
    }
    try {
        const googleRes = await google.youtube('v3').channels.list({
            auth: oauth2Client,
            part: [
                'statistics'
            ],
            id: [ data.id ]
        });

        if (!googleRes.data.items || googleRes.data.items.length === 0) {
            count = undefined;
        } else {
            count = parseInt(googleRes.data.items[0].statistics.videoCount);
        }
    } catch (err) {
        throw "Could not process query";
    }
    if (count === undefined) {
        throw "Could not find any channel from given id parameter";
    }
    return count;
}

async function getPlaylistVideoCount(user, data) {
    const oauth2Client = await getUserClient(user);
    let count = undefined;

    if (oauth2Client == null) {
        throw "Not connected to google";
    }
    try {
        const googleRes = await google.youtube('v3').playlists.list({
            auth: oauth2Client,
            part: [
                'contentDetails'
            ],
            id: [ data.id ]
        });

        if (!googleRes.data.items || googleRes.data.items.length === 0) {
            count = undefined;
        } else {
            count = googleRes.data.items[0].contentDetails.itemCount;
        }
    } catch (err) {
        throw "Could not process query";
    }
    if (count === undefined) {
        throw "Could not find any playlist from given id parameter";
    }
    return count;
}

async function googleTriggers(area, react) {
    const user = await User.findById(area.userId);

    if (area.action.name === 'new_video') {
        await checkCount(area, () => getVideoCount(user, area.action.data), react);
    } else if (area.action.name === 'playlist_update') {
        await checkCount(area, () => getPlaylistVideoCount(user, area.action.data), react);
    }
}

async function googleCheck(user, action) {
    if (action.name === 'new_video') {
        try {
            await getVideoCount(user, action.data);
        } catch (err) {
            return err;
        }
        return false;
    } else if (action.name === 'playlist_update') {
        try {
            await getPlaylistVideoCount(user, action.data);
        } catch (err) {
            return err;
        }
        return false;
    }
    return "Could not find any query from action name (not supposed to happen)";
}

module.exports = {
    googleTriggers,
    googleCheck
};
