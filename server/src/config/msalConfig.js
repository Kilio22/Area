const msal = require('@azure/msal-node');

const MSAL_SCOPES = [ 'profile', 'openid', 'offline_access', 'email', 'User.Read', 'Mail.Read', 'Mail.Send' ];
const MSAL_REDIRECT_URI_WEB = 'http://localhost:8080/connect/microsoft/callback';
const MSAL_REDIRECT_URI_MOBILE = 'msauth.area.app://auth';
const MONGOOSE_MSAL_KEY = 'microsoft';

const MSAL_CONFIG = {
    auth: {
        clientId: '<YOUR_CLIENT_ID>',
        authority: 'https://login.microsoftonline.com/common/',
    },
    system: {
        loggerOptions: {
            loggerCallback(loglevel, message) {
                console.log(message);
            },
            piiLoggingEnabled: false,
            logLevel: msal.LogLevel.Verbose
        }
    }
};

const MSAL_CONFIG_SECRET = {
    ...MSAL_CONFIG,
    auth: {
        ...MSAL_CONFIG.auth,
        clientSecret: '<YOUR_CLIENT_SECRET>'
    }
}

module.exports = {
    MONGOOSE_MSAL_KEY,
    MSAL_SCOPES,
    MSAL_REDIRECT_URI_WEB,
    MSAL_REDIRECT_URI_MOBILE,
    MSAL_CONFIG,
    MSAL_CONFIG_SECRET
};
