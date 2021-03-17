const express = require('express');
const mongoose = require('mongoose');
const passport = require('passport');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const msal = require('@azure/msal-node');

const aboutRouter = require('./src/routes/aboutRoute');
const areaRouter = require('./src/routes/areasRoutes');
const authRouter = require('./src/routes/authRoutes');
const connectRouter = require('./src/routes/connectRoutes');
const profileRouter = require('./src/routes/profileRoutes');
const usersRouter = require('./src/routes/usersRoutes');

const { ALLOWED_ORIGINS } = require('./src/config/config');
const { MONGO_URI, MONGO_DB_NAME, MONGO_USER, MONGO_PASSWORD } = require('./src/config/mongoConfig');
const { MSAL_CONFIG, MSAL_CONFIG_SECRET } = require('./src/config/msalConfig');
const checkupTriggers = require('./src/area');

const swaggerUi = require('swagger-ui-express');
const swaggerJSDoc = require('swagger-jsdoc');

const SWAGGER_OPTIONS = {
    definition: {
        openapi: '3.0.3',
        info: {
            title: 'Area',
            version: '1.0.0'
        }
    },
    apis: [ './src/routes/*Route*.js' ]
};

const swaggerSpec = swaggerJSDoc(SWAGGER_OPTIONS); // TODO: move (avec la config) dans un fichier de config.

const port = process.env.SERVER_PORT || 8080;

async function eraseUsersMicrosoftConnectData() {
    const User = require('./src/models/User');
    const { MONGOOSE_MSAL_KEY } = require('./src/config/msalConfig');
    const users = await User.find({});

    for (const user of users) {
        user.connectData.delete(MONGOOSE_MSAL_KEY);
        await User.findByIdAndUpdate(user._id, user);
    }
}

function startServer() {
    const app = express();

    app.locals.publicMsalClient = new msal.PublicClientApplication(MSAL_CONFIG);
    app.locals.confidentialMsalClient = new msal.ConfidentialClientApplication(MSAL_CONFIG_SECRET);

    app.use(morgan('combined'));
    app.use(bodyParser.json());
    app.use(bodyParser.urlencoded({
        extended: false
    }));
    app.use(cookieParser());
    app.set('trust proxy', true);
    app.use(cors({
        origin: ALLOWED_ORIGINS,
        credentials: true
    }));
    app.use(passport.initialize({}));

    app.use('/about.json', aboutRouter);
    app.use('/areas', areaRouter);
    app.use('/auth', authRouter);
    app.use('/connect', connectRouter);
    app.use('/profile', profileRouter);
    app.use('/users', usersRouter);

    app.get('/', (req, res) => res.send('Hello World!'));
    app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

    app.listen(port, () => {
        console.log(`Example app listening at http://localhost:${port}`);
    });

    setInterval(() => {
        checkupTriggers(app.locals.publicMsalClient, app.locals.confidentialMsalClient);
    }, 5000);
}

function connectToDb() {
    mongoose.connect(MONGO_URI, {
        user: MONGO_USER,
        pass: MONGO_PASSWORD,
        dbName: MONGO_DB_NAME,
        useNewUrlParser: true,
        useUnifiedTopology: true
    });
    const db = mongoose.connection;

    mongoose.set('useFindAndModify', false);
    db.on('error', console.error.bind(console, 'connection error:'));
    db.once('open', () => {
        eraseUsersMicrosoftConnectData().then(() => {
            startServer();
        });
    });
}

connectToDb();
