const express = require('express');
const passport = require('passport');
const protectedRequest = require('../passport/protectedRequest');
const User = require('../models/User');
const bcrypt = require('bcrypt');

const router = express.Router();

/**
 * @swagger
 *
 * /profile:
 *   get:
 *     summary: Get profile information.
 *     responses:
 *       200:
 *         description: Profile information sent.
 *       500:
 *         description: Error.
 */
router.get('/', protectedRequest, (req, res) => {
    let connectData = req.user.connectData;
    let formattedConnectData = [];

    for (const [ k ] of connectData) {
        formattedConnectData.push(k);
    }
    return res.send({
        displayName: req.user.displayName,
        email: req.user.email,
        services: formattedConnectData,
        isMicrosoftAuthed: req.user.isMicrosoftAuthed
    });
});

/**
 * @swagger
 *
 * /profile:
 *   put:
 *     summary: Update displayName and email.
 *     responses:
 *       200:
 *         description: Information updated.
 *       400:
 *         description: Could not update information.
 *       500:
 *         description: Error.
 */
router.put('/', protectedRequest, async (req, res) => {
    const { user } = req;

    try {
        await User.findByIdAndUpdate(user._id, { displayName: req.body.displayName, email: req.body.email });
    } catch (err) {
        console.log(err);
        return res.status(400).send('Can\'t edit username');
    }
    return res.sendStatus(200);
});

/**
 * @swagger
 *
 * /profile/password:
 *   put:
 *     summary: Update password.
 *     responses:
 *       200:
 *         description: Password updated.
 *       400:
 *         description: Could not update password.
 *       500:
 *         description: Error.
 */
router.put('/password', protectedRequest, async (req, res) => {
    const { user } = req;

    if (user.isMicrosoftAuthed === true) {
        return res.status(403).send('You are connected using Microsoft');
    }
    try {
        let pwd = await bcrypt.hash(req.body.password, 10);

        await User.findByIdAndUpdate(user._id, { password: pwd });
    } catch (err) {
        console.log(err);
        return res.status(400).send('Can\'t edit password');
    }
    return res.sendStatus(200);
});

module.exports = router;
