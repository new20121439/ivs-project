import { EntitySchema } from 'typeorm';

export const UserEntity = new EntitySchema({
    name: 'User',
    tableName: 'users',
    columns: {
        id: {
            primary: true,
            type: 'bigint',
            generated: true,
        },
        name: {
            type: 'text',
            nullable: false,
        },
        email: {
            type: 'text',
            nullable: false,
            unique: true,
        }
    }
});
