const Area = require('../models/Area');

async function everyHour(area, react) {
    const { data } = area.action;
    const date = new Date();
    const hour = date.getUTCHours();
    const minutes = date.getUTCMinutes();

    if (data.minute === minutes && data.lastHour !== hour) {
        area.action.data.lastHour = hour;
        await Area.findByIdAndUpdate(area._id, area);
        react(area);
    }
}

async function everyDay(area, react) {
    const { data } = area.action;
    const date = new Date();
    const hour = date.getUTCHours();
    const day = date.getUTCDay();

    if (data.hour === hour && data.lastDay !== day) {
        area.action.data.lastDay = day;
        await Area.findByIdAndUpdate(area._id, area);
        react(area);
    }
}

async function timerTriggers(area, react) {
    if (area.action.name === 'every_hour') {
        await everyHour(area, react);
    }
    if (area.action.name === 'every_day') {
        await everyDay(area, react);
    }
}

module.exports = {
    timerTriggers
};
