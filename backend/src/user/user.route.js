import express from 'express';
import { authMiddleware } from "../utils/middleware/auth.middleware.js";
import {datasource} from "../config/database.js";
import {UserEnity} from './user.entity.js';
import {UserService} from "./user.service.js";
import {validateMiddleware} from "../utils/middleware/validate.middleware.js";
import validateSchema from "./validate-schema.js";

const router = express.Router();

const userRepository = datasource.getRepository(UserEnity);
const userService = new UserService(userRepository);

router.post('/', validateMiddleware(validateSchema.createUser), async function(req, res, next) {
    const createUserDto = req.body;
    try {
        const user = await userService.create(createUserDto);
        res.status(201).json({ message: 'User created successfully', data: user });
    } catch (err) {
        next(err);
    }
});

router.get('/', authMiddleware, async function(req, res) {
    const users = await userService.getAll();
    res.json(users);
});

router.get('/:id', authMiddleware, async function(req, res, next) {
    const id = req.params.id;
    try {
        const user = await userService.getById(id);
        res.status(200).json(user);
    } catch (err) {
        next(err)
    }
});

export  default router;
