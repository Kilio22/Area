const passport = require('passport');
const { STRATEGY_JWT } = require('../passport/jwtStrategy');

const protectedRequest = passport.authenticate(STRATEGY_JWT, { session: false });

module.exports = protectedRequest;
