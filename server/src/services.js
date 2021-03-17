const { discordReact } = require("./area/discord");
const { githubTriggers, githubReact, githubCheck } = require("./area/github");
const { googleTriggers, googleCheck } = require("./area/google");
const { microsoftTriggers, microsoftReact, microsoftCheck } = require("./area/microsoft");
const { timerTriggers } = require("./area/timer");
const { twitterReact } = require("./area/twitter");

class AreaService {
    constructor(actions, reactions, trigger, react) {
        this.actions = actions;
        this.reactions = reactions;
        this.trigger = trigger;
        this.react = react;
    }
}

class AreaAction {
    constructor(name, description, paramNames, checkFct) {
        this.name = name;
        this.description = description;
        this.paramNames = paramNames;
        this.checkFct = checkFct;
    }
}

class AreaReaction {
    constructor(name, description, paramNames) {
        this.name = name;
        this.description = description;
        this.paramNames = paramNames;
    }
}

const AREA_SERVICES = {
    discord: new AreaService(
        [],
        [
            new AreaReaction("post_message", "Posts a message in a specific location", [ "id", "body" ])
        ],
        () => {},
        discordReact
    ),
    github: new AreaService(
        [
            new AreaAction("new_repository", "Triggers when a repository is created", [ "owner" ], githubCheck),
            new AreaAction("new_issue", "Triggers when a new issue is added", [ "owner", "repo" ], githubCheck),
            new AreaAction("issue_closes", "Triggers when an issue is closed", [ "owner", "repo" ], githubCheck),
            new AreaAction("new_pull_request", "Triggers when a new pull request is posted", [ "owner", "repo" ], githubCheck),
            new AreaAction("new_ref", "Triggers when a new ref (branch) was added", [ "owner", "repo" ], githubCheck),
            new AreaAction("new_tag", "Triggers when a new tag (release) was added", [ "owner", "repo" ], githubCheck),
        ],
        [
            new AreaReaction("open_issue", "Opens a new issue", [ "owner", "repo", "title", "body" ])
        ],
        githubTriggers,
        githubReact
    ),
    google: new AreaService(
        [
            new AreaAction("new_video", "Triggers when a video was uploaded by a channel", [ "id" ], googleCheck),
            new AreaAction("playlist_update", "Triggers when a video was added to a playlist", [ "id" ], googleCheck),
        ],
        [],
        googleTriggers,
        () => {}
    ),
    microsoft: new AreaService(
        [
            new AreaAction("incoming_mail", "Triggers when an email is added into your inbox", [], microsoftCheck)
        ],
        [
            new AreaReaction("send_mail", "Sends an email", [ "to", "subject", "body" ])
        ],
        microsoftTriggers,
        microsoftReact
    ),
    timer: new AreaService(
        [
            new AreaAction("every_hour", "Triggers every hour", [ "minute" ], () => false),
            new AreaAction("every_day", "Triggers everyday", [ "hour" ], () => false),
        ],
        [],
        timerTriggers,
        () => {}
    ),
    twitter: new AreaService(
        [],
        [
            new AreaReaction("post_tweet", "Post a new tweet", [ "body" ]),
            new AreaReaction("update_bio", "Updates your bio", [ "body" ])
        ],
        () => {},
        twitterReact
    ),
};

module.exports = AREA_SERVICES;
