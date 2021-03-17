const CLIENT_WEB_PORT = process.env.CLIENT_WEB_PORT || '8081';
const CLIENT_WEB_URI = `http://localhost:${CLIENT_WEB_PORT}`;

const ALLOWED_ORIGINS = [
    CLIENT_WEB_URI,
];

module.exports = {
    ALLOWED_ORIGINS,
    CLIENT_WEB_URI
};
