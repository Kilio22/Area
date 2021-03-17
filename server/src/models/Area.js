const mongoose = require('mongoose');

const ActionSchema = new mongoose.Schema({
    service: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true,
    },
    data: {
        type: Object,
        required: true
    }
}, { minimize: false });

const ReactionSchema = new mongoose.Schema({
    service: {
        type: String,
        required: true
    },
    name: {
        type: String,
        required: true,
    },
    data: {
        type: Object,
        required: true
    }
}, { minimize: false });

const AreaSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true
    },
    isMobile: {
        type: Boolean,
        required: true
    },
    action: {
        type: ActionSchema,
        required: true,
    },
    reaction: {
        type: ReactionSchema,
        required: true,
    }
});

const AreaModel = mongoose.model('area', AreaSchema);

module.exports = AreaModel;
