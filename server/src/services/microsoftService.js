const microsoft = require('@microsoft/microsoft-graph-client');
require('isomorphic-fetch');

const User = require('../models/User');
const { MSAL_SCOPES, MONGOOSE_MSAL_KEY } = require('../config/msalConfig');

async function getUserAccessToken(user, msalClient) {
    const connectData = user.connectData.get(MONGOOSE_MSAL_KEY);

    if (!connectData) {
        return null;
    }
    try {
        const accounts = await msalClient.getTokenCache().getAllAccounts();
        const userAccount = accounts.find(account => account.homeAccountId === connectData.data.homeAccountId);
        const response = await msalClient.acquireTokenSilent({
            scopes: MSAL_SCOPES,
            account: userAccount
        });

        user.connectData.set(MONGOOSE_MSAL_KEY, {
            accessToken: response.accessToken,
            ...connectData
        });
        await User.findByIdAndUpdate(user._id, user);
        return response.accessToken;
    } catch (err) {
        console.log(err);
        user.connectData.delete(MONGOOSE_MSAL_KEY);
        await User.findByIdAndUpdate(user._id, user);
        return null;
    }
}

async function getUserDetails(accessToken) {
    const graphClient = getGraphClient(accessToken);

    return await graphClient
        .api('/me')
        .get();
}

async function sendEmail(accessToken, receiver, message) {
    const graphClient = getGraphClient(accessToken);
    const mail = {
        message: {
          subject: message.subject,
          body: {
            contentType: "Text",
            content: message.body
          },
          toRecipients: [
            {
              emailAddress: {
                address: receiver
              }
            }
          ]
        },
      };

    return await graphClient
        .api('/me/sendMail')
        .post(mail);
}

async function getInboxItemCount(accessToken) {
    const graphClient = getGraphClient(accessToken);
    const result = await graphClient
        .api('/me/mailFolders/inbox')
        .get();

    return result.totalItemCount;
}

function getGraphClient(accessToken) {
    return microsoft.Client.init({
        authProvider: done => {
            done(null, accessToken);
        }
    });
}

module.exports = {
    getUserAccessToken,
    getUserDetails,
    sendEmail,
    getInboxItemCount
};
