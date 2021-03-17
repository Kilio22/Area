const passport = require('passport');
const TwitterStrategy = require('passport-twitter').Strategy;
const User = require('../models/User');

const { TWITTER_PASSPORT_CONFIG_WEB, MONGOOSE_TWITTER_KEY } = require('../config/twitterConfig');

const STRATEGY_TWITTER_WEB = 'twitter-web';

async function twitterStrategy(req, accessToken, refreshToken, profile, done) {
    try {
        const user = req.user;

        user.connectData.set(MONGOOSE_TWITTER_KEY, { accessToken, refreshToken });
        await User.findByIdAndUpdate(user._id, user);
        return done(null, true);
    } catch (e) {
        return done(null, false);
    }
}

passport.use(STRATEGY_TWITTER_WEB, new TwitterStrategy(TWITTER_PASSPORT_CONFIG_WEB, twitterStrategy));

module.exports = {
    STRATEGY_TWITTER_WEB
}