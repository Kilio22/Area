const GITHUB_SCOPES = [ 'repo', 'user', 'read:org' ];
const MONGOOSE_GITHUB_KEY = 'github';

const GITHUB_PASSPORT_CONFIG_WEB = {
    clientID: '<YOUR_CLIENT_ID>',
    clientSecret: '<YOUR_CLIENT_SECRET>',
    callbackURL: 'http://localhost:8080/connect/github/callback',
    passReqToCallback: true
};

const GITHUB_PASSPORT_CONFIG_MOBILE = {
    clientID: '<YOUR_CLIENT_ID>',
    clientSecret: '<YOUR_CLIENT_SECRET>',
    callbackURL: 'area.app://auth',
    passReqToCallback: true
};

module.exports = {
    MONGOOSE_GITHUB_KEY,
    GITHUB_SCOPES,
    GITHUB_PASSPORT_CONFIG_WEB,
    GITHUB_PASSPORT_CONFIG_MOBILE,
}
