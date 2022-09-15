import express from 'express';
import userRouter from './user/user.route.js';
import {datasource} from "./config/database.js";
import {errorHandlerMiddleware} from "./utils/middleware/error-handler.middleware.js";
import {BaseError} from "./utils/error.js";

const app = express();
// Serve static files
app.use(express.static('../web'));

app.use(express.json());

// Init connection to db
datasource.initialize()
    .then(() => console.log('Connected to database'))
    .catch((err) => console.error('Failed to connect to database ', err));

//  Router setup
const apiRouter = express.Router();
apiRouter.use('/users', userRouter);
app.use('/api', apiRouter);
app.use('*', (req, res) => res.status(404).send('Sorry... Nothing here'));
app.use(errorHandlerMiddleware);

// Prevent Leaked Errors
process
    .on('unhandledRejection', (error, promise) => {
        console.error('unhandledRejection', error);
    })
    .on('uncaughtException', (error => {
        const errorType = (error instanceof BaseError) ? 'OperationalError': 'UnhandledError';
        console.error(`uncaughtException.${errorType} : ${error}`);
    }));

export default app;
