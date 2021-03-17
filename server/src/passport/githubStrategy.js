const passport = require('passport');
const GithubStrategy = require('passport-github2').Strategy;
const User = require('../models/User');

const { GITHUB_PASSPORT_CONFIG_WEB, GITHUB_PASSPORT_CONFIG_MOBILE, MONGOOSE_GITHUB_KEY } = require('../config/githubConfig');

const STRATEGY_GITHUB_WEB = 'github-web';
const STRATEGY_GITHUB_MOBILE = 'github-mobile';

async function githubStrategy(req, accessToken, refreshToken, profile, done) {
    try {
        const user = req.user;

        user.connectData.set(MONGOOSE_GITHUB_KEY, { accessToken, refreshToken });
        await User.findByIdAndUpdate(user._id, user);
        return done(null, true);
    } catch (e) {
        return done(null, false);
    }
}

passport.use(STRATEGY_GITHUB_WEB, new GithubStrategy(GITHUB_PASSPORT_CONFIG_WEB, githubStrategy));
passport.use(STRATEGY_GITHUB_MOBILE, new GithubStrategy(GITHUB_PASSPORT_CONFIG_MOBILE, githubStrategy));

module.exports = {
    STRATEGY_GITHUB_WEB,
    STRATEGY_GITHUB_MOBILE
}
