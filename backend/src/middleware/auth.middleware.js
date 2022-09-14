export function authMiddleware(req, res, next) {
    const auth = req.headers.authorization;
    console.log(req.headers);
    const token = (auth && auth.split('Bearer ')[1]) || null;
    if (token === process.env.TEST_TOKEN) {
        next();
    } else {
        res.sendStatus(401);
    }
}
