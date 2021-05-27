import { Module } from '@nestjs/common';
import { SotongModule } from './sotong/sotong.module';
import { GraphQLModule } from '@nestjs/graphql';
import { join } from 'path';

@Module({
    imports: [
        SotongModule,
        GraphQLModule.forRoot({
            autoSchemaFile: join(process.cwd(), 'src/schema.gql'),
            sortSchema: true,
            debug: true,
            playground: true,
        }),
    ],
})
export class AppModule {}
