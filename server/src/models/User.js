const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const Schema = mongoose.Schema;

const ServiceSchema = new Schema({
    accessToken: {
        type: String,
        default: ''
    },
    refreshToken: {
        type: String,
        default: ''
    },
    data: {
        type: Object,
        default: {}
    }
});

const UserSchema = new Schema({
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        default: ''
    },
    displayName: {
        type: String,
        default: ''
    },
    isMicrosoftAuthed: {
        type: Boolean,
        required: true,
        default: false
    },
    connectData: {
        type: Map,
        of: ServiceSchema,
        default: []
    }
});

UserSchema.pre('save', async function (next) {
    this.password = await bcrypt.hash(this.password, 10);
    next();
});

const UserModel = mongoose.model('user', UserSchema);

module.exports = UserModel;
