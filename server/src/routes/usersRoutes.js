const express = require('express');
const protectedRequest = require('../passport/protectedRequest');
const User = require('../models/User');
const { use } = require('./areasRoutes');

const router = express.Router();

/**
 * @swagger
 *
 * /users:
 *   get:
 *     summary: Get all Users.
 *     responses:
 *       200:
 *         description: Users list sent.
 *       400:
 *         description: Could not send Users list.
 *       500:
 *         description: Error.
 */
router.get('/', protectedRequest, async (req, res) => {
    try {
        const users = await User.find({});
        let formatted = [];

        for (const user of users) {
            formatted.push({ id: user._id, displayName: user.displayName, email: user.email })
        }
        return res.send(formatted);
    } catch (err) {
        console.log(err);
        return res.status(400).send('Could not get all users');
    }
})

/**
 * @swagger
 *
 * /users/:id:
 *   delete:
 *     summary: Delete User by id.
 *     parameters:
 *       - name: id
 *         required: true
 *         description: User ID
 *         in: path
 *     responses:
 *       204:
 *         description: User deleted.
 *       400:
 *         description: Could not delete User.
 *       500:
 *         description: Error.
 */
router.delete('/:id', protectedRequest, async (req, res) => {
    try {
        await User.findByIdAndDelete(req.params.id);
    } catch (err) {
        console.log(err);
        return res.status(400).send('Could not delete user');
    }
    return res.sendStatus(204);
})

module.exports = router;
