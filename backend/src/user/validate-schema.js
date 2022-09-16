import Joi from 'joi';

export default Object.freeze({
    createUser: Joi.object().keys({
        name: Joi.string().required(),
        email: Joi.string().email().required(),
    }),
})
