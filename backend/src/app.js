import express from 'express';
import userRouter from './user.js';

const app = express();
// Serve static files
app.use(express.static('../web'));

//  Router setup
const apiRouter = express.Router();
apiRouter.use('/users', userRouter);
app.use('/api', apiRouter);
app.use('*', (req, res) => res.status(404).send('Sorry... Nothing here'));

export default app;
