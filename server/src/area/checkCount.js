const Area = require('../models/Area');

async function checkCount(area, getCount, react) {
    const { data } = area.action;
    let count = undefined;

    try {
        count = await getCount();
    } catch (err) {
        console.log(err);
        return;
    }
    if (count !== data.currentCount) {
        let diff = count - data.currentCount;

        area.action.data.currentCount = count;
        await Area.findByIdAndUpdate(area._id, area);
        while (diff > 0) {
            diff--;
            react(area);
        }
    }
}

module.exports = checkCount;
