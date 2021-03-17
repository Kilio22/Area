const Twitter = require('twitter');

const { MONGOOSE_TWITTER_KEY, TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET } = require('../config/twitterConfig');

function getUserData(user) {
    const connectData = user.connectData.get(MONGOOSE_TWITTER_KEY);

    if (!connectData) {
        return null;
    }
    return connectData;
}

async function postTweet(accessToken, accessTokenSecret, tweet) {
    const client = new Twitter({
        consumer_key: TWITTER_CONSUMER_KEY,
        consumer_secret: TWITTER_CONSUMER_SECRET,
        access_token_key: accessToken,
        access_token_secret: accessTokenSecret
    });
    const date = new Date();
    const hour = date.getUTCHours();
    const minutes = date.getUTCMinutes();
    const seconds = date.getUTCSeconds();
    const actualHour = hour;

    try {
        await client.post('/statuses/update', { status: tweet + ', at ' + actualHour + ':' + minutes + ':' + seconds })
    } catch (err) {
        console.log(err);
        return false;
    }
    return true;
}

async function updateRequest(client, description, name) {
    const date = new Date();
    const hour = date.getUTCHours();
    const minutes = date.getUTCMinutes();
    const seconds = date.getUTCSeconds();
    const actualHour = hour;
    const params = {
        name: name,
        description: description + ', at ' + actualHour + ':' + minutes + ':' + seconds
    }

    try {
        await client.post('/account/update_profile.json', params);
    } catch (err) {
        console.log(err);
        return false;
    }
    return true
}

async function updateDescription(accessToken, accessTokenSecret, description) {
    const client = new Twitter({
        consumer_key: TWITTER_CONSUMER_KEY,
        consumer_secret: TWITTER_CONSUMER_SECRET,
        access_token_key: accessToken,
        access_token_secret: accessTokenSecret
    });
    try {
        const request = await client.get('/account/settings.json', {});
        const name = request.screen_name;
        const req = updateRequest(client, description, name);

        if (req === false) {
            return false;
        }
    } catch (err) {
        console.log(err);
        return false;
    }
    return true;
}

module.exports = {
    getUserData,
    postTweet,
    updateDescription
}