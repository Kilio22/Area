const passport = require('passport');
const Strategy = require('passport-local').Strategy;
const bcrypt = require('bcrypt');
const User = require('../models/User');
const { LOCAL_PASSPORT_CONFIG } = require('../config/passportLocalConfig');

const STRATEGY_LOCAL_SIGN_IN = 'local-sign-in';
const STRATEGY_LOCAL_SIGN_UP = 'local-sign-up';

passport.use(STRATEGY_LOCAL_SIGN_IN, new Strategy(LOCAL_PASSPORT_CONFIG,
    async (req, email, password, cb) => {
        try {
            let user = await User.findOne({ email, isMicrosoftAuthed: false });

            if (!user) {
                return cb(null, false, { code: 401, message: 'User does not exist' });
            } else {
                const isValid = await bcrypt.compare(password, user.password);

                if (!isValid) {
                    return cb(null, false, { code: 409, message: 'Wrong credentials' });
                }
                return cb(null, user);
            }
        } catch (error) {
            return cb(error);
        }
    })
);

passport.use(STRATEGY_LOCAL_SIGN_UP, new Strategy(LOCAL_PASSPORT_CONFIG,
    async (req, email, password, cb) => {
        if (!req.body.username) {
            return cb(null, false, { code: 400, message: 'Missing username property.' });
        }
        try {
            let user = await User.findOne({ email, isMicrosoftAuthed: false });

            if (user) {
                return cb(null, false, { code: 409, message: 'A user with the given email already exists.' });
            } else {
                user = await User.create({
                    email,
                    password,
                    displayName: req.body.username
                });
                return cb(null, user);
            }
        } catch (error) {
            return cb(error);
        }
    })
);

module.exports = {
    STRATEGY_LOCAL_SIGN_IN,
    STRATEGY_LOCAL_SIGN_UP,
}
