import { Module } from '@nestjs/common';
import { SotongController } from './sotong.controller';
import { SotongService } from './sotong.service';
import { DatabaseModule } from '../database/database.module';
import { sotongProviders } from './sotong.providers';
import { SotongResolver } from './sotong.resolvers';

@Module({
    imports: [DatabaseModule],
    controllers: [SotongController],
    providers: [...sotongProviders, SotongService, SotongResolver],
})
export class SotongModule {}
