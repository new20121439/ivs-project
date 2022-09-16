import { sendErrorResponse } from '../error.js';

// eslint-disable-next-line no-unused-vars
export function errorHandlerMiddleware(error, req, res, next) {
    console.error('Error Middleware ', error);
    sendErrorResponse(res, error);
}
