import { BadRequestError, sendErrorResponse } from '../error.js';

export function validateMiddleware(schema) {
    return function(req, res, next) {
        const { error } = schema.validate(req.body);
        if (error) {
            const err = new BadRequestError('Validation error', error.details);
            sendErrorResponse(res, err);
        } else {
            next();
        }
    }
}
