import { DataSource } from 'typeorm';

export const datasource = new DataSource({
    type: process.env.DB_TYPE,
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    database: process.env.DB_NAME,
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    connectTimeoutMS: 3000,
    entities: [
        '**/**.entity.js'
    ],
});
