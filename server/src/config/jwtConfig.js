const ExtractJWT = require('passport-jwt').ExtractJwt;
const Axios = require('axios');
const decode = require('jsonwebtoken').decode;

const { AZURE_CLIENT_ID, AZURE_ISSUER, AZURE_DISCOVERY_URL } = require("./azureConfig");

const JWT_SECRET_KEY = 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

async function getPrivateKey(request, rawJwtToken, done) {
    let decodedAccessToken = null;
    try {
        decodedAccessToken = decode(rawJwtToken, {complete: true});
    } catch (e) {
        return done(null, false);
    }

    try {
        if (!decodedAccessToken) {
            return done(null, false);
        }
        const response = await Axios.get(AZURE_DISCOVERY_URL);

        for (let key of response.data.keys) {
            if (key && key.kid === decodedAccessToken?.header?.kid && key.x5c && key.x5c.length) {
                const fullKey = '-----BEGIN CERTIFICATE-----\n' + key.x5c[0] + '\n-----END CERTIFICATE-----';
                return done(null, fullKey);
            }
        }
        return done(null, false);
    } catch (e) {
        return done(e, false);
    }
}

const JWT_PASSPORT_AZURE_CONFIG = {
    audience: AZURE_CLIENT_ID,
    issuer: AZURE_ISSUER,
    secretOrKeyProvider: getPrivateKey,
    jwtFromRequest: ExtractJWT.fromAuthHeaderAsBearerToken()
};

module.exports = {
    JWT_PASSPORT_AZURE_CONFIG,
    JWT_SECRET_KEY,
}
