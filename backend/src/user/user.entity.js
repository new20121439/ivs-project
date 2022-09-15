import {EntitySchema} from "typeorm";
import {ENTITY_ORM} from "../config/database.js";

export const UserEnity = new EntitySchema({
    name: ENTITY_ORM.USER,
    tableName: 'users',
    columns: {
        id: {
            primary: true,
            type: 'bigint',
            generated: true,
        },
        name: {
            type: "text",
            nullable: false,
        },
        email: {
            type: "text",
            nullable: false,
            unique: true,
        }
    }
});
