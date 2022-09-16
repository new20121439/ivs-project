import { sendErrorResponse, UnauthorizedError } from '../error.js';

export function authMiddleware(req, res, next) {
    const auth = req.headers.authorization;
    const token = (auth && auth.split('Bearer ')[1]) || null;
    if (token === process.env.TEST_TOKEN) {
        next();
    } else {
        sendErrorResponse(res, new UnauthorizedError());
    }
}
