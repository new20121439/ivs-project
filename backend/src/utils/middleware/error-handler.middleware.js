import {sendErrorResponse} from "../error.js";

export function errorHandlerMiddleware(error, req, res, next) {
    console.error('Error Middleware ', error);
    // if (!err.statusCode) {
    //     err = { statusCode: 500, message: 'Internal server error', errors: []};
    // }
    // res.status(err.statusCode).json({ message: err.message, errors: err.errors});
    sendErrorResponse(res, error);
}
