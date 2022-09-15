export function sendErrorResponse(res, error) {
    if (!(error instanceof BaseError)) {
        error = new InternalServerError();
    }
    res.status(error.statusCode).json({ message: error.message, errors: error.errors });
}

export class BaseError extends Error {
    constructor(statusCode, message, errors) {
        super(message);

        Object.setPrototypeOf(this, new.target.prototype);
        this.statusCode = statusCode;
        this.message = message;
        this.errors = errors;
        Error.captureStackTrace(this)
    }
}

const httpStatusCode = Object.freeze({
    BAD_REQUEST: 400,
    NOT_FOUND: 404,
    INTERNAL_SERVER_ERROR: 500,
    UNAUTHORIZED: 401
});

export class NotFoundError extends BaseError {
    constructor(message='Not found', errors=[]) {
        super(httpStatusCode.NOT_FOUND, message, errors);
    }
}

export class InternalServerError extends BaseError {
    constructor(message='Internal server error', errors=[]) {
        super(httpStatusCode.INTERNAL_SERVER_ERROR, message, errors);
    }
}

export class BadRequestError extends BaseError {
    constructor(message='Bad request', errors=[]) {
        super(httpStatusCode.BAD_REQUEST, message, errors);
    }
}

export class UnauthorizedError extends BaseError {
    constructor(message='Unauthorized', errors=[]) {
        super(httpStatusCode.UNAUTHORIZED, message, errors);
    }
}
