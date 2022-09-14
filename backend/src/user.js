import express from 'express';
import { authMiddleware } from "./middleware/auth.middleware.js";

const router = express.Router();

router.post('/',  function(req, res) {
    const user = req.body;
    res.status(201).json({ message: 'User created successfully', data: user });
});

router.get('/', authMiddleware, function(req, res) {
    const users = [
        { name: 'foo' },
        { name: 'bar' },
    ];
    res.json(users);
})

export  default router;
