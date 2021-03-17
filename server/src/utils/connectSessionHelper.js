const ConnectSession = require('../models/ConnectSession');
const User = require('../models/User');

async function createConnectSession(userId, endpoint, isMobile) {
    let sessionId = '';

    try {
        const createdSession = await ConnectSession.create({
            userId,
            endpoint,
            isMobile
        });

        sessionId = createdSession._id;
    } catch (err) {
        console.log('Could not create ConnectSession for some reason...');
        console.log(err);
        return null;
    }
    return sessionId;
}

async function addDataToConnectSession(id, data) {
    try {
        await ConnectSession.findByIdAndUpdate(id, { data });

        return true;
    } catch (err) {
        console.log(err);
    }
    return false;
}

async function extractConnectSession(id, endpoint) {
    try {
        const connectSession = await ConnectSession.findByIdAndDelete(id);

        if (connectSession?.endpoint === endpoint) {
            return {
                user: await User.findById(connectSession?.userId),
                isMobile: connectSession?.isMobile,
                data: connectSession?.data
            };
        }
        console.log('Invalid ConnectSession.');
    } catch (err) {
        console.log('Could not verify ConnectSession for some reason...');
        console.log(err);
    }
    return { user: null, isMobile: null, data: null };
}

module.exports = {
    createConnectSession,
    extractConnectSession,
    addDataToConnectSession
};
