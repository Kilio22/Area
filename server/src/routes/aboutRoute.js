const express = require('express');
const moment = require('moment');

const AREA_SERVICES = require('../services.js');

const router = express.Router();

class AboutAction {
    constructor(name, description) {
        this.name = name;
        this.description = description;
    }
}

class AboutReaction {
    constructor(name, description) {
        this.name = name;
        this.description = description;
    }
}

class AboutService {
    constructor(name, actions, reactions) {
        this.name = name;
        this.actions = actions;
        this.reactions = reactions;
    }
}

function getAreaServices() {
    let services = [];

    services.push();
    for (const service in AREA_SERVICES) {
        if (AREA_SERVICES.hasOwnProperty(service)) {
            let actions = AREA_SERVICES[service].actions.map(action => new AboutAction(action.name, action.description));
            let reactions = AREA_SERVICES[service].reactions.map(reaction => new AboutReaction(reaction.name, reaction.description));

            services.push(new AboutService(service, actions, reactions));
        }
    }
    return services;
}

/**
 * @swagger
 *
 * /about.json:
 *   get:
 *     summary: Get about.json.
 *     responses:
 *       200:
 *         description: about.json sent.
 */
router.get('/', (req, res) => {
    return res.json({ client: { host: req.ip }, server: { current_time: moment().unix(), services: getAreaServices() } });
});

module.exports = router;
