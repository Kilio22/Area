const { google } = require('googleapis');
const User = require('../models/User');

const { MONGOOSE_GOOGLE_KEY, GOOGLE_PASSPORT_CONFIG_MOBILE, GOOGLE_PASSPORT_CONFIG_WEB } = require('../config/googleConfig');

async function getUserClient(user) {
    const connectData = user.connectData.get(MONGOOSE_GOOGLE_KEY);

    if (!connectData) {
        return null;
    }
    const config = connectData.data.isMobile ? GOOGLE_PASSPORT_CONFIG_MOBILE : GOOGLE_PASSPORT_CONFIG_WEB;
    const oauth2Client = new google.auth.OAuth2(
        config.clientID,
        config.clientSecret,
        config.callbackURL
    );

    oauth2Client.setCredentials({
        access_token: connectData.accessToken,
        refresh_token: connectData.refreshToken
    });
    try {
        const accessToken = await oauth2Client.getAccessToken(); // TODO: check ceu parce que c'est un peu dégeu le fonctionnement
        const credentials = oauth2Client.credentials;

        user.connectData.set(MONGOOSE_GOOGLE_KEY, {
            accessToken: credentials.access_token,
            refreshToken: credentials.refresh_token,
            data: { isMobile: connectData.data.isMobile }
        });
        await User.updateOne({ email: user.email, isMicrosoftAuthed: user.isMicrosoftAuthed }, user);
    } catch (err) {
        console.log(err);
        return null;
    }
    return oauth2Client;
}

module.exports = getUserClient;
