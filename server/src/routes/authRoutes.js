const passport = require('passport');
const express = require('express');
const jwt = require('jsonwebtoken');

const protectedRequest = require("../passport/protectedRequest");
const { JWT_SECRET_KEY } = require('../config/jwtConfig')
const { STRATEGY_OFFICE_JWT } = require("../passport/officeJwtStrategy");
const { STRATEGY_LOCAL_SIGN_IN, STRATEGY_LOCAL_SIGN_UP } = require('../passport/localStrategy');

const router = express.Router();

function makeToken(user, office) {
    const body = { id: user._id, office };

    return jwt.sign({ user: body }, JWT_SECRET_KEY, { expiresIn: '2 years' });
}

/**
 * @swagger
 *
 * /auth/ping:
 *   get:
 *     summary: Checks if current session is valid.
 *     responses:
 *       200:
 *         description: Authenticated.
 *         content:
 *           text/plain:
 *             schema:
 *               type: boolean
 *       401:
 *         description: Invalid session.
 */
router.get('/ping', protectedRequest, (req, res) => {
    const { user } = req;

    return res.status(200).send({ email: user.email, displayName: user.displayName, isMicrosoftAuthed: user.isMicrosoftAuthed });
});

/**
 * @swagger
 *
 * /auth/sign-in:
 *   post:
 *      summary: Authenticate to the application.
 *      produces:
 *        - application/json
 *      parameters:
 *        - name: email
 *          description: User email.
 *          in: formData
 *          required: true
 *          type: string
 *        - name: password
 *          description: User password.
 *          in: formData
 *          required: true
 *          type: string
 *      responses:
 *        200:
 *          description: Authenticated.
 *          content:
 *            application/json:
 *              schema:
 *                type: object
 *                properties:
 *                  token:
 *                    type: string
 *        401:
 *          description: Cannot find email or password.
 *        409:
 *          description: Wrong credentials.
 *        500:
 *          description: Error.
 */
router.post('/sign-in', (req, res, next) => {
    passport.authenticate(STRATEGY_LOCAL_SIGN_IN, (err, user, info) => {
        if (err) {
            return res.sendStatus(500);
        }
        if (!user) {
            if (info.hasOwnProperty('code') && info.hasOwnProperty('message')) {
                return res.status(info.code).json({ message: info.message });
            } else {
                return res.sendStatus(400);
            }
        }
        req.logIn(user, { session: false }, (err) => {
            if (err) {
                return next(err);
            }
            return res.json({ token: makeToken(user, user.isMicrosoftAuthed) });
        })
    })(req, res, next);
});

/**
 * @swagger
 *
 * /auth/sign-up:
 *   post:
 *     summary: Register to the application.
 *     produces:
 *       - application/json
 *     parameters:
 *       - name: email
 *         description: User email.
 *         in: formData
 *         required: true
 *         type: string
 *       - name: password
 *         description: User password.
 *         in: formData
 *         required: true
 *         type: string
 *       - name: fullName
 *         in: formData
 *         required: true
 *         type: string
 *         description: Username.
 *     responses:
 *       200:
 *         description: Registered and authenticated.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *       400:
 *         description: Cannot find email or password or fullName.
 *       409:
 *         description: A user with the given email already exists.
 *       500:
 *         description: Error.
 */
router.post('/sign-up', (req, res, next) => {
    passport.authenticate(STRATEGY_LOCAL_SIGN_UP, (err, user, info) => {
        if (err) {
            return res.sendStatus(500);
        }
        if (!user) {
            if (info.hasOwnProperty('code') && info.hasOwnProperty('message')) {
                return res.status(info.code).json({ message: info.message });
            } else {
                return res.sendStatus(400);
            }
        }
        req.logIn(user, { session: false }, (err) => {
            if (err) {
                return next(err);
            }
            return res.json({ token: makeToken(user, false) });
        });
    })(req, res, next);
});

/**
 * @swagger
 *
 * /auth/office-jwt:
 *   get:
 *     summary: Sign-in or sign-up to the app using a Microsoft Azure OAuth 2.0 token.
 *     parameters:
 *       - in: header
 *         name: Authorization
 *         required: true
 *     responses:
 *       200:
 *         description: Authenticated.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *       400:
 *         description: Missing token or bad token.
 *       500:
 *         description: Error.
 */
router.post('/office-jwt', (req, res, next) => {
    passport.authenticate(STRATEGY_OFFICE_JWT, (err, user) => {
        if (err) {
            return res.sendStatus(500);
        }
        if (!user) {
            return res.sendStatus(400);
        }
        req.logIn(user, { session: false }, err => {
            if (err) {
                return next(err);
            }
            return res.json({ token: makeToken(user, true) });
        });
    })(req, res, next);
});

module.exports = router;
