import { createConnection } from 'typeorm';
//디비정속정보
export const databaseProviders = [
    {
        provide: 'DATABASE_CONNECTION',
        useFactory: async () =>
            await createConnection({
                type: 'mysql',
                host: 'makgoon.tech',
                port: 40100,
                username: 'sotongteam',
                password: '!Sotong0501',
                database: 'sotongapp',
                entities: [__dirname + '/../**/*.entity{.ts,.js}'],
                synchronize: true,
            }),
    },
];
