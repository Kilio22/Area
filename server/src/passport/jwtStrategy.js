const passport = require('passport');
const passportJWT = require('passport-jwt');
const JWTStrategy = passportJWT.Strategy;
const ExtractJWT = require('passport-jwt').ExtractJwt;
const User = require('../models/User');

const { JWT_SECRET_KEY } = require('../config/jwtConfig');

const STRATEGY_JWT = 'jwt';

passport.use(STRATEGY_JWT, new JWTStrategy(
    {
        jwtFromRequest: ExtractJWT.fromAuthHeaderAsBearerToken(),
        secretOrKey: JWT_SECRET_KEY
    },
    async (token, done) => {
        try {
            let user = await User.findOne({ _id: token.user.id, isMicrosoftAuthed: token.user.office });

            if (!user) {
                return done(null);
            }
            return done(null, user);
        } catch (error) {
            return done(error);
        }
    })
);

module.exports = {
    STRATEGY_JWT
};
