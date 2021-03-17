export class Param {
    type: string;
    check: string;
    value: any;
    placeholder: any;
    requestValue: string;
    error: string;

    constructor(type: string, check: string, placeholder: any, requestValue = "") {
        this.type = type;
        this.check = check;
        this.placeholder = placeholder;
        this.requestValue = requestValue;
        this.error = "";
    }

    validateValue(): boolean {
        var isValueValid:boolean = false;
        var regexpEmail = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var regexpMinutes = /^[0-5]?[0-9]$/;
        var regexpHours = /^([0-1]?[0-9]|2[0-3])$/;
        var regexpChannel = /^\d{18}$/;

        if (this.check!= "None" && (this.value == "" || this.value == null || this.value == undefined)) {
            this.error = "You're missing a value here.";
            return false;
        }
        switch (this.check) {
        case "None":
            isValueValid = true;
            break;
        case "Hours":
            if (regexpHours.test(this.value)) {
                isValueValid = true;
                this.error = "";
            } else {
                isValueValid = false;
                this.error = "Please input a valid 0-24 hour.";
            }
            break;
        case "Minutes":
            if (regexpMinutes.test(this.value)) {
                isValueValid = true;
                this.error = "";
            } else {
                isValueValid = false;
                this.error = "Please input a valide 0-60 minute.";
            }
            break;
        case "Channel":
            if (regexpChannel.test(this.value)) {
                isValueValid = true;
                this.error = "";
            } else {
                isValueValid = false;
                this.error = "Please input a valid discord channel id."
            }
            break;
        case "Email":
            if (regexpEmail.test(this.value)) {
                isValueValid = true;
                this.error = "";
            } else {
                isValueValid = false;
                this.error = "Please input a valid email address."
            }
            break;
        default:
            isValueValid = false;
            this.error = "Internal Error. Value couldn't be validated.";
            break;
        }
        return isValueValid
    }

    getValue(): any {
        switch (this.type) {
            case "Number":
                return Number(this.value);
            case "String":
                return this.value;
            default:
                return this.value;
        }
    }
}

export class ParamList {
    description: string;
    list: Array<Param>;
    requestValue: string;

    constructor(description: string) {
        this.description = description;
        this.requestValue = "";
        this.list = new Array<Param>();
    }

    getData(): any {
        var data = {};
        if (this.requestValue == "new_video" || this.requestValue == "playlist_update") {
            data = {
                action: this.requestValue,
                id: this.list[0].value,
            }
        } else if (this.requestValue == "new_issue" || this.requestValue == "issue_closes" || this.requestValue == "new_pull_request" || this.requestValue == "new_ref" || this.requestValue == "new_tag") {
            data = {
                action: this.requestValue,
                owner: this.list[0].value,
                repo: this.list[1].value
            }
        } else if (this.requestValue == "new_repository") {
            data = {
                action: this.requestValue,
                owner: this.list[0].value
            }
        } else if (this.requestValue == "every_day") {
            data = {
                action: this.requestValue,
                hour: Number(this.list[0].value)
            }
        } else if (this.requestValue == "every_hour") {
            data = {
                action: this.requestValue,
                minute: Number(this.list[0].value)
            }
        } else if (this.requestValue == "send_mail") {
            data = {
                reaction: this.requestValue,
                to: this.list[0].value,
                subject: this.list[1].value,
                body: this.list[2].value
            }
        } else if (this.requestValue == "post_tweet" || this.requestValue == "update_bio") {
            data = {
                reaction: this.requestValue,
                body: this.list[0].value
            }
        } else if (this.requestValue == "post_message") {
            data = {
                reaction: this.requestValue,
                id: this.list[0].value,
                body: this.list[1].value,
            }
        } else if (this.requestValue == "open_issue") {
            data = {
                reaction: this.requestValue,
                owner: this.list[0].value,
                repo: this.list[1].value,
                title: this.list[2].value,
                body: this.list[3].value
            }
        } else if (this.requestValue == "incoming_mail") {
            data = {
                reaction: this.requestValue,
            }
        }
        return data;
    }
}

export class Selectable {
    service: string;
    params: Array<ParamList>;

    constructor(service: string) {
        this.service = service;
        this.params = new Array<ParamList>();
    }
}

export class Area {
    action: Selectable;
    reaction: Selectable;
    id: string;

    constructor(action: Selectable, reaction: Selectable, id = "") {
        this.action = action;
        this.reaction = reaction;
        this.id = id;
    }
}

class AutomationStorage {
    actions: Array<Selectable>;
    reactions: Array<Selectable>;

    clearAllValues() {
        for (var i:number = 0; i < this.actions.length; i++) {
            for (var j:number = 0; j < this.actions[i].params.length; j++) {
                for (var k:number = 0; k < this.actions[i].params[j].list.length; k++) {
                    this.actions[i].params[j].list[k].error = "";
                    this.actions[i].params[j].list[k].value = "";
                }
            }
        }
        for (var i:number = 0; i < this.reactions.length; i++) {
            for (var j:number = 0; j < this.reactions[i].params.length; j++) {
                for (var k:number = 0; k < this.reactions[i].params[j].list.length; k++) {
                    this.reactions[i].params[j].list[k].error = "";
                    this.reactions[i].params[j].list[k].value = "";
                }
            }
        }
    }

