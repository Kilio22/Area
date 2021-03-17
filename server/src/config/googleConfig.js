const GOOGLE_SECRET = '<YOUR_CLIENT_SECRET>';
const GOOGLE_SCOPES = [ 'email', 'profile', 'openid', 'https://www.googleapis.com/auth/youtube.readonly' ];
const MONGOOSE_GOOGLE_KEY = 'google';

const GOOGLE_PASSPORT_CONFIG_WEB = {
    clientID: '<YOUR_CLIENT_ID>',
    clientSecret: GOOGLE_SECRET,
    callbackURL: 'http://localhost:8080/connect/google/callback',
    passReqToCallback: true
};

const GOOGLE_PASSPORT_CONFIG_MOBILE = {
    clientID: '<YOUR_CLIENT_ID>',
    callbackURL: 'area.app:/auth',
    passReqToCallback: true
};

module.exports = {
    MONGOOSE_GOOGLE_KEY,
    GOOGLE_SCOPES,
    GOOGLE_PASSPORT_CONFIG_WEB,
    GOOGLE_PASSPORT_CONFIG_MOBILE,
};
