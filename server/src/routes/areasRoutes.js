const express = require('express');

const protectedRequest = require('../passport/protectedRequest');
const Area = require('../models/Area');
const AREA_SERVICES = require('../services');

const router = express.Router();

/**
 * @swagger
 *
 * /areas:
 *   post:
 *     summary: Create areas.
 *     responses:
 *       201:
 *         description: Area created.
 *       400:
 *         description: Bad request body parameters.
 *       500:
 *         description: Error.
 */
router.post('/', protectedRequest, async (req, res) => {
    const isMobile = !!req.query.mobile;
    const { user } = req;
    const actionService = AREA_SERVICES[req.body.action.service];
    const reactionService = AREA_SERVICES[req.body.reaction.service];

    if (!actionService) {
        return res.status(400).send('Action: service does not exist');
    }
    if (!reactionService) {
        return res.status(400).send('Reaction: service does not exist');
    }

    const action = actionService.actions.find(a => a.name === req.body.action.name);
    const reaction = reactionService.reactions.find(r => r.name === req.body.reaction.name);

    if (!action) {
        return res.status(400).send('Action: name does not exist');
    }
    if (!reaction) {
        return res.status(400).send('Reaction: name does not exist');
    }

    // Check if all params are given in data object for both action and reaction.
    for (const param of action.paramNames) {
        if (!req.body.action.data.hasOwnProperty(param)) {
            return res.status(400).send(`Action: missing '${param}' data argument.`);
        }
    }
    for (const param of reaction.paramNames) {
        if (!req.body.reaction.data.hasOwnProperty(param)) {
            return res.status(400).send(`Reaction: missing '${param}' data argument.`);
        }
    }

    const error = await action.checkFct(user, req.body.action, isMobile ? req.app.locals.publicMsalClient : req.app.locals.confidentialMsalClient);
    if (error) {
        return res.status(400).send(error);
    }

    try {
        await Area.create({
            userId: user._id,
            isMobile,
            action: req.body.action,
            reaction: req.body.reaction
        });
    } catch(err) {
        console.log(err);
        return res.status(400).send('Area creation failed');
    }
    return res.sendStatus(201);
});

/**
 * @swagger
 *
 * /areas/:id:
 *   put:
 *     summary: Update area by id.
 *     parameters:
 *       - name: id
 *         required: true
 *         description: Area ID
 *         in: path
 *     responses:
 *       200:
 *         description: Area updated.
 *       400:
 *         description: Could not update Area.
 *       500:
 *         description: Error.
 */
router.put('/:id', protectedRequest, async (req, res) => {
    try {
        await Area.findByIdAndUpdate(req.params.id, { action: req.body.action, reaction: req.body.reaction });
    } catch (err) {
        console.log(err);
        return res.status(400).send('Could not update Area');
    }
    return res.sendStatus(200);
})

/**
 * @swagger
 *
 * /areas/:id:
 *   delete:
 *     summary: Delete area by id.
 *     parameters:
 *       - name: id
 *         required: true
 *         description: Area ID
 *         in: path
 *     responses:
 *       204:
 *         description: Area deleted.
 *       400:
 *         description: Could not delete Area.
 *       500:
 *         description: Error.
 */
router.delete('/:id', protectedRequest, async (req, res) => {
    try {
        await Area.findByIdAndDelete(req.params.id);
    } catch (err) {
        console.log(err);
        return res.status(400).send('Could not delete Area');
    }
    return res.sendStatus(204);
})

/**
 * @swagger
 *
 * /areas:
 *   get:
 *     summary: Get all Areas of the user.
 *     responses:
 *       200:
 *         description: Areas list sent.
 *       400:
 *         description: Could not send Areas list.
 *       500:
 *         description: Error.
 */
router.get('/', protectedRequest, async (req, res) => {
    const { user } = req;

    const areas = await Area.find({ userId: user._id });
    let areasList = [];

    for (const area of areas) {
        areasList.push({ id: area.id, action: area.action, reaction: area.reaction });
    }
    return res.send(areasList);
});

module.exports = router;