    lastAction(): Selectable {
        return this.actions[this.actions.length - 1];
    }

    lastActionParam(): ParamList {
        return this.lastAction().params[this.lastAction().params.length - 1];
    }

    lastReaction(): Selectable {
        return this.reactions[this.reactions.length - 1];
    }

    lastReactionParam(): ParamList {
        return this.lastReaction().params[this.lastReaction().params.length - 1];
    }

    addNewActionService(name: string) {
        this.actions.push(new Selectable(name));
    }

    addNewAction(description: string, requestValue:string) {
        this.lastAction().params.push(new ParamList(description));
        this.lastActionParam().requestValue = requestValue;
    }

    addNewActionParam(type: string, check: string, placeholder: any, requestValue:string) {
        this.lastActionParam().list.push(new Param(type, check, placeholder, requestValue));
    }

    addNewReactionService(name: string) {
        this.reactions.push(new Selectable(name));
    }

    addNewReaction(description: string, requestValue:string) {
        this.lastReaction().params.push(new ParamList(description));
        this.lastReactionParam().requestValue = requestValue;
    }

    addNewReactionParam(type: string, check: string, placeholder: any, requestValue:string) {
        this.lastReactionParam().list.push(new Param(type, check, placeholder, requestValue));
    }

    constructor() {
        this.actions = new Array<Selectable>();
        this.reactions = new Array<Selectable>();
        // ---------------------------------------------------------------------------- ACTIONS
        // Microsoft
        this.addNewActionService("Microsoft");
        this.addNewAction("New e-mail received.", "incoming_mail");
        this.addNewActionParam("None", "None", "", "none");
        // Google
        this.addNewActionService("Google");
        this.addNewAction("New video uploaded from a specific channel.", "new_video");
        this.addNewActionParam("String", "None", "Channel Id", "id");
        this.addNewAction("New video was added to a specific playlist.", "playlist_update");
        this.addNewActionParam("String", "None", "Playlist Id", "id");
        // Github
        this.addNewActionService("Github");
        this.addNewAction("New issue from a specific repository.", "new_issue");
        this.addNewActionParam("String", "None", "Github Username", "owner");
        this.addNewActionParam("String", "None", "Repository name", "repo");
        this.addNewAction("Issue closed in a specific repository.", "issue_closes");
        this.addNewActionParam("String", "None", "Github Username", "owner");
        this.addNewActionParam("String", "None", "Repository name", "repo");
        this.addNewAction("New Pull Request from a specific repository.", "new_pull_request");
        this.addNewActionParam("String", "None", "Github Username", "owner");
        this.addNewActionParam("String", "None", "Repository name", "repo");
        this.addNewAction("New public repository from a specific User", "new_repository");
        this.addNewActionParam("String", "None", "Username", "owner");
        this.addNewAction("New Reference from a specific repository.", "new_ref");
        this.addNewActionParam("String", "None", "Github Username", "owner");
        this.addNewActionParam("String", "None", "Repository name", "repo");
        this.addNewAction("New Tag from a specific repository.", "new_tag");
        this.addNewActionParam("String", "None", "Github Username", "owner");
        this.addNewActionParam("String", "None", "Repository name", "repo");
        // Timer
        this.addNewActionService("Timer");
        this.addNewAction("Execute a task every day at a specific hour.", "every_day");
        this.addNewActionParam("Number", "Hours", "Hour", "hour");
        this.addNewAction("Execute a task every hour at a specific minute.", "every_hour");
        this.addNewActionParam("Number", "Minutes", "Minute", "minute");
        // ---------------------------------------------------------------------------- REACTIONS
        // Microsoft
        this.addNewReactionService("Microsoft");
        this.addNewReaction("Send an email", "send_mail");
        this.addNewReactionParam("String", "Email", "Email@Email.com", "to");
        this.addNewReactionParam("String", "None", "Subject", "subject");
        this.addNewReactionParam("String", "None", "Your email here", "body");
        // Twitter
        this.addNewReactionService("Twitter");
        this.addNewReaction("Post a tweet", "post_tweet");
        this.addNewReactionParam("String", "None", "Hello twitter!", "body");
        this.addNewReaction("Update Bio", "update_bio");
        this.addNewReactionParam("String", "None", "Your new bio.", "body");
        // Discord
        this.addNewReactionService("Discord");
        this.addNewReaction("Send a message in a specific channel.", "post_message");
        this.addNewReactionParam("Number", "Channel", "Channel Id", "id");
        this.addNewReactionParam("String", "None", "Your message here", "body");
        // Github
        this.addNewReactionService("Github");
        this.addNewReaction("Create a new issue in a specific Repository", "open_issue");
        this.addNewReactionParam("String", "None", "Github Username", "owner");
        this.addNewReactionParam("String", "None", "Repository name", "repo");
        this.addNewReactionParam("String", "None", "Title", "title");
        this.addNewReactionParam("String", "None", "Description", "body");
    }
}


const data: AutomationStorage = new AutomationStorage();

export default data;