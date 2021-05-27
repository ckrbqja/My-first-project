import { Connection, Repository } from 'typeorm';
import { Sotong } from './sotong.entity';

export const sotongProviders = [
    {
        provide: 'SOTONG_REPOSITORY',
        useFactory: (connection: Connection) =>
            connection.getRepository(Sotong),
        inject: ['DATABASE_CONNECTION'],
    },
];
