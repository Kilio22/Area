const passport = require('passport');
const OfficeJwtStrategy = require('passport-jwt').Strategy;
const User = require('../models/User');
const { JWT_PASSPORT_AZURE_CONFIG } = require('../config/jwtConfig');

const STRATEGY_OFFICE_JWT = 'office-jwt';

passport.use(STRATEGY_OFFICE_JWT, new OfficeJwtStrategy(JWT_PASSPORT_AZURE_CONFIG,
    async (token, done) => {
        try {
            let user = await User.findOne({ email: token.email, isMicrosoftAuthed: true });

            if (!user) {
                user = await User.create({
                    email: token.email,
                    displayName: token.name,
                    isMicrosoftAuthed: true
                });
            }
            return done(null, user);
        } catch (error) {
            done(error);
        }
    })
);

module.exports = {
    STRATEGY_OFFICE_JWT
}
