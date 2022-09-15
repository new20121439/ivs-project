import { DataSource } from 'typeorm';
import path from 'node:path';

const host = 'ivs-db.clheixzydscv.ap-southeast-1.rds.amazonaws.com';
const username = 'postgres';
const password = 'tmvF7CbH9CVTFUfvBwZZ';
const database = 'postgres';
const port = 5432;

export const datasource = new DataSource({
    type: 'postgres',
    host,
    port,
    database,
    username,
    password,
    connectTimeoutMS: 3000,
    entities: [
        '**/**.entity.js'
    ],
});

export const ENTITY_ORM = Object.freeze({
    USER: 'User',
});

